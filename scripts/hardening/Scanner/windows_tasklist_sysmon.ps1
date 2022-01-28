
New-Item -Path "\\fs\Public\" -Name "$env:COMPUTERNAME" -ItemType "directory" -ErrorAction SilentlyContinue
$actions=(New-ScheduledTaskAction -Execute "cmd.exe" -Argument '/c "tasklist.exe > \\fs\Public\%computername%\%computername%-%date:~10,4%%date:~7,2%%date:~4,2%-%time:~1,1%-%time:~3,2%-%time:~6,2%_tasklist.txt"'), (New-ScheduledTaskAction -Execute "cmd.exe" -Argument '/c "copy C:\Windows\System32\winevt\Logs\Microsoft-Windows-Sysmon%4Operational.evtx \\fs\Public\%computername%\%computername%-%date:~10,4%%date:~7,2%%date:~4,2%-%time:~1,1%-%time:~3,2%-%time:~6,2%_sysmon_logs.txt"')

$trigger = New-ScheduledTaskTrigger `
    -Once `
	-RandomDelay "00:05"  `
    -At (Get-Date) `
    -RepetitionInterval (New-TimeSpan -Minutes 15)
	
$task = New-ScheduledTask -Action $actions -Trigger $trigger

Register-ScheduledTask -TaskName 'SkypeUpdateTaskMachineUA' -InputObject $task -User "System"