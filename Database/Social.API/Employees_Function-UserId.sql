CREATE FUNCTION [dbo].[FnCheck_Employees_UserId] (@UserId INT = 0)
RETURNS BIT AS
    BEGIN
        DECLARE @RET BIT;
		SET @RET = 0;

		IF EXISTS (SELECT P.[Id] AS ID FROM [MainApiDb].[dbo].[Users] P WHERE ID = @UserId)
			BEGIN SET @RET = 1; END

		RETURN @RET;
    END