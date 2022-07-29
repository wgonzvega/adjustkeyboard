############################################
#          Enterprise Architecture         #
#              Walter Gonzalez             #
#                 July 2022                #
############################################
#List subs y su plan de EA o CSP

#############################################################
# Must be run from the Azure portal Resource Graph Explorer #
#############################################################

resourcecontainers
| where type == "microsoft.resources/subscriptions"
| project name, properties.subscriptionPolicies.quotaId
