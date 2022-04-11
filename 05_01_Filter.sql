USE StretchOnPrem 
GO

select * from customer 
go

-- Create filter predicate
-- drop function dbo.fnStretchPredicate
CREATE FUNCTION dbo.fnStretchPredicate(@IsActive char)
RETURNS TABLE
WITH SCHEMABINDING 
AS 
RETURN
	SELECT 1 AS is_eligible
	 WHERE @IsActive = 'N'
GO

-- Enable stretch with filter predicate
ALTER TABLE customer
	SET (REMOTE_DATA_ARCHIVE = ON (
		FILTER_PREDICATE = dbo.fnStretchPredicate(IsActive),
		MIGRATION_STATE = OUTBOUND))
GO


SELECT DATEADD(mi, DATEDIFF(mi, GETUTCDATE(), GETDATE()), start_time_utc) start_time,
DATEADD(mi, DATEDIFF(mi, GETUTCDATE(), GETDATE()), end_time_utc) end_time,
db_name(database_id)DB,object_name(table_id)[Table],migrated_rows
FROM sys.dm_db_rda_migration_status WHERE migrated_rows > 0
EXEC sp_spaceused @objname = 'dbo.customer', @mode = 'LOCAL_ONLY'
EXEC sp_spaceused @objname = 'dbo.customer', @mode = 'REMOTE_ONLY'


-----------------------------------------------------------
-- *** view remote data execution plan ***
-----------------------------------------------------------

-- SQL Server knows when it needs to run a remote database query and when it doesn't
--------------------------------------------------------
-- check the execution plan 
--------------------------------------------------------
SELECT * FROM customer WHERE IsActive = 'N' ORDER BY Id
SELECT * FROM customer WHERE IsActive = 'Y' ORDER BY Id

SELECT * FROM customer

-- Can't reverse the status once migrated
UPDATE customer
 SET IsActive = 'Y' WHERE Id in (select top 1 id from customer where isactive = 'N')

-- this will work, row being on-prem
UPDATE customer
 SET IsActive = 'N' WHERE Id in (select top 5 id from customer where isactive = 'Y')


SELECT DATEADD(mi, DATEDIFF(mi, GETUTCDATE(), GETDATE()), start_time_utc) start_time,
DATEADD(mi, DATEDIFF(mi, GETUTCDATE(), GETDATE()), end_time_utc) end_time,
db_name(database_id)DB,object_name(table_id)[Table],migrated_rows
FROM sys.dm_db_rda_migration_status WHERE migrated_rows > 0
EXEC sp_spaceused @objname = 'dbo.customer', @mode = 'LOCAL_ONLY'
EXEC sp_spaceused @objname = 'dbo.customer', @mode = 'REMOTE_ONLY'