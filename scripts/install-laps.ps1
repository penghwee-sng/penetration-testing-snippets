Copy-Item "network share location" "destination location"
Invoke-Command -ComputerName $computer -ScriptBlock {msiexec.exe -i C:\Windows\Temp\LAPS.x64.msi /quiet}