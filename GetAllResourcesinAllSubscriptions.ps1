#EvertecLLC: $tenant = "2b5b7d77-f19b-4c6d-b180-5768c09ad43b"
#BPPR:       $tenant = "aae8bd45-1879-4a6e-ac08-16cc906ee6bf"

connect-azaccount -Tenant $tenant
#Get all subs in a Tenant
$Selsubscription = @(Get-AzSubscription -TenantId connect-azaccount -Tenant $tenant -WarningAction:SilentlyContinue) 
$totalres = 0
foreach ($rec in $Selsubscription) {
    Set-AzContext -Subscription $rec.name
    write-output $rec.Name >> /Users/wgonzvega/AllEvertecLLCResources.txt
    $res = Get-AzResource 
    $res | Format-Table >> /Users/wgonzvega/AllEvertecLLCResources.txt
    $totalres = $totalres + $res.Count
}
write-host "Resource count total:" $totalres