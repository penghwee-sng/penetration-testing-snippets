$credential = Get-Credential
$dc = "dc1.mil.01.crx"
$scriptblock = { \\fs\Public\Security\scripts\windows_persistence_task.ps1 }
#$scriptblock = { ipconfig > "\\fs\profiles\administrator\desktop\shared\"{hostname}"-ipconfig.txt" }
$computers =  Invoke-Command -ComputerName $dc -Credential $credential -ScriptBlock { Get-ADComputer -Filter 'OperatingSystem -like "Windows*"' | Select-Object -ExpandProperty DNSHostName }
$computer = @("ws101.mil.01.crx","ws102.mil.01.crx","dc1.mil.01.crx")
Invoke-Command -ComputerName $computer -Authentication CredSSP -Credential $credential -ScriptBlock { $scriptblock }

# net user Marilyn.Young Deal.Seem.2 /domain