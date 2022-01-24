$Password = "Root1Root1"
$User = "root"
$ScriptName = "basic_linux_hardening_script.sh"

#$Computers = @("ws403.power.01.crx","ws202.power.01.crx","ws210.power.01.crx","ws204.power.01.crx","ws206.power.01.crx","ws208.power.01.crx","ws402.power.01.crx","ws401.power.01.crx")
$Computers = @("10.151.9.41","10.151.9.42","10.151.9.43","10.151.9.44","10.151.9.45","10.151.9.46","10.151.9.47","10.151.9.48","10.151.9.49","10.151.9.50")
$Command = "rm -f /tmp/$ScriptName && wget http://100.90.151.75/$ScriptName -P /tmp && chmod +x /tmp/$ScriptName && /tmp/$ScriptName"

foreach($computer in $Computers) 
{
  $secpasswd = ConvertTo-SecureString $Password -AsPlainText -Force
  $Credentials = New-Object System.Management.Automation.PSCredential($User, $secpasswd)
  $SessionID = New-SSHSession -ComputerName $computer -Credential $Credentials -AcceptKey  #Connect Over SSH
  Invoke-SSHCommand -Index $sessionid.sessionid -Command $Command -Timeout 100000000
}