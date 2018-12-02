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
		R.Funny, R.Helpful, R.Recommend
	FROM gitSteamed.Users U
		INNER JOIN gitSteamed.Reviews R ON U.Username = R.Username
		INNER JOIN gitSteamed.Items I ON I.ItemID = R.ItemID
	WHERE U.Username = @Username
	GROUP BY R.[Description], I.[Name], Posted, LastEdited, R.Funny, R.Helpful, R.Recommend
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
		P.ReviewCount, P.FunnyCount, P.HelpfulCount, P.RecommendedCount, G.[Action], G.Adventure, G.Casual,
		G.EarlyAccess, G.Education, G.Indie, G.Racing, G.RPG, G.Simulation, G.Sports, G.Startegy	
	FROM gitSteamed.Users U 
		INNER JOIN gitSteamed.Libraries L ON U.Username = L.Username
		INNER JOIN 
			(SELECT U.Username, COUNT(R.ReviewID), SUM(R.Funny), SUM(R.Helpful), SUM(CONVERT(INT, R.Recommend)) 
				FROM gitSteamed.Reviews R 
					INNER JOIN gitSteamed.Users U ON U.Username = R.Username
				GROUP BY U.Username)
			P(Username, ReviewCount, FunnyCount, HelpfulCount, RecommendedCount) ON U.Username = P.Username
		INNER JOIN
			(SELECT SUM(CONVERT(INT, G.[Action])), SUM(CONVERT(INT, G.Adventure)), SUM(CONVERT(INT, G.Casual)), 
				SUM(CONVERT(INT, G.EarlyAccess)), SUM(CONVERT(INT, G.Education)), SUM(CONVERT(INT, G.Indie)),
				SUM(CONVERT(INT, G.Racing)),SUM(CONVERT(INT, G.RPG)), SUM(CONVERT(INT, G.Simulation)), 
				SUM(CONVERT(INT, G.Sports)), SUM(CONVERT(INT, G.Strategy)), L.Username
				FROM gitSteamed.Genres G 
					INNER JOIN gitSteamed.Items I ON I.GenreID = G.GenreID
					INNER JOIN gitSteamed.Libraries L ON L.ItemID = I.ItemID
				WHERE I.GenreID IS NOT NULL
				GROUP BY L.Username)
			G([Action], Adventure, Casual, EarlyAccess, Education, Indie, Racing, RPG, Simulation, Sports, Startegy, Username)
				ON U.Username = G.Username
	WHERE U.Username = @Username
	GROUP BY U.Username, P.ReviewCount, p.FunnyCount, P.HelpfulCount, P.RecommendedCount, G.[Action], G.Adventure, G.Casual,
		G.EarlyAccess, G.Education, G.Indie, G.Racing, G.RPG, G.Simulation, G.Sports, G.Startegy
GO

DECLARE @ResultCount INT
EXEC gitSteamed.GetUserReviews N'chicken_tonight', 10, 1, @ResultCount OUTPUT
SELECT @ResultCount ReviewsCount
EXEC gitSteamed.GetUserGames N'chicken_tonight', 72, 1, @ResultCount OUTPUT
SELECT @ResultCount GamesCount
EXEC gitSteamed.GetUserStats N'chicken_tonight'