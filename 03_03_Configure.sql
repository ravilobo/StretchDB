USE StretchOnPrem2 
GO
EXEC sp_configure 'remote data archive', 1
RECONFIGURE 
go 

CREATE MASTER KEY
 ENCRYPTION BY PASSWORD = 'ThisIsaLongAndComplexP@ssw0rd!'
go 

-- Create credential for communication between local and Azure servers (uses master key for encryption)
-- This is the same user you create on azure SQL Server 
CREATE DATABASE SCOPED CREDENTIAL StretchOnPremScopedCredentialName
    WITH IDENTITY = 'stretchadmin' , SECRET = 'BigDataCluster123@'
go 

select * from sys.database_scoped_credentials 
-- drop database scoped credential StretchOnPremScopedCredentialName
go 

-- Enable stretch (~ 6 min)
/*
ALTER DATABASE StretchOnPrem2
    SET REMOTE_DATA_ARCHIVE = ON (
        SERVER = 'stretchserver.database.windows.net',
        CREDENTIAL = StretchOnPremScopedCredentialName)

go 
*/