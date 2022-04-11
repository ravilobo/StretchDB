<#
if exists (select 1 from sys.database_scoped_credentials where name = 'StretchOnPremScopedCredentialName')
begin 
DROP DATABASE SCOPED CREDENTIAL StretchOnPremScopedCredentialName
end 
-- select * from sys.symmetric_keys
DROP MASTER KEY
#>

#region pause stretch 
$sql = "use stretchonprem 
ALTER TABLE customer SET (REMOTE_DATA_ARCHIVE = ON (MIGRATION_STATE = INBOUND))"
  Invoke-Sqlcmd -ServerInstance $OnPremServer  -query $sql   -ConnectionTimeout 60 -QueryTimeout 10000
#endregion 

#region disable stretch 
$sql = " use stretchonprem 
ALTER TABLE customer SET (REMOTE_DATA_ARCHIVE = OFF_WITHOUT_DATA_RECOVERY (MIGRATION_STATE = PAUSED))"
Invoke-Sqlcmd -ServerInstance $OnPremServer  -query $sql   -ConnectionTimeout 60 -QueryTimeout 10000
#endregion 


#region drop databases 
$databases = 'StretchOnPrem', 'StretchOnPrem2'

foreach ($db in $databases) {
 $sqlDropDB = "
USE [master]
go
if exists (Select 1 from sys.databases where name ='$db' and is_remote_data_archive_enabled =1)
begin 
ALTER DATABASE $db SET REMOTE_DATA_ARCHIVE = OFF
end 
go 
if exists (Select 1 from sys.databases where name ='$db')
begin
ALTER DATABASE [$db] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE [$db]
end
go
"
 Invoke-Sqlcmd -ServerInstance $OnPremServer  -query $sqlDropDB   -ConnectionTimeout 60 -QueryTimeout 10000
}
#endregion 

#region disable RDA
$sql = "EXEC sp_configure 'remote data archive', 0
RECONFIGURE 
GO"
Invoke-Sqlcmd -ServerInstance $OnPremServer  -query $sql   -ConnectionTimeout 60 -QueryTimeout 10000
#endregion 

#region stop sql server service 
$status = (get-service -Name $SQLServerservice).status 
if ($status -ne 'stopped') {
    (get-service -Name $SQLServerservice).Stop()
    Write-Host "Stopping service [$SQLServerservice]..." -ForegroundColor Green
    Start-Sleep -Seconds 5 
    $status = (get-service -Name $SQLServerservice).status 
    if ($status -eq 'stopped') {
      Write-Host "Successfully stopped local SQL Server service" -ForegroundColor Green
    } else {
      Write-warning "Failed to stop local SQL Server service!"
    }
} else {
  Write-Host "No need to stop the service. It is already stopped." -ForegroundColor Green
}
#endregion 

$RG = 'RG-STRETCH'
az account set -s $AzureSub
az group delete --name $RG --yes -y