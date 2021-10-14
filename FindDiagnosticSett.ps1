<#
.Synopsis
A script used to export diagnostics settings configuration for all Azure resources.

.DESCRIPTION
A script used to find and export diagnostics settings configuration for Azure resources in all Azure Subscriptions.
Finally, it will save the report as text file for each Azure Subscription.

.Notes
Created   : 2020-11-16
Version   : 1.0
Author    : Charbel Nemnom
Twitter   : @CharbelNemnom
Blog      : https://charbelnemnom.com
Disclaimer: This script is provided "AS IS" with no warranties.
#>

# Login with Connect-AzAccount if not using Cloud Shell
Connect-AzAccount

# Get all Azure Subscriptions
$azSubs = Get-AzSubscription

# Loop through all Azure Subscriptions
foreach ($azSub in $azSubs) {
    Set-AzContext $azSub.id | Out-Null

    # Set array
    $azlogs = @()

    # Get all Azure resources deployed in each Subscription
    $azResources = Get-AZResource

    # Get all Azure resources which have Diagnostic settings enabled and configured
    foreach ($azResource in $azResources) {
        $resourceId = $azResource.ResourceId
        $azDiagSettings = Get-AzDiagnosticSetting -ResourceId $resourceId | Where-Object { $_.Id -ne $NULL }
        foreach ($azDiag in $azDiagSettings) {
            If ($azDiag.StorageAccountId) {
                [string]$storage = $azDiag.StorageAccountId
                [string]$storageAccount = $storage.Split('/')[-1]
            }
            If ($azDiag.WorkspaceId) {
                [string]$workspace = $azDiag.WorkspaceId
                [string]$logAnalytics = $workspace.Split('/')[-1]
            }
            If ($azDiag.EventHubAuthorizationRuleId) {
                [string]$eHub = $azDiag.EventHubAuthorizationRuleId
                [string]$eventHub = $eHub.Split('/')[-3]
            }
            [string]$resource = $azDiag.id
            [string]$resourceName = $resource.Split('/')[-5]
            $azlogs += @($("Diagnostic setting name: " + $azDiag.Name), ("Azure Resource name: " + $resourceName), `
                ("Logs: " + $azDiag.Logs), ("Metrics: " + $azDiag.Metrics), `
                ("Storage Account Name: " + $storageAccount), ("Log Analytics workspace: " + $logAnalytics), `
                ("Event Hub Namespace: " + $eventHub))
            $azlogs += @(" ")
        }
    }
    # Save Diagnostic settings report for each Azure Subscription
    $azSubName = $azSub.Name
    $azlogs > .\$azSubName.txt
}