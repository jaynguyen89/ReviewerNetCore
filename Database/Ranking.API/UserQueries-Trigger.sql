CREATE TRIGGER [UserQueries_UpdatedOn]
	ON [MainApiDb].[dbo].[UserQueries]
	AFTER UPDATE AS
		UPDATE [dbo].[UserQueries]
        SET [Updatedon] = GETDATE()
        FROM Inserted I
        WHERE [dbo].[UserQueries].[Id] = I.[Id]