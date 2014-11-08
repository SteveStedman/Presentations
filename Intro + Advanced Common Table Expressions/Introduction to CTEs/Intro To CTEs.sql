-- SAMPLE CODE for the SQL Saturday Presentation 
-- Created by Steve Stedman
--    http://SteveStedman.com
--    twitter:   @SqlEmt

RAISERROR ('Dont run the whole script, just run sections at a time', 20, 1)  WITH LOG



USE [master];
SET STATISTICS IO OFF;
SET NOCOUNT ON;

IF EXISTS(SELECT name 
            FROM sys.databases 
		   WHERE name = 'cte_demo')
BEGIN
	ALTER DATABASE [cte_demo] 
	  SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [cte_demo];
END
CREATE DATABASE [cte_demo];
GO

USE [cte_demo];

CREATE TABLE [Royalty] (
	id int,  --would normally be an INT IDENTITY
    name VARCHAR (200),
	mother int,
	father int,
	);
	
insert into [Royalty] (id, name, mother, father) values (1, 'George V, King of England', null, null);
insert into [Royalty] (id, name, mother, father) values (2, 'Mary, Princess of Teck', null, null);
insert into [Royalty] (id, name, mother, father) values (3, 'George VI Windsor, King of England', 2, 1);
insert into [Royalty] (id, name, mother, father) values (4, 'Claude George Bowes-Lyon', null, null);
insert into [Royalty] (id, name, mother, father) values (5, 'Nina Cecilia Cavendish-Bentinck', null, null);
insert into [Royalty] (id, name, mother, father) values (6, 'Elizabeth Angela Marguerite Bowes-Lyon', 5, 4);
insert into [Royalty] (id, name, mother, father) values (7, 'William George I of the Hellenes', null, null);
insert into [Royalty] (id, name, mother, father) values (8, 'Olga Konstantinovna Romanova', null, null);
insert into [Royalty] (id, name, mother, father) values (9, 'Louis Alexander von Battenburg', null, null);
insert into [Royalty] (id, name, mother, father) values (10, 'Victoria von Hessen und bei Rhein', null, null);
insert into [Royalty] (id, name, mother, father) values (11, 'Andreas, Prince of Greece', 8, 7);
insert into [Royalty] (id, name, mother, father) values (12, 'Alice, Princess of Battenbugr', 10, 9);
insert into [Royalty] (id, name, mother, father) values (13, 'Phillip Mountbatten, Duke of Edinburgh', 12, 11);
insert into [Royalty] (id, name, mother, father) values (14, 'Elizabeth II Windsor, Queene of England', 6, 3);
insert into [Royalty] (id, name, mother, father) values (15, 'Charles Philip Arthur Windsor', 14, 13);
insert into [Royalty] (id, name, mother, father) values (16, 'Diana Frances (Lady) Spencer', 18, 19);
insert into [Royalty] (id, name, mother, father) values (17, 'William Arthur Phillip Windsor', 16, 15);
insert into [Royalty] (id, name, mother, father) values (18, 'Frances Ruth Burke Roche', null, null);
insert into [Royalty] (id, name, mother, father) values (19, 'Edward John Spencer', null, null);

--create a table to use for CTE query demo
CREATE TABLE [Departments] (
	id int,  --would normally be an INT IDENTITY
	department VARCHAR (200),
	parent int
	);

GO
CREATE PROCEDURE ReloadDepartments
AS 
BEGIN
	SET NOCOUNT ON;
	TRUNCATE TABLE [dbo].[Departments];	
	-- insert top level departments
	insert into [Departments] (id, department, parent) 
	     values (1, 'Camping', null);
	insert into [Departments] (id, department, parent) 
	     values (2, 'Cycle', null);
	insert into [Departments] (id, department, parent) 
	     values (3, 'Snowsports', null);
	insert into [Departments] (id, department, parent) 
	     values (4, 'Fitness', null);
      
	-- now some sub-departments for camping
	insert into [Departments] (id, department, parent) 
	     values (5, 'Tents', 1);
	insert into [Departments] (id, department, parent) 
	     values (6, 'Backpacks', 1);
	insert into [Departments] (id, department, parent) 
	     values (7, 'Sleeping Bags', 1);
	insert into [Departments] (id, department, parent) 
	     values (8, 'Cooking', 1);
       
	-- now some sub-departments for cycle
	insert into [Departments] (id, department, parent) 
	     values (9, 'Bikes', 2);
	insert into [Departments] (id, department, parent) 
	     values (10, 'Helmets', 2);
	insert into [Departments] (id, department, parent) 
	     values (11, 'Locks', 2);

	-- now some sub-departments for snowsports
	insert into [Departments] (id, department, parent) 
	     values (12, 'Ski', 3);
	insert into [Departments] (id, department, parent) 
	     values (13, 'Snowboard', 3);
	insert into [Departments] (id, department, parent) 
	     values (14, 'Snowshoe', 3);
       
	-- now some sub-departments for fitness
	insert into [Departments] (id, department, parent) 
	     values (15, 'Running', 4);
	insert into [Departments] (id, department, parent) 
	     values (16, 'Swimming', 4);
	insert into [Departments] (id, department, parent) 
	     values (17, 'Yoga', 4);
END
GO 
CREATE PROCEDURE FillMoreDepartments
AS
BEGIN
	SET NOCOUNT ON;
	delete from Departments where id > 17; 
	 --now add 2 more levels of depth
	insert into [Departments] (id, department, parent) 
	     values (18, '1 Person', 5);
	insert into [Departments] (id, department, parent) 
	     values (19, '2 Person', 5);
	insert into [Departments] (id, department, parent) 
	     values (20, '3 Person', 5);
	insert into [Departments] (id, department, parent) 
	     values (21, '4 Person', 5);

	insert into [Departments] (id, department, parent) 
	     values (22, 'Backpacking', 19);
	insert into [Departments] (id, department, parent) 
	     values (23, 'Family Camping', 19);
	insert into [Departments] (id, department, parent) 
	     values (24, 'Mountaineering', 19);

	insert into [Departments] (id, department, parent) 
	     values (25, 'Ultra-lightweight', 24);
	insert into [Departments] (id, department, parent) 
	     values (26, 'Lightweight', 24);
	insert into [Departments] (id, department, parent) 
	     values (27, 'Standard', 24);

	insert into [Departments] (id, department, parent) 
	     values (28, 'Gifts', null);
	insert into [Departments] (id, department, parent) 
	     values (29, 'Clearance', null);

END
GO

USE [cte_demo];
EXECUTE ReloadDepartments;


-- just see what is in the Departments table
-- http://stevestedman.com/?p=2856

SELECT * 
  FROM Departments;

SELECT * 
  FROM Royalty;


-- now lets take a look at the derived table
-- http://stevestedman.com/?p=2856

SELECT * 
  FROM (SELECT id, department, parent 
          FROM Departments) as Dept;






---Demo:  Simple CTE
-- ; before the with is important or could be a GO
-- http://stevestedman.com/?p=2856

;WITH departmentsCTE(id, department, parent) AS 
(
	SELECT id, department, parent 
	  FROM Departments
) 
SELECT * 
  FROM departmentsCTE;









-- example of what happens if you have multiple statements without the semicolon.

-- just see what is in the Departments table
SELECT * FROM Departments
---Demo:  Simple CTE
WITH departmentsCTE(id, department, parent) AS 
(
  SELECT id, department, parent 
    FROM Departments
) 
SELECT * FROM departmentsCTE;


















---------------------------------------------
-- Chapter 3 - CTE Instead of a Derived Table
---------------------------------------------





-- Derived Table- NO CTE
SELECT q1.department, 
       q2.department AS subDepartment
  FROM (SELECT id, department, parent 
	      FROM Departments) AS q1
 INNER JOIN (SELECT id, department, parent 
	           FROM Departments) AS q2 
         ON q1.id = q2.parent
 WHERE q1.parent IS NULL; 



















---CTE for Subquery Re-use
;WITH DepartmentCTE(id, department, parent) AS 
(	
   SELECT id, department, parent
	 FROM Departments
) 
SELECT q1.department, 
       q2.department AS subDepartment
  FROM DepartmentCTE q1
 INNER JOIN DepartmentCTE q2 ON q1.id = q2.parent
 WHERE q1.parent IS NULL; 












---------------------------------------------
--- Chapter 6 - Multiple CTEs
---------------------------------------------





 -- multipe CTE's for multiple derived table re-use
 SELECT q1.department, 
        q2.department AS subDepartment
   FROM (SELECT id, department, parent 
           FROM Departments
	  	  WHERE id = 4) AS q1
  INNER JOIN (SELECT id, department, parent 
                FROM Departments) as q2 
          ON q1.id = q2.parent;








;WITH DeptCTETop AS
(
   SELECT id, department, parent 
     FROM Departments
	WHERE id = 4
)
, DeptCTELevels AS
(
   SELECT id, department, parent 
     FROM Departments
)
SELECT q1.department, 
       q2.department AS subDepartment
  FROM DeptCTETop AS q1
 INNER JOIN DeptCTELevels AS q2 
         ON q1.id = q2.parent;

 



--Demo: Multiple CTE - Names
SELECT 'John' 
  UNION 
 SELECT 'Mary' 
  UNION 
 SELECT 'Bill';



;WITH Fnames (Name) AS
(SELECT 'John' 
  UNION 
 SELECT 'Mary' 
  UNION 
 SELECT 'Bill')
SELECT F.Name FirstName
  FROM Fnames F;



 
 
;WITH Fnames (Name) AS
(
  SELECT 'John' 
   UNION 
  SELECT 'Mary' 
   UNION 
  SELECT 'Bill'
)
, Lnames (Name) AS
(
  SELECT 'Smith' 
   UNION 
  SELECT 'Gibb' 
   UNION 
  SELECT 'Jones'
)
SELECT F.Name AS FirstName, 
       L.Name AS LastName
  FROM Fnames AS F
 CROSS JOIN Lnames AS L;
 

-- Now Add middle initials, and reformat a bit
;WITH Fnames (Name) AS 
(
  SELECT 'John' UNION SELECT 'Mary' UNION SELECT 'Bill'
)
, Minitials (initial) AS 
(
  SELECT 'A' UNION SELECT 'B' UNION SELECT 'C'
)
, Lnames (Name) AS
(
  SELECT 'Smith' UNION SELECT 'Gibb' UNION SELECT 'Jones'
)
SELECT F.Name FirstName, M.initial, L.Name LastName
  FROM Fnames F
 CROSS JOIN Lnames AS L
 CROSS JOIN Minitials AS M;
 




-- sample using a row constructor  SQL 2008 and newer
SELECT x FROM (VALUES ('John'),('Mary'),('Bill')) f(x) ;


 --Demo: Multiple CTE
;WITH Fnames (Name) AS 
(
  SELECT x FROM (VALUES ('John'),('Mary'),('Bill')) f(x) 
)
, Lnames (Name) AS
(
  SELECT x FROM (VALUES ('Smith'),('Gibb'),('Jones')) f(x) 
)
SELECT F.Name FirstName, 
       L.Name LastName
  FROM Fnames AS F
 CROSS JOIN Lnames AS L;



-- firstname, lastname, middle initial as the row constructor format
;WITH Fnames (Name) AS 
(
  SELECT x FROM (VALUES ('John'),('Mary'),('Bill')) f(x) 
)
, Minitials (initial) AS 
(
  SELECT x FROM (VALUES ('A'),('B'),('C')) f(x) 
)
, Lnames (Name) AS
(
  SELECT x FROM (VALUES ('Smith'),('Gibb'),('Jones')) f(x) 
)
SELECT F.Name FirstName, 
       M.initial, 
	   L.Name LastName
  FROM Fnames AS F
 CROSS JOIN Lnames AS L
 CROSS JOIN Minitials AS M;







 
 
 






-- NESTED CTEs

;WITH cte0 AS
(
  SELECT 1 AS num
)
, cte1 AS 
(
  SELECT num + 1 as num
    FROM cte0
)
, cte2 AS 
(
  SELECT num + 1 as num 
    FROM cte1
)
SELECT * 
  FROM cte2;









CREATE NONCLUSTERED INDEX [NonClustered1] ON [dbo].[Departments]
(
	[id] ASC,
	[parent] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

CREATE NONCLUSTERED INDEX [NonClustered2] ON [dbo].[Departments]
(
	[id] ASC,
	[parent] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

CREATE NONCLUSTERED INDEX [NonClustered3] ON [dbo].[Departments]
(
	[id] ASC,
	[parent] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)



-- Sample of a query I wrote for the Database Health Monitor (Reports)
-- http://DatabaseHealth.com
;WITH unusedCTE AS
(
	SELECT count(1) AS unusedIndexes
	FROM   (SELECT i.object_id, 
				   i.index_id, 
				   SUM(i.user_seeks) AS seeks, 
				   SUM(i.user_scans) AS scans, 
				   SUM(i.user_lookups) AS lookups 
			FROM   sys.tables t 
				   INNER JOIN sys.dm_db_index_usage_stats i ON t.object_id = i.object_id 
			GROUP  BY i.object_id, i.index_id) AS iv 
		   INNER JOIN sys.indexes i ON iv.object_id = i.object_id AND iv.index_id = i.index_id 
	       INNER JOIN sys.objects sys_objects ON sys_objects.[object_id] = i.[object_id]   
	       INNER JOIN sys.schemas sys_schemas ON sys_objects.[schema_id] = sys_schemas.[schema_id]   AND sys_schemas.name <> 'SYS'  
	WHERE iv.seeks + iv.scans + iv.lookups = 0
)
--SELECT * FROM unusedCTE;
, indexCTE AS
(
		SELECT Object_name(i.object_id) AS TableName, 
			   i.name                   AS IndexName, 
			   i.index_id               AS IndexID, 
			   i.object_id				AS object_id
		FROM   sys.indexes AS i 
			   JOIN sys.partitions AS p 
				 ON p.object_id = i.object_id 
					AND p.index_id = i.index_id 
			   JOIN sys.allocation_units AS a 
				 ON a.container_id = p.partition_id 
		GROUP  BY i.object_id, 
				  i.index_id, 
				  i.name
)
--SELECT * FROM indexCTE;
,
dupeIndexesCTE as
(
	select distinct TableName, KeyCols, isnull(IncludeCols, '') as IncludeCols
	FROM (
		SELECT TableName, KeyCols, IncludeCols, Count(1) over (partition by TableName, KeyCols, IncludeCols) as dupes
		FROM (
			SELECT Tab.[name] AS TableName, 
				   Ind.[name] AS IndexName, 
				   Substring((SELECT ', ' + AC.name 
							  FROM   sys.[tables] AS T 
									 INNER JOIN sys.[indexes] I ON T.[object_id] = I.[object_id] 
									 INNER JOIN sys.[index_columns] IC ON I.[object_id] = IC.[object_id] AND I.[index_id] = IC.[index_id] 
									 INNER JOIN sys.[all_columns] AC ON T.[object_id] = AC.[object_id] AND IC.[column_id] = AC.[column_id] 
							  WHERE  Ind.[object_id] = I.[object_id] AND Ind.index_id = I.index_id AND IC.is_included_column = 0 
							  ORDER  BY IC.key_ordinal 
							  FOR xml path('')), 2, 8000) AS KeyCols, 
				   Substring((SELECT ', ' + AC.name 
							  FROM   sys.[tables] AS T 
									 INNER JOIN sys.[indexes] I  ON T.[object_id] = I.[object_id] 
									 INNER JOIN sys.[index_columns] IC ON I.[object_id] = IC.[object_id] AND I.[index_id] = IC.[index_id] 
									 INNER JOIN sys.[all_columns] AC ON T.[object_id] = AC.[object_id] AND IC.[column_id] = AC.[column_id] 
							  WHERE  Ind.[object_id] = I.[object_id] AND Ind.index_id = I.index_id AND IC.is_included_column = 1 
							  ORDER  BY IC.key_ordinal 
							  FOR xml path('')), 2, 8000) AS IncludeCols
			FROM   sys.[indexes] Ind 
				   INNER JOIN sys.[tables] AS Tab ON Tab.[object_id] = Ind.[object_id] 
				   INNER JOIN indexCTE as cte on cte.IndexID = Ind.[index_id] and cte.object_id = Ind.[object_id]
			 WHERE Ind.[name] is not null
		 ) as t
	) as t2
	where dupes > 1
)
--SELECT * FROM dupeIndexesCTE;
SELECT (SELECT unusedIndexes FROM unusedCTE) AS unusedIndexes,
	   (SELECT COUNT(1) FROM dupeIndexesCTE) AS numDuplicateIndexes; 






























USE [cte_demo];
---------------------------------------------
-- Chapter 7 - Data Paging
---------------------------------------------


-- query with no data paging  Shows all tables on this database, and all columns
SELECT OBJECT_NAME(sc.object_id) as TableName, 
       name as ColumnName
  FROM sys.columns sc
ORDER BY OBJECT_NAME(sc.object_id);


-- CTE Example to get data paging
-- Assume that page size is 10 the first page would display the first 10 rows
--   the second page would display rows 11 to 20,
--   third page would display rows 21 to 30
  
declare @pageNum as int;
declare @pageSize as int;
set @pageNum = 2;
set @pageSize = 10;

;WITH TablesAndColumns AS 
( 
SELECT OBJECT_NAME(sc.object_id) AS TableName, 
       name AS ColumnName, 
       ROW_NUMBER() OVER (ORDER BY OBJECT_NAME(sc.object_id)) AS RowNum 
  FROM sys.columns sc 
) 
SELECT * 
  FROM TablesAndColumns 
  WHERE RowNum BETWEEN (@pageNum - 1) * @pageSize + 1 
               AND @pageNum * @pageSize ; 

  
  
GO  
-- now simplify it by creating a stored procedure.
CREATE PROCEDURE TablesAndColumnsPager
	@pageNum int,
	@pageSize int
AS
BEGIN
	SET NOCOUNT ON;

	;WITH TablesAndColumns AS 
	( 
	SELECT OBJECT_NAME(sc.object_id) AS TableName, 
		   name AS ColumnName, 
		   ROW_NUMBER() OVER (ORDER BY OBJECT_NAME(sc.object_id)) AS RowNum 
	  FROM sys.columns sc 
	) 
	SELECT * 
	  FROM TablesAndColumns 
	  WHERE RowNum BETWEEN (@pageNum - 1) * @pageSize + 1 
				   AND @pageNum * @pageSize ; 
END
GO

exec TablesAndColumnsPager 1, 10;
exec TablesAndColumnsPager 2, 10;
exec TablesAndColumnsPager 3, 10;
  
  
  








-- performance test
-- comparing CTE to new offset and fetch options
SET STATISTICS IO, TIME ON;
DECLARE @pageNum AS INT;
DECLARE @pageSize AS INT;
SET @pageNum = 2;
SET @pageSize = 10;

;WITH TablesAndColumns AS 
( 
SELECT OBJECT_NAME(sc.object_id) AS TableName, 
       name AS ColumnName, 
       ROW_NUMBER() OVER (ORDER BY OBJECT_NAME(sc.object_id)) AS RowNum 
  FROM sys.columns sc 
) 
SELECT tableName, ColumnName
  FROM TablesAndColumns 
  WHERE RowNum BETWEEN (@pageNum - 1) * @pageSize + 1 
               AND @pageNum * @pageSize 
  ORDER BY TableName; 


-- DEMO THE SQL SERVER 2012 way of doing it.  Does NOT work in 2005, 2008 or 2008R2
-- http://stevestedman.com/?p=1597
SELECT OBJECT_NAME(sc.object_id) AS TableName, 
       name AS ColumnName
  FROM sys.columns sc 
 ORDER BY TableName
OFFSET (@pageNum - 1) * @pageSize ROWS FETCH NEXT @pageSize ROWS ONLY;
    
GO  

























---------------------------------------------
--- Chapter 9 - sprocs, functions, views
---------------------------------------------


USE [cte_demo]
GO
--DROP PROCEDURE [dbo].[ShowDepartments]
GO
CREATE PROCEDURE [dbo].[ShowDepartments]
AS
BEGIN
	SET NOCOUNT ON;

	WITH departmentsCTE(id, department, parent) AS
	(
	  SELECT id, department, parent
	    FROM Departments
	)
	SELECT *
	  FROM departmentsCTE;
END
GO

EXECUTE [dbo].[ShowDepartments] 
GO










--DROP FUNCTION [dbo].[ShowDepartments_InlineTableValuedFunction];
GO
CREATE FUNCTION [dbo].[ShowDepartments_InlineTableValuedFunction] (	)
RETURNS TABLE 
AS
RETURN 
(
	WITH departmentsCTE(id, department, parent) AS
	(
	  SELECT id, department, parent
	    FROM Departments
	)
	SELECT *
	  FROM departmentsCTE
)
GO

SELECT * FROM [dbo].[ShowDepartments_InlineTableValuedFunction] ();
GO







--DROP FUNCTION [dbo].[ShowDepartments_MultiStatement];
GO
CREATE FUNCTION [dbo].[ShowDepartments_MultiStatement] ( )
RETURNS @results TABLE 
(
	id int,
	department VARCHAR (200),
	parent int
)
AS
BEGIN

	WITH departmentsCTE(id, department, parent) AS
	(
	  SELECT id, department, parent
	    FROM Departments
	)
	INSERT INTO @results
	SELECT *
	  FROM departmentsCTE
	 WHERE parent = 1;


	WITH departmentsCTE(id, department, parent) AS
	(
	  SELECT id, department, parent
	    FROM Departments
	)
	INSERT INTO @results
	SELECT *
	  FROM departmentsCTE
	 WHERE parent = 3;

	RETURN;
END
GO

SELECT * FROM [dbo].[ShowDepartments_MultiStatement] ();
GO





--DROP FUNCTION [dbo].[DepartmentCount];
GO
CREATE FUNCTION [dbo].[DepartmentCount] ()
RETURNS INT
AS
BEGIN
	DECLARE @results AS INT;

	WITH departmentsCTE(id, department, parent) AS
	(
	  SELECT id, department, parent
	    FROM Departments
		WHERE parent = 1
	)
	SELECT @results = count(1)
	  FROM departmentsCTE;
	 
	RETURN @results;
END
GO

SELECT [dbo].[DepartmentCount] ();
GO





DROP VIEW [dbo].[CteViewTest]
GO
CREATE VIEW [dbo].[CteViewTest]
AS 
	WITH departmentsCTE(id, department, parent) AS
	(
	  SELECT id, department, parent
	    FROM Departments
	)
	SELECT *
	  FROM departmentsCTE;
GO

SELECT * FROM [dbo].[CteViewTest];

















---------------------------------------------
-- Chapter 4 - RECURSIVE INTRO......
---------------------------------------------



--For more info on recursive CTEs see http://stevestedman.com/?p=2914

--Look at all Departments
SELECT * 
  FROM Departments;



--Find the top level
SELECT * 
  FROM Departments
 WHERE parent IS NULL;


-- Non CTE to get department levels
SELECT d1.department as 'Top_level',
       d2.department as 'Child_level'
  FROM Departments d1
  RIGHT JOIN Departments d2 on d1.id = d2.parent;

SELECT d2.id, d2.Department, d2.Parent,
       case when d2.Parent is NULL then 0 else 1 end as lvl
  FROM Departments d1
 RIGHT JOIN Departments d2 on d1.id = d2.parent;






--Building the anchor query
SELECT id, Department, parent, 1 AS lvl 
  FROM Departments
 WHERE parent IS NULL;



--Turn into a CTE
;WITH DepartmentCTE AS
(
	SELECT id, Department, parent, 0 AS lvl 
	  FROM Departments
	 WHERE parent IS NULL
) 
SELECT * FROM DepartmentCTE;


-- now just those that are not top level
-- the recursive query


    SELECT d.id, d.Department, d.parent, cte.lvl + 1
      FROM Departments AS d
     INNER JOIN DepartmentCTE AS cte ON d.parent = cte.id


--Add all second level departments
;WITH DepartmentCTE AS
(
	SELECT id, Department, parent, 0 AS lvl 
	  FROM Departments
	 WHERE parent IS NULL

 	UNION ALL 

    SELECT d.id, d.Department, d.parent, cte.lvl + 1
      FROM Departments AS d
     INNER JOIN DepartmentCTE AS cte ON d.parent = cte.id
) 
SELECT * 
  FROM DepartmentCTE;


  
 EXEC FillMoreDepartments;

-- now take a look at the NON cte query
SELECT d2.id, d2.Department, d2.Parent,
       case when d2.Parent is NULL then 0 else 1 end as lvl
  FROM Departments d1
 RIGHT JOIN Departments d2 on d1.id = d2.parent;




-- use [cte_demo];  -- download the cte_demo database from http://stevestedman.com/?p=2839


/*sum of parts
 1: 1
 2: 1+2 = 3
 3: 1+2+3 = 6
 4: 1+2+3+4 = 10
 .
 .
 .
 10: 1+2+3+4+5+6+7+8+9+10 = 55

 For more info on recursive CTEs see http://stevestedman.com/?p=2914
*/




-- with NON CTE way to do recursion.

CREATE FUNCTION dbo.SumParts (@Num INTEGER)
RETURNS INTEGER
AS
BEGIN
    DECLARE @ResultVar AS INTEGER = 0;
    IF (@Num > 0)
        SET @ResultVar = @Num + dbo.SumParts(@Num - 1);
    RETURN @ResultVar;
END
GO

SELECT dbo.SumParts(10);

SELECT dbo.SumParts(3);

SELECT dbo.SumParts(100);  -- this will throw an error







-- Recursive sum of parts CTE
--Anchor Query
SELECT 1 AS CountNumber, 1 AS GrandTotal;





 
--Next, the anchor query is placed into a CTE
;WITH SumPartsCTE AS
( 
	SELECT 1 AS CountNumber, 1 AS GrandTotal
)
SELECT * 
  FROM SumPartsCTE;




 

--Recursive Query
SELECT CountNumber + 1,
       GrandTotal + CountNumber + 1






--Next, add a UNION ALL statement into the existing CTE and add the recursive part of the query, 
--which should run fine, but does it?
;WITH SumPartsCTE AS
(
	SELECT 1 AS CountNumber, 1 AS GrandTotal

    UNION ALL

	SELECT CountNumber + 1,
           GrandTotal + CountNumber + 1
      FROM SumPartsCTE
)
SELECT * 
  FROM SumPartsCTE;
--Maximum recursion exhausted error.




-- Add a where clause that will terminate the recursion.

;WITH SumPartsCTE AS
(
	SELECT 1 AS CountNumber, 1 AS GrandTotal

     UNION ALL

    SELECT CountNumber + 1,
           GrandTotal + CountNumber + 1
      FROM SumPartsCTE
     WHERE CountNumber < 10
)
SELECT * 
  FROM SumPartsCTE;




;WITH SumPartsCTE AS
(
	SELECT 1 AS CountNumber, 1 AS GrandTotal

     UNION ALL

    SELECT CountNumber + 1,
           GrandTotal + CountNumber + 1
      FROM SumPartsCTE
     WHERE CountNumber < 10
)
SELECT MAX(GrandTotal) as SumOfParts
  FROM SumPartsCTE;









 -- But what if we want to go futher than 100 on the recursion
;WITH SumPartsCTE AS
(
	SELECT 1 AS CountNumber, 1 AS GrandTotal

     UNION ALL

    SELECT CountNumber + 1,
           GrandTotal + CountNumber + 1
      FROM SumPartsCTE
     WHERE CountNumber < 150
)
SELECT MAX(GrandTotal) as SumOfParts
  FROM SumPartsCTE


  
--OPTION (MAXRECURSION 200);








;WITH SumPartsCTE AS
(
	SELECT 1 AS CountNumber, 1 AS GrandTotal

     UNION ALL

    SELECT CountNumber + 1,
           GrandTotal + CountNumber + 1
      FROM SumPartsCTE
     WHERE CountNumber < 40000
)
SELECT MAX(GrandTotal) as SumOfParts
  FROM SumPartsCTE
OPTION (MAXRECURSION 40000);















-- Multiple Anchor Queries



-- take a look at the Royalty table
SELECT *
  FROM Royalty;







--If we wanted to create a query to trace Prince William’s maternal ancestors it would be 
-- straightforward with a CTE. We can see that Prince William has an id of 17 and a full 
-- name of “William Arthur Phillip Windsor”.
;WITH RoyalTreeCTE AS
(
   SELECT * 
     FROM Royalty 
	WHERE id = 17
    
	UNION ALL

   SELECT r.* 
     FROM Royalty AS r
    INNER JOIN RoyalTreeCTE AS rt ON rt.mother = r.id 
)
SELECT * 
 FROM RoyalTreeCTE;




 
--Prince William and his maternal ancestors from the CTE query.
--Finding the paternal ancestors would be very similar. Instead of using the mother 
--   column, use the father column.


;WITH RoyalTreeCTE AS
(
  SELECT * 
    FROM Royalty 
   WHERE id = 17

   UNION ALL

  SELECT r.*
    FROM Royalty AS r
   INNER JOIN RoyalTreeCTE AS rt ON rt.father = r.id 
)
SELECT * FROM RoyalTreeCTE;
  






--How can we write the query to find both the maternal and paternal sides of a family tree? 
-- Keep in mind that doing this will produce both the mother and father of each person in the tree.
;WITH RoyalTreeCTE AS
(  SELECT * 
     FROM Royalty 
	WHERE id = 17

    UNION ALL

   SELECT r.* 
     FROM Royalty r
    INNER JOIN RoyalTreeCTE rt ON rt.father = r.id

    UNION ALL

   SELECT r.*
     FROM Royalty r
    INNER JOIN RoyalTreeCTE rt ON rt.mother = r.id
)
SELECT * 
  FROM RoyalTreeCTE;





































--BONUS MATERIAL  
-- The following CTE examples are not part of the introduction presentation
--  they are just included as bonus material























 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 






GO


-- Calculating the Fibonacci sequence 
-- By definition, the first two numbers in the Fibonacci sequence are 0 and 1, and each subsequent number is the sum of the previous two.
-- http://stevestedman.com/?p=1142

-- Build the anchor query
;WITH Fibonacci (PrevN, N) AS 
( SELECT 0, 1
) 
SELECT * 
  FROM Fibonacci;

-- add the recursive query
;WITH Fibonacci (PrevN, N) AS 
( SELECT 0, 1
   UNION ALL 
  SELECT N, PrevN + N 
    FROM Fibonacci 
   WHERE N < 1000000000
) 
SELECT * 
  FROM Fibonacci;


 
 -- select just the column we want
;WITH Fibonacci (PrevN, N) AS 
( SELECT 0, 1
   UNION ALL 
  SELECT N, PrevN + N 
    FROM Fibonacci 
   WHERE N < 1000000000
) 
 SELECT PrevN as Fibo
   FROM Fibonacci 
 OPTION (MAXRECURSION 0);



-- Fibonacci with output as a csv
-- http://stevestedman.com/?p=320
WITH Fibonacci (PrevN, N) AS 
( SELECT 0, 1
   UNION ALL 
  SELECT N, PrevN + N 
    FROM Fibonacci 
   WHERE N < 1000000000
) 
 SELECT Substring((SELECT cast(', ' as varchar(max)) + 
		cast(PrevN as varchar(max))
   FROM Fibonacci 
  FOR XML PATH('')),3,10000000) AS list;
  
  




-- Calculating Factorials with a CTE : Step 1 Build the Anchor Query
--  5! = 5 * 4 * 3 * 2 * 1 = 120
-- http://stevestedman.com/?p=1166
-- Not yet recursive, only calculates 1!
--   A start, but not very interesting
WITH Factorial (N, Factorial) AS 
(
 SELECT 1, 1
) 
 SELECT N, Factorial
   FROM Factorial;

 

  
-- Calculating Factorials with a CTE : Step 2 Build the recursive query
-- http://stevestedman.com/?p=1166
-- This works great for 5!
;WITH Factorial (N, Factorial) AS 
( SELECT 1, 1
   UNION ALL -- here is where it gets recursive
  SELECT N + 1, (N + 1) * Factorial
    FROM Factorial -- reference back to the CTE
   WHERE N < 5 -- abort when we get to 5!
) 
 SELECT N, Factorial
   FROM Factorial;
 
 
  
  
-- Calculating Factorials with a CTE : Step 3
-- http://stevestedman.com/?p=1166
-- this one throws an error of "Arithmetic overflow error converting expression to data type int."
WITH Factorial (N, Factorial) AS 
( SELECT 1, 1
   UNION ALL -- here is where it gets recursive
  SELECT N + 1, (N + 1) * Factorial
    FROM Factorial -- reference back to the CTE
   WHERE N < 20 -- abort when we get to 20!
) 
 SELECT N, Factorial
   FROM Factorial;
   
   
   
   
   
   
   
-- Calculating Factorials with a CTE  : Step 4  - GO BIG
-- http://stevestedman.com/?p=1166
WITH Factorial (N, Factorial) AS 
( SELECT 1, cast(1 as BIGINT) -- Cast to BIGINT to avoid overflow
   UNION ALL -- here is where it gets recursive
  SELECT N + 1, (N + 1) * Factorial
    FROM Factorial -- reference back to the CTE
   WHERE N < 20 -- abort when we get to 20!
) 
 SELECT N, Factorial
   FROM Factorial;
   
   
   
   
   
   
   
   
 
 
 
-- Calculating Factorials with a CTE  : Step 5  - GO REALLY BIG
-- http://stevestedman.com/?p=1166
;WITH Factorial (N, Factorial) AS 
( SELECT 1, cast(1 as NUMERIC(38,0)) -- Cast to NUMERIC to avoid overflow
   UNION ALL -- here is where it gets recursive
  SELECT N + 1, (N + 1) * Factorial
    FROM Factorial -- reference back to the CTE
   WHERE N < 33 -- abort when we get to 33!
) 
 SELECT N, Factorial
   FROM Factorial; 
 
 
 
 --previous query, try 34...  What now?
 
 
 
 
 
 
 
 
 
 
 
 
 
 
GO
CREATE FUNCTION dbo.Split (@sep char(1), @s varchar(8000))
RETURNS table
AS
RETURN (
    WITH splitter_cte AS (
      SELECT CHARINDEX(@sep, @s) as pos, 0 as lastPos
      UNION ALL
      SELECT CHARINDEX(@sep, @s, pos + 1), pos 
      FROM splitter_cte
      WHERE pos > 0
    )
    SELECT SUBSTRING(@s, lastPos + 1, case when pos = 0 then 80000 else pos - lastPos -1 end) as chunk
    FROM splitter_cte
  )
GO


SELECT * 
  FROM dbo.Split(' ', 'the quick brown dog jumps over the lazy fox')
OPTION(MAXRECURSION 0);



declare @InputString as varchar(8000);
set @InputString = 'Anyone can perform a SQL Server upgrade, but the risk of failure is much greater if you don’t plan it correctly.  By the end of this chapter you will understand how to plan for the things that could go wrong during the upgrade, and options you can take to mitigate those risks.  
This chapter will cover the details that you will need to know when upgrading a stand alone, non High Availability (HA), SQL Server from one version to a newer version, with minimal downtime.  I use the term “minimal downtime” as the goal, as it is very expensive to get to the point of zero downtime with a SQL Server upgrade without an HA solution.  For the purpose of this upgrade process we will be considering a single SQL Server being upgraded, although it may end up on different hardware or it may be the same hardware.
Upgrading may involve upgrading just the hardware for better performance or more capacity and not the SQL Server version.  The specific upgrade path may depend on your business needs and the resources or budget that you have available.
Most of the summaries and stories in this chapter are based on my experiences using SQL Server over the last 21 years.  I will refer to several examples in this chapter of things that went wrong, and then at the end follow up with a case study of an upgrade that went very well.  Considering the things that can go wrong will help you think about ways to prevent them, or reduce their likelihood of happening.'
set @InputString = replace( @InputString, '.', ' ');
set @InputString = replace( @InputString, ',', ' ');
set @InputString = replace( @InputString, ':', ' ');
set @InputString = replace( @InputString, char(13), ' ');
set @InputString = replace( @InputString, char(10), ' ');
set @InputString = replace( @InputString, '  ', ' ');
set @InputString = replace( @InputString, '  ', ' ');
set @InputString = replace( @InputString, '  ', ' ');
set @InputString = replace( @InputString, '  ', ' ');


SELECT * 
  FROM dbo.Split(' ', @InputString)
OPTION(MAXRECURSION 0);

SELECT count(1) as NumUsages, cast(chunk as varchar(100))
  FROM dbo.Split(' ', @InputString)
  GROUP BY chunk
  order by NumUsages desc
OPTION(MAXRECURSION 0);





GO
CREATE FUNCTION dbo.SplitWithLineNumber (@sep char(1), @s varchar(max))
RETURNS table
AS
RETURN (
 WITH splitter_cte AS (
 SELECT CHARINDEX(@sep, @s) as pos,
        cast(0 as bigint) as lastPos,
        cast(0 as int) as LineNumber
 UNION ALL
 SELECT CHARINDEX(@sep, @s, pos + 1),
        cast(pos as bigint),
        LineNumber + 1 as LineNumber
 FROM splitter_cte
 WHERE pos > 0
 )
 SELECT LineNumber,
        SUBSTRING(@s,
                 lastPos + 1,
                 case when pos = 0 then 2147483647
                      else pos - lastPos -1 end) as chunk
 FROM splitter_cte
 );


GO
CREATE FUNCTION [dbo].[varcharDiff](@s1 varchar(max), @s2 varchar(max))
RETURNS table
AS
RETURN (
	WITH FirstStringAsTable as
	(
	SELECT leftDiff.lineNumber, leftDiff.chunk AS leftChunk, rightDiff.chunk AS rightChunk
	  FROM dbo.SplitWithLineNumber(char(10), @s1) AS leftDiff
	 LEFT JOIN dbo.SplitWithLineNumber(char(10), @s2) AS rightDiff ON leftDiff.lineNumber = rightDiff.lineNumber,
	)
	SELECT * 
	FROM FirstStringAsTable
	WHERE leftChunk <> rightChunk
  )
GO



declare @InputString as varchar(8000);
set @InputString = 'Anyone can perform a SQL Server upgrade, but the risk of failure is much 
greater if you don’t plan it correctly.  By the end of this chapter you will understand how 
to plan for the things that could go wrong during the upgrade, and options you can take to 
mitigate those risks.  
This chapter will cover the details that you will need to know when upgrading a stand alone, 
non High Availability (HA), SQL Server from one version to a newer version, with minimal 
downtime.  I use the term “minimal downtime” as the goal, as it is very expensive to get to the
point of zero downtime with a SQL Server upgrade without an HA solution.  For the purpose of
this upgrade process we will be considering a single SQL Server being upgraded, although it
may end up on different hardware or it may be the same hardware.
Upgrading may involve upgrading just the hardware for better performance or more capacity and
not the SQL Server version.  The specific upgrade path may depend on your business needs and 
the resources or budget that you have available.
Most of the summaries and stories in this chapter are based on my experiences using SQL Server 
over the last 21 years.  I will refer to several examples in this chapter of things that went 
wrong, and then at the end follow up with a case study of an upgrade that went very well.  
Considering the things that can go wrong will help you think about ways to prevent them, or 
reduce their likelihood of happening.'




declare @InputString2 as varchar(8000);
set @InputString2 = 'Anyone can perform a SQL Server upgrade, but the risk of failure is much 
greater if you don’t plan it correctly.  By the end of this chapter you will understand how 
to plan for the things that could go wrong during the upgrade, and options you can take to 
mitigate those risks.  
This chapter will cover the details that you need to know when upgrading a stand alone, 
non High Availability (HA), SQL Server from one version to a newer version, with minimal 
downtime.  I use the term “minimalistic downtime” as the goal, as it is very expensive to get to the
point of zero downtime with a SQL Server upgrade without an HA solution.  For the purpose of
this upgrade process we will be considering a single SQL Server being upgraded, although it
may end up on different hardware or it may be the same hardware.
Upgrading may involve upgrading just the hardware for better performance or more capacity and
not the SQL Server version.  The specific upgrade path may depend on your business needs and 
the resources or budget that you have.
Most of the summaries and stories in this chapter are based on my experiences using SQL Server 
over the last 21 years.  I will refer to several examples in this chapter of things that went 
wrong, and then at the end follow up with a case study of an upgrade that went very well.  
Considering the things that can go wrong will help you think about ways to prevent them, or 
reduce their likelihood of happening.'



select * 
from [dbo].[varcharDiff](@InputString, @InputString2);














--multiple anchor queries
USE [cte_demo];

-- first start with just the cycle department
;WITH DepartmentCTE AS
( SELECT id, Department, parent, 0 as Level 
    FROM Departments
   WHERE id = 2 -- 2 for cycle
   UNION ALL
  SELECT d.id, d.Department, d.parent,
         DepartmentCTE.Level + 1 as Level 
    FROM Departments d
   INNER JOIN DepartmentCTE
      ON DepartmentCTE.id = d.parent) 
SELECT * 
  FROM DepartmentCTE
 ORDER BY parent;

 -- then add in the fitness department
 ;WITH DepartmentCTE AS
( SELECT id, Department, parent, 0 as Level 
    FROM Departments
   WHERE id = 2
   UNION ALL
SELECT id, Department, parent, 0 as Level 
  FROM Departments
 WHERE id = 4
   UNION ALL
  SELECT d.id, d.Department, d.parent,
         DepartmentCTE.Level + 1 as Level 
    FROM Departments d
   INNER JOIN DepartmentCTE
      ON DepartmentCTE.id = d.parent) 
SELECT * 
  FROM DepartmentCTE
 ORDER BY parent;


 -- single anchor alternative
 ;WITH DepartmentCTE AS
( SELECT id, Department, parent, 0 as Level 
    FROM Departments
   WHERE id in (2, 4)
   UNION ALL
  SELECT d.id, d.Department, d.parent,
         DepartmentCTE.Level + 1 as Level 
    FROM Departments d
   INNER JOIN DepartmentCTE
      ON DepartmentCTE.id = d.parent) 
SELECT * 
  FROM DepartmentCTE
 ORDER BY parent;







SELECT * FROM Royalty;

-- Trace Prince William's maternal side
WITH RoyalTreeCTE 
AS
(
	SELECT * FROM Royalty WHERE id = 17
	UNION ALL
	SELECT r.* 
	  FROM Royalty r
	 INNER JOIN RoyalTreeCTE rt on rt.mother = r.id
)
SELECT * FROM RoyalTreeCTE;


-- Trace Prince William's paternal side

WITH RoyalTreeCTE 
AS
(
	SELECT * FROM Royalty WHERE id = 17
	UNION ALL
	SELECT r.* 
	  FROM Royalty r
	 INNER JOIN RoyalTreeCTE rt on rt.father = r.id
)
SELECT * FROM RoyalTreeCTE;


-- trace both sides.
WITH RoyalTreeCTE 
AS
(
	SELECT * 
	 FROM Royalty WHERE id = 17
	UNION ALL
	SELECT r.* 
	  FROM Royalty r
	 INNER JOIN RoyalTreeCTE rt on rt.father = r.id
	UNION ALL
	SELECT r.* 
	  FROM Royalty r
	 INNER JOIN RoyalTreeCTE rt on rt.mother = r.id
)
SELECT * FROM RoyalTreeCTE;


WITH RoyalTreeCTE (id, name, mother, father, relationship)
AS
(
	SELECT *, 'source' as relationship
	 FROM Royalty WHERE id = 17
	UNION ALL
	SELECT r.*, 'father' as relationship
	  FROM Royalty r
	 INNER JOIN RoyalTreeCTE rt on rt.father = r.id
	UNION ALL
	SELECT r.*, 'mother' as relationship
	  FROM Royalty r
	 INNER JOIN RoyalTreeCTE rt on rt.mother = r.id
)
SELECT * FROM RoyalTreeCTE;











WITH RoyalTreeCTE AS
(  SELECT *, 0 as level,
          cast(name as varchar(4096)) as TreePath
     FROM Royalty WHERE id = 17
    UNION ALL
   SELECT r.*, level + 1 as level,
          cast(rt.TreePath + '-->father:' +
               r.name as varchar(4096)) as TreePath
     FROM Royalty r
    INNER JOIN RoyalTreeCTE rt on rt.father = r.id
    UNION ALL
   SELECT r.*, level + 1 as level,
          cast(rt.TreePath + '-->mother:' +
               r.name as varchar(4096)) as TreePath
     FROM Royalty r
    INNER JOIN RoyalTreeCTE rt on rt.mother = r.id)
SELECT TreePath
  FROM RoyalTreeCTE
 WHERE level < 3
 ORDER BY TreePath;


WITH RoyalTreeCTE AS
(  SELECT *, 0 as level,
          cast(name as varchar(4096)) as TreePath,
		  cast('Root' as varchar(10)) as Relationship
     FROM Royalty WHERE id = 17
    UNION ALL
   SELECT r.*, level + 1 as level,
          cast(rt.TreePath + '-->father:' +
               r.name as varchar(4096)) as TreePath,
		  cast('Father' as varchar(10)) as Relationship
     FROM Royalty r
    INNER JOIN RoyalTreeCTE rt on rt.father = r.id
    UNION ALL
   SELECT r.*, level + 1 as level,
          cast(rt.TreePath + '-->mother:' +
               r.name as varchar(4096)) as TreePath,
		  cast('Mother' as varchar(10)) as Relationship
     FROM Royalty r
    INNER JOIN RoyalTreeCTE rt on rt.mother = r.id)
SELECT REPLICATE('.      ', Level) + Relationship + ': ' + name
  FROM RoyalTreeCTE
 ORDER BY TreePath;





WITH RoyalTreeCTE AS
(  SELECT *, 0 as level,
          cast('b' as varchar(4096)) as Sorter,
		  cast('Top' as varchar(10)) as Relationship
     FROM Royalty WHERE id = 17
    UNION ALL
   SELECT r.*, level + 1 as level,
          cast(Sorter + 'a' as varchar(4096)) as Sorter,
		  cast('Father' as varchar(10)) as Relationship
     FROM Royalty r
    INNER JOIN RoyalTreeCTE rt on rt.father = r.id
    UNION ALL
   SELECT r.*, level + 1 as level,
          cast(Sorter + 'c' as varchar(4096)) as Sorter,
		  cast('Mother' as varchar(10)) as Relationship
     FROM Royalty r
    INNER JOIN RoyalTreeCTE rt on rt.mother = r.id)
SELECT sorter, name--, REPLICATE('.           ', Level) + Relationship + ': ' + name
  FROM RoyalTreeCTE
 ORDER BY Sorter + 'bbbbbbbbbbbbb';







WITH RoyalTreeCTE (id, name, mother, father, level, TreePath)
AS
(
	SELECT *, 0 as level,
           cast(name as varchar(4096)) as TreePath
	 FROM Royalty WHERE id = 17
	UNION ALL
	SELECT r.*, level + 1 as level,
           cast(rt.TreePath + '-->father:' + cast(r.name as varchar(4096)) as varchar(4096)) as TreePath
	  FROM Royalty r
	 INNER JOIN RoyalTreeCTE rt on rt.father = r.id
	UNION ALL
	SELECT r.*, level + 1 as level,
           cast(rt.TreePath + '-->mother:' + cast(r.name as varchar(4096)) as varchar(4096)) as TreePath
	  FROM Royalty r
	 INNER JOIN RoyalTreeCTE rt on rt.mother = r.id
)
--SELECT TreePath FROM RoyalTreeCTE;
SELECT TreePath FROM RoyalTreeCTE where level < 2
ORDER BY TreePath;
 





-- compared to a recursive function
GO
DROP FUNCTION dbo.SumParts;
GO
CREATE FUNCTION dbo.SumParts (@Num integer)
RETURNS integer
AS
BEGIN
	DECLARE @ResultVar as integer;
	set @ResultVar = 0;
	IF (@Num > 0)
		SET @ResultVar = @Num + dbo.SumParts(@Num - 1);
	RETURN @ResultVar;
END
GO
select dbo.SumParts(10);

GO

DECLARE @Num as INTEGER;
SET @Num = 10;

;WITH SumPartsCTE AS
(
	SELECT @Num as Total, @Num as CountDown
	UNION ALL
	SELECT Total + CountDown - 1, CountDown - 1 as CountDown
	  FROM SumPartsCTE
	 WHERE CountDown > 0
)
SELECT max(Total) FROM SumPartsCTE;



GO



 --The department id field will show up as department.
WITH departmentsCTE(department, parent, id) AS
( SELECT id, department, parent
    FROM Departments) 
SELECT * 
  FROM departmentsCTE;















-- filling up a test table.
USE [cte_demo]
GO
DROP TABLE [dbo].[Users];
--create a table Users to fill from a CTE
CREATE TABLE [dbo].[Users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NULL,
	[MiddleName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[LoginName] [varchar](100) NULL
) ON [PRIMARY];

CREATE CLUSTERED INDEX [ClusteredUsers] 
    ON [dbo].[Users] ( [id] ASC );

CREATE NONCLUSTERED INDEX [UsersLoginName] 
    ON [dbo].[Users] ( [LoginName] ASC );


GO

set nocount on;
GO
INSERT INTO [dbo].[Users]
           ([FirstName], [MiddleName], [LastName], [LoginName])
     VALUES
           ('Steve', 'Tester', 'Stedman', 'SteveTesterStedman');
GO 10000000


--or fill it up with more varying data.


;WITH Fnames (Name) AS
(SELECT 'John' 
  UNION 
 SELECT 'Mary' 
  UNION 
 SELECT 'Bill'),
Mnames (Name) AS
(SELECT 'A' 
  UNION 
 SELECT 'Ed' 
  UNION 
 SELECT 'Helen') ,
Lnames (Name) AS
(SELECT 'Smith' 
  UNION 
 SELECT 'Gibb' 
  UNION 
 SELECT 'Jones')
SELECT F.Name AS FirstName,
       M.Name AS MiddleName,
       L.Name AS LastName
  FROM Fnames AS F
 CROSS JOIN Mnames AS M
 CROSS JOIN Lnames AS L;




 ;WITH Fnames (Name) AS
(SELECT 'John' UNION SELECT 'Mary' UNION SELECT 'Bill'),
Mnames (Name) AS
(SELECT 'A' UNION SELECT 'Ed' UNION SELECT 'Helen') ,
Lnames (Name) AS
(SELECT 'Smith' UNION SELECT 'Gibb' UNION SELECT 'Jones'),
UserNameBase (Name) AS
(SELECT 'Ace' UNION SELECT 'Stallion' UNION SELECT 'Princess')
SELECT F.Name AS FirstName, M.Name AS MiddleName,
       L.Name AS LastName, U.Name + L.Name as UserName
  FROM Fnames AS F
 CROSS JOIN Mnames AS M
 CROSS JOIN Lnames AS L
 CROSS JOIN UserNameBase AS U;




 ;WITH Fnames (Name) AS
(SELECT 'John' UNION SELECT 'Mary' UNION SELECT 'Bill'),
Mnames (Name) AS
(SELECT 'A' UNION SELECT 'Ed' UNION SELECT 'Helen') ,
Lnames (Name) AS
(SELECT 'Smith' UNION SELECT 'Gibb' UNION SELECT 'Jones'),
UserNameBase (Name) AS
(SELECT 'Ace' UNION SELECT 'Stallion' UNION 
 SELECT 'Princess'),
Uniqueifier(Name) AS
(SELECT 'A' UNION SELECT 'B' UNION SELECT 'C')
INSERT INTO [dbo].[Users]
           ([FirstName], [MiddleName], [LastName], [LoginName])
SELECT F.Name AS FirstName, M.Name AS MiddleName,
       L.Name AS LastName, 
       Uniq.Name + U.Name + L.Name + Uniq2.Name as UserName
  FROM Fnames AS F
 CROSS JOIN Mnames AS M
 CROSS JOIN Lnames AS L
 CROSS JOIN UserNameBase AS U
 CROSS JOIN Uniqueifier AS Uniq
 CROSS JOIN Uniqueifier AS Uniq2;

 SELECT * FROM Users;




 ;WITH Fnames (Name) AS
(SELECT 'John' UNION ALL SELECT 'Mary' UNION ALL SELECT 'Bill' UNION ALL SELECT 'Fred' UNION ALL SELECT 'Harry' UNION ALL SELECT 'Peter' UNION ALL SELECT 'Donna' UNION ALL SELECT 'Karen' UNION ALL SELECT 'Jack' UNION ALL SELECT 'Dee' UNION ALL SELECT 'Mary' UNION ALL SELECT 'Bill2' UNION ALL SELECT 'Bill3' UNION ALL SELECT 'Bill4' UNION ALL SELECT 'Bill5'),
Mnames (Name) AS
(SELECT 'A' UNION ALL SELECT 'Ed' UNION ALL SELECT 'Helen' UNION ALL SELECT 'Helen' UNION ALL SELECT 'Helen' UNION ALL SELECT 'Helen' UNION ALL SELECT 'Helen' UNION ALL SELECT 'Helen' UNION ALL SELECT 'Helen' UNION ALL SELECT 'Helen' UNION ALL SELECT 'Helen' UNION ALL SELECT 'Helen' UNION ALL SELECT 'Helen' UNION ALL SELECT 'Helen' UNION ALL SELECT 'Helen') ,
Lnames (Name) AS
(SELECT 'Smith' UNION ALL SELECT 'Gibb' UNION ALL SELECT 'Jones' UNION ALL SELECT 'Jones' UNION ALL SELECT 'Jones' UNION ALL SELECT 'Jones' UNION ALL SELECT 'Jones' UNION ALL SELECT 'Jones' UNION ALL SELECT 'Jones' UNION ALL SELECT 'Jones' UNION ALL SELECT 'Jones' UNION ALL SELECT 'Jones' UNION ALL SELECT 'Jones' UNION ALL SELECT 'Jones' UNION ALL SELECT 'Jones'),
UserNameBase (Name) AS
(SELECT 'Ace' UNION ALL SELECT 'Stallion' UNION ALL SELECT 'Princess' UNION ALL SELECT 'Princess' UNION ALL SELECT 'Princess' UNION ALL 
 SELECT 'Princess' UNION ALL SELECT 'Princess' UNION ALL SELECT 'Princess' UNION ALL SELECT 'Princess' UNION ALL SELECT 'Princess' UNION ALL 
 SELECT 'Princess' UNION ALL SELECT 'Princess' UNION ALL SELECT 'Princess' UNION ALL SELECT 'Princess' UNION ALL SELECT 'Princess'),
Uniqueifier(Name) AS
(SELECT 'A' UNION ALL SELECT 'B' UNION ALL SELECT 'C' UNION ALL SELECT 'C' UNION ALL SELECT 'C' UNION ALL 
 SELECT 'C' UNION ALL SELECT 'C' UNION ALL SELECT 'C' UNION ALL SELECT 'C' UNION ALL SELECT 'C' UNION ALL 
 SELECT 'C' UNION ALL SELECT 'C' UNION ALL SELECT 'C' UNION ALL SELECT 'C' UNION ALL SELECT 'C')
INSERT INTO [dbo].[Users]
           ([FirstName], [MiddleName], [LastName], [LoginName])
SELECT F.Name AS FirstName, M.Name AS MiddleName,
       L.Name AS LastName, 
       Uniq.Name + U.Name + L.Name + Uniq2.Name as UserName
  FROM Fnames AS F
 CROSS JOIN Mnames AS M
 CROSS JOIN Lnames AS L
 CROSS JOIN UserNameBase AS U
 CROSS JOIN Uniqueifier AS Uniq
 CROSS JOIN Uniqueifier AS Uniq2;





 --THE END---------------------------------------------------


