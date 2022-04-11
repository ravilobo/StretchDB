-- creates DB and configures Stretch 
-- F5 the whole thing 
-- Runs in 6-10 mins 
-- Run this script on on-prem instance of SQL Server 
if ((select SERVERPROPERTY('edition')) = 'SQL Azure')
begin 
 RAISERROR('Please run this script on on-prem server!',16,1)
 set noexec ON  
end 
go 


USE [master]
GO
set nocount on 
if exists (Select 1 from sys.databases where name ='StretchOnPrem')
DROP DATABASE [StretchOnPrem]
GO
CREATE DATABASE StretchOnPrem
GO
USE StretchOnPrem 
GO

CREATE TABLE customer (
	Id int IDENTITY,
	FirstName varchar(20),
	LastName varchar(20),
	IsActive char(1),
	Remarks varchar(100) 
)


INSERT INTO customer (FirstName, LastName) values ('Lois','Walker')
INSERT INTO customer (FirstName, LastName) values ('Brenda','Robinson')
INSERT INTO customer (FirstName, LastName) values ('Joe','Robinson')
INSERT INTO customer (FirstName, LastName) values ('Diane','Evans')
INSERT INTO customer (FirstName, LastName) values ('Benjamin','Russell')
INSERT INTO customer (FirstName, LastName) values ('Patrick','Bailey')
INSERT INTO customer (FirstName, LastName) values ('Nancy','Baker')
INSERT INTO customer (FirstName, LastName) values ('Carol','Murphy')
INSERT INTO customer (FirstName, LastName) values ('Frances','Young')
INSERT INTO customer (FirstName, LastName) values ('Diana','Peterson')
INSERT INTO customer (FirstName, LastName) values ('Ralph','Flores')
INSERT INTO customer (FirstName, LastName) values ('Jack','Alexander')
INSERT INTO customer (FirstName, LastName) values ('Melissa','King')
INSERT INTO customer (FirstName, LastName) values ('Wayne','Watson')
INSERT INTO customer (FirstName, LastName) values ('Cheryl','Scott')
INSERT INTO customer (FirstName, LastName) values ('Paula','Diaz')
INSERT INTO customer (FirstName, LastName) values ('Joshua','Stewart')
INSERT INTO customer (FirstName, LastName) values ('Theresa','Lee')
INSERT INTO customer (FirstName, LastName) values ('Julia','Scott')
INSERT INTO customer (FirstName, LastName) values ('Thomas','Lewis')
INSERT INTO customer (FirstName, LastName) values ('Carol','Edwards')
INSERT INTO customer (FirstName, LastName) values ('Matthew','Turner')
INSERT INTO customer (FirstName, LastName) values ('Joan','Stewart')
INSERT INTO customer (FirstName, LastName) values ('Ruby','Rogers')
INSERT INTO customer (FirstName, LastName) values ('Carolyn','Hayes')
INSERT INTO customer (FirstName, LastName) values ('Anne','Russell')
INSERT INTO customer (FirstName, LastName) values ('Daniel','Cooper')
INSERT INTO customer (FirstName, LastName) values ('Roger','Roberts')
INSERT INTO customer (FirstName, LastName) values ('Maria','Walker')
INSERT INTO customer (FirstName, LastName) values ('Brenda','Butler')
INSERT INTO customer (FirstName, LastName) values ('Lillian','Brown')
INSERT INTO customer (FirstName, LastName) values ('Amy','Howard')
INSERT INTO customer (FirstName, LastName) values ('Gregory','Edwards')
INSERT INTO customer (FirstName, LastName) values ('Roy','Griffin')
INSERT INTO customer (FirstName, LastName) values ('Richard','Mitchell')
INSERT INTO customer (FirstName, LastName) values ('Mary','Wilson')
INSERT INTO customer (FirstName, LastName) values ('Aaron','Price')
INSERT INTO customer (FirstName, LastName) values ('Donna','Brown')
INSERT INTO customer (FirstName, LastName) values ('Carl','Collins')
INSERT INTO customer (FirstName, LastName) values ('Joyce','Jenkins')
INSERT INTO customer (FirstName, LastName) values ('Mary','Bryant')
INSERT INTO customer (FirstName, LastName) values ('Amanda','Hughes')
INSERT INTO customer (FirstName, LastName) values ('Jack','Campbell')
INSERT INTO customer (FirstName, LastName) values ('Alan','Rivera')
INSERT INTO customer (FirstName, LastName) values ('Elizabeth','Jackson')
INSERT INTO customer (FirstName, LastName) values ('Nancy','Davis')
INSERT INTO customer (FirstName, LastName) values ('Ernest','Martinez')
INSERT INTO customer (FirstName, LastName) values ('Judy','Hernandez')
INSERT INTO customer (FirstName, LastName) values ('Nancy','Jones')
INSERT INTO customer (FirstName, LastName) values ('John','Smith')


update customer set IsActive = 'Y'
go 

; with random50 as (
select top 25 id ,IsActive
from customer 
order by newid()
)
update random50 
set IsActive = 'N'
go 

SELECT * FROM customer ORDER BY Id
go 

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

-- Enable stretch (~ 3 min)
ALTER DATABASE StretchOnPrem
    SET REMOTE_DATA_ARCHIVE = ON (
        SERVER = 'stretchserver.database.windows.net',
        CREDENTIAL = StretchOnPremScopedCredentialName)

go 

set noexec OFF 