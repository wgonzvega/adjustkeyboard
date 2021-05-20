############################################
#          Enterprise Architecture         #
#              Walter Gonzalez             #
#                 June 2020                #
############################################


#Registrar Providers mas comunes


#########################################
# Must be run from the Azure PowerShell #
#########################################


# Variables
$providers = @("Microsoft.Advisor", "Microsoft.Security", "Microsoft.AlertsManagement", "Microsoft.PolicyInsights", "Microsoft.Network", "Microsoft.EventHub", "Microsoft.Storage", `
        "Microsoft.Compute", "Microsoft.ResourceHealth", "Microsoft.SqlVirtualMachine", "Microsoft.RecoveryServices", "Microsoft.insights", `
        "Microsoft.Automation", "Microsoft.Sql", "Microsoft.OperationalInsights", "Microsoft.OperationsManagement", "Microsoft.SecurityInsights", `
        "Microsoft.ManagedIdentity", "Microsoft.Capacity","Microsoft.Blueprint")

function setProviders {
    foreach ($list in $providers) {
        Register-AzResourceProvider -ProviderNamespace $list
        write-host $list
    }
}

function listSubscriptions {
    cls
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
cls

Set-ExecutionPolicy -Scope Process - ExecutionPolicy Bypass
write-host "Getting Azure Information, please wait..."
$subscriptionlist = @(Get-AzSubscription)
$mySubscription = listSubscriptions
write-host "Connecting to subscription..."

selectSubscription
write-host $mySubscription.Name $mySubscription.Id
setProviders
