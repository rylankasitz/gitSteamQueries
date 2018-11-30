DROP PROCEDURE IF EXISTS gitSteamed.GetUser
GO
DROP PROCEDURE IF EXISTS gitSteamed.GetItem
GO
DROP PROCEDURE IF EXISTS gitSteamed.GetGamesOfUser
GO
DROP PROCEDURE IF EXISTS gitSteamed.GetReviewsOfGame
GO


CREATE OR ALTER PROCEDURE gitSteamed.GetUser
	@username NVARCHAR(128)
AS
	SELECT U.Username, U.ItemCount, U.[Url]
	FROM gitSteamed.Users U
	WHERE U.Username = @username
GO
CREATE OR ALTER PROCEDURE gitSteamed.GetItem
	@ItemId INT
AS
	SELECT I.Name, I.Genre, I.URL, I.Price
	FROM gitSteamed.Items I
	WHERE I.ItemID = @ItemId
GO
CREATE OR ALTER PROCEDURE gitSteamed.GetGamesOfUser
	@username NVARCHAR(128),
	@ResultCount INT = 10
AS
	SELECT TOP (@ResultCount) I.Name, I.Genre, I.URL, I.Price, L.TimePlayed2Weeks, L.TimePlayedForever
	FROM gitSteamed.Users U
		INNER JOIN gitSteamed.Libraries L ON L.Username = U.Username
		INNER JOIN gitSteamed.Items I ON I.ItemID = L.ItemID
	WHERE U.Username = @username
	ORDER BY I.Name ASC, L.TimePlayedForever DESC
GO
CREATE OR ALTER PROCEDURE gitSteamed.GetReviewsOfGame
	@ItemId INT,
	@ResultCount INT = 10
AS
	SELECT TOP (@ResultCount) R.Username, R.Description, R.Recommend, R.Helpful, R.Posted
	FROM gitSteamed.Reviews R
	WHERE R.ItemID = @ItemId
	ORDER BY R.LastEdited, R.Helpful, R.Username
GO


EXEC gitSteamed.GetUser @username = N'___Plasma___' -- nvarchar(128)
EXEC gitSteamed.GetItem @ItemId = 50 -- int
EXEC gitSteamed.GetGamesOfUser @username = N'___Plasma___'
EXEC gitSteamed.GetReviewsOfGame @ItemId = 50      -- int


