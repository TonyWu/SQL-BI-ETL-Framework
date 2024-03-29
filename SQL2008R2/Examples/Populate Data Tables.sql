--Insert Into Workflow Table
SET NOCOUNT ON
DECLARE @WorkflowInfo WorkflowTableType
DECLARE @WorkflowId int

Insert Into @WorkflowInfo(WorkflowName,WorkflowStatus,WorkflowRecoveryMode)
Values('Test Workflow','N','I')


EXECUTE [dbo].[usp_InsertWorkflowInfo] 
   @WorkflowInfo
  ,@WorkflowId OUTPUT
PRINT 'Created new Workflow with Id:'+Convert(varchar(10),@WorkflowId)

--Check Workflow Table
SELECT  [Workflow_Id]
      ,[Workflow_Name]
      ,[Workflow_Status]
      ,[WorkFlow_RecoveryMode]
FROM [dbo].[ETL_Workflow]


--Insert Into Tasks Table
SET NOCOUNT ON
DECLARE @WorkflowTasks TaskTableType
DECLARE @WorkflowName nvarchar(255)

Insert Into @WorkflowTasks(TaskName,TaskOrder,TaskStatus,TaskFailureAction,TaskRecoveryMode,
                           PrecedentTaskName,ExtractLimitType,ExtractLimitStart,ExtractLimitEnd)                      
Values ('Clear Staging Table',1,'N','C','I',NULL,NULL,NULL,NULL)

EXECUTE [dbo].[usp_InsertTaskInfo] 
   @WorkflowTasks
  ,@WorkflowName='Test Workflow'


Delete from @WorkflowTasks 

Insert Into @WorkflowTasks(TaskName,TaskOrder,TaskStatus,TaskFailureAction,TaskRecoveryMode,
                           PrecedentTaskName,ExtractLimitType,ExtractLimitStart,ExtractLimitEnd)
Values('Transfer Data into Staging',2,'N','R','R','Clear Staging Table','Date Range','01-Jan-2012','31-Jan-2012')

EXECUTE [dbo].[usp_InsertTaskInfo] 
   @WorkflowTasks
  ,@WorkflowName='Test Workflow'


--Check Task Table
SELECT [Task_Id]
      ,[Workflow_Id]
      ,[Task_Name]
      ,[Task_Order]
      ,[Precendent_TaskId]
      ,[Task_Status]
      ,[Task_FailureAction]
      ,[Task_RecoveryMode]
      ,[IsActive]
      ,[Extract_Limit_Type]
      ,[Extract_Limit_Start]
      ,[Extract_Limit_End]
  FROM [dbo].[Workflow_Tasks]


--Insert Into Packages Table
SET NOCOUNT ON
Declare @TaskPackages PackageTableType

Insert Into @TaskPackages(PackageName,TaskName,WorkflowName,PackageConnectionString,PackageGUID,PackageVersion,PackageCreationDate)
Values ('Package 1','Clear Staging Table','Test Workflow','Test\Package1.dtsx','72F0A044-2B07-41EB-B3C9-AD932AB3049B','0.0.1',GetDate())
,('Package 2','Transfer Data into Staging','Test Workflow','Test\Package2.dtsx','89A0860D-115A-4C9F-BFAB-F53B2C626C6B','0.0.1',GetDate())

EXECUTE [dbo].[usp_InsertPackageInfo] 
   @TaskPackages


--Check Package Table
SELECT [Package_Id]
      ,[Task_Id]
      ,[Package_Name]
      ,[Package_ConnectionString]
      ,[Package_GUID]
      ,[Package_Version]
      ,[Package_CreationDate]
      ,[IsActive]
  FROM [dbo].[Task_Packages]
GO




