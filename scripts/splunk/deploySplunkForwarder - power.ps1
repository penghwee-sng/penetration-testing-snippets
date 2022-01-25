$Path = "\\fs\Public\Security\splunkforwarder.msi";

# Path to all input.conf file for power
$InputPathPower = "\\fs\Public\Security\inputs\power\Servers and Clients\inputs.conf";
$InputPathPowerEmail = "\\fs\Public\Security\inputs\power\Exchange\inputs.conf";
$InputPathPowerWeb = "\\fs\Public\Security\inputs\power\Web\inputs.conf"

# Deployment of splunk forwarder to all client machines
foreach($DNSHostName in Get-ADComputer -Filter * | Select -expand DNSHostName){
    Write-Host "Installing splunk forwarder on $DNSHostName`:";

    # For mail on power
    if ($DNSHostName -eq "mail.power.01.crx"){
        Invoke-Command -AsJob -ArgumentList $Path,$InputPathPowerEmail -ConfigurationName "AdminPSSC" -ComputerName $DNSHostName -ScriptBlock {
            Param($Path,$InputPathPowerEmail)

            msiexec.exe /i $Path RECEIVING_INDEXER="61.16.103.155:9997" SPLUNKPASSWORD=Cytec@2014 AGREETOLICENSE=Yes /quiet;

            Copy-Item -Path $InputPathPowerEmail -Destination "C:\Program Files\SplunkUniversalForwarder\etc\system\local\";
            
            Get-Service -DisplayName "SplunkForwarder Service" | Stop-Service;

            Start-Service -DisplayName "SplunkForwarder Service";
        };
    } # For client-web on power
    elseif ($DNSHostName -eq "client-web.power.01.crx"){
        Invoke-Command -AsJob -ArgumentList $Path,$InputPathPowerWeb -ConfigurationName "AdminPSSC" -ComputerName $DNSHostName -ScriptBlock {
            Param($Path,$InputPathPowerWeb)

            msiexec.exe /i $Path RECEIVING_INDEXER="61.16.103.155:9997" SPLUNKPASSWORD=Cytec@2014 AGREETOLICENSE=Yes /quiet;

            Copy-Item -Path $InputPathPowerWeb -Destination "C:\Program Files\SplunkUniversalForwarder\etc\system\local\";

            Get-Service -DisplayName "SplunkForwarder Service" | Stop-Service;

            Start-Service -DisplayName "SplunkForwarder Service";
        };
    }
    # For all windows clients and servers on power
    elseif ((($DNSHostName -notlike "ws2*") -and ($DNSHostName -notlike "ws4*")) -and ($DNSHostName -like "*power*")) {
        Invoke-Command -AsJob -ArgumentList $Path,$InputPathPower -ConfigurationName "AdminPSSC" -ComputerName $DNSHostName -ScriptBlock {
            Param($Path,$InputPathPower)

            msiexec.exe /i $Path RECEIVING_INDEXER="61.16.103.155:9997" SPLUNKPASSWORD=Cytec@2014 AGREETOLICENSE=Yes /quiet;

            Copy-Item -Path $InputPathPower -Destination "C:\Program Files\SplunkUniversalForwarder\etc\system\local\";

            Get-Service -DisplayName "SplunkForwarder Service" | Stop-Service;

            Start-Service -DisplayName "SplunkForwarder Service";
        };
    } # For anything that was skipped
    else{
        Write-Host "Skipped $DNSHostName";
    }
}