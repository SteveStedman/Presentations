use [cte_demo];  -- download the cte_demo database from http://stevestedman.com/?p=2839
go


--For more info on recursive CTEs see http://stevestedman.com/?p=2914

--Look at all Departments
SELECT * 
  FROM Departments;



--Find the top level
SELECT * 
  FROM Departments
 WHERE parent IS NULL;



--Building the anchor query
SELECT id, Department, parent, 1 AS lvl 
  FROM Departments
 WHERE parent IS NULL;



--Turn into a CTE
;WITH DepartmentCTE AS
(
	SELECT id, Department, parent, 1 AS lvl 
	  FROM Departments
	 WHERE parent IS NULL
) 
SELECT * FROM DepartmentCTE;


-- now just those that are not top level
-- the recursive query

SELECT id, Department, parent, 2 AS lvl 
  FROM Departments AS d
 WHERE parent IS NOT NULL;


--Add all second level departments
;WITH DepartmentCTE AS
(
	SELECT id, Department, parent, 1 AS lvl 
	  FROM Departments
	 WHERE parent IS NULL

 	UNION ALL 

	SELECT id, Department, parent, 2 AS lvl 
	  FROM Departments AS d
	 WHERE parent IS NOT NULL
) 
SELECT * 
  FROM DepartmentCTE;





--Add recursion
;WITH DepartmentCTE AS
(
	SELECT id, Department, parent, 1 AS lvl 
  	  FROM Departments
	 WHERE parent IS NULL

	 UNION ALL 

	SELECT d.id, d.Department, d.parent, dCTE.lvl + 1 AS lvl 
	  FROM Departments AS d 
	 INNER JOIN DepartmentCTE AS dCTE ON d.parent = dCTE.id
) 
SELECT * 
  FROM DepartmentCTE;




-- Non CTE to get department levels
SELECT d1.department as 'Top_level',
       d2.department as 'Child_level'
  FROM Departments d1
 RIGHT JOIN Departments d2 on d1.id = d2.parent;




SELECT d2.id, 
       d2.Department, 
	   d2.Parent,
       CASE WHEN d2.Parent is NULL THEN 0 ELSE 1 END AS lvl
  FROM Departments d1
 RIGHT JOIN Departments d2 ON d1.id = d2.parent;





EXEC FillMoreDepartments;


SELECT id, Department, Parent
  FROM Departments;

