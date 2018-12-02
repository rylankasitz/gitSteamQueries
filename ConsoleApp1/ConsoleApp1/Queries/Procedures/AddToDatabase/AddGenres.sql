CREATE OR ALTER PROCEDURE gitSteamed.AddGenreToItem
	@GenreName NVARCHAR(32),
	@ItemID INT
AS
	WITH GenreName([Name]) AS (SELECT @GenreName)
	MERGE gitSteamed.Genres G
	USING GenreName N ON G.[Name] = N.[Name]
	WHEN NOT MATCHED THEN
		INSERT([Name])
		VALUES(N.[Name]);
	WITH tempTable(GenreID, ItemID) AS
	(	
		SELECT GenreID, @ItemID FROM gitSteamed.Genres WHERE [Name] = @GenreName
	)
	MERGE gitSteamed.ItemsGenreContents IG
	USING tempTable T ON T.GenreID = IG.GenreID and T.ItemID = IG.ItemID
	WHEN NOT MATCHED THEN
		INSERT (GenreID, ItemID)
		VALUES (T.GenreID, T.ItemID);
GO

EXEC gitSteamed.AddGenreToItem N'Software', 10
EXEC gitSteamed.AddGenreToItem N'Weeb', 333600
EXEC gitSteamed.GetGameGenres 333600