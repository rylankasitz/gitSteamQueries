DROP PROCEDURE IF EXISTS gitSteamed.ArchiveReview
GO

CREATE OR ALTER PROCEDURE gitSteamed.ArchiveReview
	@ReviewId INT,
	@Archived INT OUT
AS
	DECLARE @row_before INT = (SELECT COUNT(*) FROM gitSteamed.Reviews);
	WITH ReviewCTE(ReviewId, Username, ItemId, Funny, Posted, LastEdited, Helpful, Recommend, Description) AS (
		SELECT R.ReviewId, R.Username, R.ItemId, R.Funny, R.Posted, R.LastEdited, R.Helpful, R.Recommend, R.Description
		FROM gitSteamed.Reviews R
		WHERE R.ReviewId = @ReviewId
	)
	MERGE gitSteamed.ArchivedReviews AR
	USING ReviewCTE C ON C.ReviewId = AR.ReviewId
	WHEN NOT MATCHED THEN
		INSERT (ReviewId, Username, ItemId, Funny, Posted, LastEdited, Helpful, Recommend, Description)
		VALUES(C.ReviewId, C.Username, C.ItemId, C.Funny, C.Posted, C.LastEdited, C.Helpful, C.Recommend, C.Description);
	SET @Archived = (SELECT COUNT(*) FROM gitSteamed.Reviews) - @row_before
GO
