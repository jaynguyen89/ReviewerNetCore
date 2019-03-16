CREATE TABLE [dbo].[Categories] (
    [Id] INT IDENTITY(1, 1) NOT NULL,
    [CategoryName] NVARCHAR(100) DEFAULT NULL,
    [Description] NVARCHAR(255) DEFAULT NULL,
    [IsActive] BIT DEFAULT 1,
    CONSTRAINT [PK_Categories_Id] PRIMARY KEY ([Id] ASC)
);

CREATE TABLE [dbo].[Subcategories] (
    [Id] INT IDENTITY(1, 1) NOT NULL,
    [CategoryId] INT NOT NULL,
    [SubcategoryName] NVARCHAR(100) DEFAULT NULL,
    [Description] NVARCHAR(255) DEFAULT NULL,
    [IsActive] BIT DEFAULT 1,
    CONSTRAINT [PK_Subcategories_id] PRIMARY KEY ([Id] ASC),
    CONSTRAINT [FK_Subcategories_Categories] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[Categories] ([Id])
);

CREATE TABLE [dbo].[Questions] (
    [Id] INT IDENTITY(1, 1) NOT NULL,
    [UserId] NVARCHAR(450) DEFAULT NULL,
    [SubcategoryId] INT NOT NULL,
    [Title] NVARCHAR(100) DEFAULT NULL,
    [Content] NVARCHAR(4000) DEFAULT NULL,
    [IsActive] BIT DEFAULT 1,
    [CreatedOn] DATETIME2 (7) DEFAULT (GETDATE()) NOT NULL,
    [UpdatedOn] DATETIME2 (7) DEFAULT NULL,
    [UpdatedReason] NVARCHAR(100) DEFAULT NULL,
    CONSTRAINT [PK_Questions_Id] PRIMARY KEY ([Id] ASC),
    CONSTRAINT [FK_Questions_Subcategories] FOREIGN KEY ([SubcategoryId]) REFERENCES [dbo].[Subcategories] ([Id])
);

ALTER TABLE [dbo].[Questions] ADD CONSTRAINT CHECK_Questions_UserId CHECK([dbo].[FnCheck_Questions_UserId](UserId)=1);

CREATE TABLE [dbo].[QuestionAttachments] (
    [Id] INT IDENTITY(1, 1) NOT NULL,
    [QuestionId] INT NOT NULL,
    [AttachmentType] TINYINT DEFAULT NULL,
    [AttachmentName] NVARCHAR(255) DEFAULT NULL,
    [Note] NVARCHAR(100) DEFAULT NULL,
    CONSTRAINT [PK_QuestionAttachments_Id] PRIMARY KEY ([Id] ASC),
    CONSTRAINT [FK_QuestionAttachments_Questions] FOREIGN KEY ([QuestionId]) REFERENCES [dbo].[Questions] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [dbo].[QuestionVotes] (
    [Id] INT IDENTITY(1, 1) NOT NULL,
    [QuestionId] INT NOT NULL,
    [UserId] NVARCHAR(450) DEFAULT NULL,
    [VoteSign] BIT DEFAULT NULL,
    [UpdatedOn] DATETIME2 (7) DEFAULT NULL,
    CONSTRAINT [PK_QuestionVotes_Id] PRIMARY KEY ([Id] ASC),
    CONSTRAINT [FK_QuestionVotes_Questions] FOREIGN KEY ([QuestionId]) REFERENCES [dbo].[Questions] ([Id]) ON DELETE CASCADE
);

ALTER TABLE [dbo].[QuestionVotes] ADD CONSTRAINT CHECK_QuestionVotes_UserId CHECK([dbo].[FnCheck_QuestionVotes_UserId](UserId)=1);

CREATE TABLE [dbo].[Answers] (
    [Id] INT IDENTITY(1, 1) NOT NULL,
    [QuestionId] INT NOT NULL,
    [UserId] NVARCHAR(450) DEFAULT NULL,
    [Content] NVARCHAR(1000) DEFAULT NULL,
    [CreatedOn] DATETIME2 (7) DEFAULT (GETDATE()) NOT NULL,
    [UpdatedOn] DATETIME2 (7) DEFAULT NULL,
    [UpdatedReason] NVARCHAR(100) DEFAULT NULL,
    [IsActive] BIT DEFAULT 1,
    [IsSelected] BIT DEFAULT NULL,
    CONSTRAINT [PK_Answers_Id] PRIMARY KEY ([Id] ASC),
    CONSTRAINT [FK_Answers_Questions] FOREIGN KEY ([QuestionId]) REFERENCES [dbo].[Questions] ([Id]) ON DELETE CASCADE
);

ALTER TABLE [dbo].[Answers] ADD CONSTRAINT CHECK_Answers_UserId CHECK([dbo].[FnCheck_Answers_UserId](UserId)=1);

CREATE TABLE [dbo].[AnswerVotes] (
    [Id] INT IDENTITY(1, 1) NOT NULL,
    [AnswerId] INT NOT NULL,
    [UserId] NVARCHAR(450) DEFAULT NULL,
    [VoteSign] BIT DEFAULT NULL,
    [UpdatedOn] DATETIME2 (7) DEFAULT NULL,
    CONSTRAINT [PK_AnswerVotes_Id] PRIMARY KEY ([Id] ASC),
    CONSTRAINT [FK_AnswerVotes_Answers] FOREIGN KEY ([AnswerId]) REFERENCES [dbo].[Answers] ([Id]) ON DELETE CASCADE
);

ALTER TABLE [dbo].[AnswerVotes] ADD CONSTRAINT CHECK_AnswerVotes_UserId CHECK([dbo].[FnCheck_AnswerVotes_UserId](UserId)=1);

CREATE TABLE [dbo].[AnswerAttachments] (
    [Id] INT IDENTITY(1, 1) NOT NULL,
    [AnswerId] INT NOT NULL,
    [AttachmentType] TINYINT DEFAULT NULL,
    [AttachmentName] NVARCHAR(255) DEFAULT NULL,
    [Note] NVARCHAR(100) DEFAULT NULL,
    CONSTRAINT [PK_AnswerAttachments_Id] PRIMARY KEY ([Id] ASC),
    CONSTRAINT [FK_AnswerAttachments_Answers] FOREIGN KEY ([AnswerId]) REFERENCES [dbo].[Answers] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [dbo].[AnswerInclusions] (
    [Id] INT IDENTITY(1, 1) NOT NULL,
    [AnswerId1] INT NOT NULL,
    [AnswerId2] INT NOT NULL,
    CONSTRAINT [PK_AnswerInclusions_Id] PRIMARY KEY ([Id] ASC),
    CONSTRAINT [FK_AnswerInclusions_Answers1] FOREIGN KEY ([AnswerId1]) REFERENCES [dbo].[Answers] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_AnswerInclusions_Answers2] FOREIGN KEY ([AnswerId2]) REFERENCES [dbo].[Answers] ([Id]) ON DELETE CASCADE
);