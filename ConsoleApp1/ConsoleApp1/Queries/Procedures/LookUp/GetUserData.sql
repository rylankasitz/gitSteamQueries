DROP PROCEDURE IF EXISTS gitSteamed.GetUserReviews
GO
DROP PROCEDURE IF EXISTS gitSteamed.GetUserGames
GO
DROP PROCEDURE IF EXISTS gitSteamed.GetUserPlaytime
GO

CREATE OR ALTER PROCEDURE gitSteamed.GetUserReviews
	@Username NVARCHAR(64),
	@ResultCount INT,
	@PageNumber INT,
	@ReturnedCount INT OUTPUT
AS
	SET @ReturnedCount = (SELECT COUNT(*) FROM (SELECT R.Username FROM gitSteamed.Reviews R
									GROUP BY R.Username, R.[Description], Posted, LastEdited, R.Funny, R.Helpful, R.Recommend) R
							WHERE R.Username = @Username GROUP BY R.Username) 
	SELECT R.[Description], I.[Name] Game, FORMAT(R.Posted, N'MMMM dd, yyyy') PostedOn, FORMAT(R.LastEdited, N'MMMM dd, yyyy') LastEdited, 
		R.Funny, R.Helpful, R.Recommend, R.ItemID
	FROM gitSteamed.Users U
		INNER JOIN gitSteamed.Reviews R ON U.Username = R.Username
		INNER JOIN gitSteamed.Items I ON I.ItemID = R.ItemID
	WHERE U.Username = @Username AND R.ReviewID NOT IN (SELECT AR.ReviewID FROM gitSteamed.ArchivedReviews AR)
	GROUP BY R.[Description], I.[Name], Posted, LastEdited, R.Funny, R.Helpful, R.Recommend, R.ItemID
	ORDER BY R.LastEdited DESC
	OFFSET (@ResultCount*(@PageNumber-1)) ROWS FETCH NEXT (CASE WHEN (@ResultCount = 0) THEN @ReturnedCount ELSE @ResultCount END) ROWS ONLY
GO
CREATE OR ALTER PROCEDURE gitSteamed.GetUserGames
	@Username NVARCHAR(64),
	@ResultCount INT,
	@PageNumber INT,
	@ReturnedCount INT OUTPUT
AS
	SET @ReturnedCount = (SELECT COUNT(*) FROM gitSteamed.Libraries L WHERE L.Username = @Username GROUP BY L.Username)
	SELECT I.ItemID, I.[Name], (L.TimePlayedForever / 60) TotalPlayTime, (L.TimePlayed2Weeks / 60) Week2PlayTime
	FROM gitSteamed.Users U
		INNER JOIN gitSteamed.Libraries L ON L.Username = U.Username
		INNER JOIN gitSteamed.Items I ON I.ItemID = L.ItemID
	WHERE U.Username = @Username 
	ORDER BY L.TimePlayedForever DESC, L.TimePlayed2Weeks DESC, I.[Name] ASC
	OFFSET (@ResultCount*(@PageNumber-1)) ROWS FETCH NEXT (CASE WHEN (@ResultCount = 0) THEN @ReturnedCount ELSE @ResultCount END) ROWS ONLY
GO
CREATE OR ALTER PROCEDURE gitSteamed.GetUserStats
	@Username NVARCHAR(64)
AS
	SELECT (SUM(L.TimePlayedForever) / 60) TotalPlayTime, (SUM(L.TimePlayed2Weeks) / 60) PlayTime2Weeks,
		P.ReviewCount, P.FunnyCount, P.HelpfulCount, P.RecommendedCount, U.[Url]	
	FROM gitSteamed.Users U 
		INNER JOIN gitSteamed.Libraries L ON U.Username = L.Username
		INNER JOIN 
			(SELECT U.Username, COUNT(R.ReviewID), SUM(R.Funny), SUM(R.Helpful), SUM(CONVERT(INT, R.Recommend)) 
				FROM gitSteamed.Reviews R 
					INNER JOIN gitSteamed.Users U ON U.Username = R.Username
				GROUP BY U.Username)
			P(Username, ReviewCount, FunnyCount, HelpfulCount, RecommendedCount) ON U.Username = P.Username
	WHERE U.Username = @Username
	GROUP BY U.Username, P.ReviewCount, p.FunnyCount, P.HelpfulCount, P.RecommendedCount, U.[Url]
GO
CREATE OR ALTER PROCEDURE gitSteamed.GetUserGenreLayout
	@Username NVARCHAR(64)
AS
	SELECT G.[Name], COUNT(*) GenreCount
	FROM gitSteamed.Libraries L
		INNER JOIN gitSteamed.ItemsGenreContents IG ON L.ItemID = IG.ItemID
		INNER JOIN gitSteamed.Genres G ON G.GenreID = IG.GenreID
	WHERE L.Username = @Username
	GROUP BY G.GenreID, G.[Name]
	ORDER BY GenreCount DESC
GO

DECLARE @ResultCount INT
EXEC gitSteamed.GetUserReviews N'REBAS_AS_F-T', 10, 1, @ResultCount OUTPUT
SELECT @ResultCount ReviewsCount
EXEC gitSteamed.GetUserGames N'REBAS_AS_F-T', 72, 1, @ResultCount OUTPUT
SELECT @ResultCount GamesCount
EXEC gitSteamed.GetUserStats N'REBAS_AS_F-T'
EXEC gitSteamed.GetUserGenreLayout N'REBAS_AS_F-T'