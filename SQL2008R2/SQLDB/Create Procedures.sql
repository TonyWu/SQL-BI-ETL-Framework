/********************************************************************************************
** Decription : Create Procedures that operate on SQL App Tables for ETL Framework
** Author : Pavan Keerthi

Change Log:
-----------
07-March-2012 :Created Initial Version.
*********************************************************************************************/
/* Create a procedure to insert data into ETL_Workflow Table via a table-valued parameter(TVP) */
CREATE PROCEDURE usp_InsertWorkflowInfo
	(@WorkflowInfo WorkflowTableType READONLY)
AS
INSERT INTO [ETLFramework2008].[dbo].[ETL_Workflow]
           ([Workflow_Name]
           ,[Workflow_Status]
           ,[WorkFlow_RecoveryMode])

GO

