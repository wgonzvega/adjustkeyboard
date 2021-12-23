#EvertecLLC: $tenant = "2b5b7d77-f19b-4c6d-b180-5768c09ad43b"
#BPPR:       $tenant = "aae8bd45-1879-4a6e-ac08-16cc906ee6bf"

#set off environmental warnings, set this to false for debbuging
Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"  
connect-azaccount -DeviceCode -Tenant $tenant
#Get all subs in a Tenant
$Selsubscription = @(Get-AzSubscription -TenantId $tenant) 
#$totalres = 0
foreach ($rec in $Selsubscription) {
    Set-AzContext -Subscription $rec.name
    $aks = Get-AzAksCluster
    if ($aks) {
        write-host $rec.name
        write-host $aks.Name
        #write-output $rec.Name >> /Users/wgonzvega/AllEvertecLLCResources.txt
        #$totalres = $totalres + $res.Count
    }else {
        write-host "AKS not found in" $rec.name
    }

}
#write-host "Resource count total:" $totalres#