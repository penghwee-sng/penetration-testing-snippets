# Change the initial password for all domain users
Write-Output "Changing password for Domain Users..."
$users = Get-ADUser -Filter "GivenName -like '*'" | Select-Object -ExpandProperty SamAccountName
foreach($user in $users) { 
    $password = "P@55w0rd!!-$($user.substring(0,1).toUpper()+$user.substring($user.length - 1).toUpper())"
    try {
        Set-ADAccountPassword -Identity $user -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$password" -Force)
        Write-Output "Password for [$user] has been changed to [$password]."
    }
    catch {
        Write-Output $Error[0]
    }
}


# Change the password for all local administrator account
Write-Output "Changing password for Local Administrator on all machines..."
$password = "P@55w0rdAoG"
$computers =  Get-ADComputer -Filter 'OperatingSystem -like "Windows*"' | Select-Object -ExpandProperty DNSHostName
foreach($computer in $computers){
    $user = [adsi]"WinNT://$computer/administrator"
    $password = "Hu@7`$999"
    $user.SetPassword($password)
    $user.SetInfo()
    Write-Output "Password for [$computer] has been changed."
}


# Change the default password for domain administrator
Write-Output "Changing password for Domain Administrator..."
$adminPassword = "P@55w0rdMore"
Set-ADAccountPassword -Identity Administrator -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$adminPassword" -Force)
Write-Output "Password for [Administrator] has been changed to [$adminPassword]."


Remove-Item $((Get-PSReadlineOption).HistorySavePath)
