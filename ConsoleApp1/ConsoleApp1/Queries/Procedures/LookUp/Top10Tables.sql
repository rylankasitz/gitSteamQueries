DROP PROCEDURE IF EXISTS gitSteamed.GetTop10UsersPlaytime
GO
DROP PROCEDURE IF EXISTS gitSteamed.GetTop10ItemsPlaytime
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

EXEC gitSteamed.GetTop10ItemsPlaytime
EXEC gitSteamed.GetTop10UsersPlaytime