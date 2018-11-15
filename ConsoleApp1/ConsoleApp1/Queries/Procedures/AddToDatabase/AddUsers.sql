CREATE OR ALTER PROCEDURE gitSteamed.AddUser
	@username NVARCHAR(64),
	@itemcount INT,
	@url NVARCHAR(256)
AS

INSERT gitSteamed.Users(Username, ItemCount, [Url])
VALUES(@username, @itemcount, @url)
GO