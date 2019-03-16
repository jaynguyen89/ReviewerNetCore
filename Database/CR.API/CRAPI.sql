CREATE TABLE [dbo].[Items] (
    [Id] INT IDENTITY(1, 1) NOT NULL,
    [UserId] NVARCHAR(450) DEFAULT NULL,
    [SubcategoryId] INT DEFAULT NULL,
    [ItemName] NVARCHAR(100) DEFAULT NULL,
    [Description] NVARCHAR(2000) DEFAULT NULL,
    [IsActive] BIT DEFAULT 1,
    [CreatedOn] DATETIME2 (7) DEFAULT (GETDATE()) NOT NULL,
    [UpdatedOn] DATETIME2 (7) DEFAULT NULL,
    [UpdateReason] NVARCHAR(100) DEFAULT NULL,
    CONSTRAINT [PK_Items_Id] PRIMARY KEY ([Id] ASC),
);

ALTER TABLE [dbo].[Items] ADD CONSTRAINT CHECK_Items_UserId CHECK([dbo].[FnCheck_Items_UserId](UserId)=1);

ALTER TABLE [dbo].[Items] ADD CONSTRAINT CHECK_Items_SubcategoryId CHECK([dbo].[FnCheck_Items_SubcategoryId](SubcategoryId)=1);

CREATE TABLE [dbo].[ItemLocations] (
    [Id] INT IDENTITY(1, 1) NOT NULL,
    [ItemId] INT NOT NULL,
    [LocationId] INT DEFAULT NULL,
    CONSTRAINT [PK_ItemLocations_Id] PRIMARY KEY ([Id] ASC),
    CONSTRAINT [FK_ItemLocations_Items] FOREIGN KEY ([ItemId]) REFERENCES [dbo].[Items] ([Id]) ON DELETE CASCADE
);

ALTER TABLE [dbo].[ItemLocations] ADD CONSTRAINT CHECK_ItemLocations_LocationId CHECK([dbo].[FnCheck_ItemLocations_LocationId](LocationId)=1);

CREATE TABLE [dbo].[Ratings] (
    [Id] INT IDENTITY(1, 1) NOT NULL,
    [ItemId] INT NOT NULL,
    [UserId] NVARCHAR(450) DEFAULT NULL,
    [Rating] TINYINT DEFAULT NULL,
    [CreatedOn] DATETIME2 (7) DEFAULT (GETDATE()) NOT NULL,
    [UpdatedOn] DATETIME2 (7) DEFAULT NULL,
    [IsActive] BIT DEFAULT 1,
    CONSTRAINT [PK_Ratings_Id] PRIMARY KEY ([Id] ASC),
    CONSTRAINT [FK_Ratings_Items] FOREIGN KEY ([ItemId]) REFERENCES [dbo].[Items] ([Id]) ON DELETE CASCADE
);

ALTER TABLE [dbo].[Ratings] ADD CONSTRAINT CHECK_Ratings_UserId CHECK([dbo].[FnCheck_Ratings_UserId](UserId)=1);

CREATE TABLE [dbo].[ItemInterests] (
    [Id] INT IDENTITY(1, 1) NOT NULL,
    [ItemId] INT NOT NULL,
    [UserId] NVARCHAR(450) DEFAULT NULL,
    [CreatedOn] DATETIME2 (7) DEFAULT (GETDATE()) NOT NULL,
    CONSTRAINT [PK_ItemInterests_Id] PRIMARY KEY ([Id] ASC),
    CONSTRAINT [FK_ItemInterests_Items] FOREIGN KEY ([ItemId]) REFERENCES [dbo].[Items] ([Id]) ON DELETE CASCADE
 );

ALTER TABLE [dbo].[ItemInterests] ADD CONSTRAINT CHECK_ItemInterests_UserId CHECK([dbo].[FnCheck_ItemInterests_UserId](UserId)=1);