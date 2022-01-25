$Password = "Root1Root1"
$User = "root"
$ScriptName = "basic_linux_hardening_script_ultimate.sh"
$dc = "dc1.mil.01.crx"
#$Computers =  Invoke-Command -ComputerName $dc -Credential $credential -Authentication Kerberos -ScriptBlock { Get-ADComputer -Filter 'OperatingSystem -notlike "Windows*"' | Select-Object -ExpandProperty DNSHostName }
$Computers = @("10.151.8.77")
$Command = "rm -f /tmp/$ScriptName && wget http://100.90.151.75/$ScriptName -P /tmp && chmod +x /tmp/$ScriptName && /tmp/$ScriptName"

foreach($computer in $Computers)
{
  $secpasswd = ConvertTo-SecureString $Password -AsPlainText -Force
  $Credentials = New-Object System.Management.Automation.PSCredential($User, $secpasswd)
  $SessionID = New-SSHSession -ComputerName $computer -Credential $Credentials -AcceptKey
  Invoke-SSHCommand -Index $sessionid.sessionid -Command $Command -Timeout 100000000
}
