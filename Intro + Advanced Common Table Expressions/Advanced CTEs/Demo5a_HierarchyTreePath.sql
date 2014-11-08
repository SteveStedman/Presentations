use [cte_demo];  -- download the cte_demo database from http://stevestedman.com/?p=2839
--For more info on recursive CTE formatting see http://stevestedman.com/?p=1130
GO
-- hierarchy


--To implement this let’s start with the original departmentsCTE query from the last session as seen in the following code:
;WITH DepartmentCTE AS
(
	SELECT id, Department, parent, 1 AS lvl 
  	  FROM Departments
	 WHERE parent IS NULL

	 UNION ALL 

	SELECT d.id, d.Department, d.parent, dCTE.lvl + 1 AS lvl 
	  FROM Departments AS d 
	 INNER JOIN DepartmentCTE AS dCTE ON d.parent = dCTE.id
	 WHERE d.parent IS NOT NULL
) 
SELECT * 
  FROM DepartmentCTE;


EXEC dbo.FillMoreDepartments;

-- For the anchor query the full path (TreePath) is just the current department so 
--   we add a new column into the anchor query:

cast(Department as varchar(8000)) as TreePath

--For the recursive query we add a reference to the existing TreePath, followed by 
--   a separator and then the current department.

cast(dCTE.TreePath 
   + ' -> ' 
   + d.Department as varchar(8000)) as TreePath





;WITH DepartmentCTE AS
(
	SELECT id, Department, parent, 1 AS lvl,
           cast(Department as varchar(8000)) as TreePath 
  	  FROM Departments
	 WHERE parent IS NULL

	 UNION ALL 

	SELECT d.id, d.Department, d.parent, dCTE.lvl + 1 AS lvl,
		   cast(dCTE.TreePath 
                + ' -> ' 
                + d.Department AS varchar(8000)) as TreePath
	  FROM Departments AS d 
	 INNER JOIN DepartmentCTE AS dCTE ON d.parent = dCTE.id
	 WHERE d.parent IS NOT NULL
) 
SELECT * 
  FROM DepartmentCTE
 ORDER BY parent;








-- To improve even further on the query we can just show the TreePath column 
--   and order it by TreePath for a better visual representation.
;WITH DepartmentCTE AS
(
	SELECT id, Department, parent, 1 AS lvl,
           cast(Department as varchar(8000)) as TreePath 
  	  FROM Departments
	 WHERE parent IS NULL

	 UNION ALL 

	SELECT d.id, d.Department, d.parent, dCTE.lvl + 1 AS lvl,
		   cast(dCTE.TreePath 
                + ' -> ' 
                + d.Department AS varchar(8000)) as TreePath
	  FROM Departments AS d 
	 INNER JOIN DepartmentCTE AS dCTE ON d.parent = dCTE.id
	 WHERE d.parent IS NOT NULL
) 
SELECT TreePath
  FROM DepartmentCTE
 ORDER BY TreePath;

-- how about a path like a filesystem path
-- Replace this: + ' -> ' 
---With this: + '\' 




-- the TSQL REPLICATE function
SELECT REPLICATE('abc.', 3)


--only change is the final SELECT statement
;WITH DepartmentCTE AS
(
	SELECT id, Department, parent, 1 AS lvl,
           cast(Department as varchar(8000)) as TreePath 
  	  FROM Departments
	 WHERE parent IS NULL

	 UNION ALL 

	SELECT d.id, d.Department, d.parent, dCTE.lvl + 1 AS lvl,
		   cast(dCTE.TreePath 
                + ' -> ' 
                + d.Department AS varchar(8000)) as TreePath
	  FROM Departments AS d 
	 INNER JOIN DepartmentCTE AS dCTE ON d.parent = dCTE.id
	 WHERE d.parent IS NOT NULL
) 
SELECT REPLICATE('    ', lvl)
     + Department as Department
  FROM DepartmentCTE
 ORDER BY TreePath;



--In the previous example it is necessary to include the ORDER BY 
--   TreePath to get all the departments to show up in the right 
--   order with sub-departments being shown under their parents. 



-- try this one
SELECT REPLICATE('.  ', Level) 
     + Department as Department

-- or this
SELECT REPLICATE('   ', Level) + '+'
     + Department as Department


