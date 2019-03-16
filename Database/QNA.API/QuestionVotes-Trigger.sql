CREATE TRIGGER [QuestionVotes_UpdatedOn]
	ON [dbo].[QuestionVotes]
	AFTER UPDATE AS
		UPDATE [dbo].[QuestionVotes]
        SET [Updatedon] = GETDATE()
        FROM Inserted I
        WHERE [dbo].[QuestionVotes].[Id] = I.[Id]