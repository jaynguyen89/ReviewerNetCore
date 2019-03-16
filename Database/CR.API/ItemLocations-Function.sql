CREATE FUNCTION [dbo].[FnCheck_ItemLocations_LocationId] (@LocationId INT = 0)
RETURNS BIT AS
    BEGIN
        DECLARE @RET BIT;
		SET @RET = 0;

		IF EXISTS (SELECT A.[Id] AS ID FROM [MainApiDb].[dbo].[Locations] A WHERE ID = @LocationId)
			BEGIN SET @RET = 1; END

		RETURN @RET;
    END