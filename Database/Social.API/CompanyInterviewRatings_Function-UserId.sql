CREATE FUNCTION [dbo].[FnCheck_CompanyInterviewRatings_UserId] (@UserId INT = 0)
RETURNS BIT AS
    BEGIN
        DECLARE @RET BIT;
		SET @RET = 0;

		IF EXISTS (SELECT U.[Id] AS ID FROM [MainApiDb].[dbo].[Users] U
                                       WHERE ID = @UserId
                                       AND U.[IsActive] = 1)
			BEGIN SET @RET = 1; END

		RETURN @RET;
    END