# Change the following variables accordingly
$HardeningKittyPath = ""
$HardeningKittyConfigPathWS = "\\fs\Public\Security\hardening\WS.csv"

			Import-Module \\fs\Public\Security\hardening\Invoke-HardeningKitty.ps1
			Invoke-HardeningKitty -Mode HailMary -FileFindingList .\WS.csv

