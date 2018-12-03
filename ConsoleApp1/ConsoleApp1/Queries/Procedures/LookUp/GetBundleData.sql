DROP PROCEDURE IF EXISTS gitSteamed.GetBundleGames
GO
DROP PROCEDURE IF EXISTS gitSteamed.GetBundleStats
GO
DROP PROCEDURE IF EXISTS gitSteamed.GetBundleGenreLayout
GO

CREATE OR ALTER PROCEDURE gitSteamed.GetBundleGames
	@BundleID INT
AS
	SELECT I.ItemID, I.[Name], I.Price, I.[URL]
	FROM gitSteamed.BundleContents BC
		INNER JOIN gitSteamed.Items I ON I.ItemID = BC.ItemID
	WHERE BC.BundleID = @BundleID
	ORDER BY I.[Price], I.[Name]
GO
CREATE OR ALTER PROCEDURE gitSteamed.GetBundleStats
	@BundleID INT
AS 
	SELECT B.[Name], B.FinalPrice, B.DiscountPrice, B.[URL], COUNT(BC.ItemID) GameCount
	FROM gitSteamed.Bundles B
		INNER JOIN gitSteamed.BundleContents BC ON BC.BundleID = B.BundleID
	WHERE B.BundleID = @BundleID
	GROUP BY B.[Name], B.FinalPrice, B.DiscountPrice, B.[URL]
GO
CREATE OR ALTER PROCEDURE gitSteamed.GetBundleGenreLayout
	@BundleID INT
AS 
	SELECT G.[Name], COUNT(*) Counts
	FROM gitSteamed.BundleContents BC
		INNER JOIN gitSteamed.Items I ON I.ItemID = BC.ItemID
		INNER JOIN gitSteamed.ItemsGenreContents IG ON IG.ItemID = I.ItemID
		INNER JOIN gitSteamed.Genres G ON G.GenreID = IG.GenreID
	WHERE BC.BundleID = @BundleID
	GROUP BY IG.GenreID, G.[Name]
GO


EXEC gitSteamed.GetBundleGames 268
EXEC gitSteamed.GetBundleStats 268
EXEC gitSteamed.GetBundleGenreLayout 268