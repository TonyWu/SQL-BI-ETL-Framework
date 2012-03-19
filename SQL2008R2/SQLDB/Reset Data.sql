---Clear Tables
DELETE FROM dbo.ETL_Workflow_Log
DBCC CHECKIDENT('ETL_Workflow_Log',reseed,0)

DELETE FROM dbo.Workflow_Tasks_Log
DBCC CHECKIDENT('Workflow_Tasks_Log',reseed,0)

DELETE FROM [dbo].[Task_Packages]
DBCC CHECKIDENT('Task_Packages',reseed,0)

DELETE FROM [dbo].[Workflow_Tasks]
DBCC CHECKIDENT('Workflow_Tasks',reseed,0)

DELETE FROM [dbo].[ETL_Workflow]
DBCC CHECKIDENT('ETL_Workflow',reseed,0)