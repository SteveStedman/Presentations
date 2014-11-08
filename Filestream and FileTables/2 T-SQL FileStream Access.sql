USE FilestreamDemoDB;
GO

-- Insert data into a FILESTREAM column, then query data from that column.


INSERT INTO [dbo].[FileStreamFiles] 
            ([id], [description], [fileData])
       VALUES
	        (NEWID(), 'Test File', CAST('testdata' AS VARBINARY(MAX)));
           


SELECT * 
  FROM [dbo].[FileStreamFiles];

SELECT CAST ([fileData] AS VARCHAR(MAX)) 
  FROM [dbo].[FileStreamFiles];


-- Find the file that was created when you inserted data into the FILESTREAM column. 
--   Open the file and confirm that it has your data in it.


-- Change some data and see that the following query returns the changed results

SELECT CAST ([fileData] AS VARCHAR(MAX)) 
  FROM [dbo].[FileStreamFiles];


-- the .WRITE functionality does not work on FILESTREAM tables

UPDATE [dbo].[FileStreamFiles]
SET [fileData].WRITE(CAST('1234567890' AS VARBINARY), 20, 10);	




