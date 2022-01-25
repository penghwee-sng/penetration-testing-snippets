$Password = "Root1Root1"
$User = "root"
$ScriptName = "basic_linux_hardening_script_ultimate.sh"
Get-SSHTrustedHost | Remove-SSHTrustedHost
$Computers = @("drony.mil.01.crx", "ws201.mil.01.crx")
$Command = "rm -f /tmp/$ScriptName && wget http://100.90.151.75/html/$ScriptName -P /tmp && chmod +x /tmp/$ScriptName && /tmp/$ScriptName && rm /tmp/$ScriptName"

foreach($computer in $Computers) 
{
  $secpasswd = ConvertTo-SecureString $Password -AsPlainText -Force
  $Credentials = New-Object System.Management.Automation.PSCredential($User, $secpasswd)
  $SessionID = New-SSHSession -ComputerName $computer -Credential $Credentials -AcceptKey  #Connect Over SSH
  Invoke-SSHCommand -Index $sessionid.sessionid -Command $Command -Timeout 1000000 -AsJob
}
