USE [Master];

IF EXISTS(SELECT name FROM sys.databases WHERE name = 'analytics_demo')
BEGIN
	ALTER DATABASE [analytics_demo] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [analytics_demo];
END
GO
CREATE DATABASE [analytics_demo];
GO

USE [analytics_demo];




-- same Revenue Table used in previous examples of the OVER clause
-- http://stevestedman.com/?p=1454

CREATE TABLE REVENUE
(
[DepartmentID] int,
[Revenue] int,
[Year] int
);
 
insert into REVENUE
values (1,20000,1999),(2,60000,1999),(3,49000,1999),
 (1,40000,2000),(2,40000,2000),(3,60000,2000),
 (1,30000,2001),(2,30000,2001),(3,700,2001),
 (1,90000,2002),(2,20000,2002),(3,80000,2002),
 (1,10300,2003),(2,1000,2003), (3,900,2003),
 (1,10000,2004),(2,10000,2004),(3,10000,2004),
 (1,20000,2005),(2,20000,2005),(3,20000,2005),
 (1,40000,2006),(2,30000,2006),(3,300,2006),
 (1,70000,2007),(2,40000,2007),(3,40000,2007),
 (1,50000,2008),(2,50000,2008),(3,42000,2008),
 (1,20000,2009),(2,60000,2009),(3,600,2009),
 (1,30000,2010),(2,70000,2010),(3,700,2010),
 (1,80000,2011),(2,80000,2011),(3,800,2011),
 (1,10000,2012),(2,90000,2012),(3,900,2012);



 --just double check the table to see what's there for DepartmentID of 1
 select DepartmentID, Revenue, Year 
   from REVENUE
  where DepartmentID = 1;

-- Using LAG
-- http://stevestedman.com/?p=1513

select DepartmentID, Revenue, Year, 
       LAG(Revenue) OVER (ORDER BY Year) as LastYearRevenue
  from REVENUE
 where DepartmentID = 1
 order by Year;


-- Using LEAD
-- http://stevestedman.com/?p=1513

select DepartmentID, Revenue, Year, 
       LAG(Revenue) OVER (ORDER BY Year) as LastYearRevenue,
       LEAD(Revenue) OVER (ORDER BY Year) as NextYearRevenue
  from REVENUE
 where DepartmentID = 1
  order by Year;



--So how do we calculate the difference between last year's 
-- numbers and this years numbers 
-- http://stevestedman.com/?p=1513

select DepartmentID, Revenue, Year, 
       LAG(Revenue) OVER (ORDER BY Year) as LastYearRevenue,
       Revenue - LAG(Revenue) OVER (ORDER BY Year) as YearOverYearDelta
  from REVENUE
 where DepartmentID = 1
 order by Year;
 

 -- now to try out PERCENT_RANK() with a comparison to RANK()
 -- http://stevestedman.com/?p=1525
 select DepartmentID, Revenue, Year, 
        RANK() OVER(ORDER BY Revenue) as RankYear,
	    PERCENT_RANK() OVER(ORDER BY Revenue) as PercentRank
   from REVENUE
  where DepartmentID = 1;
 







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
USE [analytics_demo];
GO
CREATE TABLE DiceRolls
(
	[FirstDie] int,
	[SecondDie] int
);

GO 
delete from DiceRolls;
set nocount on;
DECLARE @maxRandomValue int = 6;
DECLARE @minRandomValue int = 1;
 
insert into DiceRolls 
values(Cast(((@maxRandomValue + 1) - @minRandomValue) * Rand() + @minRandomValue As int) ,
      Cast(((@maxRandomValue + 1) - @minRandomValue) * Rand() + @minRandomValue As int));
GO 1000
set nocount off;


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
delete from DiceRolls;
GO
set nocount on;
DECLARE @maxRandomValue int = 6;
DECLARE @minRandomValue int = 1;
 
insert into DiceRolls 
values(Cast(((@maxRandomValue + 1) - @minRandomValue) * Rand() + @minRandomValue As int) ,
      Cast(((@maxRandomValue + 1) - @minRandomValue) * Rand() + @minRandomValue As int));
GO 1000000
set nocount off;

SELECT CD.TotalRoll, 
       round((CD.CumulativeDist - isnull(LAG(CD.CumulativeDist) OVER(ORDER BY TotalRoll), 0)) * 100, 1) as OddsOfThisRoll
from ( SELECT distinct TotalRoll,
			   CUME_DIST() OVER (ORDER BY TotalRoll) as CumulativeDist
		FROM (SELECT FirstDie + SecondDie as TotalRoll FROM DiceRolls) as t) CD
order by TotalRoll;