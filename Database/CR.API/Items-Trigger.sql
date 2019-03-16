CREATE TRIGGER [Items_UpdatedOn]
	ON [dbo].[Items]
	AFTER UPDATE AS
		UPDATE [dbo].[Items]
        SET [Updatedon] = GETDATE()
        FROM Inserted I
        WHERE [dbo].[Items].[Id] = I.[Id]