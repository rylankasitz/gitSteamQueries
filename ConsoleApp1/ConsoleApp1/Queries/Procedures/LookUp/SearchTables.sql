DROP PROCEDURE IF EXISTS gitSteamed.SearchUser
GO
DROP PROCEDURE IF EXISTS gitSteamed.SearchItem
GO
DROP PROCEDURE IF EXISTS gitSteamed.SearchBundle
GO

CREATE OR ALTER PROCEDURE gitSteamed.SearchUser
	@LookupString NVARCHAR(128),
	@ResultCount INT = 10
AS
	SELECT TOP (@ResultCount) U.Username
	FROM gitSteamed.Users U
	WHERE U.Username LIKE (N'%' + @LookupString + N'%')
	ORDER BY CASE 
		WHEN U.Username LIKE (@LookupString + N'%') THEN 1
		ELSE 2
	END
GO
CREATE OR ALTER PROCEDURE gitSteamed.SearchItem
	@LookupString NVARCHAR(128),
	@ResultCount INT = 10
AS
	SELECT TOP (@ResultCount) I.[Name]
	FROM gitSteamed.Items I
	WHERE I.[Name] LIKE (N'%' + @LookupString + N'%')
	ORDER BY CASE 
		WHEN I.[Name] LIKE (@LookupString + N'%') THEN 1
		ELSE 2
	END
GO
CREATE OR ALTER PROCEDURE gitSteamed.SearchBundle
	@LookupString NVARCHAR(128),
	@ResultCount INT = 10
AS
	SELECT TOP (@ResultCount) B.[Name]
	FROM gitSteamed.Bundles B
	WHERE B.[Name] LIKE (N'%' + @LookupString + N'%')
	ORDER BY CASE 
		WHEN B.[Name] LIKE (@LookupString + N'%') THEN 1
		ELSE 2
	END
GO

EXEC gitSteamed.SearchItem N'Kerbal'
EXEC gitSteamed.SearchUser N'Ca'
EXEC gitSteamed.SearchBundle N'aB'