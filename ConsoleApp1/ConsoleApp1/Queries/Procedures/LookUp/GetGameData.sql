DROP PROCEDURE IF EXISTS gitSteamed.GetGameReviews
GO
DROP PROCEDURE IF EXISTS gitSteamed.GetGameBundles
GO
DROP PROCEDURE IF EXISTS gitSteamed.GetGameStats
GO

CREATE OR ALTER PROCEDURE gitSteamed.GetGameReviews
	@ItemID INT,
	@ResultCount INT,
	@PageNumber INT,
	@ReturnedCount INT OUTPUT
AS
	SET @ReturnedCount = (SELECT COUNT(*) FROM (SELECT R.ItemID FROM gitSteamed.Reviews R
								GROUP BY R.ItemID, R.[Description], Posted, LastEdited, R.Funny, R.Helpful, R.Recommend) R
							WHERE R.ItemID = @ItemID GROUP BY R.ItemID) 
	SELECT R.[Description], I.[Name] Game, FORMAT(R.Posted, N'MMMM dd, yyyy') PostedOn, FORMAT(R.LastEdited, N'MMMM dd, yyyy') LastEdited, 
		R.Funny, R.Helpful, R.Recommend
	FROM gitSteamed.Items I
		INNER JOIN gitSteamed.Reviews R ON I.ItemID = R.ItemID
	WHERE I.ItemID = @ItemID
	GROUP BY R.[Description], I.[Name], Posted, LastEdited, R.Funny, R.Helpful, R.Recommend
	ORDER BY R.LastEdited DESC
	OFFSET (@ResultCount*(@PageNumber-1)) ROWS FETCH NEXT (CASE WHEN (@ResultCount = 0) THEN @ReturnedCount ELSE @ResultCount END) ROWS ONLY
GO
CREATE OR ALTER PROCEDURE gitSteamed.GetGameBundles
	@ItemID INT,
	@ResultCount INT,
	@PageNumber INT,
	@ReturnedCount INT OUTPUT
AS
	SET @ReturnedCount = (SELECT COUNT(*) FROM gitSteamed.BundleContents WHERE ItemID = @ItemID)
	SELECT B.[Name], B.FinalPrice, B.DiscountPrice
	FROM gitSteamed.Items I
		INNER JOIN gitSteamed.BundleContents BC ON I.ItemID = BC.ItemID
		INNER JOIN gitSteamed.Bundles B ON B.BundleID = BC.BundleID
	WHERE I.ItemID = @ItemID
	ORDER BY B.[Name]
	OFFSET (@ResultCount*(@PageNumber-1)) ROWS FETCH NEXT (CASE WHEN (@ResultCount = 0) THEN @ReturnedCount ELSE @ResultCount END) ROWS ONLY
GO
CREATE OR ALTER PROCEDURE gitSteamed.GetGameStats
	@ItemdID NVARCHAR(64)
AS
	SELECT I.Price, COUNT(L.Username) UsersOwned, 
		SUM(CASE WHEN (L.TimePlayedForever != 0) THEN 1 ELSE 0 END) UsersPlayed,
		SUM(L.TimePlayedForever / 60) TotalPlayTimeForever, 
		SUM(L.TimePlayed2Weeks / 60) TotalPlayTime2Weeks
	FROM gitSteamed.Items I
		INNER JOIN gitSteamed.Libraries L ON I.ItemID = L.ItemID
	WHERE I.ItemID = @ItemdID
	GROUP BY I.ItemID, I.Price
GO

DECLARE @ResultCount INT
EXEC gitSteamed.GetGameReviews 10, 10, 6, @ResultCount OUTPUT
SELECT @ResultCount
EXEC gitSteamed.GetGameBundles 10, 10, 6, @ResultCount OUTPUT
SELECT @ResultCount
EXEC gitSteamed.GetGameStats 10
