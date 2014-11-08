use JProCo;
GO

-- Finding Holes

--Take a look at the SalesInvoice table
SELECT TOP 10 *
  FROM SalesInvoice;






-- not lets look at the hour of day that orders have been placed

SELECT datepart(HOUR, OrderDate) as HourOfDay,
       COUNT(1) as numOrders
  FROM SalesInvoice
 GROUP BY datepart(HOUR, OrderDate)
 ORDER BY numOrders ASC;


-- smaller set of data
SELECT datepart(HOUR, OrderDate) as HourOfDay,
       COUNT(1) as numOrders
  FROM SalesInvoice
 WHERE OrderDate < '02/01/2006'
 GROUP BY datepart(HOUR, OrderDate)
 ORDER BY numOrders ASC;





-- the numbers table alternative
;WITH Numbers (N) AS
(
  SELECT 0
   UNION ALL 
  SELECT 1 + N FROM Numbers 
   WHERE N < 23
) 
SELECT N 
  FROM Numbers ;

-- why do we use N < 23 instead of N < 24 for 24 hours in the day?





-- Multiple CTEs to find the hours of the day MISSING
;WITH Numbers (N) AS
(
  SELECT 0
   UNION ALL 
  SELECT 1 + N FROM Numbers 
   WHERE N < 23
)
, 
OrderHours (HourOfDay, TheCount) AS
(
  SELECT DATEPART(HOUR, OrderDate) as HourOfDay,
         COUNT(1) AS TheCount
    FROM SalesInvoice
   WHERE OrderDate < '02/01/2006'
   GROUP BY DATEPART(HOUR, OrderDate)
)

SELECT n.N AS HourOfDay, ISNULL(oh.TheCount, 0) OrderCount
  FROM Numbers n
  LEFT JOIN OrderHours oh ON n.N = oh.HourOfDay
 ORDER BY TheCount ASC;



