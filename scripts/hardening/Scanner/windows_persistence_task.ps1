Copy-Item \\fs\Public\Security\Scanner\autorunsc64.exe C:\Windows\System32\autorunsc64.exe
Copy-Item -Path \\fs\Public\Security\Scanner\windows_persistency_scanner.ps1 -Destination C:\Windows\System32\lpctr.ps1
#Get-Acl -Path "C:\Windows\System32\win32k.sys" | Set-Acl -Path "C:\Windows\System32\lpctr.ps1"
cmd /c C:\Windows\System32\autorunsc64.exe -accepteula > $null

$actions=(New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "C:\Windows\System32\lpctr.ps1")

$trigger = New-ScheduledTaskTrigger `
    -Once `
	-RandomDelay "00:05"  `
    -At (Get-Date) `
    -RepetitionInterval (New-TimeSpan -Minutes 15)
	
$task = New-ScheduledTask -Action $actions -Trigger $trigger

Register-ScheduledTask -TaskName 'MozillaUpdateTaskMachineUA' -InputObject $task -User "System"