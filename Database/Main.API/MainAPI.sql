CREATE TABLE [dbo].[Locations] (
	[Id]                INT IDENTITY(1, 1)  NOT NULL,
    [BuildingName]      NVARCHAR(50)        DEFAULT NULL,
	[BuildingAddress]   NVARCHAR(50)        DEFAULT NULL,
	[StreetAddress]     NVARCHAR(50)        DEFAULT NULL,
    [City_District]     NVARCHAR(50)        DEFAULT NULL,
    [Province_State]    NVARCHAR(50)        DEFAULT NULL,
    [Suburb_Ward]       NVARCHAR(50)        DEFAULT NULL,
	[Postcode]          NVARCHAR(10)        DEFAULT NULL,
    [Country]           NVARCHAR(50)        DEFAULT NULL,
    [CountryCode]       NVARCHAR(10)        DEFAULT NULL,
	[FormerAddress]     NVARCHAR(150)       DEFAULT NULL,
	[Description]       NVARCHAR(200)       DEFAULT NULL,
    [AvatarName]        NVARCHAR(450)       DEFAULT NULL,
    [CombinedAddress]   NVARCHAR(450)       DEFAULT NULL,
    [SimpleAddress]     NVARCHAR(200)       DEFAULT NULL,
	CONSTRAINT [PK_Locations_Id] PRIMARY KEY ([Id] ASC)
);

-- Profiles are personal information and biography that are created for Users and CompanyOwners
CREATE TABLE [dbo].[Profiles] (
    [Id]                INT IDENTITY(1, 1)  NOT NULL,
    [IsUserProfile]     BIT                 DEFAULT 0,
    [POD_LocationId]    INT                 DEFAULT NULL,
    [POB_LocationId]    INT                 DEFAULT NULL,
    [RestingPlaceId]    INT                 DEFAULT NULL,
    -- Store data in JSON format: {"PlaceName":"", "LocationId":"", "MovedInFrom":"", "Description":"", "SignificantEvents":{"EventTitle":"", "EventDetail":""}}
    [PlacesOfLiving]    NVARCHAR(4000)      DEFAULT NULL,
    -- Store data in JSON format: {"Name":"", "Description":""}
    [OtherNames]        NVARCHAR(1000)      DEFAULT NULL,
    -- Store data in JSON format: {"MotherName":"ProfileId", "FatherName":"ProfileId"}
    [ParentsName]       NVARCHAR(150)       DEFAULT NULL,
    -- Store data in JSON format: {"Event":"Description"}
    [HighLights]        NVARCHAR(4000)      DEFAULT NULL,
    -- Store data in JSON format: {"PersonName":{"ProfileId":"", "Relation":"", "RelationFrom":"", "RelationTo":"", "Children":{"ChildName":"", "ProfileId":""}}}
    [Relationships]     NVARCHAR(4000)      DEFAULT NULL,
    -- Store data in JSON format: {"ProgramName":{"University":"", "Faculty":"", "StartedOn":"", "CompletedOn":"", "Achievements":{"Title":"", "Description":"", "ObtainedOn":""}}}
    [Education]         NVARCHAR(4000)      DEFAULT NULL,
    -- Store data in JSON format: {"Language":"Fluency"}
    [Languages]         NVARCHAR(1000)      DEFAULT NULL,
    -- Store data in JSON format: {"CompanyId":{"PositionTitle":"", "WorkFrom":"", "WorkUntil":"", "Notes":""}}
    [WorkHistory]       NVARCHAR(4000)      DEFAULT NULL,
    [FirstName]         NVARCHAR(50)        DEFAULT NULL,
    [MiddleName]        NVARCHAR(50)        DEFAULT NULL,
    [GiveName]          NVARCHAR(50)        DEFAULT NULL,
    [PhoneNumber]       NVARCHAR(30)        DEFAULT NULL,
    [AvatarName]        NVARCHAR(450)       DEFAULT NULL,
    [AvatarTitle]       NVARCHAR(100)       DEFAULT NULL,
    [FacebookProfile]   NVARCHAR(200)       DEFAULT NULL,
    [TwitterProfile]    NVARCHAR(200)       DEFAULT NULL,
    [BlogLink]          NVARCHAR(200)       DEFAULT NULL,
    [DateOfBirth]       DATETIME2 (7)       DEFAULT NULL,
    [DateOfDeath]       DATETIME2 (7)       DEFAULT NULL,
    [CauseOfDeath]      NVARCHAR(100)       DEFAULT NULL,
    -- Store data in JSON format: {"CompanyName":"Occupation"}
    [Occupations]       NVARCHAR(1000)      DEFAULT NULL,
    -- Store data in JSON format: {"Notoriety":"Quote"}
    [FavoriteQuotes]    NVARCHAR(1000)      DEFAULT NULL,
    -- Store all data as plain texts
    [ProfileContent]    NVARCHAR(4000)      DEFAULT NULL,
    [CreatedOn]         DATETIME2 (7)       DEFAULT (GETDATE()) NOT NULL,
    -- If this is not a user's profile, then JSON format: {"UserId":{"UpdateOn":"", "Reason":""}}
    -- If this is a user's profile, then store Datetime in string format in this tuple. No trigger.
    [UpdateRecords]     NVARCHAR(4000)      DEFAULT NULL,
    CONSTRAINT [PK_Profiles_Id] PRIMARY KEY ([Id] ASC),
    CONSTRAINT [FK_Profiles_Locations_POD] FOREIGN KEY ([POD_LocationId]) REFERENCES [dbo].[Locations] ([Id]),
    CONSTRAINT [FK_Profiles_Locations_POB] FOREIGN KEY ([POB_LocationId]) REFERENCES [dbo].[Locations] ([Id]),
    CONSTRAINT [FK_Profiles_Locations_RIP] FOREIGN KEY ([RestingPlaceId]) REFERENCES [dbo].[Locations] ([Id])
);

CREATE TABLE [dbo].[Users] (
	[Id]		INT IDENTITY(1, 1)	NOT NULL,
    [LocationId]    INT             DEFAULT NULL,
    [ProfileId]     INT             DEFAULT NULL,
	[Username]  NVARCHAR(30)        NOT NULL,
    [Email]     NVARCHAR(100)       NOT NULL,
    [PasswordHash]  NVARCHAR(450)       NOT NULL,
    [PasswordSalt]  NVARCHAR(450)   NOT NULL,
    -- Forgotten password recovery
    [PasswordToken]  NVARCHAR(450)   DEFAULT NULL,
    [EmailToken]  NVARCHAR(450)   DEFAULT NULL,
    [IsEmailConfirmed]  BIT         DEFAULT 0,
    [PhoneNumber]   NVARCHAR(30)    DEFAULT NULL,
    [IsPhoneConfirmed]  BIT         DEFAULT 0,
    -- Two-Factors Authentication
    [Is2FAEnabled]      BIT         DEFAULT 0,
    -- Not set (0), (1) Via Email, (2) Via Phone, (3) Via SMS
    [TwoFADestination]  TINYINT     DEFAULT 0,
    [TwoFAToken]    NVARCHAR(450)   DEFAULT NULL,
    [TwoFATokenSentOn]  DATETIME2 (7)   DEFAULT NULL,
    [FamilyName]    NVARCHAR(50)    DEFAULT NULL,
    [MiddleName]    NVARCHAR(50)    DEFAULT NULL,
    [GiveName]      NVARCHAR(50)    DEFAULT NULL,
    [DateOfBirth]    DATETIME2 (7)   DEFAULT NULL,
    [Headline]      NVARCHAR(150)   DEFAULT NULL,
    -- Avatar uploaded by user, if null, use Gravatar instead
    [AvatarName]    NVARCHAR(450)   DEFAULT NULL,
    [IsActive]      BIT             DEFAULT 1,
    [LastLogin]     DATETIME2 (7)   DEFAULT NULL,
    [LastActive]    DATETIME2 (7)   DEFAULT NULL,
    -- Store data in JSON format: {"password hash": {"salt string":"", "set date":""}}
    [OldPasswords]  NVARCHAR(1000)  DEFAULT NULL,
    [LoginFailedCount]  TINYINT     DEFAULT 0,
    [IsLocked]      BIT             DEFAULT 0,
    [LockedOn]      DATETIME2 (7)   DEFAULT NULL,
    [LockDuration]  SMALLINT        DEFAULT 0,
    [CreatedOn]     DATETIME2 (7)   DEFAULT (GETDATE()) NOT NULL,
    [UpdatedOn]     DATETIME2 (7)   DEFAULT NULL,
    CONSTRAINT [PK_Users_Id] PRIMARY KEY ([Id] ASC),
    CONSTRAINT [FK_Users_Profiles] FOREIGN KEY ([ProfileId]) REFERENCES [dbo].[Profiles] ([Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_Users_Locations] FOREIGN KEY ([LocationId]) REFERENCES [dbo].[Locations] ([Id])
);

CREATE TABLE [dbo].[UserConnections] (
	[Id]		        INT IDENTITY(1, 1)	NOT NULL,
	[RequesterId]       INT                 NOT NULL,
	[ReceiverId]        INT                 NOT NULL,
	[IsAccepted]	    BIT                 DEFAULT 0,
	[Message]           NVARCHAR(250)       DEFAULT NULL,
	[CreatedOn]         DATETIME2 (7)       DEFAULT (GETDATE()) NOT NULL,
	[UpdatedOn]         DATETIME2 (7)       DEFAULT NULL,
	CONSTRAINT [PK_UserConnections_Id] PRIMARY KEY ([Id] ASC),
	CONSTRAINT [FK_UserConnections_Users_RequesterId] FOREIGN KEY ([RequesterId]) REFERENCES [dbo].[Users] ([Id]),
	CONSTRAINT [FK_UserConnections_Users_ReceiverId] FOREIGN KEY ([ReceiverId]) REFERENCES [dbo].[Users] ([Id])
);

CREATE TABLE [dbo].[Blockings] (
	[Id]                INT IDENTITY(1, 1)  NOT NULL,
	[BlockerId]         INT                 NOT NULL,
	[BlockedId]         INT                 NOT NULL,
	[CreatedOn]         DATETIME2 (7)       DEFAULT (GETDATE()) NOT NULL,
	CONSTRAINT [PK_Blockings_Id] PRIMARY KEY ([Id] ASC),
	CONSTRAINT [FK_Blockings_Users_BlockerId] FOREIGN KEY ([BlockerId]) REFERENCES [dbo].[Users] ([Id]),
	CONSTRAINT [FK_Blockings_Users_BlockedId] FOREIGN KEY ([BlockedId]) REFERENCES [dbo].[Users] ([Id])
);

https://localhost:5001/Account/ActivateAccount?EmailToken=77781841A2EAFA72B9600A07367896A9&UserEmail=love.achay@gmail.com