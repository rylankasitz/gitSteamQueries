DROP PROCEDURE IF EXISTS gitSteamed.ArchiveReview
GO
DROP PROCEDURE IF EXISTS gitSteamed.UnArchiveReview
GO

CREATE OR ALTER PROCEDURE gitSteamed.ArchiveReview
	@ReviewID INT,
	@Archived INT OUTPUT
AS
	DECLARE @row_before INT = (SELECT COUNT(*) FROM gitSteamed.ArchivedReviews);
	WITH ReviewCTE(ReviewId, Username, ItemId, Funny, Posted, LastEdited, Helpful, Recommend, Description) AS (
		SELECT R.ReviewID, R.Username, R.ItemId, R.Funny, R.Posted, R.LastEdited, R.Helpful, R.Recommend, R.Description
		FROM gitSteamed.Reviews R
		WHERE R.ReviewID = @ReviewId
	)
	MERGE gitSteamed.ArchivedReviews AR
	USING ReviewCTE C ON C.ReviewId = AR.ReviewId
	WHEN NOT MATCHED THEN
		INSERT (ReviewID, Username, ItemId, Funny, Posted, LastEdited, Helpful, Recommend, Description)
		VALUES(C.ReviewID, C.Username, C.ItemId, C.Funny, C.Posted, C.LastEdited, C.Helpful, C.Recommend, C.Description);
	SET @Archived = (SELECT COUNT(*) FROM gitSteamed.ArchivedReviews) - @row_before
GO

CREATE OR ALTER PROCEDURE gitSteamed.UnArchiveReview
	@ReviewID INT,
	@UnArchived INT OUTPUT
AS
	DECLARE @row_before INT = (SELECT COUNT(*) FROM gitSteamed.ArchivedReviews);
	DELETE gitSteamed.ArchivedReviews
	WHERE ReviewID = @ReviewID;
	SET @UnArchived = @row_before - (SELECT COUNT(*) FROM gitSteamed.ArchivedReviews)
GO