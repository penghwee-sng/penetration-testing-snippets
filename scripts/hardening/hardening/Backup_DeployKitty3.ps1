# Change the following variables accordingly
$HardeningKittyPath = "\\fs\Public\Security\hardening\Invoke-HardeningKitty.ps1"
$HardeningKittyConfigPathWS = "\\fs\Public\Security\hardening\WS.csv"
$HardeningKittyConfigPathDC = "\\fs\Public\Security\hardening\DC.csv"
$HardeningKittyConfigPathWAP = "\\fs\Public\Security\hardening\WAP.csv"
$HardeningKittyConfigPathMSSQL = "\\fs\Public\Security\hardening\MSSQL.csv"
$HardeningKittyConfigPathPSOS = "\\fs\Public\Security\hardening\PSOS.csv"

		Invoke-Command -ArgumentList $HardeningKittyPath,$HardeningKittyConfigPathWS -ComputerName $DNSHostName -ScriptBlock {
			Param($HardeningKittyPath, $HardeningKittyConfigPathWS)

			# Copy HardeningKitty files to C:\Windows\Temp and install HardeningKitty
			Copy-Item -Path $HardeningKittyPath -Destination "C:\Windows\";
			Copy-Item -Path $HardeningKittyConfigPathWS -Destination "C:\Windows\";
			Copy-Item -Path $HardeningKittyConfigPathDS -Destination "C:\Windows\";
			Copy-Item -Path $HardeningKittyConfigPathWAP -Destination "C:\Windows\";
			Copy-Item -Path $HardeningKittyConfigPathMSSQL -Destination "C:\Windows\";
			Copy-Item -Path $HardeningKittyConfigPathPSOS -Destination "C:\Windows\";

			#set-executionpolicy unrestricted
			
			# invoke hardeningKitty first time, repond 'n' to auto reboot. 
			Import-Module C:\Windows\Invoke-HardeningKitty.ps1
            
            if (($Computer -like "ws1*") -or ($Computer -like "ws3*") -or ($Computer -like "ws5*") -or ($Computer -like "employee*") -or ($Computer -like "sp5dc*")) 
			{
			Invoke-HardeningKitty -Mode HailMary -FileFindingList C:\Windows\WS.csv
			}
		elseif (($Computer -like "dc*") -or ($Computer -like "adfs*")) 
			{
			Invoke-HardeningKitty -Mode HailMary -FileFindingList C:\Windows\DC.csv
			}
		elseif (($Computer -like "wap*") -or ($Computer -like "mail*") -or ($Computer -like "client-web*")) 
			{
			Invoke-HardeningKitty -Mode HailMary -FileFindingList C:\Windows\WAP.csv
			}
		elseif (($Computer -like "mssql*") -or ($Computer -like "client-db*")) 
			{
			Invoke-HardeningKitty -Mode HailMary -FileFindingList C:\Windows\MSSQL.csv
			}					
		else (($Computer -like "psos*") -or ($Computer -like "ts*")) 
			{
			Invoke-HardeningKitty -Mode HailMary -FileFindingList C:\Windows\PSOS.csv
			}
  
			#set-executionpolicy restricted

			del C:\Windows\Invoke-HardeningKitty.ps1
			del C:\Windows\WS.csv
            del C:\Windows\DC.csv
            del C:\Windows\WAP.csv
            del C:\Windows\MSSQL.csv
            del C:\Windows\PSOS.csv
            
		   }