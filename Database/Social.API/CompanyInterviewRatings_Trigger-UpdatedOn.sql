CREATE TRIGGER [CompanyInterviewRatings_UpdatedOn]
	ON [SocialDb].[dbo].[CompanyInterviewRatings]
	AFTER UPDATE AS
		UPDATE [dbo].[CompanyInterviewRatings]
        SET [Updatedon] = GETDATE()
        FROM Inserted I
        WHERE [dbo].[CompanyInterviewRatings].[Id] = I.[Id]