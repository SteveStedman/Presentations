USE cte_demo;
GO

-- First setup perfmon with memory:Committed Byes and and Sqlserver:Memory Manager- Total Server Memory

-- Turn on Actual Execution Plan



--Multiple references to a single CTE
SET STATISTICS IO ON;

-- single CTE reference
;WITH departmentsCTE(id, department, parent) AS
(
  SELECT id, department, parent 
    FROM Departments
)
SELECT q1.department
  FROM departmentsCTE AS q1
 WHERE q1.parent IS NULL; 

-- two CTE references
;WITH departmentsCTE(id, department, parent) AS
(
  SELECT id, department, parent 
    FROM Departments
)
SELECT q1.department, q2.department AS subDepartment
  FROM departmentsCTE AS q1
 INNER JOIN departmentsCTE as q2 ON q1.id = q2.parent
 WHERE q1.parent IS NULL; 










--CTEs vs. Derived Tables

SET STATISTICS IO ON;
-- Derived Table Query
SELECT q1.department, q2.department as subDepartment
  FROM (SELECT id, department, parent 
          FROM Departments) as q1
INNER JOIN (SELECT id, department, parent 
              FROM Departments) as q2 
        ON q1.id = q2.parent
 WHERE q1.parent is null; 

 -- CTE Query
;WITH departmentsCTE(id, department, parent) AS
(
  SELECT id, department, parent 
    FROM Departments
)
SELECT q1.department, q2.department as subDepartment
  FROM departmentsCTE as q1
 INNER JOIN departmentsCTE as q2 
         ON q1.id = q2.parent
 WHERE q1.parent is null; 











--CTEs vs. Views

-- created earlier.
--CREATE VIEW DeptView AS 
-- SELECT id, department, parent
--   FROM Departments;

SET STATISTICS IO ON;
-- CTE version of the query
;WITH DeptCTE(id, department, parent) AS 
(
  SELECT id, department, parent
    FROM Departments
) 
SELECT q1.department, q2.department as subDepartment
  FROM DeptCTE q1
 INNER JOIN DeptCTE q2 on q1.id = q2.parent
 WHERE q1.parent is null; 


-- View version of the query
SELECT q1.department, q2.department as subDepartment
  FROM DeptView q1
 INNER JOIN DeptView q2 on q1.id = q2.parent
 WHERE q1.parent is null; 





--Multiple Nested CTEs in a query
-- see seperate file...











--Recursive Performance
GO
USE JProCo;
GO
execute FillMoreDepartments;

SET STATISTICS IO OFF;
SET STATISTICS TIME ON;
;WITH departmentsCTE AS
( 
  SELECT id, Department, parent, 0 as Level,
         cast(Department as varchar(8000)) as TreePath
    FROM Departments
   WHERE parent is NULL 

   UNION ALL 

  SELECT d.id, d.Department, d.Parent,
         DepartmentsCTE.Level + 1 as Level,
         cast(DepartmentsCTE.TreePath 
            + ' -> ' 
            + d.Department as varchar(8000)) as TreePath
    FROM Departments d
   INNER JOIN departmentsCTE ON DepartmentsCTE.id = d.Parent
)
SELECT id as DeptID, TreePath
  FROM departmentsCTE
 ORDER BY TreePath;









-- non CTE query
SELECT d.id as DeptId, d.Department AS TreePath 
  FROM Departments d 
  WHERE d.Parent is null 

UNION ALL 

SELECT da2.id AS DeptId, 
       da1.department + ' -> ' + 
       da2.department AS TreePath 
  FROM Departments da1 
  INNER JOIN Departments da2 ON da1.id = da2.parent 
  WHERE da1.parent is null 

UNION ALL 

SELECT db3.id AS DeptId, 
       db1.department + ' -> ' + 
       db2.department + ' -> ' + 
       db3.department AS TreePath 
  FROM Departments db1 
  INNER JOIN Departments db2 ON db1.id = db2.parent 
  INNER JOIN Departments db3 ON db2.id = db3.parent 
  WHERE db1.parent is null 

UNION ALL 

SELECT dc3.id AS DeptId, 
       dc1.department + ' -> ' + 
       dc2.department + ' -> ' + 
       dc3.department + ' -> ' + 
       dc4.department AS TreePath 
  from Departments dc1 
  INNER JOIN Departments dc2 ON dc1.id = dc2.parent 
  INNER JOIN Departments dc3 ON dc2.id = dc3.parent 
  INNER JOIN Departments dc4 ON dc3.id = dc4.parent 
  where dc1.parent is null 

UNION ALL 

SELECT dd3.id AS DeptId, 
       dd1.department + ' -> ' + 
       dd2.department + ' -> ' + 
       dd3.department + ' -> ' + 
       dd4.department + ' -> ' + dd5.department AS TreePath 
  FROM Departments dd1 
  INNER JOIN Departments dd2 ON dd1.id = dd2.parent 
  INNER JOIN Departments dd3 ON dd2.id = dd3.parent 
  INNER JOIN Departments dd4 ON dd3.id = dd4.parent 
  INNER JOIN Departments dd5 ON dd4.id = dd5.parent 
  WHERE dd1.parent is null 
ORDER by TreePath;





DELETE FROM Departments WHERE ID > 29; 
	 --now add 2 more levels of depth
INSERT INTO Departments (id, department, parent) values (30, 'Integrated Fly', 25);
INSERT INTO Departments (id, department, parent) values (31, 'Replacable Tent Poles', 30);
	
SELECT * FROM Departments;













--Deep Recursion

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

;WITH Numbers (N) AS
( SELECT 0
   UNION ALL 
  SELECT 1 + N FROM Numbers 
   WHERE N < 100
) 
SELECT N 
  FROM Numbers ;





;WITH Numbers (N) AS
( SELECT 0
   UNION ALL 
  SELECT 1 + N FROM Numbers 
   WHERE N < 1000
) 
SELECT N 
  FROM Numbers 
OPTION (MAXRECURSION 1001);



-- try 10,000
-- try 100,000
-- try 1,000,000


-- more than half an hour
;WITH Numbers (N) AS
( SELECT 0
   UNION ALL 
  SELECT 1 + N FROM Numbers 
   WHERE N < 100000000
) 
SELECT N 
  FROM Numbers 
 WHERE n > 100000000 - 10
OPTION (MAXRECURSION 0);
