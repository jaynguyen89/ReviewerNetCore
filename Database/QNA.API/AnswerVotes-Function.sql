CREATE FUNCTION [dbo].[FnCheck_AnswerVotes_UserId] (@UserId NVARCHAR(450) = '')
RETURNS BIT AS
    BEGIN
        DECLARE @RET BIT;
		SET @RET = 0;

		IF EXISTS (SELECT A.[Id] AS ID FROM [MainApiDb].[dbo].[AspNetUsers] A WHERE ID = @UserId)
			BEGIN SET @RET = 1; END

		RETURN @RET;
    END