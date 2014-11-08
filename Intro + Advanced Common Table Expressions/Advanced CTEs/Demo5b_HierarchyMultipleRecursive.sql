use [cte_demo];  -- download the cte_demo database from http://stevestedman.com/?p=2839
--For more info on recursive CTE formatting see http://stevestedman.com/?p=1130
GO

-- hierarchy multiple recursive



-- The RoyalTreeCTE from the previous chapter was an interesting example of multiple 
--   recursive queries in the CTE, but it didn’t have a great visual representation of the data.
-- First we could apply the tree path method of formatting with the following query, 
--   which limits the results to only 3 levels of the hierarchy:
;WITH RoyalTreeCTE AS
(
   SELECT *, 0 AS lvl,
          CAST(name AS VARCHAR(4096)) AS TreePath
     FROM Royalty WHERE id = 17  -- 17 is Prince William

    UNION ALL

   SELECT r.*, lvl + 1 AS lvl,
          CAST(rt.TreePath + '-->father:' +
               r.name AS VARCHAR(4096)) AS TreePath
     FROM Royalty r
    INNER JOIN RoyalTreeCTE rt ON rt.father = r.id

    UNION ALL

   SELECT r.*, lvl + 1 AS lvl,
          CAST(rt.TreePath + '-->mother:' +
               r.name AS VARCHAR(4096)) AS TreePath
     FROM Royalty r
    INNER JOIN RoyalTreeCTE rt ON rt.mother = r.id
)
SELECT TreePath
  FROM RoyalTreeCTE
 WHERE lvl < 3
 ORDER BY TreePath;








-- try this
SELECT REPLICATE('.      ', Level) + 
       Relationship + ': ' + name
-- and add a relationship column





;WITH RoyalTreeCTE AS
(
   SELECT *, 0 AS lvl,
          CAST(name AS VARCHAR(4096)) AS TreePath,
		  CAST('Top' AS VARCHAR(10)) AS Relationship
     FROM Royalty WHERE id = 17  -- 17 is Prince William
UNION ALL
   SELECT r.*, lvl + 1 AS lvl,
          CAST(rt.TreePath + '-->father:' +
               r.name AS VARCHAR(4096)) AS TreePath,
		  CAST('Father' AS VARCHAR(10)) AS Relationship
     FROM Royalty r
    INNER JOIN RoyalTreeCTE rt ON rt.father = r.id
UNION ALL
   SELECT r.*, lvl + 1 AS lvl,
          CAST(rt.TreePath + '-->mother:' +
               r.name AS VARCHAR(4096)) AS TreePath,
		  CAST('Mother' AS VARCHAR(10)) AS Relationship
     FROM Royalty r
    INNER JOIN RoyalTreeCTE rt ON rt.mother = r.id
)
SELECT REPLICATE('.      ', lvl) + 
       Relationship + ': ' + name
  FROM RoyalTreeCTE
 ORDER BY TreePath;






-- In order to improve the format we simply need to improve the formatting. We 
--  have all the right people, just not in the right order. 
-- step 1: add the Sorter column
;WITH RoyalTreeCTE AS
(
   SELECT *, 0 AS lvl,
          CAST('b' AS VARCHAR(4096)) AS Sorter,
          CAST('Top' AS VARCHAR(10)) AS Relationship
     FROM Royalty WHERE id = 17
UNION ALL
   SELECT r.*, lvl + 1 AS lvl,
          CAST(Sorter + 'a' AS VARCHAR(4096)) AS Sorter,
          CAST('Father' AS VARCHAR(10)) AS Relationship
     FROM Royalty r
    INNER JOIN RoyalTreeCTE rt ON rt.father = r.id
UNION ALL
   SELECT r.*, lvl + 1 as lvl,
          cast(Sorter + 'c' AS VARCHAR(4096)) AS Sorter,
          cast('Mother' AS VARCHAR(10)) AS Relationship
     FROM Royalty r
    INNER JOIN RoyalTreeCTE rt ON rt.mother = r.id
)
SELECT sorter, name
  FROM RoyalTreeCTE
 ORDER BY Sorter + 'bbbbbbbbbbbbb';







--next add the indentation
--  SELECT REPLICATE('.           ', Level) + 
--     Relationship + ': ' + name

;WITH RoyalTreeCTE AS
(
   SELECT *, 0 AS lvl,
          CAST('b' AS VARCHAR(4096)) AS Sorter,
          CAST('Top' AS VARCHAR(10)) AS Relationship
     FROM Royalty WHERE id = 17
UNION ALL
   SELECT r.*, lvl + 1 AS lvl,
          CAST(Sorter + 'a' AS VARCHAR(4096)) AS Sorter,
          CAST('Father' AS VARCHAR(10)) AS Relationship
     FROM Royalty r
    INNER JOIN RoyalTreeCTE rt ON rt.father = r.id
UNION ALL
   SELECT r.*, lvl + 1 as lvl,
          cast(Sorter + 'c' AS VARCHAR(4096)) AS Sorter,
          cast('Mother' AS VARCHAR(10)) AS Relationship
     FROM Royalty r
    INNER JOIN RoyalTreeCTE rt ON rt.mother = r.id
)
SELECT REPLICATE('.           ', lvl) + 
       Relationship + ': ' + name
  FROM RoyalTreeCTE
 ORDER BY Sorter + 'bbbbbbbbbbbbb';
