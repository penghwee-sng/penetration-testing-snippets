$actions=(New-ScheduledTaskAction -Execute "cmd.exe" -Argument '/c "tasklist.exe > \\fs\Public\%computername%-%date:~10,4%%date:~7,2%%date:~4,2%-%time:~1,1%-%time:~3,2%-%time:~6,2%_tasklist.txt"'), (New-ScheduledTaskAction -Execute "cmd.exe" -Argument '/c "copy C:\Windows\System32\winevt\Logs\Microsoft-Windows-Sysmon%4Operational.evtx \\fs\Public\%computername%-%date:~10,4%%date:~7,2%%date:~4,2%-%time:~1,1%-%time:~3,2%-%time:~6,2%_sysmon_logs.txt"')

$trigger = New-ScheduledTaskTrigger `
    -Once `
	-RandomDelay "00:01"  `
    -At (Get-Date) `
    -RepetitionInterval (New-TimeSpan -Minutes 1)
	
$task = New-ScheduledTask -Action $actions -Trigger $trigger

Register-ScheduledTask -TaskName 'Task List Scheduler' -InputObject $task -User "System"
Remove-Item $PSCommandPath -Force