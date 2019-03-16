CREATE TRIGGER [UserConnections_UpdatedOn]
	ON [MainApiDb].[dbo].[UserConnections]
	AFTER UPDATE AS
		UPDATE [dbo].[UserConnections]
        SET [Updatedon] = GETDATE()
        FROM Inserted I
        WHERE [dbo].[UserConnections].[Id] = I.[Id]