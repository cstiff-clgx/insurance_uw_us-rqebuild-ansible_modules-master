USE master;

IF NOT EXISTS 
    (SELECT name  
     FROM master.sys.server_principals
     WHERE name = 'EC_User')
BEGIN
    CREATE LOGIN EC_User WITH PASSWORD = 'Test1234';
END
GO

USE [master]
GO

DROP DATABASE IF EXISTS [ECRelease];

/****** Object:  Database [ECRelease]    Script Date: 1/17/2024 2:40:31 PM ******/
CREATE DATABASE [ECRelease]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ECRelease', FILENAME = N'/tsmsdb/ECRelease.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ECRelease_log', FILENAME = N'/tsmsdb/ECRelease.ldf' , SIZE = 3456KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [ECRelease] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ECRelease].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ECRelease] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ECRelease] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ECRelease] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ECRelease] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ECRelease] SET ARITHABORT OFF 
GO
ALTER DATABASE [ECRelease] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ECRelease] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ECRelease] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ECRelease] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ECRelease] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ECRelease] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ECRelease] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ECRelease] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ECRelease] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ECRelease] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ECRelease] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ECRelease] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ECRelease] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ECRelease] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ECRelease] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ECRelease] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ECRelease] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ECRelease] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ECRelease] SET  MULTI_USER 
GO
ALTER DATABASE [ECRelease] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ECRelease] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ECRelease] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ECRelease] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [ECRelease] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ECRelease] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'ECRelease', N'ON'
GO
ALTER DATABASE [ECRelease] SET QUERY_STORE = OFF
GO
USE [ECRelease]
GO
CREATE USER [EC_User] FOR LOGIN [EC_User] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [EC_User]
GO

/****** Object:  Table [dbo].[EC_Release]    Script Date: 1/17/2024 2:40:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EC_Release](
	[Release_Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Release_Name] [varchar](50) NOT NULL,
	[Release_Database] [varchar](50) NOT NULL,
	[Release_Connection] [varchar](150) NULL,
	[Build_Folder] [varchar](50) NULL,
	[Tolerance] [decimal](4, 2) NULL,
	[Created_User] [varchar](50) NULL,
	[Created_DateTime] [datetime] NULL,
	[Last_Modified_User] [varchar](50) NULL,
	[Last_Modified_DateTime] [datetime] NULL,
	[Deleted] [bit] NULL,
	[Deleted_User] [varchar](50) NULL,
	[Deleted_DateTime] [datetime] NULL,
 CONSTRAINT [PK_EC_Release] PRIMARY KEY CLUSTERED 
(
	[Release_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EC_ToleranceHistoryLog]    Script Date: 1/17/2024 2:40:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EC_ToleranceHistoryLog](
	[Release_Id] [bigint] NOT NULL,
	[Old_Tolerance] [decimal](4, 2) NOT NULL,
	[New_Tolerance] [decimal](4, 2) NOT NULL,
	[Last_Modified_User] [varchar](50) NULL,
	[Last_Modified_DateTime] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EC_ToleranceHistoryLog]  WITH CHECK ADD  CONSTRAINT [FK_EC_ToleranceHistoryLog_EC_Release] FOREIGN KEY([Release_Id])
REFERENCES [dbo].[EC_Release] ([Release_Id])
GO
ALTER TABLE [dbo].[EC_ToleranceHistoryLog] CHECK CONSTRAINT [FK_EC_ToleranceHistoryLog_EC_Release]
GO
/****** Object:  StoredProcedure [dbo].[AddRelease]    Script Date: 1/17/2024 2:40:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Binu John>
-- Create date: <10/20/2010>
-- Description:	<Update a Release in EC_Release table>
-- Version:		<1.0>
-- =============================================
CREATE PROCEDURE [dbo].[AddRelease]
@R_Name varchar(50),
@R_Database varchar(50),
@R_Connection varchar(150),
@R_Folder varchar(50),
@R_Tolerance decimal (4,2),
@R_User varchar(50)
AS
BEGIN
	BEGIN TRY
		IF EXISTS( SELECT 'True' FROM EC_Release WHERE Release_Name = @R_Name AND Deleted = 0)
			BEGIN				
				RAISERROR('This Release already exists!', 11, 1);
				RETURN;
			END
		ELSE
			BEGIN
				INSERT INTO EC_Release 
				VALUES(
						@R_Name,
						@R_Database,
						@R_Connection,
						@R_Folder,
						@R_Tolerance,
						@R_User,
						GETDATE(),
						NULL,
						NULL,
						0,
						NULL,
						NULL)
				SELECT 'Release added successfully.' AS Result
			END	
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage nvarchar(4000);
		DECLARE @ErrorSeverity int;
		DECLARE @ErrorState int;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(); 
		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteRelease]    Script Date: 1/17/2024 2:40:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Binu John>
-- Create date: <10/20/2010>
-- Description:	<Update a Release in EC_Release table>
-- Version:		<1.0>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteRelease]
@R_Id bigint,
@R_User varchar(50)
AS
BEGIN
	SET NOCOUNT ON;		
	BEGIN TRY
		UPDATE EC_Release 
		SET 	Deleted = 1,
				Deleted_User = @R_User,
				Deleted_DateTime = GETDATE()
		WHERE Release_Id = @R_Id	
		SELECT 'Release deleted successfully.' AS Result
	END TRY	
	BEGIN CATCH
		DECLARE @ErrorMessage nvarchar(4000);
		DECLARE @ErrorSeverity int;
		DECLARE @ErrorState int;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(); 
		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[GetAllReleases]    Script Date: 1/17/2024 2:40:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Binu John>
-- Create date: <09/24/2010>
-- Description:	<Get All the Release from EC_Release table>
-- Version:		<1.0>
-- =============================================
CREATE PROCEDURE [dbo].[GetAllReleases] 		
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY	
		SELECT Release_Id, Release_Name, Release_Database, Release_Connection, Tolerance, Build_Folder   
		FROM EC_Release    
		WHERE Deleted = 0
		ORDER BY Release_Name DESC;
	END TRY	
	BEGIN CATCH
		DECLARE @ErrorMessage nvarchar(4000);
		DECLARE @ErrorSeverity int;
		DECLARE @ErrorState int;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(); 
		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[GetReleaseDatabaseConnection]    Script Date: 1/17/2024 2:40:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Binu John>
-- Create date: <10/07/2010>
-- Description:	<Get a Release database connection string from the EC_Release table>
-- Version:		<1.0>
-- =============================================
CREATE PROCEDURE [dbo].[GetReleaseDatabaseConnection] 		
@R_Id bigint
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT *
		FROM EC_Release 
		WHERE Release_Id = @R_Id;
    END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage nvarchar(4000);
		DECLARE @ErrorSeverity int;
		DECLARE @ErrorState int;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(); 
		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[GetReleaseDatabaseConnectionByName]    Script Date: 1/17/2024 2:40:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Binu John>
-- Create date: <10/07/2010>
-- Description:	<Get a Release database connection string from the EC_Release table by Release Name>
-- Version:		<1.0>
-- =============================================
CREATE PROCEDURE [dbo].[GetReleaseDatabaseConnectionByName] 		
@R_Name varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT *
		FROM EC_Release 
		WHERE Release_Name = @R_Name;
    END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage nvarchar(4000);
		DECLARE @ErrorSeverity int;
		DECLARE @ErrorState int;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(); 
		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[GetReleaseToleranceHistory]    Script Date: 1/17/2024 2:40:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Binu John>
-- Create date: <11/24/2010>
-- Description:	<Get GetReleaseToleranceHistory from the EC_ToleranceHistoryLog table>
-- Version:		<1.0>
-- =============================================
CREATE PROCEDURE [dbo].[GetReleaseToleranceHistory]
@R_Id bigint
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT TOP 10 *
		FROM EC_ToleranceHistoryLog 
		WHERE Release_Id = @R_Id;
    END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage nvarchar(4000);
		DECLARE @ErrorSeverity int;
		DECLARE @ErrorState int;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(); 
		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[UpdateRelease]    Script Date: 1/17/2024 2:40:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Binu John>
-- Create date: <10/20/2010>
-- Description:	<Update a Release in EC_Release table>
-- Version:		<1.0>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateRelease]
@R_Id bigint,
@R_Name varchar(50),
@R_Database varchar(50),
@R_Connection varchar(150),
@R_Folder varchar(50),
@R_Tolerance decimal (4,2),
@R_User varchar(50)
AS
BEGIN
	SET NOCOUNT ON;		
	BEGIN TRY
		IF EXISTS( SELECT 'True' FROM EC_Release WHERE Release_Name = @R_Name AND Deleted = 0 AND Release_Id <> @R_Id)
			BEGIN
				RAISERROR('This Release already exists!', 11, 1);
				RETURN;
			END
		ELSE
			BEGIN
				BEGIN TRANSACTION
					DECLARE @Old_Tolerance decimal(4,2);
					SET @Old_Tolerance = (SELECT Tolerance FROM EC_Release WHERE Release_Id = @R_Id);
					UPDATE EC_Release 
					SET		Release_Name = @R_Name,
							Release_Database = @R_Database,
							Release_Connection = @R_Connection,
							Build_Folder = @R_Folder,
							Tolerance = @R_Tolerance,
							Last_Modified_User = @R_User,
							Last_Modified_DateTime = GETDATE()					
					WHERE Release_Id = @R_Id
					
					IF(@Old_Tolerance <> @R_Tolerance)
						BEGIN
							INSERT INTO EC_ToleranceHistoryLog 
							VALUES( @R_Id,
									@Old_Tolerance,
									@R_Tolerance,
									@R_User,
									GETDATE());
						END
						
					SELECT 'Release updated successfully.' AS Result
				COMMIT TRAN
			END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN
		DECLARE @ErrorMessage nvarchar(4000);
		DECLARE @ErrorSeverity int;
		DECLARE @ErrorState int;
		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(); 
		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH
END

GO
USE [master]
GO
ALTER DATABASE [ECRelease] SET  READ_WRITE 
GO

USE master;

DROP DATABASE IF EXISTS [ECTestCaseQueue];

CREATE DATABASE ECTestCaseQueue ON
(
  NAME = ECTestCaseQueue,
  FILENAME = '/tsmsdb/ECTestCaseQueue.mdf'
)
LOG ON
(
  NAME = ECTestCaseQueue_log,
  FILENAME = '/tsmsdb/ECTestCaseQueue_log.ldf'
);
GO

USE ECTestCaseQueue;
CREATE USER EC_User FOR LOGIN EC_User;
GO

use ECTestCaseQueue;
EXEC sp_addrolemember 'db_owner', 'EC_User';
GO

CREATE TABLE EC_TestCaseQueue(
    ReleaseId BIGINT NOT NULL,
    ServerId BIGINT NOT NULL,
    TestRunId BIGINT NOT NULL,
    TestCaseId BIGINT NOT NULL,
    [Type] VARCHAR(16) NOT NULL,
    CreatedTime DATETIME NOT NULL,
    [Status] VARCHAR(16) NOT NULL,
    StatusChangedTime DATETIME,
    Comment VARCHAR(256),

    PRIMARY KEY(ReleaseId, TestRunId, TestCaseId)
);
GO



