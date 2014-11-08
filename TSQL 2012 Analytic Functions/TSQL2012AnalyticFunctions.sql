-- SAMPLE CODE for the TSQL 2012 presentation
-- Created by Steve Stedman
--    http://SteveStedman.com
--    twitter:   @SqlEmt

RAISERROR ('Dont run the whole script, just run sections at a time', 20, 1)  WITH LOG


USE [Master];
set statistics io off;

IF EXISTS(SELECT name FROM sys.databases WHERE name = 'tsql2012')
BEGIN
    ALTER DATABASE [tsql2012] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [tsql2012];
END;

USE [Master];
CREATE DATABASE [tsql2012];
GO

USE [tsql2012];




-- Table to be used by Over Clause Rows/Range
CREATE TABLE REVENUE
(
[DepartmentID] int,
[Revenue] int,
[Year] int
);

insert into REVENUE
values (1,10030,1998),(2,20000,1998),(3,40000,1998),
       (1,20000,1999),(2,60000,1999),(3,50000,1999),
       (1,40000,2000),(2,40000,2000),(3,60000,2000),
       (1,30000,2001),(2,30000,2001),(3,70000,2001),
       (1,90000,2002),(2,20000,2002),(3,80000,2002),
       (1,10300,2003),(2,1000,2003), (3,90000,2003),
       (1,10000,2004),(2,10000,2004),(3,10000,2004),
       (1,20000,2005),(2,20000,2005),(3,20000,2005),
       (1,40000,2006),(2,30000,2006),(3,30000,2006),
       (1,70000,2007),(2,40000,2007),(3,40000,2007),
       (1,50000,2008),(2,50000,2008),(3,50000,2008),
       (1,20000,2009),(2,60000,2009),(3,60000,2009),
       (1,30000,2010),(2,70000,2010),(3,70000,2010),
       (1,80000,2011),(2,80000,2011),(3,80000,2011),
       (1,10000,2012),(2,90000,2012),(3,90000,2012);



-- first lets look at the REVENUE table

SELECT * 
  FROM Revenue;


--First OVER Clause pre SQL 2012
-- http://stevestedman.com/?p=1454
SELECT *,
	   avg(Revenue) OVER (PARTITION by DepartmentID) as AverageRevenue,
	   sum(Revenue) OVER (PARTITION by DepartmentID) as TotalRevenue
FROM REVENUE
ORDER BY departmentID, year;







--ROWS PRECEDING
-- http://stevestedman.com/?p=1454
--  look at the sum of revenue over a trailing 3 year period
SELECT Year, DepartmentID, Revenue,
	   sum(Revenue) OVER (PARTITION by DepartmentID 
						  ORDER BY [YEAR] 
						  ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) as Prev3
FROM REVENUE
ORDER BY departmentID, year;


--ROWS PRECEDING
SELECT Year, DepartmentID, Revenue,
	   sum(Revenue) OVER (PARTITION by DepartmentID 
						  ORDER BY [YEAR] 
						  ROWS BETWEEN 5 PRECEDING AND 2 PRECEDING) as Prev5to3
FROM REVENUE
ORDER BY departmentID, year;




-- ROWS FOLLOWING
-- http://stevestedman.com/?p=1454
SELECT Year, DepartmentID, Revenue,
	   sum(Revenue) OVER (PARTITION by DepartmentID 
						  ORDER BY [YEAR] 
						  ROWS BETWEEN CURRENT ROW AND 3 FOLLOWING) as Next3
FROM REVENUE
ORDER BY departmentID, year;



--ROWS PRECEDING
SELECT Year, DepartmentID, Revenue,
	   sum(Revenue) OVER (PARTITION by DepartmentID 
						  ORDER BY [YEAR] 
						  ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) as BeforeAndAfter
FROM REVENUE
ORDER BY departmentID, year;








-- ROWS UNBOUNDED PRECEDING
-- http://stevestedman.com/?p=1485
SELECT Year, DepartmentID, Revenue,
	   min(Revenue) OVER (PARTITION by DepartmentID 
						  ORDER BY [YEAR] 
						  ROWS UNBOUNDED PRECEDING) as MinRevenueToDate
FROM REVENUE
ORDER BY departmentID, year;


-- ROWS UNBOUNDED PRECEDING
-- http://stevestedman.com/?p=1485
SELECT Year, DepartmentID, Revenue,
	   min(Revenue) OVER (PARTITION by DepartmentID 
						  ORDER BY [YEAR] 
						  ROWS UNBOUNDED PRECEDING) as MinRevenueToDate,
	   sum(Revenue) OVER (PARTITION by DepartmentID 
						  ORDER BY [YEAR] 
						  ROWS UNBOUNDED PRECEDING) as TotalRevenueToDate
FROM REVENUE
ORDER BY departmentID, year;



-- ROWS UNBOUNDED FOLLOWING
-- http://stevestedman.com/?p=1485
SELECT Year, DepartmentID, Revenue,
	   min(Revenue) OVER (PARTITION by DepartmentID 
						  ORDER BY [YEAR] 
						  ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) as MinRevenueBeyond
FROM REVENUE
ORDER BY departmentID, year;














-- RANGE UNBOUNDED PRECEDING
SELECT Year, DepartmentID, Revenue,
	   sum(Revenue) OVER (PARTITION by DepartmentID 
						  ORDER BY [YEAR] 
						  ROWS UNBOUNDED PRECEDING) as RowsCumulative,
	   sum(Revenue) OVER (PARTITION by DepartmentID 
						  ORDER BY [YEAR] 
						  RANGE UNBOUNDED PRECEDING) as RangeCumulative
FROM REVENUE
WHERE year between 2003 and 2008
ORDER BY departmentID, year;



-- INSERT A DUPLICATE VALUE FOR RANGE UNBOUNDED PRECEEDING
insert into REVENUE
values (1,10000,2005),(2,20000,2005),(3,30000,2005);

-- same query as above
SELECT Year, DepartmentID, Revenue,
	   sum(Revenue) OVER (PARTITION by DepartmentID 
						  ORDER BY [YEAR] 
						  ROWS UNBOUNDED PRECEDING) as RowsCumulative,
	   sum(Revenue) OVER (PARTITION by DepartmentID 
						  ORDER BY [YEAR] 
						  RANGE UNBOUNDED PRECEDING) as RangeCumulative
FROM REVENUE
WHERE year between 2003 and 2008
ORDER BY departmentID, year;







-----------------------------------------------------------
--   FIRST_VALUE and LAST_VALUE
-----------------------------------------------------------

select DepartmentID, Revenue, Year, 
        FIRST_VALUE(YEAR) OVER(PARTITION BY DepartmentID ORDER BY YEAR) as FirstYear,
		LAST_VALUE(YEAR) OVER(PARTITION BY DepartmentID ORDER BY YEAR) as FinalYearSoFar
   from REVENUE
order by DepartmentID;
-- Problem.... LAST_VALUE only returns the last value encountered so far in the set
-- solution:  use ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
select DepartmentID, Revenue, Year, 
        FIRST_VALUE(YEAR) OVER(PARTITION BY DepartmentID ORDER BY YEAR
							   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as FirstYear,
		LAST_VALUE(YEAR) OVER(PARTITION BY DepartmentID ORDER BY YEAR
		                      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as FinalYear
   from REVENUE
order by DepartmentID;
 








-----------------------------------------------------------
--   PERCENT_RANK
-----------------------------------------------------------
 -- now to try out PERCENT_RANK() with a comparison to RANK()
 -- http://stevestedman.com/?p=1525
 select DepartmentID, Revenue, Year, 
        RANK() OVER(ORDER BY Revenue) as RankYear,
	    PERCENT_RANK() OVER(ORDER BY Revenue) as PercentRank
   from REVENUE
  where DepartmentID = 1;
 






-----------------------------------------------------------
--   PERCENTILE    - CONT and DISC
-----------------------------------------------------------

 -- now on to PERCENTILE_CONT to calculate the 90th percentile
 -- http://stevestedman.com/?p=1533
 select DepartmentID, Revenue, Year, 
        PERCENTILE_CONT(.9) 
			WITHIN GROUP(ORDER BY Revenue)  
			OVER(PARTITION BY DepartmentID) as Percentile90
   from REVENUE
order by DepartmentID;
 

-- now on to PERCENTILE_DISC to calculate the 90th percentile
 -- http://stevestedman.com/?p=1533
  select DepartmentID, Revenue, Year, 
         PERCENTILE_DISC(.9) 
			WITHIN GROUP(ORDER BY Revenue)  
			OVER(PARTITION BY DepartmentID) as Percentile90
    from REVENUE
order by DepartmentID;
 

 -- calculating the median with PERCENTILE_DISC and PERCENTILE_CONT
 -- http://stevestedman.com/?p=1533
  select DepartmentID, Revenue, Year, 
         PERCENTILE_DISC(.5) 
			WITHIN GROUP(ORDER BY Revenue)  
			OVER(PARTITION BY DepartmentID) as MedianDisc,
         PERCENTILE_CONT(.5) 
			WITHIN GROUP(ORDER BY Revenue)  
			OVER(PARTITION BY DepartmentID) as MedianCont
    from REVENUE
order by DepartmentID;
 











-----------------------------------------------------------
--   Cumulative Distribution
-----------------------------------------------------------


-- CUME_DIST
-- http://stevestedman.com/?p=1545
select DepartmentID, Revenue, Year, 
       CUME_DIST() OVER (ORDER BY Year) as CumulativeDistributionYear
  from REVENUE
 where DepartmentID = 1
 order by Year;


-- CUME_DIST
-- http://stevestedman.com/?p=1545
select DepartmentID, Revenue, Year, 
       CUME_DIST() OVER (ORDER BY Revenue) as CumulativeDistributionRev
  from REVENUE
 where DepartmentID = 1
 order by Revenue;


-- CUME_DIST
-- http://stevestedman.com/?p=1545
select DepartmentID, Revenue, Year, 
       CUME_DIST() OVER (ORDER BY Revenue) as CumulativeDistributionRev,
       ROUND(CUME_DIST() OVER (ORDER BY Revenue) * 100, 1)  as PercentLessThanOrEqual
  from REVENUE
 where DepartmentID = 1
 order by Revenue;























 
-- Using CUME_DIST to test a random function
-- determining if our random number has an even distribution
GO
CREATE TABLE RandomNumbers
(
	[RNum] int
);
GO
DELETE FROM RandomNumbers;
GO
DECLARE @maxRandomValue int = 100;
DECLARE @minRandomValue int = 1;

INSERT INTO RandomNumbers VALUES(Cast(((@maxRandomValue + 1) - @minRandomValue) * Rand() + @minRandomValue As int));
GO 10000

SELECT DISTINCT RNum, 
	   CUME_DIST() OVER (ORDER BY RNum)  * 100 as CumulativeDistribution
  FROM RandomNumbers
 ORDER BY RNum;


SELECT RNum, CumulativeDistribution,  CumulativeDistribution - LAG(CumulativeDistribution) OVER (ORDER BY RNum) as LastCDist
FROM (
SELECT DISTINCT RNum, 
       CUME_DIST() OVER (ORDER BY RNum)  * 100 as CumulativeDistribution
  FROM RandomNumbers ) as t

 











GO
CREATE TABLE DiceRolls
(
	[FirstDie] int,
	[SecondDie] int
);

GO 
delete from DiceRolls;
GO
set nocount on;
DECLARE @maxRandomValue int = 6;
DECLARE @minRandomValue int = 1;
 
insert into DiceRolls 
values(Cast(((@maxRandomValue + 1) - @minRandomValue) * Rand() + @minRandomValue As int) ,
      Cast(((@maxRandomValue + 1) - @minRandomValue) * Rand() + @minRandomValue As int));
GO 1000
set nocount off;




--lets see whats in the table.
SELECT * from DiceRolls;

SELECT FirstDie + SecondDie as TotalRoll FROM DiceRolls;


SELECT distinct TotalRoll,
       CUME_DIST() OVER (ORDER BY TotalRoll) as CumulativeDist
FROM (SELECT FirstDie + SecondDie as TotalRoll FROM DiceRolls) as t
order by TotalRoll;


SELECT CD.TotalRoll, 
       round((CD.CumulativeDist - isnull(LAG(CD.CumulativeDist) OVER(ORDER BY TotalRoll), 0)) * 100, 1) as OddsOfThisRoll
from ( SELECT distinct TotalRoll,
			   CUME_DIST() OVER (ORDER BY TotalRoll) as CumulativeDist
		FROM (SELECT FirstDie + SecondDie as TotalRoll FROM DiceRolls) as t) CD
order by TotalRoll;








-- to 10,000 rolls
delete from DiceRolls;
GO
set nocount on;
DECLARE @maxRandomValue int = 6;
DECLARE @minRandomValue int = 1;
 
insert into DiceRolls 
values(Cast(((@maxRandomValue + 1) - @minRandomValue) * Rand() + @minRandomValue As int) ,
      Cast(((@maxRandomValue + 1) - @minRandomValue) * Rand() + @minRandomValue As int));
GO 10000
set nocount off;

SELECT CD.TotalRoll, 
       round((CD.CumulativeDist - isnull(LAG(CD.CumulativeDist) OVER(ORDER BY TotalRoll), 0)) * 100, 1) as OddsOfThisRoll
from ( SELECT distinct TotalRoll,
			   CUME_DIST() OVER (ORDER BY TotalRoll) as CumulativeDist
		FROM (SELECT FirstDie + SecondDie as TotalRoll FROM DiceRolls) as t) CD
order by TotalRoll;








-- to 1,000,000 rolls
-- This takes too long to run during the demo.

--delete from DiceRolls;
--GO
--set nocount on;
--DECLARE @maxRandomValue int = 6;
--DECLARE @minRandomValue int = 1;
 
--insert into DiceRolls 
--values(Cast(((@maxRandomValue + 1) - @minRandomValue) * Rand() + @minRandomValue As int) ,
--      Cast(((@maxRandomValue + 1) - @minRandomValue) * Rand() + @minRandomValue As int));
--GO 1000000
--set nocount off;

--SELECT CD.TotalRoll, 
--       round((CD.CumulativeDist - isnull(LAG(CD.CumulativeDist) OVER(ORDER BY TotalRoll), 0)) * 100, 1) as OddsOfThisRoll
--from ( SELECT distinct TotalRoll,
--			   CUME_DIST() OVER (ORDER BY TotalRoll) as CumulativeDist
--		FROM (SELECT FirstDie + SecondDie as TotalRoll FROM DiceRolls) as t) CD
--order by TotalRoll;

