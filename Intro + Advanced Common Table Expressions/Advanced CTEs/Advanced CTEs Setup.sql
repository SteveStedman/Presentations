-- SAMPLE CODE for the SQL Saturday Presentation 
-- Created by Steve Stedman
--    http://SteveStedman.com
--    twitter:   @SqlEmt


USE [master];
SET STATISTICS IO OFF;
SET NOCOUNT ON;

IF EXISTS(SELECT name 
            FROM sys.databases 
		   WHERE name = 'cte_demo')
BEGIN
	ALTER DATABASE [cte_demo] 
	  SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [cte_demo];
END
CREATE DATABASE [cte_demo];
GO

USE [cte_demo];

CREATE TABLE [Royalty] (
	id int,  --would normally be an INT IDENTITY
    name VARCHAR (200),
	mother int,
	father int,
	);
	
insert into [Royalty] (id, name, mother, father) values (1, 'George V, King of England', null, null);
insert into [Royalty] (id, name, mother, father) values (2, 'Mary, Princess of Teck', null, null);
insert into [Royalty] (id, name, mother, father) values (3, 'George VI Windsor, King of England', 2, 1);
insert into [Royalty] (id, name, mother, father) values (4, 'Claude George Bowes-Lyon', null, null);
insert into [Royalty] (id, name, mother, father) values (5, 'Nina Cecilia Cavendish-Bentinck', null, null);
insert into [Royalty] (id, name, mother, father) values (6, 'Elizabeth Angela Marguerite Bowes-Lyon', 5, 4);
insert into [Royalty] (id, name, mother, father) values (7, 'William George I of the Hellenes', null, null);
insert into [Royalty] (id, name, mother, father) values (8, 'Olga Konstantinovna Romanova', null, null);
insert into [Royalty] (id, name, mother, father) values (9, 'Louis Alexander von Battenburg', null, null);
insert into [Royalty] (id, name, mother, father) values (10, 'Victoria von Hessen und bei Rhein', null, null);
insert into [Royalty] (id, name, mother, father) values (11, 'Andreas, Prince of Greece', 8, 7);
insert into [Royalty] (id, name, mother, father) values (12, 'Alice, Princess of Battenbugr', 10, 9);
insert into [Royalty] (id, name, mother, father) values (13, 'Phillip Mountbatten, Duke of Edinburgh', 12, 11);
insert into [Royalty] (id, name, mother, father) values (14, 'Elizabeth II Windsor, Queene of England', 6, 3);
insert into [Royalty] (id, name, mother, father) values (15, 'Charles Philip Arthur Windsor', 14, 13);
insert into [Royalty] (id, name, mother, father) values (16, 'Diana Frances (Lady) Spencer', 18, 19);
insert into [Royalty] (id, name, mother, father) values (17, 'William Arthur Phillip Windsor', 16, 15);
insert into [Royalty] (id, name, mother, father) values (18, 'Frances Ruth Burke Roche', null, null);
insert into [Royalty] (id, name, mother, father) values (19, 'Edward John Spencer', null, null);

--create a table to use for CTE query demo
CREATE TABLE [Departments] (
	id int,  --would normally be an INT IDENTITY
	department VARCHAR (200),
	parent int
	);

GO
CREATE PROCEDURE ReloadDepartments
AS 
BEGIN
	SET NOCOUNT ON;
	TRUNCATE TABLE [dbo].[Departments];	
	-- insert top level departments
	insert into [Departments] (id, department, parent) 
	     values (1, 'Camping', null);
	insert into [Departments] (id, department, parent) 
	     values (2, 'Cycle', null);
	insert into [Departments] (id, department, parent) 
	     values (3, 'Snowsports', null);
	insert into [Departments] (id, department, parent) 
	     values (4, 'Fitness', null);
      
	-- now some sub-departments for camping
	insert into [Departments] (id, department, parent) 
	     values (5, 'Tents', 1);
	insert into [Departments] (id, department, parent) 
	     values (6, 'Backpacks', 1);
	insert into [Departments] (id, department, parent) 
	     values (7, 'Sleeping Bags', 1);
	insert into [Departments] (id, department, parent) 
	     values (8, 'Cooking', 1);
       
	-- now some sub-departments for cycle
	insert into [Departments] (id, department, parent) 
	     values (9, 'Bikes', 2);
	insert into [Departments] (id, department, parent) 
	     values (10, 'Helmets', 2);
	insert into [Departments] (id, department, parent) 
	     values (11, 'Locks', 2);

	-- now some sub-departments for snowsports
	insert into [Departments] (id, department, parent) 
	     values (12, 'Ski', 3);
	insert into [Departments] (id, department, parent) 
	     values (13, 'Snowboard', 3);
	insert into [Departments] (id, department, parent) 
	     values (14, 'Snowshoe', 3);
       
	-- now some sub-departments for fitness
	insert into [Departments] (id, department, parent) 
	     values (15, 'Running', 4);
	insert into [Departments] (id, department, parent) 
	     values (16, 'Swimming', 4);
	insert into [Departments] (id, department, parent) 
	     values (17, 'Yoga', 4);
END
GO 
CREATE PROCEDURE FillMoreDepartments
AS
BEGIN
	SET NOCOUNT ON;
	delete from Departments where id > 17; 
	 --now add 2 more levels of depth
	insert into [Departments] (id, department, parent) 
	     values (18, '1 Person', 5);
	insert into [Departments] (id, department, parent) 
	     values (19, '2 Person', 5);
	insert into [Departments] (id, department, parent) 
	     values (20, '3 Person', 5);
	insert into [Departments] (id, department, parent) 
	     values (21, '4 Person', 5);

	insert into [Departments] (id, department, parent) 
	     values (22, 'Backpacking', 19);
	insert into [Departments] (id, department, parent) 
	     values (23, 'Family Camping', 19);
	insert into [Departments] (id, department, parent) 
	     values (24, 'Mountaineering', 19);

	insert into [Departments] (id, department, parent) 
	     values (25, 'Ultra-lightweight', 24);
	insert into [Departments] (id, department, parent) 
	     values (26, 'Lightweight', 24);
	insert into [Departments] (id, department, parent) 
	     values (27, 'Standard', 24);

	insert into [Departments] (id, department, parent) 
	     values (28, 'Gifts', null);
	insert into [Departments] (id, department, parent) 
	     values (29, 'Clearance', null);

END
GO

USE [cte_demo];
EXECUTE ReloadDepartments;


-- just see what is in the Departments table
-- http://stevestedman.com/?p=2856

SELECT * 
  FROM Departments;



 --THE END---------------------------------------------------


