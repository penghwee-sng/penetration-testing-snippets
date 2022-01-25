# Please change the following variables accordingly
$SysmonPath = "\\fs\Public\Security\Sysmon64.exe";
$SysmonConfigPath = "\\fs\Public\Security\sysmonconfig-export.xml";




foreach($DNSHostName in Get-ADComputer -Filter * | Select -expand DNSHostName){
    Write-Host "Installing sysmon on $DNSHostName`:";
    
    # For all windows clients and servers
    if (($DNSHostName -notlike "ws2*") -and ($DNSHostName -notlike "ws4*")) {
        Invoke-Command -AsJob -ArgumentList $SysmonPath,$SysmonConfigPath -ConfigurationName "AdminPSSC" -ComputerName $DNSHostName -ScriptBlock {
            Param($SysmonPath, $SysmonConfigPath)

            # Copy Sysmon files to C:\Windows\ and install Sysmon
            Copy-Item -Path $SysmonPath -Destination "C:\Windows\";
            Copy-Item -Path $SysmonConfigPath -Destination "C:\Windows\";
            $SysmonLocalPath = "C:\Windows\" + [System.IO.Path]::GetFileName($SysmonPath);
            $SysmonConfigLocalPath = "C:\Windows\" + [System.IO.Path]::GetFileName($SysmonConfigPath);
            & $SysmonLocalPath -accepteula -i $SysmonConfigLocalPath 2>&1 | %{ "$_" };
        };
    } # For all linux clients
    else {
        Write-Output "Skip Linux";
    }
}