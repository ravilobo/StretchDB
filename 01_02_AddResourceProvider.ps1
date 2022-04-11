<#
This is a one time setting. 

Exception: 
The subscription is not registered to use namespace 'Microsoft.Sql'

By default, your Azure Subscription is not registered with all resource providers,
run the script to register the provider

#>

az login 
az account set -s $AzureSub

az provider list -o table
az provider register --namespace Microsoft.Sql

# monitor the status
az provider show -n Microsoft.Sql -o table 