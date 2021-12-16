Connect-AzAccount
$mysubs = Get-AzSubscription -SubscriptionId "4f7bb945-1eab-4177-9767-6ced4f6290d8"
ForEach($subs in $mysubs){
    Set-AzContext -subscriptionId $subs.SubscriptionId >>c:/azuredevrbacs.csv
    (Get-AzRoleAssignment -ResourceGroupName "ath-evtc-test" | Where-Object {($_.ObjectType -EQ "user" -and $_.RoleDefinitionName -EQ "Contributor")}) | Select-Object DisplayName,SignInName,RoleDefinitionName,Scope >>~/azuredevrbacs.csv
    #(Get-AzRoleAssignment | Where-Object {($_.ObjectType -EQ "user" -and $_.RoleDefinitionName -EQ "Contributor")}) | Select-Object DisplayName,SignInName,RoleDefinitionName,Scope >>c:/azuredevrbacs.csv
}