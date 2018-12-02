DROP PROCEDURE IF EXISTS gitSteamed.SearchReview
GO
DROP PROCEDURE IF EXISTS gitSteamed.[Login]
GO

CREATE OR ALTER PROCEDURE gitSteamed.SearchReview
	@LookupString NVARCHAR(128),
	@ResultCount INT,
	@PageNumber INT
AS
	SELECT R.Username, R.Description
	FROM gitSteamed.Reviews R
	WHERE R.Description LIKE (N'%' + @LookupString + N'%')
	ORDER BY (CASE WHEN R.[Description] LIKE (@LookupString + N'%') THEN 1 ELSE 2 END), R.Username DESC
	OFFSET (@ResultCount*(@PageNumber-1)) ROWS FETCH NEXT @ResultCount ROWS ONLY
GO

CREATE OR ALTER PROCEDURE gitSteamed.[Login]
	@username NVARCHAR(64),
	@password NVARCHAR(256),
	@exists INT OUT
AS
	SET @exists = (SELECT COUNT(*) FROM gitSteamed.Admin A WHERE A.Username = @username AND A.Password = @password)
GO