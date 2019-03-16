CREATE TRIGGER [CompanyCultureRatings_UpdatedOn]
	ON [SocialDb].[dbo].[CompanyCultureRatings]
	AFTER UPDATE AS
		UPDATE [dbo].[CompanyCultureRatings]
        SET [Updatedon] = GETDATE()
        FROM Inserted I
        WHERE [dbo].[CompanyCultureRatings].[Id] = I.[Id]