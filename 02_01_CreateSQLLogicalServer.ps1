# F5 the whole thing
#region create logical server 
az login 

az account set -s $AzureSub
az group create --name $RG --location $Region

#create SQL Server logical 
# only works in EAST US for now
# takes 3 mins 
az sql server create `
 --name $sqlservername `
 --location $Region `
 --resource-group $RG `
 --admin-user $sqladminusername `
 --admin-password $sqladminpassword

# create firewall rule 
az sql server firewall-rule create `
 --name $firewallName `
 --resource-group $RG `
 --server $sqlservername `
 --start-ip-address $StartIP `
 --end-ip-address $EndIP

#endregion 
