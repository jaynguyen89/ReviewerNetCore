CREATE TRIGGER [Questions_UpdatedOn]
	ON [dbo].[Questions]
	AFTER UPDATE AS
		UPDATE [dbo].[Questions]
        SET [Updatedon] = GETDATE()
        FROM Inserted I
        WHERE [dbo].[Questions].[Id] = I.[Id]