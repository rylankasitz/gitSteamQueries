DROP PROCEDURE IF EXISTS gitSteamed.GetItem
GO
DROP PROCEDURE IF EXISTS gitSteamed.GetReviewsOfGame
GO

CREATE OR ALTER PROCEDURE gitSteamed.GetItem
	@ItemId INT
AS
	SELECT I.Name, I.Genre, I.URL, I.Price
	FROM gitSteamed.Items I
	WHERE I.ItemID = @ItemId
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

EXEC gitSteamed.GetReviewsOfGame @ItemId = 50      -- int
EXEC gitSteamed.GetItem @ItemId = 50 -- int