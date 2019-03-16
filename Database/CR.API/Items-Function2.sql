CREATE FUNCTION [dbo].[FnCheck_Items_SubcategoryId] (@SubcategoryId INT = 0)
RETURNS BIT AS
    BEGIN
        DECLARE @RET BIT;
		SET @RET = 0;

		IF EXISTS (SELECT A.[Id] AS ID FROM [QaApiDb].[dbo].[Subcategories] A WHERE ID = @SubcategoryId)
			BEGIN SET @RET = 1; END

		RETURN @RET;
    END