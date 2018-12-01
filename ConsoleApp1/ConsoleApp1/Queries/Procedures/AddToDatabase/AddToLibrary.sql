DROP PROCEDURE IF EXISTS gitSteamed.AddToUserLibrary
GO

CREATE OR ALTER PROCEDURE gitSteamed.AddToUserLibrary
	@Username NVARCHAR(64),
	@ItemId INT,
	@TimePlayedForever INT = 0,
	@TimePlayed2Weeks INT = 0
AS

WITH LibraryCTE(Username, ItemId, TimePlayedForever, TimePlayed2Weeks) AS (
	SELECT *
	FROM (VALUES(@Username, @ItemId, @TimePlayedForever, @TimePlayed2Weeks)) AS P(Username, ItemId, TimePlayedForever, TimePlayed2Weeks)
)
MERGE gitSteamed.Library L
USING LibraryCTE C ON C.Username = L.Username AND C.ItemId = L.ItemId
WHEN NOT MATCHED THEN
	INSERT (Username, ItemId, TimePlayedForever, TimePlayed2Weeks)
	VALUES(@Username, @ItemId, @TimePlayedForever, @TimePlayed2Weeks);
GO