#EvertecLLC: $tenant = "2b5b7d77-f19b-4c6d-b180-5768c09ad43b"
#BPPR:       $tenant = "aae8bd45-1879-4a6e-ac08-16cc906ee6bf"

$tenant = "2b5b7d77-f19b-4c6d-b180-5768c09ad43b"
#set off environmental warnings, set this to false for debbuging
Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"  
connect-azaccount -DeviceCode -Tenant $tenant
#Get all subs in a Tenant
$Selsubscription = @(Get-AzSubscription -TenantId $tenant) 
#$totalres = 0
#$targetSubs = "evtc-cps-multicliente 78601 evtc-corenetwork 78087 evtc-cps-chile 78602 risk"
Clear-Host
$output = 'Subscription' + ',' + 'VM Name' + ',' + 'VM Id'
write-output $output >/Users/waltergonzalez/AzureVmHumbertoSanchez.csv
foreach ($rec in $Selsubscription) {
    if (($rec.name -match 'corenetwork') -or ($rec.name -match 'cps') -or ($rec.name -match 'risk')) {
        Set-AzContext -Subscription $rec.name
        $vms = Get-AzVM
        if ($vms) {
            foreach ($vm in $vms) {
                $output = $rec.name + ',' + $vm.Name + ',' + $vm.VmId
                write-output $output  >>/Users/waltergonzalez/AzureVmHumbertoSanchez.csv
            }
        }
        else {
            write-host $vms.Name
            write-host "VMs not found in" $rec.name
        }
    }
}
