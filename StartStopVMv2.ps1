
<#
Cambios propuestos en 6/2/2021
1- Preguntar por nombre solucion
    a-Pays
    b-Paye
    c-Paya
    d- Pueden haber otros
    Con esta informacion utilizar una suscripcion en particular:
        a- Chile Santander
        b- Multiclientes
2- Preguntar por ambiente (convertir en minusculas)
    a- Dev
    b- Cert,Crt
    c- Prod, Prd
    d- UAT, Uat, uat
3- Preguntar por nombre servidor
4- Confirmar preguntando nuevamente punto 2 y punto 3
5- Verificar que la informacion concuerde entre ambas preguntas
6- Buscar por toda las suscripciones el nombre del servidor en los RG (convertirlos en minusculas
 y verificar que contenga la frase del punto 2)
7- Validar el hallazgo del server y su RG correspondiente
8- Seleccionar la accion
9- Confirmar accion
10- Tomar la accion

#>
function gettenant {
    Clear-Host 
   
    #Clear-AzContext
    Connect-AzAccount #-WarningAction:SilentlyContinue
    $tenant = Get-AzTenant #-WarningAction:SilentlyContinue
    $t = 0
    write-host "`n##" "`tTenant Name" "`t`t`t`t`tId"

    foreach ($recs in $tenant) {
        $spaces = $recs.Name.Length
        if ($spaces -gt 40) {
            $nametodisplay = $recs.name.substring(0, 40) 
        }
        else {
            $spaces = 40 - $spaces
            $nametodisplay = $recs.name + $divider.substring(0, $spaces) 
        }
        write-host $t $nametodisplay $recs.Id -Separator "`t"
        $t ++
    }
    $t --
    $selsubs = Read-Host "`nPlease enter the number of the Tenant that you want to work with (Ctrl/C to cancel)"
    if ([int]$selsubs -le $t -and [int]$selsubs -ge 0) {
        $seltenant = $tenant[$selsubs].Id
        write-host "Tenant selected:", $tenant[$selsubs].Name, $seltenant
    }
    else {
        write-host "Entered value is out of range"
        break
    }
    
    return $seltenant
}



function setsub {
    param (
        [string]$tenant
    )
    #Get all subs in a Tenant
    $length = $tenant.length
    $tenantid = $tenant.Substring($length-36,36)
    write-host "Tenant Id:" $tenantid
    $Selsubscription = @(Get-AzSubscription -TenantId $tenantid -WarningAction:SilentlyContinue) 
    $t = 0
    $divider = "                                                               "
    write-host "`n##" "`tSubscription Name" "`t`t`t`tSubscription Id"
    foreach ($recs in $Selsubscription) {
        $spaces = $recs.Name.Length
        if ($spaces -gt 40) {
            $nametodisplay = $recs.name.substring(0, 40) 
        }
        else {
            $spaces = 40 - $spaces
            $nametodisplay = $recs.name + $divider.substring(0, $spaces) 
        }
        write-host $t $nametodisplay $recs.id -Separator "`t"
        $t ++
    }
    $selsubs = Read-Host "`nPlease enter the number of the subscription that you want to work with (Ctrl/C to cancel)"
    $t --
    if ([int]$selsubs -le $t -and [int]$selsubs -gt -1) {
        write-host "Subscription selected:", $Selsubscription[$selsubs].Name
        $subsid = $Selsubscription[$selsubs].Id
        write-host "Setting Subscription..."
        Set-AzContext -Subscription $subsid
    }
    else {
        write-host "Entered value is out of range"
        break
    }
    $selsubsc = $Selsubscription[$selsubs].Name
    return $selsubsc
}

function getvms {
    param (
        [string] $tenant,
        [string] $subs
    )
    write-host "Getting VM list..."
    $vms = @(Get-AzVM -WarningAction:SilentlyContinue)
    $t = 0

    write-host "`n##" "`tServer Name" "`t`t`t`t`tResourceGroup"
    foreach ($recs in $vms) {
        $spaces = $recs.Name.Length
        if ($spaces -gt 40) {
            $nametodisplay = $recs.name.substring(0, 40) 
        }
        else {
            $spaces = 40 - $spaces
            $nametodisplay = $recs.name + $divider.substring(0, $spaces) 
        }

        write-host $t $nametodisplay $recs.ResourceGroupName  -Separator "`t"
        $t ++
    }
    $listrec = Read-Host "`nPlease enter the number of the vm that you want to work with (Ctrl/C to cancel)"
    $t --
    if ([int]$listrec -le $t -and [int]$listrec -gt -1) {
        write-host "Working..."
        $tenantname = Get-AzTenant -TenantId $tenant
        write-host "`nYou have selected..."
        write-host "Virtual machine   : " $vms[$listrec].Name 
        write-host "From subscription : " $subs
        write-host "In the tenant     : " $tenantname.Name    }
    else {
        write-host "Entered value is out of range"
        break
    }


    $actionrec = Read-Host "`nPlease enter the number of the action that you want to perform (1 = Stop (Deallocate), 2= Start, Ctrl/C to cancel)"

    switch ($actionrec) {
        "1" {
            write-host "`nStopping server", $vms[$listrec].Name , "from Resource Group" $vms[$listrec].ResourceGroupName, "please confirm..."
            Stop-AzVM -ResourceGroupName $vms[$listrec].ResourceGroupName -Name $vms[$listrec].Name 
            ; break
        }
        "2" {
            write-host "`nStarting server", $vms[$listrec].Name , "from Resource Group" $vms[$listrec].ResourceGroupName, "please confirm..."
            Start-AzVM -ResourceGroupName $vms[$listrec].ResourceGroupName -Name $vms[$listrec].Name -Confirm
            ; break
        }
        default { "`nSEntered value is out of range, error in action value"; break }
    }

}
 
#Start functions calls
$divider = "                                                                           "
$tenantback = gettenant 
$subsback = setsub -tenant $tenantback
getvms -tenant $tenantback -subs $subsback
#End