CREATE FUNCTION [dbo].[FnCheck_Companies_LocationId] (@LocationId INT = 0)
RETURNS BIT AS
    BEGIN
        DECLARE @RET BIT;
		SET @RET = 0;

		IF EXISTS (SELECT L.[Id] AS ID FROM [MainApiDb].[dbo].[Locations] L WHERE ID = @LocationId)
			BEGIN SET @RET = 1; END

		RETURN @RET;
    END