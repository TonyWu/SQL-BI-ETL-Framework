/********************************************************************************************
** Decription : Create User-defined Data Types in SQL App Tables for ETL 
** Author : Pavan Keerthi

Change Log:
-----------
07-March-2012 :Created Initial Version.
*********************************************************************************************/
/* Create a workflow table type. */
CREATE TYPE WorkflowTableType AS TABLE 
(WorkflowName nvarchar(255),WorkflowStatus nchar(1),WorkflowRecoveryMode nchar(1))
GO


/*Create a Task table type*/
CREATE TYPE TaskTableType AS TABLE
(TaskName nvarchar(255),TaskOrder smallint,PrecedentTaskName nvarchar(255),TaskStatus nchar(1),TaskFailureAction nchar(1),
 TaskRecoveryMode nchar(1),ExtractLimitType nvarchar(50),ExtractLimitStart nvarchar(255),
 ExtractLimitEnd nvarchar(255))
GO

/*Create Package table type*/
CREATE TYPE PackageTableType AS TABLE
(PackageName nvarchar(255),TaskName nvarchar(255),WorkflowName nvarchar(255),PackageConnectionString nvarchar(2000),PackageGUID uniqueidentifier,
PackageVersion varchar(20),PackageCreationDate datetime)
GO