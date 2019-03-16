CREATE TRIGGER [UserRankings_UpdatedOn]
	ON [MainApiDb].[dbo].[UserRankings]
	AFTER UPDATE AS
		UPDATE [dbo].[UserRankings]
        SET [Updatedon] = GETDATE()
        FROM Inserted I
        WHERE [dbo].[UserRankings].[Id] = I.[Id]