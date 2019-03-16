CREATE TRIGGER [Messages_UpdatedOn]
	ON [MainApiDb].[dbo].[Messages]
	AFTER UPDATE AS
		UPDATE [dbo].[Messages]
        SET [Updatedon] = GETDATE()
        FROM Inserted I
        WHERE [dbo].[Messages].[Id] = I.[Id]