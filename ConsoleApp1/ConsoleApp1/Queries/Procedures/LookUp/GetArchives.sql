DROP PROCEDURE IF EXISTS gitSteamed.SearchReviewArchive
GO
DROP PROCEDURE IF EXISTS gitSteamed.SearchItemArchive
GO

CREATE OR ALTER PROCEDURE gitSteamed.SearchReviewArchive
	@LookupString NVARCHAR(128),
	@ResultCount INT,
	@PageNumber INT
AS
	SELECT R.Username, R.Description
	FROM gitSteamed.ArchivedReviews R
	WHERE R.Description LIKE (N'%' + @LookupString + N'%')
	ORDER BY (CASE WHEN R.[Description] LIKE (@LookupString + N'%') THEN 1 ELSE 2 END), R.Username DESC
	OFFSET (@ResultCount*(@PageNumber-1)) ROWS FETCH NEXT @ResultCount ROWS ONLY
GO

CREATE OR ALTER PROCEDURE gitSteamed.SearchItemArchive
	@LookupString NVARCHAR(128),
	@ResultCount INT,
	@PageNumber INT
AS
	SELECT I.[Name]
	FROM gitSteamed.ArchiveItems I
		INNER JOIN gitSteamed.Libraries L ON L.ItemID = I.ItemID
	WHERE I.[Name] LIKE (N'%' + @LookupString + N'%')
	GROUP BY I.ItemID, I.[Name]
	ORDER BY (CASE WHEN I.[Name] LIKE (@LookupString + N'%') THEN 1 ELSE 2 END), COUNT(L.UserName) DESC 
	OFFSET (@ResultCount*(@PageNumber-1)) ROWS FETCH NEXT @ResultCount ROWS ONLY
GO