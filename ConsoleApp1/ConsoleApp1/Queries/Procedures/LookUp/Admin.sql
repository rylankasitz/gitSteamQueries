DROP PROCEDURE IF EXISTS gitSteamed.SearchReview
GO
DROP PROCEDURE IF EXISTS gitSteamed.[Login]
GO

CREATE OR ALTER PROCEDURE gitSteamed.SearchReview
	@LookupString NVARCHAR(128),
	@ResultCount INT,
	@PageNumber INT,
	@ReturnedCount INT OUTPUT
AS
	SET @ReturnedCount = (SELECT COUNT(*) FROM gitSteamed.Reviews R WHERE R.Description LIKE (N'%' + @LookupString + N'%'))
	SELECT R.Username, R.Description, I.Name AS GameName, R.ReviewID
	FROM gitSteamed.Reviews R
		INNER JOIN gitSteamed.Items I ON R.ItemID = I.ItemID
	WHERE R.Description LIKE (N'%' + @LookupString + N'%') AND R.ReviewID NOT IN (SELECT AR.ReviewID FROM gitSteamed.ArchivedReviews AR)
	ORDER BY (CASE WHEN R.[Description] LIKE (@LookupString + N'%') THEN 1 ELSE 2 END), R.Username DESC
	OFFSET (@ResultCount*(@PageNumber-1)) ROWS FETCH NEXT @ResultCount ROWS ONLY
GO

CREATE OR ALTER PROCEDURE gitSteamed.[Login]
	@username NVARCHAR(64),
	@password NVARCHAR(256),
	@exists INT OUTPUT
AS
	SET @exists = (SELECT COUNT(*) FROM gitSteamed.Admin A WHERE A.Username = @username AND A.Password = @password)
GO