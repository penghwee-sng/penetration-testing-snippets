# Please change the following variables accordingly
$HelloKittyPath = "\\fs\C$\Installation\hardening\Invoke-HardeningKitty.ps1";
$HelloKittyConfigPathWS = "\\fs\C$\Installation\hardening\WS.csv";
$HelloKittyConfigPathDC = "\\fs\C$\Installation\hardening\DC.csv";
$HelloKittyConfigPathWAP = "\\fs\C$\Installation\hardening\WAP.csv";
$HelloKittyConfigPathMSSQL = "\\fs\C$\Installation\hardening\MSSQL.csv";
$HelloKittyConfigPathPSOS = "\\fs\C$\Installation\hardening\PSOS.csv";


foreach($DNSHostName in Get-ADComputer -Filter * | Select -expand DNSHostName){
    Write-Host "Invoking commands on $DNSHostName`:";
	if (($DNSHostName -like "ws1*") -or ($DNSHostName -like "ws3*") -or ($DNSHostName -like "ws5*") -or ($DNSHostName -like "fs*") -or ($DNSHostName -like "employee*") -or ($DNSHostName -like "sp5dc*")) {
		
		Invoke-Command -ArgumentList $HelloKittyPath,$HelloKittyConfigPathWS -ComputerName $DNSHostName -ScriptBlock {
			Param($HelloKittyPath, $HelloKittyConfigPathWS)

			# Copy HardeningKitty files to C:\Windows\Temp and install HardeningKitty
			Copy-Item -Path $HelloKittyPath -Destination "C:\Windows\";
			Copy-Item -Path $HelloKittyConfigPathWS -Destination "C:\Windows\";
			
			# invoke hardeningKitty first time, repond 'n' to auto reboot. 
			import-module 'C:\Windows\Invoke-HardeningKitty.ps1'
			echo n | Invoke-HardeningKitty -Mode HailMary -FileFindingList c:\WS.csv
					
		};
	}
	
		elseif (($DNSHostName -like "dc*") -or ($DNSHostName -like "adfs*")) {
		
		Invoke-Command -ArgumentList $HelloKittyPath,$HelloKittyConfigPathDC -ComputerName $DNSHostName -ScriptBlock {
			Param($HelloKittyPath, $HelloKittyConfigPathDC)

			# Copy HardeningKitty files to C:\Windows\Temp and install HardeningKitty
			Copy-Item -Path $HelloKittyPath -Destination "C:\Windows\";
			Copy-Item -Path $HelloKittyConfigPathDC -Destination "C:\Windows\";
			
			# invoke hardeningKitty first time, repond 'n' to auto reboot. 
			import-module 'C:\Windows\Invoke-HardeningKitty.ps1'
			echo n | Invoke-HardeningKitty -Mode HailMary -FileFindingList c:\DC.csv
					
		};
	}
	
		elseif (($DNSHostName -like "wap*") -or ($DNSHostName -like "mail*") -or ($DNSHostName -like "www*") -or ($DNSHostName -like "client-web*")) {
		
		Invoke-Command -ArgumentList $HelloKittyPath,$HelloKittyConfigPathWAP -ComputerName $DNSHostName -ScriptBlock {
			Param($HelloKittyPath, $HelloKittyConfigPathWAP)

			# Copy HardeningKitty files to C:\Windows\Temp and install HardeningKitty
			Copy-Item -Path $HelloKittyPath -Destination "C:\Windows\";
			Copy-Item -Path $HelloKittyConfigPathWAP -Destination "C:\Windows\";
			
			# invoke hardeningKitty first time, repond 'n' to auto reboot. 
			import-module 'C:\Windows\Invoke-HardeningKitty.ps1'
			echo n | Invoke-HardeningKitty -Mode HailMary -FileFindingList c:\WAP.csv
					
		};
	}
	
			elseif (($DNSHostName -like "mssql*") -or ($DNSHostName -like "client-db*")) {
		
		Invoke-Command -ArgumentList $HelloKittyPath,$HelloKittyConfigPathMSSQL -ComputerName $DNSHostName -ScriptBlock {
			Param($HelloKittyPath, $HelloKittyConfigPathMSSQL)

			# Copy HardeningKitty files to C:\Windows\Temp and install HardeningKitty
			Copy-Item -Path $HelloKittyPath -Destination "C:\Windows\";
			Copy-Item -Path $HelloKittyConfigPathMSSQL -Destination "C:\Windows\";
			
			# invoke hardeningKitty first time, repond 'n' to auto reboot. 
			import-module 'C:\Windows\Invoke-HardeningKitty.ps1'
			echo n | Invoke-HardeningKitty -Mode HailMary -FileFindingList c:\MSSQL.csv
					
		};
	}
	
			else (($DNSHostName -like "psos*") -or ($DNSHostName -like "ts*")) {
		
		Invoke-Command -ArgumentList $HelloKittyPath,$HelloKittyConfigPathPSOS -ComputerName $DNSHostName -ScriptBlock {
			Param($HelloKittyPath, $HelloKittyConfigPathPSOS)

			# Copy HardeningKitty files to C:\Windows\Temp and install HardeningKitty
			Copy-Item -Path $HelloKittyPath -Destination "C:\Windows\";
			Copy-Item -Path $HelloKittyConfigPathPSOS -Destination "C:\Windows\";
			
			# invoke hardeningKitty first time, repond 'n' to auto reboot. 
			import-module 'C:\Windows\Invoke-HardeningKitty.ps1'
			echo n | Invoke-HardeningKitty -Mode HailMary -FileFindingList c:\PSOS.csv
					
		};
	}	
	
}