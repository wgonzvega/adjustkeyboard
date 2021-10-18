############################################################################
#                             Walter Gonzalez                              #
#                                Mayo 2020                                 #
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



#Parameters -----------------------------------------------------------------------------------------------------
$mySubscription = "TBD"

#Code of the application the resource is associated with in the CMDB.
$applicationCode = "TBD"

#Name of the application, service, or workload the resource is associated with in the CMDB
$applicationName = "TBD" 

#Name of the module or component associated with the application.
$applicationModule = "TBD" 

#Evertec group responsible for the implementation of the project
$group = "TBD" 

#Owner of the application, workload, or service.(email)
$ownerName = "TBD" 

#Accounting cost center associated with this resource

$costCenter = "TBD"

#Deployment environment of this application, workload, or service
$env = "TBD"

#Person responsible for approving costs related to this resource.(email)
$approver = "TBD"

#Top-level division of your company that owns the workload the resource belongs to.
#In smaller organizations, this may represent a single corporate or shared top-level organizational element
$businessUnit = "TBD"

#User that requested the creation of this application.(email)
$requestor = "TBD"

#Service Level Agreement level of this application, workload, or service
$serviceClass = "TBD"

#Date when this application, workload, or service was first deployed
$startDate = "TBD"
#End of parameters----------------------------------------------------------------------------------------------------





#Update tags for all CURRENT services

function createRunbooks {
    New-AzAutomationRunbook -Name CreateTagToAllResourceGroups -Type PowerShell -ResourceGroupName $rg -AutomationAccountName $autoacc
    New-AzAutomationRunbook -Name CreateBackupTagToAllResources -Type PowerShell -ResourceGroupName $rg -AutomationAccountName $autoacc

    #Put code into runbook
    #In progress:
    <#
        $resourceGroupName = "MyResourceGroup"
        $automationAccountName = "MyAutomatonAccount"
        $runbookName = "Hello-World"
        $osType = Read-host "What OS are you using"
        #$WindowsscriptFolder = "c:\runbooks"
        #$MacscriptFolder = "/runbooks"
        Import-AzAutomationRunbook -Path "$scriptfolder\Hello-World.ps1" -Name $runbookName -Type PowerShell -AutomationAccountName $automationAccountName -ResourceGroupName $resourceGroupName -Force
        Publish-AzAutomationRunbook -Name $runbookName -AutomationAccountName $automationAccountName -ResourceGroupName $resourceGroupName
    #>
}

function createSchedules {
    #Set schedule time
    $StartTime1 = Get-Date "23:00:00"   #23:00:00 es las tres de la AM en horario PR
    $StartTime2 = Get-Date "23:30:00"

    #Create schedules
    New-AzAutomationSchedule -AutomationAccountName $autoacc -Name "sch-RGtag1" -StartTime $StartTime1 -DayInterval 1 -ResourceGroupName $rg
    New-AzAutomationSchedule -AutomationAccountName $autoacc -Name "sch-BKPtag1" -StartTime $StartTime2 -DayInterval 1 -ResourceGroupName $rg

    #Publish runbook
    Publish-AzAutomationRunbook -AutomationAccountName $autoacc -Name CreateTagToAllResourceGroups -ResourceGroupName $rg
    Publish-AzAutomationRunbook -AutomationAccountName $autoacc -Name CreateBackupTagToAllResources -ResourceGroupName $rg

    #Link schedule to runbook
    Register-AzAutomationScheduledRunbook -Name CreateTagToAllResourceGroups -ResourceGroupName $rg -AutomationAccountName $autoacc -ScheduleName "sch-RGtag1"
    Register-AzAutomationScheduledRunbook -Name CreateBackupTagToAllResources -ResourceGroupName $rg -AutomationAccountName $autoacc -ScheduleName "sch-BKPtag1"
}

function listSubscriptions {
    Clear-Host
    $c = 0
    foreach ($list in $subscriptionlist) {
        write-host $c "- " $list.Name
        $c ++
    }
    $subscriptionID = Read-Host -Prompt 'Please enter the number of the SubscriptionId (Ctrl/C to quit)'
    return $subscriptionlist[$subscriptionID]
}

function selectSubscription {
    Select-AzSubscription -SubscriptionId $mySubscription.Id #-TenantId $mySubscription.TenantId
}


#Start
Clear-Host
$login = Read-Host -Prompt 'Do you want or need to login?(y/n), (Ctrl/C to quit)"'
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
$rg = Read-Host "Please enter Automation Account Resource Group (Ctrl/C to quit)" 
$autoacc = Read-Host "Please enter Automation Account name (Ctrl/C to quit)" 
createRunbooks
createSchedules
