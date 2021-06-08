<#modules needed (install them at the cmd prompt level: install-module -name [module name])
az.accounts
az.compute
az.resources
#>



#Global variables

<#For Evertecllc Chile & Multiclientes
$tenant1 = "2b5b7d77-f19b-4c6d-b180-5768c09ad43b"
$sub1 = "3e527659-51a8-4f6e-9214-c5a728456508"
$sub2 = "ea2697d1-9ec5-46ed-8bc6-c81bea17abd1"
#>

#Private test area
$tenant1 = "3eca7dff-7c23-43b9-9551-7365b93d4f97"
$sub1 = "6cfeca43-6518-489d-9a83-f0a9bb0cba5b"
$sub2 = ""
#>

$subname = ""
$vmrec = ""
$selvm1 = ""
$selvm2 = ""
$seltenant = ""
$foundit = ""
$foundrg = ""
$seltenant = ""
$vmnum = 0
$allRG = ""
$vmarray = New-Object System.Collections.ArrayList
$rgarray = New-Object System.Collections.ArrayList

function docontext {
    Clear-Host 
    Clear-AzContext -Force
    Connect-AzAccount #-WarningAction:SilentlyContinue
    $seltenant = Get-AzTenant -TenantId $tenant1  
    write-host "Selected tenant:"$seltenant.name
    domenu
}
Function domenu {
    Clear-Host
    #Set the subscription
    write-host "Tenant Id:" $tenant1
    write-host "`n`nApplications:"
    
    #Evertecllc
    #write-host "`n1- Paya" "& Paye (CPS Multiclientes)" "`n2- Pays (CPS Chile)"

    #Private
    write-host "`n1- Pay as you Go"
    
    $listrec = Read-Host "`nPlease select the application that you want to work with (Ctrl/C to cancel)"
    
    switch ($listrec) {
        "1" {
            write-host "`nPlease wait, connecting to subscription..."
            $subnameobj = Set-AzContext -Subscription $sub1 #-WarningAction:SilentlyContinue
            $subname = $subnameobj.Name
            $subname = $subname.split('(')
            $subname = $subname[0]
            write-host "`nSubscription" $subname
            write-host "Connected to subscription..." -ForegroundColor White -BackgroundColor Black "`n"
            pause
            dovmaction
        }
        "2" {
            write-host "`nPlease wait, connecting to subscription..."
            $subnameobj = Set-AzContext -Subscription $sub2 #-WarningAction:SilentlyContinue
            $subname = $subnameobj.Name
            $subname = $subname.split('(')
            $subname = $subname[0]
            write-host "Subscription" $subname
            write-host "Connected to subscription..." -ForegroundColor White -BackgroundColor Black "`n"
            pause
            dovmaction
        }
        default {
            write-Host "`nEntered value for Application is out of range, error in value." -ForegroundColor Yellow -BackgroundColor Black
            ; read-host "Press any key to continue (Ctrl/C to cancel)"; domenu 
        }
    }

}
function dovmaction {

    Clear-Host
    $selvm1 = Read-Host "`nPlease enter the name of the Virtual Machine that you want to work with (Ctrl/C to cancel)"

    #setvmname2
    clear-host
    write-host "`nConfirm your selection by re-entering the server name."
    $selvm2 = Read-Host "Please enter one more time the name of the Virtual Machine that you want to work with (Ctrl/C to cancel)"


    #check if they are equals
    $selvm1 = $selvm1.ToLower()
    $selvm2 = $selvm2.ToLower()
    if ($selvm1 -ne $selvm2) {
        write-host "`n`nThe name for the server and the name on the confirmation must match.  Input values not equals." -ForegroundColor Yellow -BackgroundColor Black
        write-host "Server name number 1:" $selvm1
        write-host "Server name number 2:" $selvm2 "`n"
        #$equalname = "n"
        pause
        clear-host
        dovmaction 
    }
    #get the vm and the resource group and compare them
    #look for the vm at each RG
    write-host "`nServer name and confirmation values matched..."
    pause
    lookforvm
}
function lookforvm {
    clear-host
    $allRG = @(Get-AzResourceGroup)
    $foundit = "0"
    write-host "`nLooking for VM" $selvm1 "on each resource group, please wait..."
    $x = 0
    write-host "`nServer list"
    foreach ($rec in $allRG) {
        $vmrec = @(Get-AzVM -ResourceGroupName $rec.ResourceGroupName)
        foreach ($vmlist in $vmrec) {
            if ($vmlist.name -eq $selvm1) {
                $foundit = "1"
                $foundrg = $rec.ResourceGroupName  
                write-host $x "- Server" $selvm1 "found at" $foundrg "Resource Group"
                $vmarray.Add($selvm1) > $null
                $rgarray.Add($foundrg) > $null
                $x ++
            } 
        }
    }
    $x = $x - 1
    stopstartvm
}

function stopstartvm {
    if ($foundit -eq "1") {
        $vmnum = read-host "`nPlease select from the list the server that you need to work with, (Crtl/C to cancel, default is 0)"
        if($vmnum -eq ""){
            $vmnum = "0"
        }
        if ($vmnum -ge "0" -and $vmnum -le $x) {
            $trec = [int]$vmnum
            write-host "`n`nYou select server" $vmarray[$trec] "from Resource Group" $rgarray[$trec]
            $foundrg = $rgarray[$trec]
            if ($selvm1 -match "prd" -or $foundrg -match "prd" -or $selvm1 -match "prod" -or $foundrg -match "prod" ) {
                if ($foundrg -notmatch "preprod") {
                    if ($foundrg -notmatch "pre-prod") {
                        write-host "`n`n`nServer" $selvm1 "seems to be a production device.`nProcess is not allowed to modify production resources. Process stopped." -ForegroundColor Yellow -BackgroundColor Black
                        exit
                    }
                }
            }
        }
        else {
            Write-Host "`nEntered value for server list is out of range, error in value."-ForegroundColor Yellow -BackgroundColor Black
            read-host "Press any key to continue (Ctrl/C to cancel)"  
            lookforvm
        }
        lastaction
    }
}
function lastaction {
    Clear-Host
    write-host "`nGetting server actual state..."
    $vm1 = Get-AzVM -ResourceGroupName $foundrg -Name $selvm1 -Status
    $status = $vm1.statuses  
    write-host "Server" $selvm1 "actual state is:" $status.displaystatus -ForegroundColor White -BackgroundColor Black
    write-host "`nTarget info..."
    write-host "Virtual Machine Name   : " $selvm1
    write-host "Resource Group Name    : " $foundrg
    write-host "Subscription Name      : " $subname
    write-host "Tenant Name            : " $seltenant.Name

    $actionrec = Read-Host "`nPlease enter the number of the action that you want to perform (1 = Stop(Deallocate), 2 = Start, Ctrl/C to cancel)"
    switch ($actionrec) {
        "1" {
            write-host "`nStopping server", $selvm1 , "from Resource Group" $foundrg, "this could take several minutes to complete, please confirm.`n" -ForegroundColor White -BackgroundColor Black
            $result = Stop-AzVM -ResourceGroupName $foundrg -Name $selvm1
            if ($result.Status -eq "Succeeded") {
                write-host "`nOperation Id:" $result.OperationId "`nStatus      :" $result.Status "`nStart time  :" $result.StartTime "`nEnd time    :" $result.EndTime
                write-host "`n`nServer has accepted the stop(deallocate) command.`nPlease wait a few minutes for the server to update his status.`n" -ForegroundColor White -BackgroundColor Black
            }
            ; exit
        }
        "2" {
            write-host "`nStarting server", $selvm1 , "from Resource Group" $foundrg, "this could take several minutes to complete, please confirm.`n" -ForegroundColor White -BackgroundColor Black
            $result = Start-AzVM -ResourceGroupName $foundrg -Name $selvm1 -Confirm
            if ($result.Status -eq "Succeeded") {
                write-host "`nOperation Id:" $result.OperationId "`nStatus      :" $result.Status "`nStart time  :" $result.StartTime "`nEnd time    :" $result.EndTime
                write-host "`n`nServer has accepted the start command.`nPlease wait a few minutes for the server to update his status.`n" -ForegroundColor White -BackgroundColor Black
            }
            ; exit
        }
        default {
            Write-Host "`nEntered value for action is out of range, error in value." -ForegroundColor Yellow -BackgroundColor Black
            read-host "Press any key to continue (Ctrl/C to cancel)"
            clear-host
            lastaction #stopstartvm #lookforvm
        }
    }
}




#function calls

docontext

