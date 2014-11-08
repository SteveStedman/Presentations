use JProCo;
GO

-- Scrubbing Duplicates


--Look at Customer Table
SELECT *
  FROM Customer;





--Find duplicate names
SELECT LastName, FirstName, COUNT(*) AS NumDups
  FROM Customer
 GROUP BY LastName, FirstName
 ORDER BY NumDups DESC;






--2nd Window: Look at Customer Table. We will keep CustID 9 as the lowest duplicateID
SELECT *
  FROM Customer
 WHERE LastName = 'Adams' 
   AND FirstName = 'Linda';





--GOAL: Keep record with the lowest ID
--Find Dupicates and thier order number

SELECT *, ROW_NUMBER() OVER(PARTITION BY LastName, FirstName ORDER BY CustomerID) AS DupNum 
FROM Customer
ORDER BY LastName, FirstName;





--ERROR: We want to see numbers that are not the lowest (Does not work)

SELECT *, ROW_NUMBER() OVER(PARTITION BY LastName, FirstName ORDER BY CustomerID) AS DupNum 
FROM Customer
WHERE DupNum > 1
ORDER BY LastName, FirstName;


-- what about a derived table query

SELECT * 
  FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY LastName, FirstName ORDER BY CustomerID) AS DupNum 
          FROM Customer
	   ) AS t
WHERE DupNum > 1
ORDER BY LastName, FirstName;


-- No try DELETE using a derived table
DELETE FROM (
             SELECT *, ROW_NUMBER() OVER(PARTITION BY LastName, FirstName ORDER BY CustomerID) AS DupNum 
               FROM Customer
	        ) AS t
WHERE DupNum > 1;






--Put in a CTE
WITH CustomerCTE AS
(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY LastName, FirstName ORDER BY CustomerID) AS DupNum 
	  FROM Customer
)
SELECT * 
FROM CustomerCTE
WHERE DupNum > 1;





--Change SELECT * to DELETE
WITH CustomerCTE AS
(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY LastName, FirstName ORDER BY CustomerID) AS DupNum 
	  FROM Customer
)
DELETE 
  FROM CustomerCTE
 WHERE DupNum > 1;
