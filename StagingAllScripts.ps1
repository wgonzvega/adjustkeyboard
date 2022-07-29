############################################################################
#                             Walter Gonzalez                              #
#                               Marzo 2022                                 #
#                                                                          # 
############################################################################

# Update Tags - Applied to all the resources in a subscription
############################################################################
#                    CHANGE THIS PER SUBSCRIPTION                          #
############################################################################

# RunBook for Update Tags - Applied at the Subscription level
#
#
#
#
#  RUN THIS VSCODE
#  RUN THIS VSCODE
#  RUN THIS VSCODE
#  RUN THIS VSCODE
#  RUN THIS VSCODE
#
#
#
#
#
#
$modules = @("az.accounts", "az.compute", "az.automation", "az.storage", "az.resources", "az.profile")

#Parameters -----------------------------------------------------------------------------------------------------
$mySubscription = "759f5f36-b74a-429e-a671-61e733115dfc"

#Code of the application the resource is associated with in the CMDB.
$applicationCode = "ISPOC"

#Name of the application, service, or workload the resource is associated with in the CMDB
$applicationName = "Governance&SecurityPOC" 

#Name of the module or component associated with the application.
$applicationModule = "ISPOC" 

#Evertec group responsible for the implementation of the project
$group = "Information Security" 

#Owner of the application, workload, or service.(email)
$ownerName = "deoscoidy.sanchez@evertecinc.com" 

#Accounting cost center associated with this resource

$costCenter = "78113"

#Deployment environment of this application, workload, or service
$env = "poc"

#Person responsible for approving costs related to this resource.(email)
$approver = "ricardo.robles@evertecinc.com"

#Top-level division of your company that owns the workload the resource belongs to.
#In smaller organizations, this may represent a single corporate or shared top-level organizational element
$businessUnit = "Information Security"

#User that requested the creation of this application.(email)
$requestor = "ricardo.robles@evertecinc.com"

#Service Level Agreement level of this application, workload, or service
$serviceClass = "TBD"

#Date when this application, workload, or service was first deployed
$startDate = "2022"
#End of parameters----------------------------------------------------------------------------------------------------



#Update tags for all CURRENT services

function createRunbooks {
    write-host "Installing Automation Account Runbooks..."
    New-AzAutomationRunbook -Name CreateTagToAllResourceGroups -Type PowerShell -ResourceGroupName $rg -AutomationAccountName $autoacc
    New-AzAutomationRunbook -Name CreateBackupTagToAllResources -Type PowerShell -ResourceGroupName $rg -AutomationAccountName $autoacc

    
}

function putCodeintoScript {
    #Put code into runbook
    ##########################################
    #
    #
    #               Important
    #
    #
    ##########################################
    write-host "Installing Automation Account Powershell script code..."
        $osType = Read-host "What OS are you using (Win = 1, Mac = 2), (Ctrl/c to quit)"
        if ($osType -eq "1") {
        #Win
        $path1 = "c:\runbooks\CreateTagToAllResourceGroups.ps1"
        $path1 = "c:\runbooks\CreateBackupTagToAllResources.ps1"
        }elseif ($osType -eq "2") {   
            #Mac
            $path1 = "~/runbooks/CreateTagToAllResourceGroups.ps1"
            $path2 = "~/runbooks/CreateBackupTagToAllResources.ps1"
        }else {
            exit
        }
        Import-AzAutomationRunbook -Path $path1 -Name CreateTagToAllResourceGroups -Type PowerShell -AutomationAccountName $autoacc -ResourceGroupName $rg -Force
        Import-AzAutomationRunbook -Path $path2 -Name CreateBackupTagToAllResources -Type PowerShell -AutomationAccountName $autoacc -ResourceGroupName $rg -Force
        Publish-AzAutomationRunbook -Name CreateTagToAllResourceGroups -AutomationAccountName $autoacc -ResourceGroupName $rg
        Publish-AzAutomationRunbook -Name CreateBackupTagToAllResources -AutomationAccountName $autoacc -ResourceGroupName $rg
}

function createSchedules {
    write-host "Installing Automation Account Schedules..."
    #Set schedule time
    $StartTime1 = Get-Date "20:00:00"   
    $StartTime2 = Get-Date "20:30:00"

    #Create schedules
    New-AzAutomationSchedule -AutomationAccountName $autoacc -Name "sch-RGtag1" -DayInterval 1 -ResourceGroupName $rg
    New-AzAutomationSchedule -AutomationAccountName $autoacc -Name "sch-BKPtag1" -DayInterval 1 -ResourceGroupName $rg
    Start-Sleep -s 30 # wait for all resources to be deployed from the above command

    #Publish runbook
    Publish-AzAutomationRunbook -AutomationAccountName $autoacc -Name CreateTagToAllResourceGroups -ResourceGroupName $rg
    Publish-AzAutomationRunbook -AutomationAccountName $autoacc -Name CreateBackupTagToAllResources -ResourceGroupName $rg
    Start-Sleep -s 60 # wait for all resources to be deployed from the above command

    #Link schedule to runbook
    Register-AzAutomationScheduledRunbook -Name CreateTagToAllResourceGroups -ResourceGroupName $rg -AutomationAccountName $autoacc -ScheduleName "sch-RGtag1"
    Register-AzAutomationScheduledRunbook -Name CreateBackupTagToAllResources -ResourceGroupName $rg -AutomationAccountName $autoacc -ScheduleName "sch-BKPtag1"
}

function setModules{
    write-host "Installing Automation Account Modules..."
    foreach($dep in $modules){
        $module = Find-Module -Name $dep
        $link = $module.RepositorySourceLocation + "/package/" + $module.Name + "/" + $module.Version
        New-AzAutomationModule -AutomationAccountName $autoacc -Name $module.Name -ContentLinkUri $link -ResourceGroupName $rg
        Start-Sleep -s 600
    }
}

function listSubscriptions {
    Clear-Host
    $c = 0
    foreach ($list in $subscriptionlist) {
        write-host $c "- " $list.Name
        $c ++
    }
    $subscriptionID = Read-Host -Prompt 'Please enter the number of the SubscriptionId (Ctrl/c to quit)'
    return $subscriptionlist[$subscriptionID]
}

function selectSubscription {
    Select-AzSubscription -SubscriptionId $mySubscription.Id #-TenantId $mySubscription.TenantId
}

#Start
Clear-Host
$login = Read-Host -Prompt 'Do you want or need to login?(y/n), (Ctrl/c to quit)"'
if ($login -eq "Y" -or $login -eq "y") {
    Connect-AzAccount
}
Set-ExecutionPolicy -Scope Process - ExecutionPolicy Bypass
write-host "Getting Azure Information, please wait..."
$subscriptionlist = @(Get-AzSubscription)
$mySubscription = listSubscriptions
write-host "Connecting to subscription..."

#function call:
selectSubscription
write-host $mySubscription.Name $mySubscription.Id



$allResources = Get-AzResource | Select-Object Id,Tags
$tags = @{"applicationCode" = $applicationCode; "applicationName" = $applicationName;"applicationModule" = $applicationModule; "group" = $group; "ownerName" = $ownerName;"costCenter" = $costCenter; "env" = $env; "approver"= $approver; "businessUnit"= $businessUnit; "requestor" = $requestor; "serviceClass" = $serviceClass; "startDate" = $startDate}
foreach($resourceList in $allResources){
    write-output $resourceList.id
    write-output $resourceList.tags
    Update-AzTag -ResourceId $resourceList.id -Tag $tags -Operation Merge

}

#function call:
$rg = Read-Host "Please enter Automation Account Resource Group (Ctrl/c to quit)" 
$autoacc = Read-Host "Please enter Automation Account name (Ctrl/c to quit)" 
setModules
createRunbooks
createSchedules
putCodeintoScript

