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
		INNER JOIN gitSteamed.Libraries L ON L.ItemID = I.ItemID
	WHERE I.[Name] LIKE (N'%' + @LookupString + N'%')
	GROUP BY I.ItemID, I.[Name]
	ORDER BY (CASE WHEN I.[Name] LIKE (@LookupString + N'%') THEN 1 ELSE 2 END), COUNT(L.UserName) DESC 
	OFFSET (@ResultCount*(@PageNumber-1)) ROWS FETCH NEXT @ResultCount ROWS ONLY
GO
CREATE OR ALTER PROCEDURE gitSteamed.SearchBundle
	@LookupString NVARCHAR(128),
	@ResultCount INT,
	@PageNumber INT,
	@ReturnedCount INT OUTPUT
AS
	SET @ReturnedCount = (SELECT COUNT(*) FROM gitSteamed.Bundles B WHERE B.[Name] LIKE (N'%' + @LookupString + N'%'))
	SELECT B.[Name]
	FROM gitSteamed.Bundles B
		INNER JOIN gitSteamed.BundleContents BC ON BC.BundleID = B.BundleID
		INNER JOIN gitSteamed.Items I ON I.ItemID = BC.ItemID
		INNER JOIN gitSteamed.Libraries L ON I.ItemID = L.ItemID
	WHERE B.[Name] LIKE (N'%' + @LookupString + N'%')
	GROUP BY B.BundleID, B.[Name]
	ORDER BY (CASE WHEN B.[Name] LIKE (@LookupString + N'%') THEN 1 ELSE 2 END), COUNT(L.Username) DESC
	OFFSET (@ResultCount*(@PageNumber-1)) ROWS FETCH NEXT @ResultCount ROWS ONLY
GO

DECLARE @UserResults INT
DECLARE @ItemsResults INT
DECLARE @BundleResults INT

EXEC gitSteamed.SearchItem N'A', 10, 1, @ItemsResults OUTPUT
SELECT @ItemsResults ItemResults
EXEC gitSteamed.SearchUser N'Ca', 10, 1, @UserResults OUTPUT
SELECT @UserResults UserResults
EXEC gitSteamed.SearchBundle N'aB', 5, 3, @BundleResults OUTPUT
SELECT @BundleResults BundleResults