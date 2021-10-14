##Login to Azure 
#az login
##Connect to Tenant, change "xxxx" to your Tenant ID
#$myTenant=connect-azaccount -Tenant "e52c32c1-d67b-4310-8cfa-4156e1d0e24b"

##Display subscriptions
$Selsubscription = Get-AzSubscription -WarningAction:SilentlyContinue
$t = 0
foreach ($rec in $Selsubscription) {
    write-host $t, '- ' $rec.Name '=' $rec
    $t ++
}

$subArray = @($Selsubscription)
$searchSub = Read-Host "Please enter the number of the subscription you want to search"
if ($searchSub -gt 0 -and $searchSub -lt $subArray.name.count - 1) {
    Select-AzSubscription $subArray[$searchSub]

    ##Read Input File.  For this example the file only have two fields (tag value and resource name)
    ##Linux Based
    $file_data = Import-Csv -Path ~/inputfile.csv -Header 'TagsName', 'ResName'

    ##Windows
    #$file_data = Import-Csv -Path c:\temp\inputfile.csv -Header 'TagsName', 'ResName'

    $t = 0

    foreach ($rec in $file_data) {
        Get-AzResource -ResourceName $file_data.ResName[$t] | Set-AzResource -Tag @{AppID = $file_data.TagsName[$t] } -Force
        write-host $file_data.TagsName[$t], $file_data.ResName[$t]
        $t ++
    }
}
else {
    write-host "Selection error please run script again"
}