DROP PROCEDURE IF EXISTS gitSteamed.SearchUser
GO
DROP PROCEDURE IF EXISTS gitSteamed.SearchItem
GO
DROP PROCEDURE IF EXISTS gitSteamed.SearchBundle
GO

CREATE OR ALTER PROCEDURE gitSteamed.SearchUser
	@LookupString NVARCHAR(128),
	@ResultCount INT,
	@PageNumber INT,
	@ReturnedCount INT OUTPUT
AS
	SET @ReturnedCount = (SELECT COUNT(*) FROM gitSteamed.Users U WHERE U.Username LIKE (N'%' + @LookupString + N'%'))
	SELECT U.Username
	FROM gitSteamed.Users U
	WHERE U.Username LIKE (N'%' + @LookupString + N'%')
	ORDER BY (CASE WHEN U.Username LIKE (@LookupString + N'%') THEN 1 ELSE 2 END)
	OFFSET (@ResultCount*(@PageNumber-1)) ROWS FETCH NEXT @ResultCount ROWS ONLY
GO
CREATE OR ALTER PROCEDURE gitSteamed.SearchItem
	@LookupString NVARCHAR(128),
	@ResultCount INT,
	@PageNumber INT,
	@ReturnedCount INT OUTPUT
AS
	SET @ReturnedCount = (SELECT COUNT(*) FROM gitSteamed.Items I WHERE I.[Name] LIKE (N'%' + @LookupString + N'%'))
	SELECT I.[Name], I.ItemID
	FROM gitSteamed.Items I
	WHERE I.[Name] LIKE (N'%' + @LookupString + N'%')
	GROUP BY I.ItemID, I.[Name]
	ORDER BY (CASE WHEN I.[Name] LIKE (@LookupString + N'%') THEN 1 ELSE 2 END), 
		(SELECT COUNT(*) FROM gitSteamed.Libraries L WHERE L.ItemID = I.ItemID) DESC
	OFFSET (@ResultCount*(@PageNumber-1)) ROWS FETCH NEXT @ResultCount ROWS ONLY
GO
CREATE OR ALTER PROCEDURE gitSteamed.SearchBundle
	@LookupString NVARCHAR(128),
	@ResultCount INT,
	@PageNumber INT,
	@ReturnedCount INT OUTPUT
AS
	SET @ReturnedCount = (SELECT COUNT(*) FROM gitSteamed.Bundles B WHERE B.[Name] LIKE (N'%' + @LookupString + N'%'))
	SELECT B.[Name], B.BundleID, B.DiscountPrice, B.FinalPrice
	FROM gitSteamed.Bundles B
		INNER JOIN gitSteamed.BundleContents BC ON BC.BundleID = B.BundleID
		INNER JOIN gitSteamed.Items I ON I.ItemID = BC.ItemID
		INNER JOIN gitSteamed.Libraries L ON I.ItemID = L.ItemID
	WHERE B.[Name] LIKE (N'%' + @LookupString + N'%')
	GROUP BY B.BundleID, B.[Name], B.DiscountPrice, B.FinalPrice
	ORDER BY (CASE WHEN B.[Name] LIKE (@LookupString + N'%') THEN 1 ELSE 2 END), COUNT(L.Username) DESC
	OFFSET (@ResultCount*(@PageNumber-1)) ROWS FETCH NEXT @ResultCount ROWS ONLY
GO

DECLARE @UserResults INT
DECLARE @ItemsResults INT
DECLARE @BundleResults INT

EXEC gitSteamed.SearchItem N'count', 10, 1, @ItemsResults OUTPUT
SELECT @ItemsResults ItemResults
EXEC gitSteamed.SearchUser N'job', 10, 1, @UserResults OUTPUT
SELECT @UserResults UserResults
EXEC gitSteamed.SearchBundle N'aB', 5, 3, @BundleResults OUTPUT
SELECT @BundleResults BundleResults

SELECT * FROM gitSteamed.Users WHERE Username = N'undefined'