use [cte_demo];  -- download the cte_demo database from http://stevestedman.com/?p=2839
GO
-- multiple recursive queries



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
