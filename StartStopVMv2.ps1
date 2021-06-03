
<#
Cambios propuestos en 6/2/2021
1- Preguntar por nombre solucion
    a-Pays
    b-Paye
    c-Paya
    Con esta informacion utilizar una suscripcion en particular:
        a- Chile Santander
        b- Multiclientes (508)
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

#Global variables
#Evertecllc
<#$tenant1 = "2b5b7d77-f19b-4c6d-b180-5768c09ad43b"
$sub1 = "3e527659-51a8-4f6e-9214-c5a728456508"
$sub2 = "ea2697d1-9ec5-46ed-8bc6-c81bea17abd1"
$subname = ""#>

#Private acc
$tenant1 = "3eca7dff-7c23-43b9-9551-7365b93d4f97"
$sub1 = "6cfeca43-6518-489d-9a83-f0a9bb0cba5b"
$subname = ""

Clear-Host 
    Connect-AzAccount #-WarningAction:SilentlyContinue
    $seltenant = Get-AzTenant -TenantId $tenant1  
    write-host "Selected tenant:"$seltenant.name
    

#Set the subscription
write-host "Tenant Id:" $tenant1
write-host "`n`nSubscriptions:"
#write-host "`n1- Paya" "- Paye" "`n2- Pays"
write-host "`n1- Pay as you go"
$listrec = Read-Host "`nPlease enter the environment that you want to work with (Ctrl/C to cancel)"
write-host "`nPlease wait, connecting to subscription..."
switch ($listrec){
    "1" {
        $subname = Set-AzContext -Subscription $sub1 #-WarningAction:SilentlyContinue
        write-host "Subscription" $subname.Name ", connected"
        break
    }
    "2" {
        $subname = Set-AzContext -Subscription $sub2 #-WarningAction:SilentlyContinue
        write-host "Subscription" $subname.Name ", connected"
        break
    }
    default { "`nSEntered value is out of range, error in action value"; break }
}

<#
#set the environment
write-host "`n1- Dev" "`n2- Crt" "`n3- Uat" "`n4- Prd"
$listrec = Read-Host "`nPlease enter the environment that you want to work with (Ctrl/C to cancel)"
switch ($listrec){
    "1" {
        write-host "Dev"
        break
    }
    "2" {
        write-host "Crt"
        break
    }
    "3" {
        write-host "Uat"
        break
    }
    "4" {
        write-host "Prd"
        break
    }
    default { "`nSEntered value is out of range, error in action value"; break }
}
#>

#setvmname1
$selvm1 = Read-Host "`nPlease enter the Virtual Machine name that you want to work with (Ctrl/C to cancel)"

#setvmname2
clear-host
write-host "Please confirm your selection by re-entering the server name."
$selvm2 = Read-Host "`nPlease enter the Virtual Machine name that you want to work with (Ctrl/C to cancel)"


#check if they are equals
$selvm1 = $selvm1.ToLower()
#$selrg1 = $selrg1.ToLower()

$selvm2 = $selvm2.ToLower()
#$selrg2 = $selrg2.ToLower()


if ($selvm1 -eq $selvm2){
    $equalname = "y"
}else {
    $equalname = "n"
}

if ($equalname = "y"){
    write-host "Equals"
}else {
    write-host "Not equal"
}
write-host "Answer #1" $selvm1
write-host "Answer #2" $selvm2

#get the vm and the real resource group, compare them
<#
 look for the vm at each RG
#>
$allRG = Get-AzResourceGroup
$foundit = 0
foreach ($rec in $allRG){
    write-host "Checking for VM" $selvm1 "at" $rec.ResourceGroupName
    $vmrec = Get-AzVM -ResourceGroupName $rec.ResourceGroupName -Name $selvm1 -ErrorAction:SilentlyContinue
    if($vmrec.name -eq $selvm1){
        $foundit = "1"
        $foundrg = $rec.ResourceGroupName

    } 
}
if($foundit -eq "1") {
    write-host "Server" $selvm1 "found at" $foundrg
}else {
    write-host "Server not found"
}

