$Password = "Root1Root1"
$User = "root"
$ScriptName = "linux_hardening.sh"
$Computers = @("100.90.151.76","100.90.151.74","100.90.151.71","100.90.151.75","100.90.151.121","100.90.151.73","100.90.151.72","100.90.151.4","100.90.151.6","100.90.151.7")
$Command = "hostname"

foreach($computer in $Computers)
{
  $secpasswd = ConvertTo-SecureString $Password -AsPlainText -Force
  $Credentials = New-Object System.Management.Automation.PSCredential($User, $secpasswd)
  $SessionID = New-SSHSession -ComputerName $computer -Credential $Credentials -AcceptKey
  Invoke-SSHCommand -Index $sessionid.sessionid -Command $Command -Timeout 100000000
}
