-- pause 
USE StretchOnPrem
GO
ALTER TABLE customer SET ( REMOTE_DATA_ARCHIVE ( MIGRATION_STATE = PAUSED ) ) ;  
GO 
SELECT object_name(object_id) TableName
,remote_table_name
,is_migration_paused
FROM sys.remote_data_archive_tables 

-- resume 
ALTER TABLE customer SET ( REMOTE_DATA_ARCHIVE ( MIGRATION_STATE = OUTBOUND ) ) ;  
GO 
SELECT object_name(object_id) TableName
,remote_table_name
,is_migration_paused
FROM sys.remote_data_archive_tables 



