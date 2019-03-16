CREATE TRIGGER [Answers_UpdatedOn]
	ON [dbo].[Answers]
	AFTER UPDATE AS
		UPDATE [dbo].[Answers]
        SET [Updatedon] = GETDATE()
        FROM Inserted I
        WHERE [dbo].[Answers].[Id] = I.[Id]