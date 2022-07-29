############################################################################
#                             Walter Gonzalez                              #
#                                Junio 2020                                 #
#                                                                          # 
############################################################################

#Just for VMs

# Update Tags - Applied to all the VMs in a subscription
############################################################################
#                    CHANGE THIS PER SUBSCRIPTION                          #
############################################################################



# RunBook for Update Tags - Applied at the Subscription level



#Parameters -----------------------------------------------------------------------------------------------------
#The resource needs a backup plan?  The value will be set in the VSP or the Backup Team will set the value in 
#accordance with the owner
$mySubscription = "759f5f36-b74a-429e-a671-61e733115dfc"
$backup = ""

#End of parameters----------------------------------------------------------------------------------------------------

function doLogin{
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

}# end login func

function doTagging { param( [string]$myTag )
Select-AzSubscription -SubscriptionId $mySubscription

#Update tags for all services

$allResources = Get-AzVM | Select Id,Name,Tags
$tags = @{"backup" = $myTag}
foreach($resourceList in $allResources){
    write-output $resourceList.id
    write-output $resourceList.Name
    write-output $resourceList.tags
    if ($resourceList.Tags.backup -eq $null){
        Update-AzTag -ResourceId $resourceList.id -Tag $tags -Operation Merge
        write-output $resourceList.tags
    }
}
}#end doTagging func

#Func calls
doLogin
doTagging $backup


