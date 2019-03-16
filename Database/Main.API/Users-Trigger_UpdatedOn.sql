CREATE TRIGGER [Users_UpdatedOn]
	ON [MainApiDb].[dbo].[Users]
	AFTER UPDATE AS
		UPDATE [dbo].[Users]
        SET [Updatedon] = GETDATE()
        FROM Inserted I
        WHERE [dbo].[Users].[Id] = I.[Id]