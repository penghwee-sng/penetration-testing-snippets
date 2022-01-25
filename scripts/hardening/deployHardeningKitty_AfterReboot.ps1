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
			
			# after reboot ... 1. run hardeningKitty again for 2nd part
			import-module 'C:\Windows\Invoke-HardeningKitty.ps1'
			Invoke-HardeningKitty -Mode HailMary -FileFindingList c:\Windows\WS.csv
			# after reboot ... 2. clean up
			del c:\windows\Invoke-HardeningKitty.ps1
			del c:\WS.csv
			del c:\DC.csv
			del c:\WAP.csv
			del c:\MSSQL.csv
			del c:\PSOS.csv
					
		};
	}
	
		elseif (($DNSHostName -like "dc*") -or ($DNSHostName -like "adfs*")) {
		
		Invoke-Command -ArgumentList $HelloKittyPath,$HelloKittyConfigPathDC -ComputerName $DNSHostName -ScriptBlock {
			Param($HelloKittyPath, $HelloKittyConfigPathDC)
			
			# after reboot ... 1. run hardeningKitty again for 2nd part
			import-module 'C:\Windows\Invoke-HardeningKitty.ps1'
			Invoke-HardeningKitty -Mode HailMary -FileFindingList c:\Windows\DC.csv
			# after reboot ... 2. clean up
			del c:\windows\Invoke-HardeningKitty.ps1
			del c:\WS.csv
			del c:\DC.csv
			del c:\WAP.csv
			del c:\MSSQL.csv
			del c:\PSOS.csv
					
		};
	}
	
		elseif (($DNSHostName -like "wap*") -or ($DNSHostName -like "mail*") -or ($DNSHostName -like "www*") -or ($DNSHostName -like "client-web*")) {
		
		Invoke-Command -ArgumentList $HelloKittyPath,$HelloKittyConfigPathWAP -ComputerName $DNSHostName -ScriptBlock {
			Param($HelloKittyPath, $HelloKittyConfigPathWAP)
			
			# after reboot ... 1. run hardeningKitty again for 2nd part
			import-module 'C:\Windows\Invoke-HardeningKitty.ps1'
			Invoke-HardeningKitty -Mode HailMary -FileFindingList c:\Windows\WAP.csv
			# after reboot ... 2. clean up
			del c:\windows\Invoke-HardeningKitty.ps1
			del c:\WS.csv
			del c:\DC.csv
			del c:\WAP.csv
			del c:\MSSQL.csv
			del c:\PSOS.csv
					
		};
	}
	
			elseif (($DNSHostName -like "mssql*") -or ($DNSHostName -like "client-db*")) {
		
		Invoke-Command -ArgumentList $HelloKittyPath,$HelloKittyConfigPathMSSQ -ComputerName $DNSHostName -ScriptBlock {
			Param($HelloKittyPath, $HelloKittyConfigPathMSSQL)
			
			# after reboot ... 1. run hardeningKitty again for 2nd part
			import-module 'C:\Windows\Invoke-HardeningKitty.ps1'
			Invoke-HardeningKitty -Mode HailMary -FileFindingList c:\Windows\MSSQL.csv
			# after reboot ... 2. clean up
			del c:\windows\Invoke-HardeningKitty.ps1
			del c:\WS.csv
			del c:\DC.csv
			del c:\WAP.csv
			del c:\MSSQL.csv
			del c:\PSOS.csv
					
		};
	}
	
			else (($DNSHostName -like "psos*") -or ($DNSHostName -like "ts*")) {
		
		Invoke-Command -ArgumentList $HelloKittyPath,$HelloKittyConfigPathPSOS -ComputerName $DNSHostName -ScriptBlock {
			Param($HelloKittyPath, $HelloKittyConfigPathPSOS)
			
			# after reboot ... 1. run hardeningKitty again for 2nd part
			import-module 'C:\Windows\Invoke-HardeningKitty.ps1'
			Invoke-HardeningKitty -Mode HailMary -FileFindingList c:\Windows\PSOS.csv
			# after reboot ... 2. clean up
			del c:\windows\Invoke-HardeningKitty.ps1
			del c:\WS.csv
			del c:\DC.csv
			del c:\WAP.csv
			del c:\MSSQL.csv
			del c:\PSOS.csv
					
		};
	}	

}
