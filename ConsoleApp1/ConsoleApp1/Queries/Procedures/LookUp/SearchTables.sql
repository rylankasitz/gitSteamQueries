DROP PROCEDURE IF EXISTS gitSteamed.SearchUser
GO
DROP PROCEDURE IF EXISTS gitSteamed.SearchItem
GO
DROP PROCEDURE IF EXISTS gitSteamed.SearchBundle
GO

CREATE OR ALTER PROCEDURE gitSteamed.SearchUser
	@LookupString NVARCHAR(128),
	@ResultCount INT,
	@PageNumber INT
AS
	SELECT U.Username
	FROM gitSteamed.Users U
	WHERE U.Username LIKE (N'%' + @LookupString + N'%')
	ORDER BY (CASE WHEN U.Username LIKE (@LookupString + N'%') THEN 1 ELSE 2 END)
	OFFSET (@ResultCount*(@PageNumber-1)) ROWS FETCH NEXT @ResultCount ROWS ONLY
GO
CREATE OR ALTER PROCEDURE gitSteamed.SearchItem
	@LookupString NVARCHAR(128),
	@ResultCount INT,
	@PageNumber INT
AS
	SELECT I.[Name]
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
	@PageNumber INT
AS
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

EXEC gitSteamed.SearchItem N'A', 10, 1
EXEC gitSteamed.SearchUser N'Ca', 10, 1
EXEC gitSteamed.SearchBundle N'aB', 5, 3