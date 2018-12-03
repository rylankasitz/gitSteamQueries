DROP PROCEDURE IF EXISTS gitSteamed.GetTop10UsersPlaytime
GO
DROP PROCEDURE IF EXISTS gitSteamed.GetTop10ItemsPlaytime
GO
DROP PROCEDURE IF EXISTS gitSteamed.GetTop10ItemsReviews
GO

CREATE OR ALTER PROCEDURE gitSteamed.GetTop10UsersPlaytime
AS
	SELECT TOP 10 L.Username
	FROM gitSteamed.Libraries L
	GROUP BY L.Username
	ORDER BY SUM(L.TimePlayedForever) DESC
GO
CREATE OR ALTER PROCEDURE gitSteamed.GetTop10ItemsPlaytime
AS
	SELECT TOP 10 I.[Name]
	FROM gitSteamed.Items I
		INNER JOIN gitSteamed.Libraries L ON I.ItemID = L.ItemID
	GROUP BY I.ItemID, I.[Name]
	ORDER BY SUM(L.TimePlayedForever) DESC
GO
CREATE OR ALTER PROCEDURE gitSteamed.GetTop10ItemsReviews
AS
	SELECT TOP 10 I.[Name]
	FROM gitSteamed.Items I
		INNER JOIN gitSteamed.Libraries L ON I.ItemID = L.ItemID
		INNER JOIN gitSteamed.Reviews R ON R.ItemID = I.ItemID
	GROUP BY I.ItemID, I.[Name]
	ORDER BY COUNT(R.ReviewID) DESC
GO
CREATE OR ALTER PROCEDURE gitSteamed.GetTop10ItemsOwners
AS
	SELECT TOP 10 I.[Name]
	FROM gitSteamed.Items I
		INNER JOIN gitSteamed.Libraries L ON I.ItemID = L.ItemID
	GROUP BY I.ItemID, I.[Name]
	ORDER BY COUNT(L.Username) DESC
GO
CREATE OR ALTER PROCEDURE gitSteamed.GetTop10ItemsUsers
AS
	SELECT TOP 10 I.[Name]
	FROM gitSteamed.Items I
		INNER JOIN gitSteamed.Libraries L ON I.ItemID = L.ItemID
	GROUP BY I.ItemID, I.[Name]
	ORDER BY SUM(CASE WHEN (L.TimePlayedForever != 0) THEN 1 ELSE 0 END) DESC
GO
CREATE OR ALTER PROCEDURE gitSteamed.GetTop10RecommendedGames
AS
	SELECT TOP 10 I.[Name], SUM(CONVERT(INT, R.Recommend)) - SUM(CASE WHEN (R.Recommend = 0) THEN 1 ELSE 0 END) Recommended
	FROM gitSteamed.Items I
		INNER JOIN gitSteamed.Reviews R ON R.ItemID = I.ItemID
	GROUP BY I.[Name]
	ORDER BY SUM(CONVERT(INT, R.Recommend)) - SUM(CASE WHEN (R.Recommend = 0) THEN 1 ELSE 0 END) DESC
GO

EXEC gitSteamed.GetTop10ItemsPlaytime
EXEC gitSteamed.GetTop10UsersPlaytime
EXEC gitSteamed.GetTop10ItemsReviews
EXEC gitSteamed.GetTop10ItemsOwners
EXEC gitSteamed.GetTop10ItemsUsers
EXEC gitSteamed.GetTop10RecommendedGames