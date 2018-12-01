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
	SET @ReturnedCount = (SELECT COUNT(*) FROM gitSteamed.Users U INNER JOIN gitSteamed.Reviews R ON R.Username = U.Username
						WHERE U.Username = @Username GROUP BY U.Username) 
	SELECT R.[Description], I.[Name] Game, FORMAT(R.Posted, N'MMMM dd, yyyy') PostedOn, FORMAT(R.LastEdited, N'MMMM dd, yyyy') LastEdited, 
		R.Funny, R.Helpful, R.Recommend
	FROM gitSteamed.Users U
		INNER JOIN gitSteamed.Reviews R ON U.Username = R.Username
		INNER JOIN gitSteamed.Items I ON I.ItemID = R.ItemID
	WHERE U.Username = @Username
	ORDER BY R.LastEdited DESC
	OFFSET (@ResultCount*(@PageNumber-1)) ROWS FETCH NEXT @ResultCount ROWS ONLY
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
	OFFSET (@ResultCount*(@PageNumber-1)) ROWS FETCH NEXT @ResultCount ROWS ONLY
GO
CREATE OR ALTER PROCEDURE gitSteamed.GetUserStats
	@Username NVARCHAR(64)
AS
	SELECT (SUM(L.TimePlayedForever) / 60) TotalPlayTime, (SUM(L.TimePlayed2Weeks) / 60) PlayTime2Weeks,
		P.ReviewCount, P.FunnyCount, P.HelpfulCount, P.RecommendedCount	
	FROM gitSteamed.Users U 
		INNER JOIN gitSteamed.Libraries L ON U.Username = L.Username
		INNER JOIN 
			(SELECT U.Username, COUNT(R.ReviewID), SUM(R.Funny), SUM(R.Helpful), SUM(CONVERT(INT, R.Recommend)) 
				FROM gitSteamed.Reviews R 
					INNER JOIN gitSteamed.Users U ON U.Username = R.Username
				GROUP BY U.Username)
			P(Username, ReviewCount, FunnyCount, HelpfulCount, RecommendedCount) ON U.Username = P.Username
	WHERE U.Username = @Username
	GROUP BY U.Username, P.ReviewCount, p.FunnyCount, P.HelpfulCount, P.RecommendedCount
GO

DECLARE @ResultCount INT
EXEC gitSteamed.GetUserReviews N'chicken_tonight', 20, 1, @ResultCount OUTPUT
SELECT @ResultCount ReviewsCount
EXEC gitSteamed.GetUserGames N'chicken_tonight', 72, 1, @ResultCount OUTPUT
SELECT @ResultCount GamesCount
EXEC gitSteamed.GetUserStats N'chicken_tonight'