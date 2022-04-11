use StretchOnPrem
ALTER TABLE customer SET ( REMOTE_DATA_ARCHIVE ( MIGRATION_STATE = INBOUND ) ) ;  


SELECT DATEADD(mi, DATEDIFF(mi, GETUTCDATE(), GETDATE()), start_time_utc) start_time,
DATEADD(mi, DATEDIFF(mi, GETUTCDATE(), GETDATE()), end_time_utc) end_time,
db_name(database_id)DB,object_name(table_id)[Table],migrated_rows
FROM sys.dm_db_rda_migration_status WHERE migrated_rows > 0
EXEC sp_spaceused @objname = 'dbo.customer', @mode = 'LOCAL_ONLY'
EXEC sp_spaceused @objname = 'dbo.customer', @mode = 'REMOTE_ONLY' -- fails since no data on the cloud

SELECT * FROM customer ORDER BY Id

