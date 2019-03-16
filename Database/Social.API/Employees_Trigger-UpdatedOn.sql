CREATE TRIGGER [Employees_UpdatedOn]
	ON [SocialDb].[dbo].[Employees]
	AFTER UPDATE AS
		UPDATE [dbo].[Employees]
        SET [Updatedon] = GETDATE()
        FROM Inserted I
        WHERE [dbo].[Employees].[Id] = I.[Id]