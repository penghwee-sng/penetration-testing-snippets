$Path = "\\fs\Public\Security\splunkforwarder.msi";

# Path to all input.conf files for mil 
$InputPathMil = "\\fs\Public\Security\inputs\mil\Servers and Clients\inputs.conf";
$InputPathMilEmail = "\\fs\Public\Security\inputs\mil\Exchange\inputs.conf";
$InputPathMilEmployeeWeb = "\\fs\Public\Security\inputs\mil\Web\inputs.conf";

# Deployment of splunk forwarder to all client machines
foreach($DNSHostName in Get-ADComputer -Filter * | Select -expand DNSHostName){
    Write-Host "Installing splunk forwarder on $DNSHostName`:";

    # For mail on mil
    if ($DNSHostName -eq "mail.mil.01.crx"){
        Invoke-Command -AsJob -ArgumentList $Path,$InputPathMilEmail -ConfigurationName "AdminPSSC" -ComputerName $DNSHostName -ScriptBlock {
            Param($Path,$InputPathMilEmail)

            msiexec.exe /i $Path RECEIVING_INDEXER="61.16.103.155:9997" SPLUNKPASSWORD=Cytec@2014 AGREETOLICENSE=Yes /quiet;

            Copy-Item -Path $InputPathMilEmail -Destination "C:\Program Files\SplunkUniversalForwarder\etc\system\local\";
            
            Get-Service -DisplayName "SplunkForwarder Service" | Stop-Service;

            Start-Service -DisplayName "SplunkForwarder Service";
        };
    } # For employee-web on mil
    elseif ($DNSHostName -eq "employee-web.mil.01.crx"){
        Invoke-Command -AsJob -ArgumentList $Path,$InputPathMilEmployeeWeb -ConfigurationName "AdminPSSC" -ComputerName $DNSHostName -ScriptBlock {
            Param($Path,$InputPathMilEmployeeWeb)

            msiexec.exe /i $Path RECEIVING_INDEXER="61.16.103.155:9997" SPLUNKPASSWORD=Cytec@2014 AGREETOLICENSE=Yes /quiet;

            Copy-Item -Path $InputPathMilEmployeeWeb -Destination "C:\Program Files\SplunkUniversalForwarder\etc\system\local\";

            Get-Service -DisplayName "SplunkForwarder Service" | Stop-Service;

            Start-Service -DisplayName "SplunkForwarder Service";
        };
    } # For all windows clients and servers on mil
    elseif ((($DNSHostName -notlike "ws2*") -and ($DNSHostName -notlike "ws4*")) -and ($DNSHostName -like "*mil*")) {
        Invoke-Command -AsJob -ArgumentList $Path,$InputPathMil -ConfigurationName "AdminPSSC" -ComputerName $DNSHostName -ScriptBlock {
            Param($Path,$InputPathMil)

            msiexec.exe /i $Path RECEIVING_INDEXER="61.16.103.155:9997" SPLUNKPASSWORD=Cytec@2014 AGREETOLICENSE=Yes /quiet;

            Copy-Item -Path $InputPathMil -Destination "C:\Program Files\SplunkUniversalForwarder\etc\system\local\";

            Get-Service -DisplayName "SplunkForwarder Service" | Stop-Service;

            Start-Service -DisplayName "SplunkForwarder Service";
        };
    } # For anything that was skipped
    else{
        Write-Host "Skipped $DNSHostName";
    }
}