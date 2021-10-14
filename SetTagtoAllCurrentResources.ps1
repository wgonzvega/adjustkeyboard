############################################################################
#                             Walter Gonzalez                              #
#                                Mayo 2020                                 #
#                                                                          # 
############################################################################



# Update Tags - Applied to all the resources in a subscription
############################################################################
#                    CHANGE THIS PER SUBSCRIPTION                          #
############################################################################
$mySubscription = "769f74a0-c7da-4b5a-8bc9-9ffb644a30eb"



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
#Code of the application the resource is associated with in the CMDB.
$applicationCode = "EVPR"

#Name of the application, service, or workload the resource is associated with in the CMDB
$applicationName = "TBD" 

#Name of the module or component associated with the application.
$applicationModule = "TBD" 

#Evertec group responsible for the implementation of the project
$group = "Digital Solutions" 

#Owner of the application, workload, or service.(email)
$ownerName = "wilfredo.rodriguez@evertecinc.com" 

#Accounting cost center associated with this resource

$costCenter = "77010"

#Deployment environment of this application, workload, or service
$env = "TBD"

#Person responsible for approving costs related to this resource.(email)
$approver = "wilfredo.rodriguez@evertecinc.com"

#Top-level division of your company that owns the workload the resource belongs to.
#In smaller organizations, this may represent a single corporate or shared top-level organizational element
$businessUnit = "Payments Reporting"

#User that requested the creation of this application.(email)
$requestor = "denise.fuentes@evertecinc.com"

#Service Level Agreement level of this application, workload, or service
$serviceClass = "TBD"

#Date when this application, workload, or service was first deployed
$startDate = "2021"
#End of parameters----------------------------------------------------------------------------------------------------





#Update tags for all CURRENT services


function listSubscriptions {
    Clear-Host
    $c = 0
    foreach ($list in $subscriptionlist) {
        write-host $c "- " $list.Name
        $c ++
    }
    $subscriptionID = Read-Host -Prompt 'Please enter the number of the SubscriptionId'
    return $subscriptionlist[$subscriptionID]
}

function selectSubscription {
    Select-AzSubscription -SubscriptionId $mySubscription.Id #-TenantId $mySubscription.TenantId
}


#Start
Clear-Host
$login = Read-Host -Prompt 'Do you want or need to login?(y/n)'
if ($login -eq "Y" -or $login -eq "y") {
    Connect-AzAccount
}
Set-ExecutionPolicy -Scope Process - ExecutionPolicy Bypass
write-host "Getting Azure Information, please wait..."
$subscriptionlist = @(Get-AzSubscription)
$mySubscription = listSubscriptions
write-host "Connecting to subscription..."

selectSubscription
write-host $mySubscription.Name $mySubscription.Id





$allResources = Get-AzResource | Select-Object Id,Tags
$tags = @{"applicationCode" = $applicationCode; "applicationName" = $applicationName;"applicationModule" = $applicationModule; "group" = $group; "ownerName" = $ownerName;"costCenter" = $costCenter; "env" = $env; "approver"= $approver; "businessUnit"= $businessUnit; "requestor" = $requestor; "serviceClass" = $serviceClass; "startDate" = $startDate}
foreach($resourceList in $allResources){
	write-output $resourceList.id
	write-output $resourceList.tags
	Update-AzTag -ResourceId $resourceList.id -Tag $tags -Operation Merge

}
