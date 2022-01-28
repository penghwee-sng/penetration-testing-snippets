# Change the initial password for all domain users
Write-Output "Changing password for Domain Users..."
$users = Get-ADUser -Filter "GivenName -like '*'" | Select-Object -ExpandProperty SamAccountName
foreach($user in $users) { 
    $password = "Hello!!$($user.substring(0,1).toUpper()+$user.substring($user.length - 1).toUpper())"
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
$computers =  Get-ADComputer -Filter 'OperatingSystem -like "Windows*"' | Select-Object -ExpandProperty DNSHostName
foreach($computer in $computers){
    try {
        $computer = $computer.Split('.')[0].ToLower()
        Add-Type -AssemblyName 'System.Web'
        $password = [System.Web.Security.Membership]::GeneratePassword($length, $nonAlphaChars)
        $account = [adsi]"WinNT://$computer/administrator"
        $account.psbase.invoke("setpassword",$password)
        Write-Verbose "Local Admin Password for [$computer] has been changed to [$password]."
    }    
    catch {
        Write-Verbose "`tFailed to Change the administrator password. Error: $_"
    }
}


# Change the default password for domain administrator
# Write-Output "Changing password for Domain Administrator..."
# if ((Get-AdDomainController | Select-Object -ExpandProperty Domain) -eq "power.01.crx") {
#     $adminPassword = "Passw0rd!PPP!"
# } elseif ((Get-AdDomainController | Select-Object -ExpandProperty Domain) -eq "mil.01.crx") {
#     $adminPassword = "Passw0rd!MMM!"
# } else {
#     $adminPassword = "Passw0rd!SSS!"
# }
# Set-ADAccountPassword -Identity Administrator -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$adminPassword" -Force)
# Write-Output "Password for [Administrator] has been changed to [$adminPassword]."
Remove-Item $((Get-PSReadlineOption).HistorySavePath)
