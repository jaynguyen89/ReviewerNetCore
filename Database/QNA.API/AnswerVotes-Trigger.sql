CREATE TRIGGER [AnswerVotes_UpdatedOn]
	ON [dbo].[AnswerVotes]
	AFTER UPDATE AS
		UPDATE [dbo].[AnswerVotes]
        SET [Updatedon] = GETDATE()
        FROM Inserted I
        WHERE [dbo].[AnswerVotes].[Id] = I.[Id]