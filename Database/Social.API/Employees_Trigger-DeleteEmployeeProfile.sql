CREATE TRIGGER [Employees_DeleteInstance]
	ON [SocialDb].[dbo].[Employees]
    FOR DELETE
	AS
		DELETE FROM [MainApiDb].[dbo].[Profiles]
        WHERE [MainApiDb].[dbo].[Profiles].[Id] IN (SELECT Deleted.ProfileId FROM Deleted)
    GO