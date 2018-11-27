CREATE OR ALTER PROCEDURE gitSteamed.AddItem
	@genre NVARCHAR(64),
	@price FLOAT,
	@url NVARCHAR(256),
	@name NVARCHAR(64)
AS

WITH ItemCTE(Genre, Price, URL, Name) AS (
	SELECT *
	FROM (VALUES(@genre, @price, @url, @name)) AS P(Genre, Price, URL, Name)
)
MERGE gitSteamed.Items I
USING ItemCTE C ON	C.Name = I.Name
WHEN MATCHED THEN
	UPDATE SET
		I.Genre = ISNULL(@genre, I.Genre),
		I.Price = ISNULL(@price, I.Price),
		I.URL = ISNULL(@url, I.URL),
		I.Name = @name
	WHEN NOT MATCHED THEN
		INSERT (Genre, Price, [URL], [Name])
		VALUES(@genre, @price, @url, @name);
GO