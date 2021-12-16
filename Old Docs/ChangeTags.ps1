#Connect to Tenant, change "6cfeca43-6518-489d-9a83-f0a9bb0cba5b" to your Tenant ID
#connect-azaccount -Tenant "2b5b7d77-f19b-4c6d-b180-5768c09ad43b"

#Get all subs in a Tenant
$Selsubscription = @(Get-AzSubscription -WarningAction:SilentlyContinue) 

#Read Input File.  For this example the file only have two fields (tag value and resource name)
#Linux Based
$file_data = Import-Csv -Path ~/inputfile.csv -Header 'TagsName', 'ResName'

#Windows
#$file_data = Import-Csv -Path c:\temp\inputfile.csv -Header 'TagsName', 'ResName'


$t=0

#Since I got only one subscription I used the variable $Selsubscription, if you have more that one subscription change the $Selsubscription.name
#with the ID of your subscription surrounded by quotes ""
Set-AzContext -Subscription $Selsubscription.name
write-host $Selsubscription.Name, $Selsubscription.Id
foreach ($rec in $file_data) {
    $mergeTag = @{AppIDSvcID=$file_data.TagsName}
	$resourceData = Get-AzResource -ResourceName $file_data.ResName
    Update-AzTag -ResourceId $resourceData.ResourceId -Tag $mergeTag -Operation Merge
    write-host $file_data.TagsName, $file_data.ResName
    $t ++
}
