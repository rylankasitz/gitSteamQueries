DROP PROCEDURE IF EXISTS gitSteamed.GetGameReviews
GO
DROP PROCEDURE IF EXISTS gitSteamed.GetGameBundles
GO
DROP PROCEDURE IF EXISTS gitSteamed.GetGameUsers
GO
DROP PROCEDURE IF EXISTS gitSteamed.GetGameStats
GO
DROP PROCEDURE IF EXISTS gitSteamed.GetGameGenres
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
	SELECT R.[Description], R.Username, FORMAT(R.Posted, N'MMMM dd, yyyy') PostedOn, FORMAT(R.LastEdited, N'MMMM dd, yyyy') LastEdited, 
		R.Funny, R.Helpful, R.Recommend
	FROM gitSteamed.Items I
		INNER JOIN gitSteamed.Reviews R ON I.ItemID = R.ItemID
		INNER JOIN gitSteamed.Libraries L ON L.ItemID = I.ItemID
	WHERE I.ItemID = @ItemID AND R.ReviewID NOT IN (SELECT AR.ReviewID FROM gitSteamed.ArchivedReviews AR)
	GROUP BY R.[Description], R.Username, Posted, LastEdited, R.Funny, R.Helpful, R.Recommend
	ORDER BY R.Funny DESC, R.Helpful DESC, R.LastEdited DESC
	OFFSET (@ResultCount*(@PageNumber-1)) ROWS FETCH NEXT (CASE WHEN (@ResultCount = 0) THEN @ReturnedCount ELSE @ResultCount END) ROWS ONLY
GO
CREATE OR ALTER PROCEDURE gitSteamed.GetGameUsers
	@ItemID INT,
	@ResultCount INT,
	@PageNumber INT,
	@ReturnedCount INT OUTPUT
AS
	SET @ReturnedCount = (SELECT COUNT(*) FROM gitSteamed.Libraries WHERE ItemID = @ItemID)
	SELECT U.Username, (L.TimePlayedForever / 60) TimePlayedForever, (L.TimePlayed2Weeks / 60) TimePlayed2Weeks
	FROM gitSteamed.Users U 
		INNER JOIN gitSteamed.Libraries L ON U.Username = L.Username
	WHERE L.ItemID = @ItemID
	ORDER BY L.TimePlayedForever DESC, L.TimePlayed2Weeks DESC
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
	FROM gitSteamed.BundleContents BC 
		INNER JOIN gitSteamed.Bundles B ON B.BundleID = BC.BundleID
	WHERE BC.ItemID = @ItemID
	ORDER BY B.[Name]
	OFFSET (@ResultCount*(@PageNumber-1)) ROWS FETCH NEXT (CASE WHEN (@ResultCount = 0) THEN @ReturnedCount ELSE @ResultCount END) ROWS ONLY
GO
CREATE OR ALTER PROCEDURE gitSteamed.GetGameStats
	@ItemID NVARCHAR(64)
AS
	SELECT I.Price, COUNT(L.Username) UsersOwned, 
		SUM(CASE WHEN (L.TimePlayedForever != 0) THEN 1 ELSE 0 END) UsersPlayed,
		SUM(CASE WHEN (L.TimePlayed2Weeks != 0) THEN 1 ELSE 0 END) UsersActive,
		SUM(L.TimePlayedForever / 60) TotalPlayTimeForever, 
		SUM(L.TimePlayed2Weeks / 60) TotalPlayTime2Weeks, I.[URL]
	FROM gitSteamed.Items I
		INNER JOIN gitSteamed.Libraries L ON I.ItemID = L.ItemID 
	WHERE I.ItemID = @ItemID
	GROUP BY I.ItemID, I.Price, I.[URL]
GO
CREATE OR ALTER PROCEDURE gitSteamed.GetGameGenres
	@ItemID NVARCHAR(64)
AS
	SELECT G.[Name]
	FROM gitSteamed.ItemsGenreContents IC
		INNER JOIN gitSteamed.Genres G ON G.GenreID = IC.GenreID
	WHERE IC.ItemID = @ItemID
	ORDER BY G.[Name]
GO

DECLARE @ResultCount INT
EXEC gitSteamed.GetGameReviews 20, 60, 1, @ResultCount OUTPUT
SELECT @ResultCount
EXEC gitSteamed.GetGameUsers 20, 10, 1, @ResultCount OUTPUT
SELECT @ResultCount
EXEC gitSteamed.GetGameBundles 20, 6, 1, @ResultCount OUTPUT
SELECT @ResultCount
EXEC gitSteamed.GetGameStats 20
EXEC gitSteamed.GetGameGenres 20