DROP PROCEDURE IF EXISTS gitSteamed.AddItem
GO

CREATE OR ALTER PROCEDURE gitSteamed.AddItem
	@price FLOAT,
	@name NVARCHAR(128),
	@url NVARCHAR(256) = NULL,
	@added INT OUTPUT
AS
	DECLARE @ID INT = (SELECT TOP(1) I.ItemID FROM gitSteamed.Items I ORDER BY I.ItemID DESC) + 1;
	DECLARE @row_before INT = (SELECT COUNT(*) FROM gitSteamed.Items);
	WITH ItemCTE(Price, [URL], [Name]) AS (
		SELECT P.Price, P.[URL], P.[Name]
		FROM (VALUES(@price, @url, @name)) AS P(Price, [URL], [Name])
	)
	MERGE gitSteamed.Items I
	USING ItemCTE C ON	C.[Name] = I.[Name]
	WHEN NOT MATCHED THEN
		INSERT (ItemID, Price, [URL], [Name])
		VALUES (@ID, @price, @url, @name);
	SET @added = (SELECT COUNT(*) FROM gitSteamed.Items) - @row_before;
GO

DECLARE @result INT
EXEC gitSteamed.AddItem 4, N'test1', @added = @result OUTPUT
SELECT @result

SELECT * FROM gitSteamed.Items WHERE [name] = N'test1'