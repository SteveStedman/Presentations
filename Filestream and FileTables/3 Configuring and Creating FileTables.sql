USE master;
GO
-- Rebuild the demo database
IF EXISTS(SELECT name FROM sys.databases WHERE name = 'FilestreamDemoDB')
BEGIN
  ALTER DATABASE [FilestreamDemoDB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [FilestreamDemoDB];
END
CREATE DATABASE [FilestreamDemoDB];
GO

USE [FilestreamDemoDB];


-- check that FILESTREAM is enabled for the instance
USE FilestreamDemoDB;
GO
EXEC sp_configure filestream_access_level;

EXEC sp_configure filestream_access_level, 2;
RECONFIGURE;

-- setup filestream for the Database
USE master;
GO


ALTER DATABASE FilestreamDemoDB
ADD FILEGROUP fsGroup CONTAINS FILESTREAM;
GO

-- Be sure the C:\Filestream directory exists on your SQL Server
ALTER DATABASE FilestreamDemoDB
ADD FILE( NAME = 'fsFilestreamDemoDB', 
 FILENAME = 'C:\FileStream\FilestreamDemoDB')
TO FILEGROUP fsGroup;





-- Turn on NON_TRANSACTED_ACCESS
ALTER DATABASE FilestreamDemoDB
SET FILESTREAM ( NON_TRANSACTED_ACCESS = FULL, DIRECTORY_NAME = N'FilestreamDemoDB' );


SELECT *, DB_NAME(database_id)
  FROM sys.database_filestream_options;




-- Create a FileTable in the FilestreamDemoDB database.

USE FilestreamDemoDB;
GO

CREATE TABLE PictureFiles as FileTable
WITH (FILETABLE_DIRECTORY = 'PictureFiles');


SELECT *
  FROM PictureFiles;


SELECT FileTableRootPath();

SELECT FileTableRootPath('dbo.PictureFiles');

