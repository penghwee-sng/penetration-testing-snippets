$computername = $env:COMPUTERNAME
$timestamp = Get-Date -Format yyyymmdd_hhmmss
$persistence_filename = "\\fs\Public\$computername\" + $computername + "_" + $timestamp + "_persistence_scanlog.txt"
$autorun_filename = "\\fs\Public\$computername\" + $computername + "_" + $timestamp + "_autorun.txt"

cmd /c C:\Windows\System32\autorunsc64.exe > $autorun_filename

echo "`nWindows Defender Status" >> $persistence_filename
$mpComputerStatus = Get-MpComputerStatus
$antiSpywareStatus = $mpComputerStatus.AntispywareEnabled
$antiVirusStatus = $mpComputerStatus.AntivirusEnabled
echo "AntiSpywareEnabled: $antiSpywareStatus" >> $persistence_filename
echo "AntivirusEnabled: $antiVirusStatus" >> $persistence_filename

echo "`nWindows Firewall Status" >> $persistence_filename
netsh advfirewall show allprofiles >> $persistence_filename


$schTasks = Get-ScheduledTask
$taskCount = $scanResult.Count
echo "Total Scheduled Tasks: $taskCount" >> $persistence_filename

echo "`nScanning C:\Users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\" > $persistence_filename
$scanResult = dir "C:\Users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\"
$scanCount = $scanResult.Count
echo "Total Items in C:\Users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs: $scanCount" >> $persistence_filename
$scanResult >> $persistence_filename

echo "`nScanning C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp" >> $persistence_filename
$scanResult = dir "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
$scanCount = $scanResult.Count
echo "Total Items in C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp: $scanCount" >> $persistence_filename
$scanResult >> $persistence_filename

echo "`nScanning C:\Program Files\Common Files\microsoft shared\ink" >> $persistence_filename
$scanResult = dir "C:\Program Files\Common Files\microsoft shared\ink"
$scanCount = $scanResult.Count
echo "Total Items in C:\Program Files\Common Files\microsoft shared\ink: $scanCount" >> $persistence_filename
$scanResult >> $persistence_filename

echo "`nScanning HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" >> $persistence_filename
Get-ItemProperty Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run -ErrorAction SilentlyContinue >> $persistence_filename

echo "`nScanning HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" >> $persistence_filename
Get-ItemProperty Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce -ErrorAction SilentlyContinue >> $persistence_filename

echo "`nScanning HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServices" >> $persistence_filename
Get-ItemProperty Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServices -ErrorAction SilentlyContinue >> $persistence_filename

echo "`nScanning HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce" >> $persistence_filename
Get-ItemProperty Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce -ErrorAction SilentlyContinue >> $persistence_filename

echo "`nScanning HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" >> $persistence_filename
Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run -ErrorAction SilentlyContinue >> $persistence_filename

echo "`nScanning HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce" >> $persistence_filename
Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce -ErrorAction SilentlyContinue >> $persistence_filename

echo "`nScanning HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunServices" >> $persistence_filename
Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunServicess -ErrorAction SilentlyContinue >> $persistence_filename

echo "`nScanning HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce" >> $persistence_filename
Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce -ErrorAction SilentlyContinue >> $persistence_filename

echo "`nScanning HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" >> $persistence_filename
Get-ItemProperty "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -ErrorAction SilentlyContinue >> $persistence_filename

echo "`nScanning Scheduled Tasks" >> $persistence_filename
echo "Total Scheduled Tasks: $taskCount" >> $persistence_filename
schtasks >> $persistence_filename