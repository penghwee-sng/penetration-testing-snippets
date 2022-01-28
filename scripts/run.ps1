# Register session
$AdminUser = "mil\administrator";
$AdminPass = "Root1Root1";
$credential = [PSCredential]::new($AdminUser, $(ConvertTo-SecureString $AdminPass -AsPlainText -Force));
$computers =  Get-ADComputer -Filter 'OperatingSystem -like "Windows*"' | Select-Object -ExpandProperty DNSHostName
foreach($computer in $computers){
    # Register PS session configuration to bypass Kerberos double-hop issue
    Invoke-Command -ComputerName $computer -ArgumentList $credential -ScriptBlock {
        Param($credential)
        Register-PSSessionConfiguration -Name "AdminPSSC" -RunAsCredential $credential -Force;
    };
}

$sessions = New-PSSession -ComputerName $computers -Credential $credential -ConfigurationName "AdminPSSC" -SessionOption (New-PSSessionOption -OpenTimeout 1000)
Copy-Item "windows\*.ps1" -Destination "C:\Windows\Temp\" -ToSession $sessions
#Invoke-Command -Session $sessions -ScriptBlock {}
Get-PSSession | Remove-PSSession
