USE StretchOnPrem 
GO


-- Disable stretch on the table
-- before disabling you need to pull the data back or 
-- to discard cloud data run the below option
-- set REMOTE_DATA_ARCHIVE = OFF_WITHOUT_DATA_RECOVERY
-- 

ALTER TABLE customer SET (REMOTE_DATA_ARCHIVE = ON (MIGRATION_STATE = INBOUND))

EXEC sp_spaceused @objname = 'dbo.customer', @mode = 'LOCAL_ONLY'

ALTER TABLE customer
	SET (REMOTE_DATA_ARCHIVE = OFF (MIGRATION_STATE = PAUSED))

----------------------------------------------------------------------
-- *** You'll have to delete the remote table manually ***
----------------------------------------------------------------------
