DROP PROCEDURE IF EXISTS gitSteamed.GetTotalUsers
GO
DROP PROCEDURE IF EXISTS gitSteamed.GetGenreTotals
GO
DROP PROCEDURE IF EXISTS gitSteamed.GetFunniestReview
GO
DROP PROCEDURE IF EXISTS gitSteamed.GetMostHelpfulReview
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
CREATE OR ALTER PROCEDURE gitSteamed.GetFunniestReview
AS
	SELECT TOP 1 R.[Description], R.Funny, R.Helpful, R.Recommend, R.Posted, R.LastEdited
	FROM gitSteamed.Reviews R
	ORDER BY R.Funny DESC
GO
CREATE OR ALTER PROCEDURE gitSteamed.GetMostHelpfulReview
AS
	SELECT TOP 1 R.[Description], R.Funny, R.Helpful, R.Recommend, R.Posted, R.LastEdited
	FROM gitSteamed.Reviews R
	ORDER BY R.Helpful DESC
GO

EXEC gitSteamed.GetMostHelpfulReview
EXEC gitSteamed.GetFunniestReview
EXEC gitSteamed.GetTotalUsers
EXEC gitSteamed.GetGenreTotals