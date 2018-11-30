DROP PROCEDURE IF EXISTS gitSteamed.GetUserReviews
GO
DROP PROCEDURE IF EXISTS gitSteamed.GetUserGames
GO

CREATE OR ALTER PROCEDURE gitSteamed.GetUserReviews
	@Username NVARCHAR(64),
	@ResultCount INT,
	@PageNumber INT
AS
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
	@PageNumber INT
AS
	SELECT I.[Name], CEILING(L.TimePlayedForever / 60) TotalPlayTime, CEILING(L.TimePlayed2Weeks / 60) Week2PlayTime
	FROM gitSteamed.Users U
		INNER JOIN gitSteamed.Libraries L ON L.Username = U.Username
		INNER JOIN gitSteamed.Items I ON I.ItemID = L.ItemID
	WHERE U.Username = @Username
	ORDER BY L.TimePlayedForever DESC
	OFFSET (@ResultCount*(@PageNumber-1)) ROWS FETCH NEXT @ResultCount ROWS ONLY
GO

EXEC gitSteamed.GetUserReviews N'chicken_tonight', 5, 3
EXEC gitSteamed.GetUserGames N'chicken_tonight', 5, 1
EXEC gitSteamed.SearchItem N'A', 10, 1