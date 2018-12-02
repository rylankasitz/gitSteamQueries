DROP PROCEDURE IF EXISTS gitSteamed.GetTotalUsers
GO
DROP PROCEDURE IF EXISTS gitSteamed.GetGenreTotals
GO

CREATE OR ALTER PROCEDURE gitSteamed.GetTotalUsers
AS
	SELECT COUNT(*) TotalUsers FROM gitSteamed.Users
GO

CREATE OR ALTER PROCEDURE gitSteamed.GetGenreTotals
AS
	SELECT G.[Name], COUNT(*) Totals
	FROM gitSteamed.ItemsGenreContents IC
		INNER JOIN gitSteamed.Genres G ON G.GenreID = IC.GenreID
	GROUP BY G.[Name]
	ORDER BY Totals DESC
GO

EXEC gitSteamed.GetTotalUsers
EXEC gitSteamed.GetGenreTotals