DROP PROCEDURE IF EXISTS gitSteamed.AddUser
GO
DROP PROCEDURE IF EXISTS gitSteamed.AddAdmin
GO

CREATE OR ALTER PROCEDURE gitSteamed.AddUser
	@username NVARCHAR(64),
	@itemcount INT = 0,
	@url NVARCHAR(256) = N'',
	@added INT OUT
AS
BEGIN
	SET @added = 0;
	DECLARE @row_before INT = (SELECT COUNT(*) FROM gitSteamed.Users);
	WITH UserCTE(Username, ItemCount, Url) AS (
		SELECT P.Username, P.ItemCount, P.Url
		FROM (VALUES(@username, @itemcount, @url)) AS P(Username, ItemCount, Url)
	)
	MERGE gitSteamed.Users U
	USING UserCTE C ON	C.Username = U.Username
	WHEN NOT MATCHED THEN
		INSERT (Username, ItemCount, [Url])
		VALUES (@username, @itemcount, @username);
	SET @added = (SELECT COUNT(*) FROM gitSteamed.Users) - @row_before;
END
GO

CREATE OR ALTER PROCEDURE gitSteamed.AddAdmin
	@username NVARCHAR(64),
	@password NVARCHAR(256)
AS
	INSERT gitSteamed.Admin(Username, Password)
	VALUES (@username, @password)
GO