# Register session
$AdminUser = "administrator";
$AdminPass = "GongXiFaCai!!22";
$ConfigName = "AdminForJack"
$Credential = [PSCredential]::new($AdminUser, $(ConvertTo-SecureString $AdminPass -AsPlainText -Force));
$Computers = Get-ADComputer -Filter 'OperatingSystem -like "Windows*"' | Select-Object -ExpandProperty DNSHostName


Write-Output "Registering configuration..."
foreach($Computer in $Computers){
    # Register PS session configuration to bypass Kerberos double-hop issue
    Invoke-Command -ComputerName $Computer -ArgumentList $Credential -ScriptBlock {
        Param($Credential)
        Register-PSSessionConfiguration -Name $ConfigName -RunAsCredential $Credential -Force;
    };
}


Write-Output "Execution of command started."
$sessions = New-PSSession -ComputerName $computers -Credential $credential -ConfigurationName $ConfigName -SessionOption (New-PSSessionOption -OpenTimeout 1000)
Invoke-Command -Session $sessions -ScriptBlock {
    $PathToSEP
}
Write-Output "Execution of command ended."


Write-Output "Deleting configuration..."
foreach($Computer in $Computers){
    # Remove PS session configuration
    Invoke-Command -AsJob -ComputerName $Computer -ScriptBlock {
        Unregister-PSSessionConfiguration -Name "AdminForJack" -Force;
    };
}

Get-PSSession | Remove-PSSession

Write-Output "Script ended."