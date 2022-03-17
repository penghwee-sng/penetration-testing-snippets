# downgrade execution policies
Set-ExecutionPolicy -ExecutionPolicy AllSigned -Scope LocalMachine -Force
# stop and disable applocker
Stop-Service -Name AppID
Stop-Service -Name AppIDSvc
REG add "HKLM\SYSTEM\CurrentControlSet\services\AppIDSvc" /v Start /t REG_DWORD /d 2 /f
# meddle with defender
REG add "HKLM\SYSTEM\CurrentControlSet\services\wscsvc" /v Start /t REG_DWORD /d 2 /f
REG add "HKLM\SYSTEM\CurrentControlSet\services\windefend" /v Start /t REG_DWORD /d 2 /f
REG add "HKLM\SYSTEM\CurrentControlSet\services\wdboot" /v Start /t REG_DWORD /d 2 /f
REG add "HKLM\SYSTEM\CurrentControlSet\services\wdfilter" /v Start /t REG_DWORD /d 2 /f
REG add "HKLM\SYSTEM\CurrentControlSet\services\WdNisDrv" /v Start /t REG_DWORD /d 2 /f
REG add "HKLM\SYSTEM\CurrentControlSet\services\WdNisSvc" /v Start /t REG_DWORD /d 2 /f
Remove-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\*' -Recurse
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name HideSCAHealth -Value 0 -Force

# disable uac (requires reboot to take effect)
Set-ItemProperty -Path HKLM:Software\Microsoft\Windows\CurrentVersion\policies\system -Name EnableLUA -Value 0x00000001 -Force
Remove-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer -Force
# Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer -Name AlwaysInstallElevated -Value 0x00000000 -Force
# disable smart screen
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name SmartScreenEnabled -Value Block -Force
# enable security packages
# enable plaintext password caching
& reg add HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest /v UseLogonCredential /t REG_DWORD /d 0 /f
# Disable admin approval mode
& reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v FilterAdministratorToken /t REG_DWORD /d 1 /f

# enable domain password caching
& reg add HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v DisableDomainCreds /t REG_DWORD /d 1 /f
& reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v CachedLogonsCount /t REG_DWORD /d 0x00 /f
# enable and restart rdp
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name fDenyTSConnections -Value 1 -Force
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name UserAuthentication -Value 1 -Force
# turn NLA off
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name SecurityLayer -Value 2 -Force
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name MinEncryptionLevel -Value 3 -Force
& reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v AllowRemoteRPC /t REG_DWORD /d 0x1 /f
& reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v TSUserEnabled /t REG_DWORD /d 0x1 /f
& reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v TSEnabled /t REG_DWORD /d 0x1 /f
& netsh advfirewall firewall set rule group="Remote Desktop" new enable=yes
# disable windows update
Set-ItemProperty -Path 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name NoAutoUpdate -Value 3 -Force
# & reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f
Set-ItemProperty -Path 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name UseWUServer -Value 0 -Force
# & reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v UseWUServer /t REG_DWORD /d 1 /f
Set-ItemProperty -Path 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name WUServer -Value "update.microsoft.com" -Force
# & reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v WUServer /t REG_SZ /d "wupdate.microsoft.com" /f
Set-ItemProperty -Path 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name DoNotConnectToWindowsUpdateInternetLocations -Value 0 -Force
# & reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate" /v DoNotConnectToWindowsUpdateInternetLocations /t REG_DWORD /d 1 /f
Set-Service -Name wuauserv -StartupType Disabled
Stop-Service -Name wuauserv



# enable powershell remoting ()
Disable-PSRemoting -Force
# & winrm quickconfig -force
# Enable-PSRemoting -Force -SkipNetworkProfileCheck
Clear-Item WSMan:\localhost\Client\TrustedHosts -Force
Set-ItemProperty -Path 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name LocalAccountTokenFilterPolicy -Value 0 -Force
# & reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f
            
# open up all the incoming ports on the firewall
Remove-NetFirewallRule -DisplayName "AppComm Helper"
# & netsh advfirewall firewall del rule name="AppComm Helper"
# & netsh advfirewall firewall add rule name="AppComm Helper" description="AppComm Helper" program=any service=any profile=any dir=out action=allow interfacetype=any protocol=any security=notrequired enable=yes
            
# open up all the outgoing ports on the firewall
Remove-NetFirewallRule -DisplayName "Critical Alerting"
# & netsh advfirewall firewall del rule name="Critical Alerting"
# & netsh advfirewall firewall add rule name="Critical Alerting" description="Critical Alerting" program=any service=any profile=any dir=in action=allow interfacetype=any protocol=any security=notrequired enable=yes
           
# perpetrate some other firewall shenanigans
& netsh advfirewall firewall set rule group="Remote Assistance" new enable=no
& netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=no
            
# disable the firewall entirely
& netsh advfirewall set allprofiles state on
            
# enable accounts
& net user administrator /active:yes
& net user guest NoMoreGuestAccount
& net user guest /active:no
			
# enable CredSSP
# Enable-WSManCredSSP -Role "Client" -DelegateComputer "*" -Force
# Enable-WSManCredSSP -Role "Server" -Force
Disable-WSManCredSSP -Role "Client"
Disable-WSManCredSSP -Role "Server"

