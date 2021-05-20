Connect-AzAccount
$mysubs = Get-AzSubscription -SubscriptionId "4f7bb945-1eab-4177-9767-6ced4f6290d8"
ForEach($subs in $mysubs){
    Set-AzContext -subscriptionId $subs.SubscriptionId >>c:/azuredevrbacs.csv
   #Not finished look for script name getcpuandram.ps1
}