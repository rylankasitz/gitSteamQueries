DROP PROCEDURE IF EXISTS gitSteamed.SearchReviewArchive
GO


CREATE OR ALTER PROCEDURE gitSteamed.SearchReviewArchive
	@ReviewSearch NVARCHAR(128),
	@ResultCount INT,
	@PageNumber INT,
	@ReturnedCount INT OUTPUT
AS
	SET @ReturnedCount = (SELECT COUNT(*) FROM gitSteamed.ArchivedReviews R WHERE R.Description LIKE (N'%' + @ReviewSearch + N'%'))
	SELECT R.Username, R.Description, I.Name AS GameName
	FROM gitSteamed.ArchivedReviews R
		INNER JOIN gitSteamed.Items I ON R.ItemID = I.ItemID
	WHERE R.Description LIKE (N'%' + @ReviewSearch + N'%')
	ORDER BY (CASE WHEN R.[Description] LIKE (@ReviewSearch + N'%') THEN 1 ELSE 2 END), R.Username DESC
	OFFSET (@ResultCount*(@PageNumber-1)) ROWS FETCH NEXT @ResultCount ROWS ONLY
GO

