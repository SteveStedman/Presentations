use [cte_demo];  -- download the cte_demo database from http://stevestedman.com/?p=2839
GO

-- The old way of doing it.
CREATE TABLE Numbers
(
	Number INTEGER Identity
);
GO

SET NOCOUNT ON;
INSERT INTO Numbers DEFAULT VALUES;
GO 1000


SELECT * FROM NUMBERS;
GO

DROP TABLE Numbers;




-- Numbers as a CTE

;WITH Numbers (N) AS 
(
  SELECT 1 
   UNION ALL 
  SELECT 1 + N FROM Numbers 
   WHERE N < 1000
)
SELECT * 
  FROM Numbers
OPTION (MAXRECURSION 1000);



