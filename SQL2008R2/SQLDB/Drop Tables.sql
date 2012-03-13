/********************************************************************************************
** Decription : Script to drop tables in SQL App for ETL Framework
** IMPORTANT NOTE : THIS SCRIPT HAS TO BE RUN IN SQLCMD MODE
** Author : Pavan Keerthi

Change Log:
-----------
01-March-2012 :Created Initial Version.
*********************************************************************************************/
:setvar ServerName "2BCN85J-LC\SQLEXPRESS"
:setvar DatabaseName "ETLFramework"
GO
:CONNECT $(ServerName)
GO
USE $(DatabaseName)
GO



/****** Object:  ForeignKey [FK_Workflow_Log_WorkflowId]    Script Date: 03/01/2012 18:15:49 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Workflow_Log_WorkflowId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ETL_Workflow_Log]'))
ALTER TABLE [dbo].[ETL_Workflow_Log] DROP CONSTRAINT [FK_Workflow_Log_WorkflowId]
GO
/****** Object:  ForeignKey [FK_RowError_Tasks_LogId]    Script Date: 03/01/2012 18:15:49 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RowError_Tasks_LogId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Row_Error_Log]'))
ALTER TABLE [dbo].[Row_Error_Log] DROP CONSTRAINT [FK_RowError_Tasks_LogId]
GO
/****** Object:  ForeignKey [FK_Tasks_Packages_TaskId]    Script Date: 03/01/2012 18:15:49 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Tasks_Packages_TaskId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Task_Packages]'))
ALTER TABLE [dbo].[Task_Packages] DROP CONSTRAINT [FK_Tasks_Packages_TaskId]
GO
/****** Object:  ForeignKey [FK_Tasks_Tasks_PrecedentTaskId]    Script Date: 03/01/2012 18:15:49 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Tasks_Tasks_PrecedentTaskId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Workflow_Tasks]'))
ALTER TABLE [dbo].[Workflow_Tasks] DROP CONSTRAINT [FK_Tasks_Tasks_PrecedentTaskId]
GO
/****** Object:  ForeignKey [FK_Workflow_Tasks_WorkflowId]    Script Date: 03/01/2012 18:15:49 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Workflow_Tasks_WorkflowId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Workflow_Tasks]'))
ALTER TABLE [dbo].[Workflow_Tasks] DROP CONSTRAINT [FK_Workflow_Tasks_WorkflowId]
GO
/****** Object:  ForeignKey [FK_WorkflowTasks_Log_TaskId]    Script Date: 03/01/2012 18:15:49 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WorkflowTasks_Log_TaskId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Workflow_Tasks_Log]'))
ALTER TABLE [dbo].[Workflow_Tasks_Log] DROP CONSTRAINT [FK_WorkflowTasks_Log_TaskId]
GO
/****** Object:  ForeignKey [FK_WorkflowTasks_Log_WorkflowId]    Script Date: 03/01/2012 18:15:49 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WorkflowTasks_Log_WorkflowId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Workflow_Tasks_Log]'))
ALTER TABLE [dbo].[Workflow_Tasks_Log] DROP CONSTRAINT [FK_WorkflowTasks_Log_WorkflowId]
GO
/****** Object:  Table [dbo].[Row_Error_Log]    Script Date: 03/01/2012 18:15:49 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RowError_Tasks_LogId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Row_Error_Log]'))
ALTER TABLE [dbo].[Row_Error_Log] DROP CONSTRAINT [FK_RowError_Tasks_LogId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Row_Error_Log]') AND type in (N'U'))
DROP TABLE [dbo].[Row_Error_Log]
GO
/****** Object:  Table [dbo].[Task_Packages]    Script Date: 03/01/2012 18:15:49 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Tasks_Packages_TaskId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Task_Packages]'))
ALTER TABLE [dbo].[Task_Packages] DROP CONSTRAINT [FK_Tasks_Packages_TaskId]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Task_Pack__IsAct__5DCAEF64]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Task_Packages] DROP CONSTRAINT [DF__Task_Pack__IsAct__5DCAEF64]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Task_Packages]') AND type in (N'U'))
DROP TABLE [dbo].[Task_Packages]
GO
/****** Object:  Table [dbo].[Workflow_Tasks_Log]    Script Date: 03/01/2012 18:15:49 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WorkflowTasks_Log_TaskId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Workflow_Tasks_Log]'))
ALTER TABLE [dbo].[Workflow_Tasks_Log] DROP CONSTRAINT [FK_WorkflowTasks_Log_TaskId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WorkflowTasks_Log_WorkflowId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Workflow_Tasks_Log]'))
ALTER TABLE [dbo].[Workflow_Tasks_Log] DROP CONSTRAINT [FK_WorkflowTasks_Log_WorkflowId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Workflow_Tasks_Log]') AND type in (N'U'))
DROP TABLE [dbo].[Workflow_Tasks_Log]
GO
/****** Object:  Table [dbo].[ETL_Workflow_Log]    Script Date: 03/01/2012 18:15:49 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Workflow_Log_WorkflowId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ETL_Workflow_Log]'))
ALTER TABLE [dbo].[ETL_Workflow_Log] DROP CONSTRAINT [FK_Workflow_Log_WorkflowId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ETL_Workflow_Log]') AND type in (N'U'))
DROP TABLE [dbo].[ETL_Workflow_Log]
GO
/****** Object:  Table [dbo].[Workflow_Tasks]    Script Date: 03/01/2012 18:15:49 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Tasks_Tasks_PrecedentTaskId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Workflow_Tasks]'))
ALTER TABLE [dbo].[Workflow_Tasks] DROP CONSTRAINT [FK_Tasks_Tasks_PrecedentTaskId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Workflow_Tasks_WorkflowId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Workflow_Tasks]'))
ALTER TABLE [dbo].[Workflow_Tasks] DROP CONSTRAINT [FK_Workflow_Tasks_WorkflowId]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Workflow___IsAct__5812160E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Workflow_Tasks] DROP CONSTRAINT [DF__Workflow___IsAct__5812160E]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Workflow_Tasks]') AND type in (N'U'))
DROP TABLE [dbo].[Workflow_Tasks]
GO
/****** Object:  Table [dbo].[ETL_Workflow]    Script Date: 03/01/2012 18:15:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ETL_Workflow]') AND type in (N'U'))
DROP TABLE [dbo].[ETL_Workflow]
GO
