Connect-AzAccount
Get-AzSubscription
Get-AzContext
Set-AzContext -subscriptionid "xxxxxxxx"

New-AzResourceGroup –Name rg-wg-test01 –Location eastus
New-AzEventHubNamespace -ResourceGroupName rg-wg-test01 -NamespaceName myevhnamespace -Location eastus
New-AzEventHub -ResourceGroupName rg-wg-test01 -NamespaceName myevhnamespace -EventHubName myevhHubname -MessageRetentionInDays 3