############################################
#          Enterprise Architecture         #
#              Walter Gonzalez             #
#                 June 2020                #
############################################

#Asignar BluePrints

#########################################
# Must be run from the PowerShell IDE   #
#########################################

function listSubscriptions {
    clear-host
    $c = 1
    foreach ($list in $subscriptionlist) {
        write-host $c "- " $list.Name
        $c ++
    }
    $subscriptionID = Read-Host -Prompt 'Please enter the number of the Subscription to deploy Blueprints'
    return $subscriptionlist[$subscriptionID-1]
}




function logInAzure {
    clear-host
    $login = Read-Host -Prompt 'Do you want to login?(y/n)'
    if ($login -eq "Y" -or $login -eq "y") {
        Connect-AzAccount
    }
}

function deployBP {
    $c = 0
    write-host "`nSetting up Subscription"  $mySubscription.name 
    #set-subscription
    select-Azsubscription -SubscriptionId $mySubscription.Id
    foreach($list in $bpList.Name){
        if($list -NotIn $bpNotToBedeployed){
            if($list -eq "BackupTeam") {
            $blueprintObject = Get-Azblueprint -ManagementGroupId "EvertecLLCManagementGroup" -Name $list
            $newBPName = "Assignment-"+$list
            New-AzBlueprintAssignment -Name $newBPName -Blueprint $blueprintObject -SubscriptionId $mySubscription.Id -Location "EastUS"
            write-host "Deploying item :" $newBPName "in" $mySubscription.Name
            $c ++
            }
        }
    }
write-host "Total of Blueprints applied:" $c
}



#                                           Start
clear-host
write-host "Getting Azure Information, please wait..."

#Set Variables
$bpNotToBedeployed = @("BasicUsersforOperations","EnterpriseArchitectureGroup","DataSecurityUsers")
$subscriptionlist = @(Get-AzSubscription -WarningAction:SilentlyContinue) 
Set-AzContext -Tenant “2b5b7d77-f19b-4c6d-b180-5768c09ad43b" #evertecincllc
$bpList = Get-Azblueprint -ManagementGroupId "EvertecLLCManagementGroup"




#function calls

logInAzure
$mySubscription = listSubscriptions
deployBP
