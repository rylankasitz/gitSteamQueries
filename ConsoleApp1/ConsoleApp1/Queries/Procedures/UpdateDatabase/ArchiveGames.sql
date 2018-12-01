DROP PROCEDURE IF EXISTS gitSteamed.ArchiveItem
GO

CREATE OR ALTER PROCEDURE gitSteamed.ArchiveItem
	@ItemId INT
AS
	WITH ItemCTE(ItemId, Genre, Price, [Url], [Name]) AS (
		SELECT I.ItemID, I.Genre, I.Price, I.URL, I.Name
		FROM gitSteamed.Items I
		WHERE I.ItemID = @ItemId
	)
	MERGE gitSteamed.ArchivedItems AI
	USING ItemCTE C ON C.ItemId = AI.ItemId
	WHEN NOT MATCHED THEN
		INSERT (ItemId, Genre, Price, [Url], [Name])
		VALUES(C.ItemId, C.Genre, C.Price, C.[Url], C.[Name]);
GO
