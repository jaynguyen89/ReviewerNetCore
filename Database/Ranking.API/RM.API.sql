CREATE TABLE [dbo].[UserRankings] (
	[Id]                INT IDENTITY(1, 1)  NOT NULL,
    [Ranking]           INT                 NOT NULL,
	[UserId]            INT                 NOT NULL,
    -- 1000 Reputation Points + Approval = 1 Prestige Point
	[ReputationPoints]  INT                 DEFAULT 0,
	[PrestigePoints]    INT                 DEFAULT 0,
	[UpdatedOn]         DATETIME2 (7)       DEFAULT (GETDATE()) NOT NULL,
	CONSTRAINT [PK_UserRankings_Id] PRIMARY KEY ([Id] ASC),
	CONSTRAINT [FK_UserRankings_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]),
    CONSTRAINT [FK_UserRankings_Rankings] FOREIGN KEY ([RankingId]) REFERENCES [dbo].[Rankings] ([Id])
);

CREATE TABLE [dbo].[Rankings] (
    [Id]                INT IDENTITY(1, 1)  NOT NULL,
    [RankTitle]         NVARCHAR(30)        DEFAULT NULL,
    [Description]       NVARCHAR(100)       DEFAULT NULL,
    [BadgeIcon]         NVARCHAR(250)       DEFAULT NULL,
    [RequiredPoints]    INT                 DEFAULT 0,
    [PointType]         NVARCHAR(20)        DEFAULT NULL,
);

CREATE TABLE [dbo].[UserQueries] (
	[Id] INT IDENTITY(1, 1) NOT NULL,
	[UserId1] NVARCHAR(450) NOT NULL,
	[UserId2] NVARCHAR(450) DEFAULT NULL,
	[Type] TINYINT DEFAULT NULL,
	[Title] NVARCHAR(100) DEFAULT NULL,
	[Content] NVARCHAR(MAX) DEFAULT NULL,
	[Note] NVARCHAR(255) DEFAULT NULL,
	[IsHighlighted] BIT DEFAULT NULL,
	[IsSolved] BIT DEFAULT NULL,
	[CreatedOn] DATETIME2 (7) DEFAULT (GETDATE()) NOT NULL,
	[UpdatedOn] DATETIME2 (7) DEFAULT NULL,
	CONSTRAINT [PK_UserQueries_Id] PRIMARY KEY ([Id] ASC),
	CONSTRAINT [FK_UserQueries_Users1] FOREIGN KEY ([UserId1]) REFERENCES [dbo].[Users] ([Id]),
	CONSTRAINT [FK_UserQueries_Users2] FOREIGN KEY ([UserId2]) REFERENCES [dbo].[Users] ([Id])
);

CREATE TABLE [dbo].[QueryAttachments] (
	[Id] INT IDENTITY(1, 1) NOT NULL,
	[UserQueryId] INT NOT NULL,
	[AttachmentType] TINYINT DEFAULT NULL,
	[AttachmentName] NVARCHAR(255) DEFAULT NULL,
	[Note] NVARCHAR(100) DEFAULT NULL,
	CONSTRAINT [PK_QueryAttachments] PRIMARY KEY ([Id] ASC),
	CONSTRAINT [FK_QueryAttachments_UserQueries] FOREIGN KEY ([UserQueryId]) REFERENCES [dbo].[UserQueries] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [dbo].[Messages] (
	[Id] INT IDENTITY(1, 1) NOT NULL,
	[UserId1] NVARCHAR(450) NOT NULL,
	[UserId2] NVARCHAR(450) NOT NULL,
	[Title] NVARCHAR(100) DEFAULT NULL,
	[Content] NVARCHAR(MAX) DEFAULT NULL,
	[CreatedOn] DATETIME2 (7) DEFAULT (GETDATE()) NOT NULL,
	[UpdatedOn] DATETIME2 (7) DEFAULT NULL,
	CONSTRAINT [PK_Messages_Id] PRIMARY KEY ([Id] ASC),
	CONSTRAINT [FK_Messages_Users1] FOREIGN KEY ([UserId1]) REFERENCES [dbo].[Users] ([Id]),
	CONSTRAINT [FK_Messages_Users2] FOREIGN KEY ([UserId2]) REFERENCES [dbo].[Users] ([Id])
);

CREATE TABLE [dbo].[MessageAttachments] (
	[Id] INT IDENTITY(1, 1) NOT NULL,
	[MessageId] INT NOT NULL,
	[AttachmentType] TINYINT DEFAULT NULL,
	[AttachmentName] NVARCHAR(255) DEFAULT NULL,
	[Note] NVARCHAR(255) DEFAULT NULL,
	CONSTRAINT [PK_QueryAttachments_Id] PRIMARY KEY ([Id] ASC),
	CONSTRAINT [FK_MessageAttachment_Messages] FOREIGN KEY ([MessageId]) REFERENCES [dbo].[Messages] ([Id]) ON DELETE CASCADE
);