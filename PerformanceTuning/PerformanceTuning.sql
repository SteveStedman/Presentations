-- SAMPLE CODE for the SQL Performance Tuning
-- Created by Steve Stedman
--    http://SteveStedman.com
--    twitter:   @SqlEmt

-- SHIFT+ALT+ENTER for full screen display in SSMS

RAISERROR ('Dont run the whole script, just run sections at a time', 20, 1)  WITH LOG

-- Performance Tuning for Developers



-- Duplicate Indexes
use AdventureWorks2012;
go

USE [AdventureWorks2012]
GO

CREATE NONCLUSTERED INDEX [MyIndex] ON [Person].[Person]
(
	[LastName] ASC,
	[FirstName] ASC,
	[MiddleName] ASC
);
GO





-- index waste - Unused Indexes
   -- need query to show Unused indexes

use AdventureWorks2012;
go

-- all unused indexes
SELECT iv.table_name, i.name AS index_name, 
       iv.seeks + iv.scans + iv.lookups AS total_accesses, 
       iv.seeks, iv.scans, iv.lookups, t.IndexType, t.IndexSizeMB
FROM   (SELECT i.object_id, Object_name(i.object_id) AS table_name, 
               i.index_id, 
               SUM(i.user_seeks)        AS seeks, 
               SUM(i.user_scans)        AS scans, 
               SUM(i.user_lookups)      AS lookups 
        FROM   sys.tables t 
               INNER JOIN sys.dm_db_index_usage_stats i ON t.object_id = i.object_id 
        GROUP  BY i.object_id, i.index_id) AS iv 
       INNER JOIN sys.indexes i ON iv.object_id = i.object_id AND iv.index_id = i.index_id 
       INNER JOIN (SELECT  sys_schemas.name AS SchemaName  ,sys_objects.name AS TableName  
,sys_indexes.name AS IndexName  ,sys_indexes.type_desc AS IndexType  ,CAST(partition_stats.used_page_count * 8 / 1024.00 AS Decimal(10,3))AS IndexSizeMB  
FROM sys.dm_db_partition_stats partition_stats  
INNER JOIN sys.indexes sys_indexes  ON partition_stats.[object_id] = sys_indexes.[object_id]   AND partition_stats.index_id = sys_indexes.index_id  AND sys_indexes.type_desc <> 'HEAP'  
INNER JOIN sys.objects sys_objects  ON sys_objects.[object_id] = partition_stats.[object_id]   
INNER JOIN sys.schemas sys_schemas    ON sys_objects.[schema_id] = sys_schemas.[schema_id]   AND sys_schemas.name <> 'SYS'  
) AS t ON t.IndexName = i.name AND t.TableName = iv.table_name
WHERE --t.IndexSizeMB > 200 and
      iv.seeks + iv.scans + iv.lookups = 0
ORDER  BY total_accesses asc ;




-- Index usage for a given table.

DECLARE @TableNameFilter VARCHAR(1024);
SET @TableNameFilter = 'StateProvince';


SELECT iv.table_name, i.name AS index_name, 
       iv.seeks + iv.scans + iv.lookups AS total_accesses, 
       iv.seeks, iv.scans, iv.lookups, t.IndexType, t.IndexSizeMB
FROM   (SELECT i.object_id, Object_name(i.object_id) AS table_name, i.index_id, 
               SUM(i.user_seeks)        AS seeks, 
               SUM(i.user_scans)        AS scans, 
               SUM(i.user_lookups)      AS lookups 
        FROM   sys.tables t 
         INNER JOIN sys.dm_db_index_usage_stats i ON t.object_id = i.object_id 
        GROUP  BY i.object_id, i.index_id) AS iv 
       INNER JOIN sys.indexes i ON iv.object_id = i.object_id 
            AND iv.index_id = i.index_id AND table_name LIKE @TableNameFilter 
       INNER JOIN (SELECT   sys_schemas.name AS SchemaName  
,sys_objects.name AS TableName, sys_indexes.name AS IndexName  
,sys_indexes.type_desc AS IndexType, CAST(partition_stats.used_page_count * 8 / 1024.00 AS Decimal(10,3))AS IndexSizeMB  
FROM sys.dm_db_partition_stats partition_stats  
INNER JOIN sys.indexes sys_indexes  ON partition_stats.[object_id] = sys_indexes.[object_id]   AND partition_stats.index_id = sys_indexes.index_id  AND sys_indexes.type_desc <> 'HEAP'  
INNER JOIN sys.objects sys_objects  ON sys_objects.[object_id] = partition_stats.[object_id]   
INNER JOIN sys.schemas sys_schemas    ON sys_objects.[schema_id] = sys_schemas.[schema_id]   AND sys_schemas.name <> 'SYS'  
) AS t ON t.IndexName = i.name AND t.TableName = iv.table_name
ORDER  BY total_accesses DESC ;








--Execution Plans Demo
use AdventureWorks2012;
go









-- Execution Plan Query 1
SELECT *
FROM person.Person p
INNER JOIN person.personphone pp ON p.BusinessEntityID = pp.BusinessEntityID;

-- Execution Plan Query 2
SELECT FirstName, MiddleName, LastName, PhoneNumber
  FROM person.Person p
 INNER JOIN person.personphone pp ON p.BusinessEntityID = pp.BusinessEntityID;


-- Will 1 and 2 perform the same or will one run faster?




-- Execution Plan Query 3
SELECT FirstName, MiddleName, LastName, PhoneNumber
  FROM person.Person p
 INNER JOIN person.personphone pp ON p.BusinessEntityID = pp.BusinessEntityID
 WHERE FirstName = 'Alexandra'
   AND MiddleName = 'E'
   AND LastName = 'Washington';

-- Execution Plan Query 4
SELECT FirstName, MiddleName, LastName, PhoneNumber
  FROM person.Person p
 INNER JOIN person.personphone pp ON p.BusinessEntityID = pp.BusinessEntityID
 WHERE FirstName like 'Alexandra'
   AND MiddleName like 'E'
   AND LastName like 'Washington';

--What about 3 and 4 how will these compare?  Is = faster than like or is like faster than = ?



-- Execution Plan Query 5
SELECT FirstName, MiddleName, LastName, PhoneNumber
  FROM person.Person p
 INNER JOIN person.personphone pp on p.BusinessEntityID = pp.BusinessEntityID
 WHERE FirstName like 'Alexa%'
   AND MiddleName like 'E'
   AND LastName like 'Wash%';
-- How do 4 and 5 compare? 


-- Execution Plan Query 6
SELECT FirstName, MiddleName, LastName, PhoneNumber
  FROM person.Person p
 INNER JOIN person.personphone pp on p.BusinessEntityID = pp.BusinessEntityID
 WHERE FirstName like 'Alexandra'
   AND MiddleName like 'E'
   AND LastName like '%ington'; 
-- How about 5 and 6? 





---------------------------------------------------------
-- Statistics
---------------------------------------------------------

SET STATISTICS IO ON;
SELECT FirstName, MiddleName, LastName, PhoneNumber
  FROM person.Person p
 INNER JOIN person.personphone pp on p.BusinessEntityID = pp.BusinessEntityID;
SET STATISTICS IO OFF;



SET STATISTICS TIME ON;
SELECT FirstName, MiddleName, LastName, PhoneNumber
  FROM person.Person p
 INNER JOIN person.personphone pp on p.BusinessEntityID = pp.BusinessEntityID;
SET STATISTICS TIME OFF;


---------------------------------------------------------
-- Procedure Cache and Parameterization
---------------------------------------------------------

USE AdventureWorks2012;
GO

DBCC FREEPROCCACHE ; -- DANGER - Dont run this in production.
GO
SELECT FirstName, MiddleName, LastName
  FROM person.Person p
 WHERE FirstName like 'John';

GO
SELECT FirstName, MiddleName, LastName
  FROM person.Person p
 WHERE FirstName like 'Mary';
GO
SELECT FirstName, MiddleName, LastName
  FROM person.Person p
 WHERE FirstName like 'Bill';
GO
 

SELECT size_in_bytes, text
  FROM sys.dm_exec_cached_plans 
 CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st
WHERE text LIKE N'SELECT FirstName%';






---------------------------------------------------------
-- Deadly Sins ------------------------------------------
-- Sin 1: Poor or No Database Design

---------------------------------------------------------
-- Deadly Sins ------------------------------------------
-- Sin 2: Index Design Issues


---------------------------------------------------------
-- Deadly Sins ------------------------------------------
-- Sin 3 RBAR instead of sets


-- Procedural
USE AdventureWorks2012;
GO

set nocount on;

BEGIN TRANSACTION;
SELECT BusinessEntityID, VacationHours
FROM HumanResources.Employee e;

-- promotion:  every employee with a BusinessEntityID < 100
--             gets an extra two weeks of vacation
DECLARE @x INT = 1 -- begining value
WHILE @x < 100
BEGIN
	UPDATE HumanResources.Employee
	   SET VacationHours = VacationHours + 80
	 WHERE BusinessEntityID = @x

	SET @x = @x + 1
END


SELECT BusinessEntityID, VacationHours
FROM HumanResources.Employee e;

ROLLBACK TRANSACTION;
GO


--Set Based
BEGIN TRANSACTION

SELECT BusinessEntityID, VacationHours
FROM HumanResources.Employee e;

UPDATE HumanResources.Employee
   SET VacationHours = VacationHours + 80
 WHERE BusinessEntityID < 100;

 SELECT BusinessEntityID, VacationHours
FROM HumanResources.Employee e;

ROLLBACK TRANSACTION
GO











--- another example of RBAR vs SET
-- AdventureWorks was purchased by BigCorporation, 
--   need to change all @Adventure-works.com email
--   addresses to be @BigCorporation.com

set statistics io off;
set nocount off;
BEGIN TRANSACTION;
	DECLARE EmployeeCursor Cursor
	FOR 
	-- I will only do 50 because it is so darn slow.
	SELECT top 50 BusinessEntityID 
	  FROM HumanResources.Employee;

	DECLARE @BEID int;

	OPEN EmployeeCursor;
		Fetch NEXT FROM EmployeeCursor INTO @BEID;
		While (@@FETCH_STATUS <> -1)
		BEGIN
			UPDATE Person.EmailAddress 
			   SET EmailAddress = REPLACE(EmailAddress, '@Adventure-Works.com', '@BigCorporation.com')
			 WHERE BusinessEntityID = @BEID
			   AND EmailAddress like '%@Adventure-Works.com';
			Fetch NEXT FROM EmployeeCursor INTO @BEID;
		END

	CLOSE EmployeeCursor;
	DEALLOCATE EmployeeCursor
ROLLBACK TRANSACTION;

-- SET BASED Example 1 
--  the IN Clause can get slow when there are too many rows in the set
BEGIN TRANSACTION;
	UPDATE Person.EmailAddress
	   SET EmailAddress = REPLACE(EmailAddress, '@Adventure-Works.com', '@BigCorporation.com')
	 WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee)
	   AND EmailAddress like '%@Adventure-Works.com';
ROLLBACK TRANSACTION;

-- SET BASED Example 2
BEGIN TRANSACTION;
	UPDATE a 
	   SET a.EmailAddress = REPLACE(a.EmailAddress, '@Adventure-Works.com', '@BigCorporation.com')
	  FROM Person.EmailAddress a
	 INNER JOIN HumanResources.Employee e on a.BusinessEntityID = e.BusinessEntityID
	 WHERE a.EmailAddress like '%@Adventure-Works.com';
ROLLBACK TRANSACTION;






---------------------------------------------------------
-- Deadly Sins ------------------------------------------
-- Sin 4: Not using explicit column lists
-- SELECT * problems.......

SELECT *
FROM person.Person AS p 
 INNER JOIN person.BusinessEntity AS be 
         ON p.BusinessEntityID = be.BusinessEntityID 
 INNER JOIN person.BusinessEntityAddress AS bea 
         ON be.BusinessEntityID = bea.BusinessEntityID 
 INNER JOIN person.Address AS a 
         ON bea.AddressID = a.AddressID 
 INNER JOIN person.AddressType AS at 
         ON bea.AddressTypeID = at.AddressTypeID 
 INNER JOIN person.StateProvince sp
         ON a.StateProvinceID = sp.StateProvinceID 
 INNER JOIN person.CountryRegion cr
         ON sp.CountryRegionCode = cr.CountryRegionCode 
 WHERE cr.Name = 'Australia'
   AND sp.Name = 'Tasmania';



SELECT p.FirstName, p.MiddleName, p.LastName
  FROM person.Person AS p 
 INNER JOIN person.BusinessEntity AS be 
         ON p.BusinessEntityID = be.BusinessEntityID 
 INNER JOIN person.BusinessEntityAddress AS bea 
         ON be.BusinessEntityID = bea.BusinessEntityID 
 INNER JOIN person.Address AS a 
         ON bea.AddressID = a.AddressID 
 INNER JOIN person.AddressType AS at 
         ON bea.AddressTypeID = at.AddressTypeID 
 INNER JOIN person.StateProvince sp
         ON a.StateProvinceID = sp.StateProvinceID 
 INNER JOIN person.CountryRegion cr
         ON sp.CountryRegionCode = cr.CountryRegionCode 
 WHERE cr.Name = 'Australia'
   AND sp.Name = 'Tasmania';





















---------------------------------------------------------
-- Deadly Sins ------------------------------------------
-- Sin 5: Calculations in the WHERE Clause

SELECT FirstName, MiddleName, LastName, PhoneNumber
  FROM person.Person p
 INNER JOIN person.personphone pp on p.BusinessEntityID = pp.BusinessEntityID
 WHERE PhoneNumber = '314-555-0177';

--CREATE FUNCTION dbo.CleanPhoneNumber (@input varchar(8000))
--RETURNS varchar(8000)
--AS
--BEGIN
--	RETURN REPLACE(@input, '-', '')
--END
--go

SELECT FirstName, MiddleName, LastName, PhoneNumber
  FROM person.Person p
 INNER JOIN person.personphone pp on p.BusinessEntityID = pp.BusinessEntityID
 WHERE dbo.CleanPhoneNumber(PhoneNumber) = dbo.CleanPhoneNumber('3145550177');









---------------------------------------------------------
-- Deadly Sins ------------------------------------------
-- Sin 6: Dirty Reads

/* prep 
--demo table
USE AdventureWorks2012;
GO
if object_id('NoLockDemo') is not null
	drop table dbo.NoLockDemo
GO

CREATE TABLE NoLockDemo(
	ID INT NOT NULL IDENTITY(1,1)
	,SomeData uniqueidentifier NOT NULL DEFAULT(NEWID())
)	

--load table
SET NOCOUNT ON 
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
DECLARE @i INT 
SET @i = 1
WHILE @i <= 100000
BEGIN
	INSERT dbo.NoLockDemo DEFAULT VALUES 
	SET @i = @i + 1	
END 

--index to ensure we will get page splits
CREATE UNIQUE CLUSTERED INDEX Clustered_NoLockDemo ON NoLockDemo(SomeData)

*/

--count rows 
USE AdventureWorks2012;
GO
SELECT COUNT(*) FROM dbo.NoLockDemo

--monitor rowcount
DECLARE @CurrentRows	INT

WHILE 1 = 1
BEGIN
    WAITFOR DELAY '00:00:00.300'
    SET @CurrentRows = (SELECT COUNT(*) FROM dbo.NoLockDemo WITH (NOLOCK))
    PRINT 'RowCount: ' + CONVERT(VARCHAR(50),@CurrentRows)
END





-- run this batch in another query window
USE AdventureWorks2012
GO

SET STATISTICS IO ON 

WHILE 1=1
BEGIN
	UPDATE dbo.NoLockDemo SET SomeData = NEWID()
	
	WAITFOR DELAY '00:00:00.300'
END








---------------------------------------------------------
-- Deadly Sins ------------------------------------------
-- Sin 7: Believing Moore’s Law Will Save You





