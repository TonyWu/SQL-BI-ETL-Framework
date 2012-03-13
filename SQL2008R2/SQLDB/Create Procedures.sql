/********************************************************************************************
** Decription : Create Procedures that operate on SQL App Tables for ETL Framework
** Author : Pavan Keerthi

Change Log:
-----------
07-March-2012 :Created Initial Version.
*********************************************************************************************/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
/* Create a procedure to insert record for new Workflow into ETL_Workflow Table and return Workflow Id */
CREATE PROCEDURE usp_InsertWorkflowInfo (@WorkflowInfo WorkflowTableType READONLY,@WorkflowId int OUTPUT)
AS
--Populate Workflow Table
INSERT INTO [dbo].[ETL_Workflow]
           ([Workflow_Name],[Workflow_Status],[WorkFlow_RecoveryMode])
Select R.WorkflowName,R.WorkflowStatus,R.WorkflowRecoveryMode  
FROM @WorkflowInfo R

--Get Workflow Id
Select @WorkflowId=SCOPE_IDENTITY()

GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
/*Create a Procedure to insert Tasks related to a Workflow */
CREATE PROCEDURE usp_InsertTaskInfo (@WorkflowTasks TaskTableType READONLY,@WorkflowName nvarchar(255))
AS

Declare @Workflowid As int
--Get WorkflowId
Select @Workflowid=Workflow_Id FROM [dbo].[ETL_Workflow] Where Workflow_Name=@WorkflowName 

--Populate Task Table 
INSERT INTO [dbo].[Workflow_Tasks]
           ([Workflow_Id],[Task_Name],[Task_Order],[Precendent_TaskId]
           ,[Task_Status],[Task_FailureAction],[Task_RecoveryMode]
           ,[Extract_Limit_Type],[Extract_Limit_Start],[Extract_Limit_End])
Select @Workflowid,C.TaskName,C.TaskOrder,P.Task_Id,C.TaskStatus,C.TaskFailureAction,
C.TaskRecoveryMode,C.ExtractLimitType,C.ExtractLimitStart,C.ExtractLimitEnd 
FROM @WorkflowTasks C
LEFT JOIN(Select Task_Id,Task_Name FROM [dbo].[Workflow_Tasks]) P ON P.Task_Name=C.PrecedentTaskName 
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
/*Create a Procedure to insert Tasks related to a Workflow */
CREATE PROCEDURE usp_InsertPackageInfo (@TaskPackages PackageTableType READONLY)
AS

INSERT INTO [dbo].[Task_Packages]
           ([Task_Id],[Package_Name],[Package_ConnectionString],[Package_GUID]
           ,[Package_Version],[Package_CreationDate])

Select T.Task_Id,P.PackageName,P.PackageConnectionString,P.PackageGUID,P.PackageVersion,P.PackageCreationDate  
FROM @TaskPackages P
INNER JOIN ETL_Workflow W ON P.WorkflowName=W.Workflow_Name  
INNER JOIN Workflow_Tasks T ON P.TaskName=T.Task_Name AND T.Workflow_Id=W.Workflow_Id               
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO