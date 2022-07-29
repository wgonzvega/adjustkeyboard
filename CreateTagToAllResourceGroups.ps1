
############################################################################
#                             Walter Gonzalez                              #
#                                Mayo 2020                                 #
#                                                                          # 
############################################################################


# Update Tags - Applied to all the resources in a subscription
############################################################################
#                    CHANGE THIS PER SUBSCRIPTION                          #
############################################################################

# RunBook for Update Tags - Applied at the RG level



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


#Start
# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave –Scope Process

#Authenticate using the account configured when the automation account was created
$connection = Get-AutomationConnection -Name AzureRunAsConnection

while(!($connectionResult) -And ($logonAttempt -le 10))
{
    $LogonAttempt++
    # Logging in to Azure...
    $connectionResult =    Connect-AzAccount `
                               -ServicePrincipal `
                               -Tenant $connection.TenantID `
                               -ApplicationId $connection.ApplicationID `
                               -CertificateThumbprint $connection.CertificateThumbprint

    Start-Sleep -Seconds 30
}

Select-AzSubscription -SubscriptionId $mySubscription

#Update tags for all services

$allResourcesGroup = Get-AzResourceGroup
$tags = @{"applicationCode" = $applicationCode; "applicationName" = $applicationName;"applicationModule" = $applicationModule; "group" = $group; "ownerName" = $ownerName;"costCenter" = $costCenter; "env" = $env; "approver"= $approver; "businessUnit"= $businessUnit; "requestor" = $requestor; "serviceClass" = $serviceClass; "startDate" = $startDate}
foreach($resourceList in $allResourcesGroup){
    write-output $resourceList.ResourceId
    write-output $resourceList.Location
    write-output $resourceList.Tags
    if ($resourceList.Tags.applicationCode -eq $null){
        $resourceGroup = Get-AzResourceGroup -Name $resourceList.ResourceGroupName
        Update-AzTag -ResourceId $resourceGroup.ResourceId -tag $tags -Operation Merge
    }
}
