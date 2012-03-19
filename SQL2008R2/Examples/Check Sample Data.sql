SELECT  [Workflow_Id]
      ,[Workflow_Name]
      ,[Workflow_Status]
      ,[WorkFlow_RecoveryMode]
FROM [dbo].[ETL_Workflow]

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

SELECT [Log_Id]
      ,[SystemExecutionGUID]
      ,[Workflow_Id]
      ,[Workflow_StartPeriod]
      ,[Workflow_EndPeriod]
      ,[Workflow_FinishStatus]
FROM [ETLFramework2008].[dbo].[ETL_Workflow_Log]