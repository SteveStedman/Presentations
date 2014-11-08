

-- Insert some files into your FileTable using the Explore FileTable Directory option.
--  Verify that files you add with the file system show up in your FileTable when 
--   viewing with T-SQL.
USE FilestreamDemoDB;
GO

SELECT FileTableRootPath();

SELECT FileTableRootPath('dbo.PictureFiles');


SELECT * 
  FROM PictureFiles;


-- Use an UPDATE statement to change the name of a file in your FileTable. 
--   Confirm that it has been changed in the file system.
USE FilestreamDemoDB;
GO

UPDATE PictureFiles
 SET name = 'FirstChicken.JPG'
 WHERE name = 'chicken1.JPG';



-- Delete a file from your FileTable with T-SQL and confirm that it is gone 
--    from the filesystem.
USE FilestreamDemoDB;
GO

DELETE FROM PictureFiles 
WHERE name = 'chicken3.jpg';


