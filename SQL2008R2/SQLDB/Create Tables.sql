/********************************************************************************************
** Decription : Create Tables required for creating SQL App for ETL Framework
** Author : Pavan Keerthi

Change Log:
-----------
01-March-2012 :Created Initial Version.
*********************************************************************************************/
--Table to hold ETL Workflow 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ETL_Workflow]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[ETL_Workflow](
	[Workflow_Id] [int] IDENTITY(1,1) NOT NULL,
	[Workflow_Name] [nvarchar](255) NOT NULL,
	[Workflow_Status] [nchar](1) NOT NULL,
	[WorkFlow_RecoveryMode] [nchar](1) NOT NULL,
 CONSTRAINT [PK_ETL_Workflow] PRIMARY KEY CLUSTERED 
(
	[Workflow_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO


--Table to hold Workflow Tasks along with Extraction Limits(if applicable)
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Workflow_Tasks]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[Workflow_Tasks](
    [Task_Id] [int]IDENTITY(1,1) NOT NULL,
	[Workflow_Id] [int] NOT NULL,
	[Task_Name] [nvarchar](255) NOT NULL,
	[Task_Order] [smallint] NULL,
	[Precendent_TaskId] int NULL,
	[Task_Status] [nchar](1) NOT NULL,
	[Task_FailureAction] [nchar](1) NOT NULL,
	[Task_RecoveryMode] [nchar](1) NOT NULL,
	[IsActive] bit NOT NULL DEFAULT 1,
	[Extract_Limit_Type] [nvarchar](50) NOT NULL,
	[Extract_Limit_Start] [nvarchar](255) NULL,
	[Extract_Limit_End] [nvarchar](255) NULL
	
 CONSTRAINT [PK_Workflow_Tasks] PRIMARY KEY CLUSTERED 
(   
	[Task_Id],[Workflow_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Workflow_Tasks] ADD CONSTRAINT UNQ_Tasks_TaskId UNIQUE ([Task_Id])

ALTER TABLE [dbo].[Workflow_Tasks]  WITH CHECK ADD  CONSTRAINT [FK_Workflow_Tasks_WorkflowId] FOREIGN KEY([Workflow_Id])
REFERENCES [dbo].[ETL_Workflow] ([Workflow_Id])

ALTER TABLE [dbo].[Workflow_Tasks] CHECK CONSTRAINT [FK_Workflow_Tasks_WorkflowId]

ALTER TABLE [dbo].[Workflow_Tasks]  WITH CHECK ADD  CONSTRAINT [FK_Tasks_Tasks_PrecedentTaskId] FOREIGN KEY([Task_Id])
REFERENCES [dbo].[Workflow_Tasks] ([Task_Id])

ALTER TABLE [dbo].[Workflow_Tasks] CHECK CONSTRAINT [FK_Tasks_Tasks_PrecedentTaskId]

END
GO


--Table to hold Task Package details along with Version History
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Task_Packages]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[Task_Packages](
    [Package_Id] [int]IDENTITY(1,1) NOT NULL,
	[Task_Id] [int] NOT NULL,
	[Package_Name] [nvarchar](255) NOT NULL,
	[Package_ConnectionString] nvarchar(2000) NOT NULL,
	[Package_GUID] [uniqueidentifier] NOT NULL,
	[Package_Version] [varchar](20) NOT NULL,
	[Package_CreationDate] [datetime] NOT NULL,
	[IsActive] bit NOT NULL DEFAULT 1,
	 
CONSTRAINT [PK_Task_Packages] PRIMARY KEY CLUSTERED 
(   
	[Package_Id],[Task_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Task_Packages]  WITH CHECK ADD  CONSTRAINT [FK_Tasks_Packages_TaskId] FOREIGN KEY([Task_Id])
REFERENCES [dbo].[Workflow_Tasks] ([Task_Id])

ALTER TABLE [dbo].[Task_Packages] CHECK CONSTRAINT [FK_Tasks_Packages_TaskId]

END
GO

--Table for Workflow Custom Logging
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ETL_Workflow_Log]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[ETL_Workflow_Log](
         [Log_Id] [int]IDENTITY(1,1) NOT NULL,
         [SystemExecutionGUID] [uniqueidentifier] NOT NULL,
         [Workflow_Id] [int] NOT NULL,
         [Workflow_StartPeriod] [datetime] NOT NULL,
         [Workflow_EndPeriod] [datetime]  NOT NULL,
         [Workflow_FinishStatus] [nchar](1) NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[ETL_Workflow_Log]  WITH CHECK ADD  CONSTRAINT [FK_Workflow_Log_WorkflowId] FOREIGN KEY([Workflow_Id])
REFERENCES [dbo].[ETL_Workflow] ([Workflow_Id])

ALTER TABLE [dbo].[ETL_Workflow_Log] CHECK CONSTRAINT [FK_Workflow_Log_WorkflowId]

END
GO 
      

--Table for Tasks Custom Logging
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Workflow_Tasks_Log]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[Workflow_Tasks_Log](
         [Log_Id] [int] IDENTITY(1,1) NOT NULL,
         [SystemExecutionGUID] [uniqueidentifier] NOT NULL,
         [Workflow_Id] [int] NOT NULL,
         [Task_Id] [int] NOT NULL,
         [Task_Order] [smallint] NULL,
         [PackageGUID] [uniqueidentifier] NOT NULL,
         [Task_StartPeriod] [datetime] NOT NULL,
         [Task_EndPeriod] [datetime]  NOT NULL,
         [Task_FinishStatus] [nchar](1) NOT NULL,
         [Extract_Limit_Type] [nvarchar](50) NOT NULL,
		 [Extract_Limit_Start] [nvarchar](255) NULL,
		 [Extract_Limit_End] [nvarchar](255) NULL,
		 [Rows_Processed] [int] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[Workflow_Tasks_Log] ADD CONSTRAINT UNQ_Workflow_Tasks_LogId UNIQUE ([Log_Id])

ALTER TABLE [dbo].[Workflow_Tasks_Log]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowTasks_Log_WorkflowId] FOREIGN KEY([Workflow_Id])
REFERENCES [dbo].[ETL_Workflow] ([Workflow_Id])

ALTER TABLE [dbo].[Workflow_Tasks_Log] CHECK CONSTRAINT [FK_WorkflowTasks_Log_WorkflowId]

ALTER TABLE [dbo].[Workflow_Tasks_Log]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowTasks_Log_TaskId] FOREIGN KEY([Task_Id])
REFERENCES [dbo].[Workflow_Tasks] ([Task_Id])

ALTER TABLE [dbo].[Workflow_Tasks_Log] CHECK CONSTRAINT [FK_WorkflowTasks_Log_TaskId]

END
GO           


--Table to capture Dataflow Row Errors
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Row_Error_Log]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[Row_Error_Log](
	[Row_Identifier] [nvarchar](255) NOT NULL,
	[Workflow_Tasks_LogId] [int] NOT NULL,
	[Error_Code] [int] NOT NULL,
	[Error_Column] [int] NOT NULL,
	[Error_Description] [nvarchar](255) NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[Row_Error_Log]  WITH CHECK ADD  CONSTRAINT [FK_RowError_Tasks_LogId] FOREIGN KEY([Workflow_Tasks_LogId])
REFERENCES [dbo].[Workflow_Tasks_Log] ([Log_Id])
ALTER TABLE [dbo].[Row_Error_Log] CHECK CONSTRAINT [FK_RowError_Tasks_LogId]

END
GO



