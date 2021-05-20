#connect-azaccount -Tenant "xxxx"
$subscriptionlist = @(Get-AzSubscription -WarningAction:SilentlyContinue) 
$file_data = Import-Csv -Path ~/inputfile.txt -Header 'TagsName', 'ResName'
$t=0
foreach ($list in $subscriptionlist) {
	Set-AzContext -Subscription $list.name
	#Get-AzPublicIpAddress | Select-Object Name, Id, IpAddress  >>publicipwalt.csv
	write-host $list.Name, $list.Id
	#Get-AzureRmResource -ResourceName "vm1" | Set-AzureRmResource -Tag @{AppIDSvcID="PAYE"} -Force
}