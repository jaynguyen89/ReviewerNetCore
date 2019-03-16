CREATE FUNCTION [dbo].[FnCheck_Employees_ProfileId] (@ProfileId INT = 0)
RETURNS BIT AS
    BEGIN
        DECLARE @RET BIT;
		SET @RET = 0;

		IF EXISTS (SELECT P.[Id] AS ID FROM [MainApiDb].[dbo].[Profiles] P WHERE ID = @ProfileId)
			BEGIN SET @RET = 1; END

		RETURN @RET;
    END