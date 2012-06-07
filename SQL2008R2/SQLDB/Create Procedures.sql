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
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
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
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
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
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO

/*****************************************************************************************************************************************/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
/*Create a Procedure to Update Workflow Log Table */
CREATE PROCEDURE usp_Update_WorkflowLog (@UpdateType varchar(20),@WorkflowName nvarchar(255)=NULL,@WorkflowId int=NULL
                                         ,@ExecutionId UniqueIdentifier=NULL,@WorkflowStatus nchar(1)=NULL,@Result int OUTPUT)
AS
DECLARE @ErrorSave INT
SET @ErrorSave = 0

/** Allowed Update Types: Start,End,Update **/

	IF @UpdateType = 'Start'
	--Create New Log Row and "Initialise" the Status
	BEGIN
       	
       	Select @WorkflowId=Workflow_Id From dbo.ETL_Workflow
       	Where Workflow_Name=@WorkflowName
       	
       	IF(@WorkflowId IS NULL) SET @ErrorSave=-1
       	ELSE
       	BEGIN
       	 INSERT INTO [dbo].[ETL_Workflow_Log]
           ([SystemExecutionGUID],[Workflow_Id],[Workflow_StartPeriod]
           ,[Workflow_EndPeriod],[Workflow_FinishStatus])
         Values (@ExecutionId,@WorkflowId,GETUTCDATE(),NULL,'I')
         
         IF (@@ERROR <> 0) SET @ErrorSave = @@ERROR 

        --Set Master Table Record Status to "Started"
        UPDATE dbo.ETL_Workflow SET Workflow_Status='S' Where Workflow_Id=@WorkflowId
        
        IF (@@ERROR <> 0) SET @ErrorSave = @@ERROR 
        END 
	END
    
    IF @UpdateType = 'Update'
    --Usually Called when need to set Status to "Running"
	BEGIN
       UPDATE [dbo].[ETL_Workflow_Log]
       SET [Workflow_FinishStatus] = @WorkflowStatus
       WHERE Workflow_Id=@WorkflowId AND SystemExecutionGUID=@ExecutionId
       
       IF (@@ERROR <> 0) SET @ErrorSave = @@ERROR
       
       --Set Master Table Record Status also to "Running"
       UPDATE dbo.ETL_Workflow SET Workflow_Status='R' Where Workflow_Id=@WorkflowId
       
       IF (@@ERROR <> 0) SET @ErrorSave = @@ERROR
       
	END
    
    
    IF @UpdateType = 'End'
    --Called for "Successful","Failed" and "Aborted" Cases
	BEGIN
       UPDATE [dbo].[ETL_Workflow_Log]
       SET [Workflow_EndPeriod] = GETDATE()
           ,[Workflow_FinishStatus] = @WorkflowStatus
       WHERE Workflow_Id=@WorkflowId AND SystemExecutionGUID=@ExecutionId
       
       IF (@@ERROR <> 0) SET @ErrorSave = @@ERROR
       
       --Set Master Table Record Status to "Not Running"
       UPDATE dbo.ETL_Workflow SET Workflow_Status='N' Where Workflow_Id=@WorkflowId  
       
       IF (@@ERROR <> 0) SET @ErrorSave = @@ERROR   
       
	END
  
  SET @Result=@ErrorSave 
   
  RETURN @ErrorSave

GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO



SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
/*Create a Procedure to Update Task Log Table */
CREATE PROCEDURE usp_Update_TaskLog (@UpdateType varchar(20),@WorkflowId int=NULL,@TaskId int=NULL
                                         ,@ExecutionId UniqueIdentifier=NULL,@TaskStatus nchar(1)=NULL,@Result int OUTPUT)
AS
DECLARE @ErrorSave INT
SET @ErrorSave = 0

/** Allowed Update Types: Start,End,Update **/
	IF @UpdateType = 'Start'
	--Create New Log Row for each Task and "Initialise" the Status
	BEGIN
	   
		INSERT INTO [ETLFramework2008].[dbo].[Workflow_Tasks_Log]
			   ([SystemExecutionGUID],[Workflow_Id],[Task_Id],[Task_Order]
			   ,[PackageGUID],[Extract_Limit_Type],[Extract_Limit_Start],[Extract_Limit_End]
			   ,[Task_StartPeriod],[Task_EndPeriod],[Task_FinishStatus]
			   ,[Rows_Processed])

		Select 
		@ExecutionId,@WorkflowId,T.Task_Id,T.Task_Order,P.Package_GUID
		,T.Extract_Limit_Type,T.Extract_Limit_Start,T.Extract_Limit_End
		,GETDATE(),NULL,'I',NULL 
		FROM [dbo].[ETL_Workflow] W 
		INNER JOIN [dbo].[Workflow_Tasks] T ON W.[Workflow_Id]=T.[Workflow_id] AND T.IsActive=1 
		INNER JOIN [dbo].[Task_Packages] P ON T.[Task_Id]=P.[Task_Id] AND P.IsActive=1
		
		IF (@@ERROR <> 0) SET @ErrorSave = @@ERROR 
		
		--Set the Master Table Record status to "Started"
		Update dbo.Workflow_Tasks SET Task_Status='S' Where Workflow_Id=@WorkflowId
    
         IF (@@ERROR <> 0) SET @ErrorSave = @@ERROR 
	END
	
	IF @UpdateType = 'Update'
	--Usually Called when need to set Status to "Running"
	BEGIN
	Update dbo.Workflow_Tasks_Log
	SET [Task_FinishStatus]=@TaskStatus 
	Where SystemExecutionGUID=@ExecutionId AND Workflow_Id=@WorkflowId AND Task_Id=@TaskId
	  
	IF (@@ERROR <> 0) SET @ErrorSave = @@ERROR 
	  
	--Set the Master Table Record status to "Running"  
	Update dbo.Workflow_Tasks SET Task_Status='R' Where Workflow_Id=@WorkflowId
	
	IF (@@ERROR <> 0) SET @ErrorSave = @@ERROR 
	
	END
	
	IF @UpdateType = 'End'
	--Called for "Successful","Failed","Aborted"  cases
	BEGIN
	Update dbo.Workflow_Tasks_Log
	SET [Task_FinishStatus]=@TaskStatus ,Task_EndPeriod=GETDATE()
	Where SystemExecutionGUID=@ExecutionId AND Workflow_Id=@WorkflowId AND Task_Id=@TaskId
	
	IF (@@ERROR <> 0) SET @ErrorSave = @@ERROR 
	
	--Set the Master Table Record status to "Not Running"  
	Update dbo.Workflow_Tasks SET Task_Status='N' Where Workflow_Id=@WorkflowId
	
	IF (@@ERROR <> 0) SET @ErrorSave = @@ERROR 
	
	END
	
  SET @Result=@ErrorSave 
   
  RETURN @ErrorSave

GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO