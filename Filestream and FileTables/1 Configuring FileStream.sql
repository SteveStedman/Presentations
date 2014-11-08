-- before running demo, delete the contents of the C:\FileStream directory

USE master;
GO
EXEC sp_configure filestream_access_level, 0;
GO
RECONFIGURE;


IF EXISTS(SELECT name FROM sys.databases WHERE name = 'FilestreamDemoDB')
BEGIN
  ALTER DATABASE [FilestreamDemoDB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [FilestreamDemoDB];
END
CREATE DATABASE [FilestreamDemoDB];
GO

USE [FilestreamDemoDB];

-- First check the level
EXEC sp_configure filestream_access_level;

-- then set it as needed
EXEC sp_configure filestream_access_level, 1;

-- don't forget to run RECONFIGURE
RECONFIGURE;

-- Confirm Changes
EXEC sp_configure filestream_access_level;


-- Creating the FILESTREAM filegroups

ALTER DATABASE FilestreamDemoDB
ADD FILEGROUP fsGroup CONTAINS FILESTREAM;
GO

-- Be sure the C:\Filestream directory exists on your SQL Server
ALTER DATABASE FilestreamDemoDB
ADD FILE( NAME = 'fsFilestreamDemoDB', 
 FILENAME = 'C:\FileStream\FilestreamDemoDB')
TO FILEGROUP fsGroup;


-- take a look at the C:\FileStream\FilestreamDemoDB directory now











--------------------------------------------------
-- FILESTREAM IS ENABLED... Now on to using it....
--------------------------------------------------











USE FilestreamDemoDB;
GO 

--DROP TABLE [dbo].[FileStreamFiles];
CREATE TABLE [dbo].[FileStreamFiles]
(
	[id] INT IDENTITY,
	[description] VARCHAR(30),
	[fileData] VARBINARY(MAX) FILESTREAM NULL
);




CREATE TABLE [dbo].[FileStreamFiles]
(
	[id] UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL UNIQUE,
	[description] VARCHAR(30),
	[fileData] VARBINARY(MAX) FILESTREAM NULL
);




