echo "`nWindows Defender Status" >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"
$mpComputerStatus = Get-MpComputerStatus
$antiSpywareStatus = $mpComputerStatus.AntispywareEnabled
$antiVirusStatus = $mpComputerStatus.AntivirusEnabled
echo "AntiSpywareEnabled: $antiSpywareStatus" >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"
echo "AntivirusEnabled: $antiVirusStatus" >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"

echo "`nWindows Firewall Status" >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"
netsh advfirewall show allprofiles >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"
$computername = $env:COMPUTERNAME
$timestamp = Get-Date -Format yyyymmdd_hhmm
$filename = "\\fs\Public\" + $computername + "_" + $timestamp + "_persistence_scanlog.txt"

$schTasks = Get-ScheduledTask
$taskCount = $scanResult.Count
echo "Total Scheduled Tasks: $taskCount" >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"

echo "`nScanning C:\Users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\" > "C:\Users\$env:USERNAME\persistence_scanlog.txt"
$scanResult = dir "C:\Users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\"
$scanCount = $scanResult.Count
echo "Total Items in C:\Users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs: $scanCount" >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"
$scanResult >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"

echo "`nScanning C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp" >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"
$scanResult = dir "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
$scanCount = $scanResult.Count
echo "Total Items in C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp: $scanCount" >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"
$scanResult >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"

echo "`nScanning C:\Program Files\Common Files\microsoft shared\ink" >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"
$scanResult = dir "C:\Program Files\Common Files\microsoft shared\ink"
$scanCount = $scanResult.Count
echo "Total Items in C:\Program Files\Common Files\microsoft shared\ink: $scanCount" >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"
$scanResult >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"

echo "`nScanning HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"
Get-ItemProperty Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run -ErrorAction SilentlyContinue >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"

echo "`nScanning HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"
Get-ItemProperty Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce -ErrorAction SilentlyContinue >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"

echo "`nScanning HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServices" >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"
Get-ItemProperty Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServices -ErrorAction SilentlyContinue >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"

echo "`nScanning HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce" >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"
Get-ItemProperty Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce -ErrorAction SilentlyContinue >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"

echo "`nScanning HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"
Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run -ErrorAction SilentlyContinue >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"

echo "`nScanning HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce" >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"
Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce -ErrorAction SilentlyContinue >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"

echo "`nScanning HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunServices" >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"
Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunServicess -ErrorAction SilentlyContinue >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"

echo "`nScanning HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce" >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"
Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce -ErrorAction SilentlyContinue >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"

echo "`nScanning HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"
Get-ItemProperty Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal .\services.exe -ErrorAction SilentlyContinue >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"

echo "`nScanning Scheduled Tasks" >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"
echo "Total Scheduled Tasks: $taskCount" >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"
schtasks >> "C:\Users\$env:USERNAME\persistence_scanlog.txt"