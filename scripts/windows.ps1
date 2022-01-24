$credential = Get-Credential
$dc = "dc1.power.01.crx"
$scriptblock = { hostname }
#$scriptblock = { ipconfig > "\\fs\profiles\administrator\desktop\shared\"{hostname}"-ipconfig.txt" }
$computers =  Invoke-Command -ComputerName $dc -Credential $credential -ScriptBlock { Get-ADComputer -Filter 'OperatingSystem -like "Windows*"' | Select-Object -ExpandProperty DNSHostName }

Invoke-Command -ComputerName $computer -Authentication CredSSP -Credential $credential -ScriptBlock { $scriptblock }

# net user Marilyn.Young Deal.Seem.2 /domain