#$arraywithheader=New-Object System.Collections.Generic.List[System.Object]
#connect-azaccount -Tenant "aae8bd45-1879-4a6e-ac08-16cc906ee6bf"
$Selsubscription = @(Get-AzSubscription -WarningAction:SilentlyContinue)
foreach ($sub in $Selsubscription){
    Set-AzContext -Subscription $sub
    $subname = $sub.Name
    Write-Output ("`nSubscription    : $subname") >> "~/cpunraminv.csv"
    $vmsizelist = Get-AzVMSize -Location eastus
    $vms=get-azvm
    Write-Output ("Name , Size , Cores , Memory") >> "~/cpunraminv.csv"
    foreach ($vm in $vms){
        $name = $vm.Name
        $size = $vm.HardwareProfile.VmSize
        $memory = ($vmsizelist | ?{$_.name -eq $size}).memoryinmb
        $cores = ($vmsizelist | ?{$_.name -eq $size}).numberofcores
        $osdisk = ($vmsizelist | ?{$_.name -eq $size}).OSDiskSizeInMB
        Write-Output ("$name , $size , $cores , $memory") >> "~/cpunraminv.csv"
        #Write-Output ("OS Disk:$osdisk`n") >> "~/cpunraminv.txt"
    }

}

