/********************************************************************************************
** Decription : Create ETL Fraemwork Database for creating SQL App for ETL Framework
** IMPORTANT NOTE : THIS SCRIPT HAS TO BE RUN IN SQLCMD MODE
** Author : Pavan Keerthi

Change Log:
-----------
28-Feb-2012 :Created Initial Version.
*********************************************************************************************/

:setvar ServerName "PAVANKEERTHI-HP"
:setvar DatabaseDirectory "C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\"
:setvar LogDirectory "C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\"
:setvar DatabaseName "ETLFramework2008"
:setvar DataFileLogicalName "$(DatabaseName)_data"
:setvar LogFileLogicalName "$(DatabaseName)_log"
:setvar DataFileName "$(DatabaseName)$(DataFileLogicalName).mdf"
:setvar LogFileName "$(DatabaseName)$(LogFileLogicalName).ldf"
:setvar DataFilePath "$(DatabaseDirectory)$(DataFileName)"
:setvar LogFilePath "$(LogDirectory)$(LogFileName)"
GO
:CONNECT $(ServerName)
GO
USE [master]
GO


CREATE DATABASE $(DatabaseName) ON  PRIMARY 
( NAME = '$(DatabaseName)_data' , FILENAME ='$(DatabaseDirectory)$(DatabaseName)_data.mdf' , SIZE = 3072KB , MAXSIZE = 10GB, FILEGROWTH = 1MB )
 LOG ON 
( NAME = '$(DatabaseName)_log', FILENAME ='$(LogDirectory)$(DatabaseName)_log.ldf'  , SIZE = 1024KB , MAXSIZE = 2GB , FILEGROWTH = 10%)
GO

ALTER DATABASE $(DatabaseName) SET COMPATIBILITY_LEVEL = 100
GO

ALTER DATABASE $(DatabaseName) SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE $(DatabaseName) SET ANSI_NULLS OFF 
GO

ALTER DATABASE $(DatabaseName) SET ANSI_PADDING OFF 
GO

ALTER DATABASE $(DatabaseName) SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE $(DatabaseName) SET ARITHABORT OFF 
GO

ALTER DATABASE $(DatabaseName) SET AUTO_CLOSE OFF 
GO

ALTER DATABASE $(DatabaseName) SET AUTO_CREATE_STATISTICS ON 
GO

ALTER DATABASE $(DatabaseName) SET AUTO_SHRINK OFF 
GO

ALTER DATABASE $(DatabaseName) SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE $(DatabaseName) SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE $(DatabaseName) SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE $(DatabaseName) SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE $(DatabaseName) SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE $(DatabaseName) SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE $(DatabaseName) SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE $(DatabaseName) SET  DISABLE_BROKER 
GO

ALTER DATABASE $(DatabaseName) SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE $(DatabaseName) SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE $(DatabaseName) SET TRUSTWORTHY OFF 
GO

ALTER DATABASE $(DatabaseName) SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE $(DatabaseName) SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE $(DatabaseName) SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE $(DatabaseName) SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE $(DatabaseName) SET  READ_WRITE 
GO

ALTER DATABASE $(DatabaseName) SET RECOVERY SIMPLE 
GO

ALTER DATABASE $(DatabaseName) SET  MULTI_USER 
GO

ALTER DATABASE $(DatabaseName) SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE $(DatabaseName) SET DB_CHAINING OFF 
GO


