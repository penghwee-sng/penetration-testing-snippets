$Password = "Root1Root1"
$User = "root"
$ScriptName = "basic_linux_hardening_script_web.sh"
# $Computers = @("100.90.151.76")
$Computers = @("100.90.151.73","100.90.151.121","10.151.8.61","10.151.3.46","100.90.151.72","100.90.151.71","100.90.151.77","100.90.151.68","100.90.151.74","10.151.3.124","gitlab.power.01.crx")
$Command = "rm -f /tmp/basic_linux_hardening_script_web.sh && wget http://100.90.151.75/basic_linux_hardening_script_web.sh -P /tmp && chmod +x /tmp/basic_linux_hardening_script_web.sh && /tmp/basic_linux_hardening_script_web.sh && rm /tmp/basic_linux_hardening_script_web.sh"

foreach($computer in $Computers) 
{
  $secpasswd = ConvertTo-SecureString $Password -AsPlainText -Force
  $Credentials = New-Object System.Management.Automation.PSCredential($User, $secpasswd)
  $SessionID = New-SSHSession -ComputerName $computer -Credential $Credentials -AcceptKey  #Connect Over SSH
  Invoke-SSHCommand -Index $sessionid.sessionid -Command $Command -Timeout 1000000
}
