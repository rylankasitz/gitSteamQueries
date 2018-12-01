CREATE OR ALTER PROCEDURE gitSteamed.AddUser
	@username NVARCHAR(64),
	@itemcount INT,
	@url NVARCHAR(256),
	@added INT OUT
AS
BEGIN
	WITH UserCTE(Username, ItemCount, Url) AS (
		SELECT *
		FROM (VALUES(@username, @itemcount, @url)) AS P(Username, ItemCount, Url)
	)
	MERGE gitSteamed.Users U
	USING UserCTE C ON	C.Username = U.Username
	WHEN NOT MATCHED THEN
		INSERT (Username, ItemCount, [Url])
		VALUES(@username, @itemcount, @url);
END
GO