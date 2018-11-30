CREATE OR ALTER PROCEDURE gitSteamed.AddLibrary
	@Username NVARCHAR(64),
	@ItemId INT,
	@TimePlayedForever INT,
	@TimePlayed2Weeks INT
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