USE FilestreamDemoDB;
GO

--3 Ways To Locate Existing FileTables

--From your database in the Object Explorer,expanding 
--     Tables, then expanding the FileTables list.




--Runing the query: SELECT * FROM sys.filetables;

SELECT * FROM sys.filetables;




--Runing the query: SELECT * FROM sys.tables WHERE is_filetable = 1;

SELECT * FROM sys.tables WHERE is_filetable = 1;
