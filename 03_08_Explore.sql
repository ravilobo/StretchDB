-- Run this script on on-prem instance of SQL Server 

USE StretchOnPrem 
GO

-- Discover databases enabled for stretch
SELECT name, is_remote_data_archive_enabled FROM sys.databases

-- Discover cloud databases being used for stretch
SELECT * FROM sys.remote_data_archive_databases

-- Start migration
ALTER TABLE customer
	SET (REMOTE_DATA_ARCHIVE = ON (MIGRATION_STATE = OUTBOUND))

-- Discover tables enabled for stretch
SELECT name, is_remote_data_archive_enabled FROM sys.tables
SELECT object_name(object_id),* FROM sys.remote_data_archive_tables 

SELECT DATEADD(mi, DATEDIFF(mi, GETUTCDATE(), GETDATE()), start_time_utc) start_time,
DATEADD(mi, DATEDIFF(mi, GETUTCDATE(), GETDATE()), end_time_utc) end_time,
db_name(database_id)DB,object_name(table_id)[Table],migrated_rows
FROM sys.dm_db_rda_migration_status WHERE migrated_rows > 0

EXEC sp_spaceused @objname = 'dbo.customer', @mode = 'LOCAL_ONLY'
EXEC sp_spaceused @objname = 'dbo.customer', @mode = 'REMOTE_ONLY'

SELECT * FROM customer ORDER BY Id

-- Can't UPDATE/DELETE
-- The data on the cloud is RO 
DELETE FROM customer WHERE Id = 20
UPDATE customer SET FirstName = 'John' WHERE Id = 3



-- 
 set noexec OFF 