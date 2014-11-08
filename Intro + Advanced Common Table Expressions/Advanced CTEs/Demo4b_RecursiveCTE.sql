use [cte_demo];  -- download the cte_demo database from http://stevestedman.com/?p=2839


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
GO
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




-- OPTION (MAXRECURSION 200);
 