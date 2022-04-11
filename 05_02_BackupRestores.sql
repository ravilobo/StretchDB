use StretchOnPrem
BACKUP DATABASE [StretchOnPrem]
TO  DISK = N'C:\StretchDB\StretchOnPrem.bak' WITH NOFORMAT, INIT,
NAME = N'StretchOnPrem first backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 5
GO

-- add 5 new rows with IsActive N 
INSERT INTO customer (FirstName, LastName,isActive,Remarks) values ('Z_Tom','Hanks','N','Post backup 1 entries')
INSERT INTO customer (FirstName, LastName,isActive,Remarks) values ('Z_Julia','Roberts','N','Post backup 1 entries')
INSERT INTO customer (FirstName, LastName,isActive,Remarks) values ('Z_Jude','Law','N','Post backup 1 entries')
INSERT INTO customer (FirstName, LastName,isActive,Remarks) values ('Z_Bill','Murray','N','Post backup 1 entries')
INSERT INTO customer (FirstName, LastName,isActive,Remarks) values ('Z_Kate','Winslet','N','Post backup 1 entries')

select * from customer order by FirstName

EXEC sp_spaceused @objname = 'dbo.customer', @mode = 'LOCAL_ONLY'
EXEC sp_spaceused @objname = 'dbo.customer', @mode = 'REMOTE_ONLY'


USE [master]
ALTER DATABASE [StretchOnPrem] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE [StretchOnPrem]
FROM  DISK = N'C:\StretchDB\StretchOnPrem.bak' WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE [StretchOnPrem] SET MULTI_USER
GO

use StretchOnPrem
EXEC sp_spaceused @objname = 'dbo.customer', @mode = 'LOCAL_ONLY'
EXEC sp_spaceused @objname = 'dbo.customer', @mode = 'REMOTE_ONLY' -- notice the cloud table is empty 

-- reauthorize 
DECLARE @credentialName nvarchar(128);   
SET @credentialName = N'StretchOnPremScopedCredentialName';   
EXEC sp_rda_reauthorize_db @credential = @credentialName, @with_copy = 0 

-- notice the 5 cloud rows are gone! 
select * from customer order by FirstName

-- restore needs reauthorize (seince we don't want random people to access data)
-- if you restore a backup, let's say a month old, data after that on the cloud will be masked
-- you can restore a few times, back and forth, abd mask will be applied accordingly

