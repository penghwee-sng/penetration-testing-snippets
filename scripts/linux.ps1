$Password = "W3BP@55w0rd"
$User = "root"
$ScriptName = "cronjob.sh"
$ScriptName2 = "linux_scan_script.sh"
$Computers = @("100.90.151.76","100.90.151.74","100.90.151.71","100.90.151.75","100.90.151.121","100.90.151.73","100.90.151.72","100.90.151.4","100.90.151.6","100.90.151.7","10.151.8.71","10.151.8.77","10.151.8.76","10.151.8.78","10.151.8.75","10.151.8.73","10.151.8.80","10.151.8.79","10.151.8.74","10.151.8.72","10.151.6.42","10.151.6.44","10.151.6.43","10.151.9.41","10.151.9.45","10.151.9.47","10.151.9.44","10.151.9.43","10.151.9.48","10.151.9.46","10.151.9.49","10.151.9.42","10.151.9.50")
#$Command = "rm -f /tmp/$ScriptName && rm -f /tmp/$ScriptName2 && wget http://100.90.151.75/$ScriptName -P /tmp && wget http://100.90.151.75/$ScriptName2 -P /tmp && chmod +x /tmp/$ScriptName && chmod +x /tmp/$ScriptName2 && /tmp/$ScriptName && ps -e -o user,comm | sort > /tmp/basePS0"
$Command = "crontab -r && rm -f /bin/ufd"

foreach($computer in $Computers)
{
  $secpasswd = ConvertTo-SecureString $Password -AsPlainText -Force
  $Credentials = New-Object System.Management.Automation.PSCredential($User, $secpasswd)
  $SessionID = New-SSHSession -ComputerName $computer -Credential $Credentials -AcceptKey
  Invoke-SSHCommand -Index $sessionid.sessionid -Command $Command -Timeout 100000000
}
