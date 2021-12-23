#EvertecLLC: $tenant = "2b5b7d77-f19b-4c6d-b180-5768c09ad43b"
#BPPR:       $tenant = "aae8bd45-1879-4a6e-ac08-16cc906ee6bf"
$tenant = "2b5b7d77-f19b-4c6d-b180-5768c09ad43b"

#set off environmental warnings, set this to false for debbuging
Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"  
connect-azaccount -DeviceCode -Tenant $tenant | Out-Null
#Get all subs in a Tenant
$Selsubscription = @(Get-AzSubscription -TenantId $tenant) 
#$totalres = 0
write-output $tenant >/Users/waltergonzalez/AzureStart.txt
foreach ($rec in $Selsubscription) {
    Set-AzContext -Subscription $rec.name | Out-Null
    write-output $rec.subscriptionid >>/Users/waltergonzalez/AzureStart.txt
}
