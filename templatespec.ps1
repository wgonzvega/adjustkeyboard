#Private test area
$tenant1 = "3eca7dff-7c23-43b9-9551-7365b93d4f97"
$sub1 = "6cfeca43-6518-489d-9a83-f0a9bb0cba5b"
#>


Clear-AzContext -Force
Connect-AzAccount #-WarningAction:SilentlyContinue
$seltenant = Get-AzTenant -TenantId $tenant1  
write-host "Selected tenant:"$seltenant.name
Set-AzContext -Subscription $sub1

#create the templatespec
New-AzTemplateSpec -Name tempspecvm -Version "1.0" -ResourceGroupName rg-templatespecs -Location eastus -TemplateFile "/Users/wgonzvega/templatespecsource/tempspecvm.json"

#get the id of the tempspec
$id = (Get-AzTemplateSpec -ResourceGroupName rg-templatespecs -Name tempspecvm -Version "1.0").Versions.Id

#deploy the template
New-AzResourceGroupDeployment -TemplateSpecId $id -ResourceGroupName rg-templatespecs