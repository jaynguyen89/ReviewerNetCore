CREATE TABLE [dbo].[Employees] (
    [Id]            INT IDENTITY(1, 1)  NOT NULL,
    [UserId]        INT                 DEFAULT NULL,
    [ProfileId]     INT                 DEFAULT NULL,
    [FirstName]     NVARCHAR(50)        DEFAULT NULL,
    [MiddleName]    NVARCHAR(50)        DEFAULT NULL,
    [GiveName]      NVARCHAR(50)        DEFAULT NULL,
    [PhoneNumber]   NVARCHAR(30)        DEFAULT NULL,
    [AvatarName]        NVARCHAR(450)   DEFAULT NULL,
    [FacebookProfile]   NVARCHAR(200)   DEFAULT NULL,
    [TwitterProfile]    NVARCHAR(200)   DEFAULT NULL,
    [BlogLink]          NVARCHAR(200)   DEFAULT NULL,
    [DateOfBirth]   DATETIME2 (7)       DEFAULT NULL,
    [CreatedOn]     DATETIME2 (7)       DEFAULT (GETDATE()) NOT NULL,
    [UpdatedOn]     DATETIME2 (7)       DEFAULT NULL,
    CONSTRAINT [PK_Employees_Id] PRIMARY KEY ([Id] ASC)
);

CREATE TABLE [dbo].[Companies] (
    [Id]                INT IDENTITY(1, 1)  NOT NULL,
    -- The user who created this company record
    [UserId]            INT                 DEFAULT NULL,
    [SubCompanyOfId]    INT                 DEFAULT NULL,
    [LocationId]        INT                 DEFAULT NULL,
    [CompanyName]       NVARCHAR(50)        DEFAULT NULL,
    [ShortDescription]  NVARCHAR(450)       DEFAULT NULL,
    [FullDescription]   NVARCHAR(4000)      DEFAULT NULL,
    [WebsiteLink]       NVARCHAR(200)       DEFAULT NULL,
    [BlogLink]          NVARCHAR(200)       DEFAULT NULL,
    [FacebookProfile]   NVARCHAR(200)       DEFAULT NULL,
    [TwitterProfile]    NVARCHAR(200)       DEFAULT NULL,
    [PhoneNumber]       NVARCHAR(30)        DEFAULT NULL,
    [CreatedOn]         DATETIME2 (7)       DEFAULT (GETDATE()) NOT NULL,
    -- Store data in JSON format: {"UserId":{"UpdateOn":"", "Reason":""}}
    [UpdateRecords]     NVARCHAR(4000)      DEFAULT NULL,
    CONSTRAINT [PK_Companies_Id] PRIMARY KEY ([Id] ASC),
    CONSTRAINT [FK_Companies_SubCompanies] FOREIGN KEY ([SubCompanyOfId]) REFERENCES [dbo].[Companies] ([Id])
);

CREATE TABLE [dbo].[CompanyDepartments] (
    [Id]            INT IDENTITY(1, 1)  NOT NULL,
    [CompanyId]     INT                 NOT NULL,
    -- Store Id of sub-departments in JSON string, ie: {4, 8, 9}
    [SubDepartments]    NVARCHAR(50)    DEFAULT NULL,
    [DepartmentName]    NVARCHAR(50)    DEFAULT NULL,
    [Description]       NVARCHAR(1000)  DEFAULT NULL,
    [PhoneNumber]       NVARCHAR(30)    DEFAULT NULL,
    [CreatedOn]         DATETIME2 (7)   DEFAULT (GETDATE()) NOT NULL,
    -- Store data in JSON format: {"UserId":{"UpdateOn":"", "Reason":""}}
    [UpdateRecords]     NVARCHAR(4000)      DEFAULT NULL,
    CONSTRAINT [PK_CompanyDepartments_Id] PRIMARY KEY ([Id] ASC),
    CONSTRAINT [FK_CompanyDepartments_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Companies] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [dbo].[CompanyOwnerships] (
    [Id]            INT IDENTITY(1, 1)      NOT NULL,
    [CompanyId]     INT                     NOT NULL,
    [OwnerId]       INT                     NOT NULL,
    [OwnerTitle]    NVARCHAR(50)            DEFAULT NULL,
    [IsAtPosition]     BIT                  DEFAULT 1,
    [PositionedFrom]   DATETIME2 (7)        DEFAULT NULL,
    [PositionedTo]     DATETIME2 (7)        DEFAULT NULL,
    CONSTRAINT [PK_CompanyOwnerships_Id] PRIMARY KEY ([Id] ASC),
    CONSTRAINT [FK_CompanyOwnerships_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Companies] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_CompanyOwnerships_Employees] FOREIGN KEY ([OwnerId]) REFERENCES [dbo].[Employees] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [dbo].[CompanyEmployees] (
    [Id]            INT IDENTITY(1, 1)     NOT NULL,
    [DepartmentId]     INT                 NOT NULL,
    [EmployeeId]       INT                 NOT NULL,
    [EmployeeTitle]    NVARCHAR(50)        DEFAULT NULL,
    [IsAtPosition]     BIT                 DEFAULT 1,
    [PositionedFrom]   DATETIME2 (7)       DEFAULT NULL,
    [PositionedTo]     DATETIME2 (7)       DEFAULT NULL,
    CONSTRAINT [PK_CompanyEmployees_Id] PRIMARY KEY ([Id] ASC),
    CONSTRAINT [FK_CompanyEmployees_CompanyDepartments] FOREIGN KEY ([DepartmentId]) REFERENCES [dbo].[CompanyDepartments] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_CompanyEmployees_Employees] FOREIGN KEY ([EmployeeId]) REFERENCES [dbo].[Employees] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [dbo].[CollectedPhotos] (
    [Id]                INT IDENTITY(1, 1)  NOT NULL,
    -- The user who uploaded the photo
    [UserId]            INT                 DEFAULT NULL,
    [PhotoName]         NVARCHAR(450)       DEFAULT NULL,
    [Description]       NVARCHAR(250)       DEFAULT NULL,
    [UploadedOn]        DATETIME2 (7)       DEFAULT (GETDATE()) NOT NULL,
    [IrrelevanceVotes]  SMALLINT            DEFAULT 0,
    [IsActive]          BIT                 DEFAULT 1,
    CONSTRAINT [PK_CollectedPhotos_Id] PRIMARY KEY ([Id] ASC)
);

CREATE TABLE [dbo].[CompanyPhotos] (
    [Id]                INT IDENTITY(1, 1)  NOT NULL,
    [CompanyId]         INT                 NOT NULL,
    [PhotoId]           INT                 NOT NULL,
    CONSTRAINT [PK_CompanyPhotos_Id] PRIMARY KEY ([Id] ASC),
    CONSTRAINT [FK_CompanyPhotos_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Companies] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_CompanyPhotos_CollectedPhotos] FOREIGN KEY ([PhotoId]) REFERENCES [dbo].[CollectedPhotos] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [dbo].[DepartmentPhotos] (
    [Id]                INT IDENTITY(1, 1)  NOT NULL,
    [DepartmentId]      INT                 NOT NULL,
    [PhotoId]           INT                 NOT NULL,
    CONSTRAINT [PK_DepartmentPhotos_Id] PRIMARY KEY ([Id] ASC),
    CONSTRAINT [FK_DepartmentPhotos_CompanyDepartments] FOREIGN KEY ([DepartmentId]) REFERENCES [dbo].[CompanyDepartments] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_DepartmentPhotos_CollectedPhotos] FOREIGN KEY ([PhotoId]) REFERENCES [dbo].[CollectedPhotos] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [dbo].[CompanyInterviewRatings] (
    [Id]                INT IDENTITY(1, 1)  NOT NULL,
    [UserId]            INT                 DEFAULT NULL,
    [CompanyId]         INT                 NOT NULL,
    [Rating]            TINYINT             DEFAULT 5,
    [AttendedInterview] BIT                 DEFAULT 0,
    [InterviewedOn]         DATETIME2 (7)   DEFAULT NULL,
    [InterviewToughness]    TINYINT         DEFAULT 5,
    [Description]       NVARCHAR(4000)      DEFAULT NULL,
    [IsUpdated]         BIT                 DEFAULT 0,
    [CreatedOn]         DATETIME2 (7)       DEFAULT (GETDATE()) NOT NULL,
    [UpdatedOn]         DATETIME2 (7)       DEFAULT NULL,
    CONSTRAINT [PK_CompanyInterviewRatings_Id] PRIMARY KEY ([Id] ASC),
    CONSTRAINT [FK_CompanyInterviewRatings_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Companies] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [dbo].[CompanyCultureRatings] (
    [Id]                INT IDENTITY(1, 1)  NOT NULL,
    [UserId]            INT                 DEFAULT NULL,
    [CompanyId]         INT                 NOT NULL,
    -- Store ratings for various criteria in JSON format: {"criterion":"rating"}
    [Rating]            NVARCHAR            NOT NULL,
    [IsEmployed]        BIT                 DEFAULT 0,
    [IsCurrentJob]      BIT                 DEFAULT 0,
    [EmployedFrom]      DATETIME2 (7)       DEFAULT NULL,
    [EmployedTo]        DATETIME2 (7)       DEFAULT NULL,
    [Description]       NVARCHAR(4000)      DEFAULT NULL,
    [CreatedOn]         DATETIME2 (7)       DEFAULT (GETDATE()) NOT NULL,
    [UpdatedOn]         DATETIME2 (7)       DEFAULT NULL,
    CONSTRAINT [PK_CompanyCultureRatings_Id] PRIMARY KEY ([Id] ASC),
    CONSTRAINT [FK_CompanyCultureRatings_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Companies] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [dbo].[Industries] (
    [Id]            INT IDENTITY(1, 1)  NOT NULL,
    [IndustryName]  NVARCHAR(50)        DEFAULT NULL,
    CONSTRAINT [PK_Industries_Id] PRIMARY KEY ([Id] ASC)
);

CREATE TABLE [dbo].[SubIndustries] (
    [Id]            INT IDENTITY(1, 1)  NOT NULL,
    [IndustryId]    INT                 NOT NULL,
    [SubIndustryName]   NVARCHAR(50)    DEFAULT NULL,
    [Description]       NVARCHAR(450)   DEFAULT NULL,
    CONSTRAINT [PK_SubIndustries_Id] PRIMARY KEY ([Id] ASC),
    CONSTRAINT [FK_SubIndustries_Industries] FOREIGN KEY ([IndustryId]) REFERENCES [dbo].[Industries] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [dbo].[CompanySubIndustries] (
    [Id]            INT IDENTITY(1, 1)  NOT NULL,
    [CompanyId]     INT                 NOT NULL,
    [SubIndustryId] INT                 NOT NULL,
    [Description]   NVARCHAR(450)       DEFAULT NULL,
    CONSTRAINT [PK_CompanySubIndustries_Id] PRIMARY KEY ([Id] ASC),
    CONSTRAINT [FK_CompanySubIndustries_Companies] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Companies] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_CompanySubIndustries_SubIndustries] FOREIGN KEY ([SubIndustryId]) REFERENCES [dbo].[SubIndustries] ([Id]) ON DELETE CASCADE
);