-- SAMPLE CODE for the SQL Saturday Presentation in Redmond WA
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


--create a table to use for CTE query demo
CREATE TABLE [Departments] (
	id int,  --would normally be an INT IDENTITY
	department VARCHAR (200),
	parent int,
	archived bit default 0
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
	insert into [Departments] (id, department, parent, archived) 
	     values (14, 'Snowshoe', 3, 1);
       
	-- now some sub-departments for fitness
	insert into [Departments] (id, department, parent) 
	     values (15, 'Running', 4);
	insert into [Departments] (id, department, parent) 
	     values (16, 'Swimming', 4);
	insert into [Departments] (id, department, parent, archived) 
	     values (17, 'Yoga', 4, 1);
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
-- multipe recursive queries
--drop table [Royalty];
CREATE TABLE [Royalty] (
	id int,  --would normally be an INT IDENTITY
    name VARCHAR (200),
	mother int,
	father int,
	);
	
insert into [Royalty] (id, name, mother, father) 
	     values (1, 'George V, King of England', null, null);
insert into [Royalty] (id, name, mother, father) 
	     values (2, 'Mary, Princess of Teck', null, null);
insert into [Royalty] (id, name, mother, father) 
	     values (3, 'George VI Windsor, King of England', 2, 1);
insert into [Royalty] (id, name, mother, father) 
	     values (4, 'Claude George Bowes-Lyon', null, null);
insert into [Royalty] (id, name, mother, father) 
	     values (5, 'Nina Cecilia Cavendish-Bentinck', null, null);
insert into [Royalty] (id, name, mother, father) 
	     values (6, 'Elizabeth Angela Marguerite Bowes-Lyon', 5, 4);
insert into [Royalty] (id, name, mother, father) 
	     values (7, 'William George I of the Hellenes', null, null);
insert into [Royalty] (id, name, mother, father) 
	     values (8, 'Olga Konstantinovna Romanova', null, null);
insert into [Royalty] (id, name, mother, father) 
	     values (9, 'Louis Alexander von Battenburg', null, null);
insert into [Royalty] (id, name, mother, father) 
	     values (10, 'Victoria von Hessen und bei Rhein', null, null);
insert into [Royalty] (id, name, mother, father) 
	     values (11, 'Andreas, Prince of Greece', 8, 7);
insert into [Royalty] (id, name, mother, father) 
	     values (12, 'Alice, Princess of Battenbugr', 10, 9);
insert into [Royalty] (id, name, mother, father) 
	     values (13, 'Phillip Mountbatten, Duke of Edinburgh', 12, 11);
insert into [Royalty] (id, name, mother, father) 
	     values (14, 'Elizabeth II Windsor, Queene of England', 6, 3);
insert into [Royalty] (id, name, mother, father) 
	     values (15, 'Charles Philip Arthur Windsor', 14, 13);
insert into [Royalty] (id, name, mother, father) 
	     values (16, 'Diana Frances (Lady) Spencer', 18, 19);
insert into [Royalty] (id, name, mother, father) 
	     values (17, 'William Arthur Phillip Windsor', 16, 15);
insert into [Royalty] (id, name, mother, father) 
	     values (18, 'Frances Ruth Burke Roche', null, null);
insert into [Royalty] (id, name, mother, father) 
	     values (19, 'Edward John Spencer', null, null);

SET NOCOUNT OFF;

USE [cte_demo];
EXECUTE ReloadDepartments;


-- just see what is in the Departments table
-- http://stevestedman.com/?p=2856
SELECT * FROM Departments;

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


















-- Derived Table- NO CTE
SELECT q1.department, q2.department as subDepartment
FROM   (SELECT id, department, parent 
	     FROM Departments) as q1
INNER JOIN (SELECT id, department, parent 
	     FROM Departments) as q2 
      ON q1.id = q2.parent
WHERE q1.parent is null; 



















---CTE for Subquery Re-use
;WITH DepartmentCTE(id, department, parent) AS 
(	SELECT id, department, parent
	  FROM Departments) 
SELECT q1.department, q2.department as subDepartment
  FROM DepartmentCTE q1
 INNER JOIN DepartmentCTE q2 on q1.id = q2.parent
 WHERE q1.parent is null; 





























-- Non CTE to get department levels
SELECT d1.department as 'Top_level',
       d2.department as 'Child_level'
  FROM Departments d1
  RIGHT JOIN Departments d2 on d1.id = d2.parent;

SELECT d2.id, d2.Department, d2.Parent,
       case when d2.Parent is NULL then 0 else 1 end as Level
  FROM Departments d1
  RIGHT JOIN Departments d2 on d1.id = d2.parent;





	use [cte_demo];


	-- Recursive CTE
	;WITH DepartmentCTE(id, Department, Parent, Level) AS 
	( 
	  SELECT id, department, parent, 0 as Level 
		FROM Departments
	   WHERE parent is NULL 

	   UNION ALL -- and now for the recursive part 

	  SELECT d.id, d.department, d.parent,
			 DepartmentCTE.Level + 1 as Level 
		FROM Departments d
		INNER JOIN DepartmentCTE
		ON DepartmentCTE.id = d.parent
	) 

	SELECT * 
	  FROM DepartmentCTE
	 ORDER BY Parent; 
 
 
 
 
 

execute FillMoreDepartments; 


-- Run it again....
-- Recursive CTE
;WITH DepartmentCTE(id, Department, Parent, Level) AS 
( SELECT id, Department, parent, 0 as Level 
    FROM Departments
   WHERE parent is NULL 
   UNION ALL -- and now for the recursive part 
  SELECT d.id, d.Department, d.parent,
         DepartmentCTE.Level + 1 as Level 
    FROM Departments d
    INNER JOIN DepartmentCTE
    ON DepartmentCTE.id = d.parent) 
SELECT * 
  FROM DepartmentCTE
 ORDER BY parent; 
















 


-- Recursive CTE with TreePath
;WITH DepartmentCTE(DeptId, Department, Parent, Level, TreePath) AS 
( SELECT id as DeptId, Department, parent, 0 as Level,
		 cast(Department as varchar(1024)) as TreePath
    FROM Departments
   WHERE parent is NULL 
   UNION ALL -- and now for the recursive part 
  SELECT d.id as DeptId, d.Department, d.parent,
         DepartmentCTE.Level + 1 as Level,
         cast(DepartmentCTE.TreePath + ' -> ' + 
              d.department as varchar(1024)) as TreePath
    FROM Departments d
    INNER JOIN DepartmentCTE
    ON DepartmentCTE.DeptId = d.parent) 
SELECT DeptId, Parent, Level, TreePath
  FROM DepartmentCTE
 ORDER BY TreePath; 
 
 
 
 -- Slightly different formatting on the path
;WITH DepartmentCTE(DeptId, Department, Parent, Level, TreePath) AS 
( SELECT id as DeptId, Department, parent, 0 as Level,
		 cast(Department as varchar(8000)) as TreePath
    FROM Departments
   WHERE parent is NULL 
   UNION ALL -- and now for the recursive part 
  SELECT d.id as DeptId, d.Department, d.parent,
         DepartmentCTE.Level + 1 as Level,
         cast(DepartmentCTE.TreePath + '/' + d.department as varchar(8000)) as TreePath
    FROM Departments d
    INNER JOIN DepartmentCTE
    ON DepartmentCTE.DeptId = d.parent) 
SELECT --DeptId, Parent, Level, 
       TreePath
  FROM DepartmentCTE
 ORDER BY TreePath; 
 
 
 
 
 
 
 
 
 
 
 
-- using the REPLICATE function
SELECT REPLICATE('abc.', 3);
 
 
-- Recursive CTE with indentation
-- Using the REPLICATE function to indent with a '.  ' for each level
;WITH DepartmentCTE AS
( SELECT id, Department, parent, 0 as Level,
         cast(Department as varchar(8000)) as TreePath
    FROM Departments
   WHERE parent is NULL 
   UNION ALL 
  SELECT d.id, d.Department, d.parent,
         DepartmentCTE.Level + 1 as Level,
         cast(DepartmentCTE.TreePath 
            + ' -> ' 
            + d.department as varchar(8000)) as TreePath
    FROM Departments d
   INNER JOIN DepartmentCTE ON DepartmentCTE.id = d.parent)
SELECT REPLICATE('   ', Level) + '+'
     + Department as Department
  FROM DepartmentCTE
 ORDER BY TreePath;

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

-- Performance Differences 
-- Remember Ctrl+M to turn on Execution Plan 
-- Recursive CTE compared to Multiple Self Joins 
;WITH DepartmentCTE(DeptId, Department, Parent, Level, TreePath) AS 
( SELECT id as DeptId, Department, parent, 0 as Level, 
     cast(Department as varchar(1024)) as TreePath 
    FROM Departments 
   WHERE parent is NULL 
   UNION ALL -- and now for the recursive part  
  SELECT d.id as DeptId, d.Department, d.parent, 
         DepartmentCTE.Level + 1 as Level, 
         cast(DepartmentCTE.TreePath + ' -> ' + 
              cast(d.department as varchar(1024)) 
            as varchar(1024)) as TreePath 
    FROM Departments d 
    INNER JOIN DepartmentCTE 
    ON DepartmentCTE.DeptId = d.parent
) 
SELECT DeptId, TreePath 
  FROM DepartmentCTE 
 ORDER BY TreePath; 
  
  
-- Multiple Self Joins Unioned 
-- Difficult to display Parent categories 
select d.id as DeptId, d.department as TreePath 
  from Departments d 
  where d.parent is null 
UNION ALL 
select da2.id as DeptId, 
       da1.department + ' -> ' + 
       da2.department as TreePath 
  from Departments da1 
  INNER JOIN Departments da2 on da1.id = da2.parent 
  where da1.parent is null 
UNION ALL 
select db3.id as DeptId, 
       db1.department + ' -> ' + 
       db2.department + ' -> ' + 
       db3.department as TreePath 
  from Departments db1 
  INNER JOIN Departments db2 on db1.id = db2.parent 
  INNER JOIN Departments db3 on db2.id = db3.parent 
  where db1.parent is null 
UNION ALL 
select dc3.id as DeptId, 
       dc1.department + ' -> ' + 
       dc2.department + ' -> ' + 
       dc3.department + ' -> ' + 
       dc4.department as TreePath 
  from Departments dc1 
  INNER JOIN Departments dc2 on dc1.id = dc2.parent 
  INNER JOIN Departments dc3 on dc2.id = dc3.parent 
  INNER JOIN Departments dc4 on dc3.id = dc4.parent 
  where dc1.parent is null 
UNION ALL 
select dd3.id as DeptId, 
       dd1.department + ' -> ' + 
       dd2.department + ' -> ' + 
       dd3.department + ' -> ' + 
       dd4.department + ' -> ' + dd5.department as TreePath 
  from Departments dd1 
  INNER JOIN Departments dd2 on dd1.id = dd2.parent 
  INNER JOIN Departments dd3 on dd2.id = dd3.parent 
  INNER JOIN Departments dd4 on dd3.id = dd4.parent 
  INNER JOIN Departments dd5 on dd4.id = dd5.parent 
  where dd1.parent is null 
   
ORDER by TreePath; 


 
 
 

 
 
 
 
 
 
 
 -- multipe CTE's for multiple derived table re-use
 SELECT q1.department, q2.department as subDepartment
  FROM (SELECT id, department, parent 
          FROM Departments
		 WHERE id = 4) as q1
INNER JOIN (SELECT id, department, parent 
              FROM Departments) as q2 
        ON q1.id = q2.parent;


WITH DeptCTETop AS
(SELECT id, department, parent 
          FROM Departments
		 WHERE id = 4)
, DeptCTELevels AS
(SELECT id, department, parent 
              FROM Departments)
SELECT q1.department, q2.department as subDepartment
  FROM DeptCTETop as q1
INNER JOIN DeptCTELevels as q2 
        ON q1.id = q2.parent;

 


;WITH Fnames (Name) AS
(SELECT 'John' 
  UNION 
 SELECT 'Mary' 
  UNION 
 SELECT 'Bill')
SELECT F.Name FirstName
  FROM Fnames F;



 
 
;WITH Fnames (Name) AS
(SELECT 'John' 
  UNION 
 SELECT 'Mary' 
  UNION 
 SELECT 'Bill'),
Lnames (Name) AS
(SELECT 'Smith' 
  UNION 
 SELECT 'Gibb' 
  UNION 
 SELECT 'Jones')
SELECT F.Name AS FirstName, L.Name AS LastName
  FROM Fnames AS F
 CROSS JOIN Lnames AS L;
 



 --Demo: Multiple CTE
;WITH Fnames (Name) AS 
(SELECT x FROM (VALUES ('John'),('Mary'),('Bill')) f(x) ),
Lnames (Name) AS
(SELECT x FROM (VALUES ('Smith'),('Gibb'),('Jones')) f(x) )
 SELECT F.Name FirstName, L.Name LastName
   FROM Fnames F
  CROSS JOIN Lnames as L;







 
 
 
 
 --Demo: Multiple CTE
;WITH Fnames (Name) AS 
(SELECT 'John' UNION SELECT 'Mary' UNION SELECT 'Bill'),
Minitials (initial) AS 
(SELECT 'A' UNION SELECT 'B' UNION SELECT 'C'),
Lnames (Name) AS
(SELECT 'Smith' UNION SELECT 'Gibb' UNION SELECT 'Jones')
 SELECT F.Name FirstName, M.initial, L.Name LastName
   FROM Fnames F
  CROSS JOIN Lnames as L
  CROSS JOIN Minitials m;
 



 --Demo: Multiple CTE  - without the union
;WITH Fnames (Name) AS 
(SELECT x FROM (VALUES ('John'),('Mary'),('Bill')) f(x) ),
Minitials (initial) AS 
(SELECT x FROM (VALUES ('A'),('B'),('C')) f(x) ),
Lnames (Name) AS
(SELECT x FROM (VALUES ('Smith'),('Gibb'),('Jones')) f(x) )
 SELECT F.Name FirstName, M.initial, L.Name LastName
   FROM Fnames F
  CROSS JOIN Lnames as L
  CROSS JOIN Minitials m;

-- sample using a row constructor  SQL 2008 and newer
SELECT x FROM (VALUES ('John'),('Mary'),('Bill')) f(x) ;





-- NESTED CTEs

with cte0 as
(	select 1 as num)
, cte1 AS (SELECT * FROM cte0)
, cte2 AS (SELECT * FROM cte1)
SELECT * 
  FROM cte2;






USE [cte_demo];

---------------------------------------------
-- Data Paging
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
  
  
  








-- another performance test
-- comparing CTE to new offset and fetch options

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










  
  
  
  
  
  
-- Recursive CTE for dates in the year
-- This one doesn't work in SQL Server 2005 because the type DATE was not available until 2008  
;WITH Dates as (
   SELECT cast('2013-01-01' as date) as CalendarDate
   UNION ALL
   SELECT dateadd(day , 1, CalendarDate) AS CalendarDate FROM Dates
   WHERE dateadd (day, 1, CalendarDate) < '2014-01-01'
)
SELECT * FROM Dates
OPTION (MAXRECURSION 366);


  
  
 -- Recursive CTE for dates in the year
 -- with extended details.
-- This one doesn't work in SQL Server 2005 because the type DATE was not availble until 2008  
 ;WITH DatesCTE as (
   SELECT cast('2011-01-01' as date) as CalendarDate
   UNION ALL
   SELECT dateadd(day , 1, CalendarDate) AS CalendarDate FROM DatesCTE
   WHERE dateadd (day, 1, CalendarDate) < '2012-01-01'
)
SELECT
   CalendarDate,
   CalendarYear=year(CalendarDate),
   CalendarQuarter=datename(quarter, CalendarDate),
   CalendarMonth=month(CalendarDate),
   CalendarWeek=datepart(wk, CalendarDate),
   CalendarDay=day(CalendarDate),
   CalendarMonthName=datename(month, CalendarDate),
   Weekday=datename(weekday, CalendarDate),
   DayOfWeek=datepart(weekday, CalendarDate)
FROM DatesCTE
OPTION (MAXRECURSION 366);












-- Replacing a numbers table with a recursive CTE
WITH NumbersCTE (N) AS 
( SELECT 1 
   UNION ALL 
  SELECT 1 + N FROM NumbersCTE
   WHERE N < 1000
) 
 SELECT N 
   FROM NumbersCTE 
 OPTION (MAXRECURSION 1000);


GO


-- Splitting up a query string with a CTE
--  http://stevestedman.com/?p=1619

CREATE FUNCTION dbo.SplitQueryString (@s varchar(8000))
RETURNS table
AS
RETURN (
 WITH splitter_cte AS (
	 SELECT CHARINDEX('&', @s) as pos, 0 as lastPos
 	  UNION ALL
	 SELECT CHARINDEX('&', @s, pos + 1), pos
	   FROM splitter_cte
	  WHERE pos > 0
 ),
 pair_cte AS (
	 SELECT chunk, CHARINDEX('=', chunk) as pos
	  FROM (SELECT SUBSTRING(@s, lastPos + 1,
	          CASE WHEN pos = 0 THEN 80000 ELSE pos - lastPos -1 END) as chunk
	          FROM splitter_cte) as t1
	 )
 SELECT substring(chunk, 0, pos) as keyName,
        substring(chunk, pos+1, 8000) as keyValue
  FROM pair_cte
)
GO
 
declare @queryString varchar(2048)
--set @queryString = 'foo=bar&temp=baz&key=value';
set @queryString = 'Key1=Value1&Key2=Value2&Key3=Value3';
--set @queryString = 'hl=en&output=search&sclient=psy-ab&q=steve+stedman&oq=steve+stedman&gs_l=hp.3..0j0i10i30j0i30l3j0i10i30j0i30j0i10i30j0i30j0i10i30.3101.4416.1.4638.13.13.0.0.0.0.136.1224.7j6.13.0.les%3Beqn%2Ccconf%3D1-2%2Cmin_length%3D2%2Crate_low%3D0-035%2Crate_high%3D0-035%2Csecond_pass%3Dfalse%2Cnum_suggestions%3D2%2Cignore_bad_origquery%3Dtrue..0.0...1c.1.vPMHlR2V5go&psj=1&bav=on.2,or.r_gc.r_pw.r_cp.r_qf.&fp=80ef5323c76d6b79&bpcl=35466521&biw=2133&bih=1061'
SELECT *
 FROM dbo.SplitQueryString(@queryString)
OPTION(MAXRECURSION 0);


GO









-- Splitting up a SQL Server connect string with a CTE
--  http://stevestedman.com/?p=1958

CREATE FUNCTION dbo.SplitConnectString(@s varchar(8000))
RETURNS table
AS
RETURN (
 WITH splitter_cte AS (
	 SELECT CHARINDEX(';', @s) as pos, 0 as lastPos
 	  UNION ALL
	 SELECT CHARINDEX(';', @s, pos + 1), pos
	   FROM splitter_cte
	  WHERE pos > 0
 ),
 pair_cte AS (
	 SELECT chunk, CHARINDEX('=', chunk) as pos
	  FROM (SELECT SUBSTRING(@s, lastPos + 1,
	          CASE WHEN pos = 0 THEN 80000 ELSE pos - lastPos -1 END) as chunk
	          FROM splitter_cte) as t1
	 )
 SELECT substring(chunk, 0, pos) as keyName,
        substring(chunk, pos+1, 8000) as keyValue
  FROM pair_cte
)

GO
declare @connectString varchar(2048)
set @connectString = 'server=myserver;user id=sa;password=asdfasdfasdasdffjfjfj';
SELECT *
 FROM dbo.SplitConnectString(@connectString)
OPTION(MAXRECURSION 0);










--looking at diffs, creating a tsql query to compare 2 strings (varchar's)


USE [cte_demo];
go

CREATE FUNCTION dbo.SplitWithLineNumber (@sep char(1), @s varchar(max))
RETURNS table
AS
RETURN (
    WITH splitter_cte AS (
      SELECT CHARINDEX(@sep, @s) as pos, cast(0 as bigint) as lastPos, 0 as LineNumber
      UNION ALL
      SELECT CHARINDEX(@sep, @s, pos + 1), cast(pos as bigint), LineNumber + 1 as LineNumber
      FROM splitter_cte
      WHERE pos > 0
    )
    SELECT LineNumber, SUBSTRING(@s, lastPos + 1, case when pos = 0 then 9223372036854775807 else pos - lastPos -1 end) as chunk
    FROM splitter_cte
  );

GO
CREATE FUNCTION dbo.varcharDiff(@s1 varchar(max), @s2 varchar(max))
RETURNS table
AS
RETURN (
	WITH FirstStringAsTable as
	(
	SELECT leftDiff.lineNumber, leftDiff.chunk AS leftChunk, rightDiff.chunk AS rightChunk
	  FROM dbo.SplitWithLineNumber(char(10), @s1) AS leftDiff
	 LEFT JOIN dbo.SplitWithLineNumber(char(10), @s2) AS rightDiff ON leftDiff.lineNumber = rightDiff.lineNumber
	)
	SELECT * 
	FROM FirstStringAsTable
	WHERE leftChunk <> rightChunk
  )
GO


DECLARE @InputString AS VARCHAR(8000);
SET @InputString = '
This is a test.
Line 2 test.
line 3 test
line 4 test.
';

DECLARE @AlteredString AS VARCHAR(8000);
SET @AlteredString = '
This is a test.
Line 2 testing.
line 3 test
line four test.
';


SELECT * 
  FROM dbo.varcharDiff(@InputString, @AlteredString)
OPTION (MAXRECURSION 366);












  
---------------------------------------------
-- Manipulating Data with a CTE
---------------------------------------------

--UPDATE 
-- Start by reloading the department table, cleaning up anything from the previous examples
EXECUTE ReloadDepartments;


--UPDATE with a single Base Table
SELECT * 
  FROM Departments;

;WITH departmentsCTE(id, department, parent) AS 
(
  SELECT id, department, parent 
    FROM Departments
)
UPDATE DepartmentsCTE
   SET department = 'Bike Locks'
 WHERE id = 11; 

SELECT * 
  FROM Departments;






-- UPDATE No Base Tables
;WITH NumbersCTE (N) AS
( SELECT 1 
   UNION ALL 
  SELECT 1 + N FROM NumbersCTE 
   WHERE N < 1000
) 
SELECT * FROM NumbersCTE
OPTION (MAXRECURSION 1000);

-- update with no base table throws an error.
;WITH NumbersCTE (N) AS
( SELECT 1 
   UNION ALL 
  SELECT 1 + N FROM NumbersCTE 
   WHERE N < 1000
) 
UPDATE NumbersCte 
   SET N = N + 1
OPTION (MAXRECURSION 1000);




--DELETE
-- Start by reloading the department table, cleaning up anything from the previous examples
EXECUTE ReloadDepartments;
GO
SELECT * 
  FROM Departments;

;WITH departmentsCTE(id, department, parent) AS 
(
  SELECT id, department, parent 
    FROM Departments
) 
DELETE FROM departmentsCTE
 WHERE parent = 1;

SELECT * 
  FROM Departments;





--INSERT
-- Start by reloading the department table, cleaning up anything from the previous examples
EXECUTE ReloadDepartments;

;WITH departmentsCTE(id, department, parent) AS 
(
  SELECT id, department, parent 
    FROM Departments
) 
INSERT INTO DepartmentsCTE 
     VALUES (99, 'xxx', 1);


SELECT * 
  FROM Departments
 ORDER BY id DESC;







EXECUTE ReloadDepartments;
Execute FillMoreDepartments; 






  
  







GO


-- Calculating the Fibonacci sequence 
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
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 --Insert Statements from a CTE, but not inside the CTE
 -- http://stevestedman.com/?p=1153
DECLARE @NumTableVar TABLE(n int);

;WITH Numbers (N) AS 
( SELECT 1 
   UNION ALL 
  SELECT 1 + N FROM Numbers 
   WHERE N < 1000
) 
INSERT INTO @NumTableVar(n)
 SELECT N 
   FROM Numbers 
 OPTION (MAXRECURSION 1001);
  
 select * from @NumTableVar;
 
 
 
 
 
 
 

--proving that the CTE is run multiple times.
-- Remember Ctrl+M to turn on Execution Plan
;WITH deptCTE(id, department, parent) AS 
(	SELECT id, department, parent
	  FROM Departments) 
SELECT q1.department, q2.department as subDepartment
  FROM deptCTE q1
 INNER JOIN deptCTE q2 on q1.id = q2.parent
 WHERE q1.parent is null; 

 
 
 
 
 
 
 
 ---CTE for Subquery Re-use  compared to a view.
;WITH deptCTE(id, department, parent) AS 
(	SELECT id, department, parent
	  FROM Departments) 
SELECT q1.department, q2.department as subDepartment
  FROM deptCTE q1
 INNER JOIN deptCTE q2 on q1.id = q2.parent
 WHERE q1.parent is null; 
 
GO
CREATE VIEW [dbo].[DeptView]
AS 
 SELECT id, department, parent
	  FROM Departments;
GO

SELECT q1.department, q2.department as subDepartment
  FROM DeptView q1
 INNER JOIN DeptView q2 on q1.id = q2.parent
 WHERE q1.parent is null; 
 
GO	  
DROP VIEW [dbo].[DeptView];
 

-- YES you can use a CTE in a view. 
GO
CREATE VIEW [dbo].[DeptCTEView]
AS 
WITH deptCTE(id, department, parent) AS 
(	SELECT id, department, parent
	  FROM Departments) 
SELECT q1.department, q2.department as subDepartment
  FROM deptCTE q1
 INNER JOIN deptCTE q2 on q1.id = q2.parent
 WHERE q1.parent is null; 

GO
SELECT * 
  FROM [dbo].[DeptCTEView];

GO
DROP VIEW [dbo].[DeptCTEView];


 

 --CTE in a function to split a string
 --http://stevestedman.com/?p=1619
USE [cte_demo];

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


