DROP PROCEDURE IF EXISTS gitSteamed.UpdateBundlePrice
GO

CREATE OR ALTER PROCEDURE gitSteamed.UpdateBundlePrice
	@BundleID INT,
	@DiscountedPrice FLOAT,
	@Valid INT OUTPUT
AS
	SET @Valid = 1
	DECLARE @FinalPrice FLOAT = (SELECT FinalPrice FROM gitSteamed.Bundles WHERE BundleID = @BundleID)
	UPDATE gitSteamed.Bundles
	SET DiscountPrice = @DiscountedPrice
	WHERE BundleID = @BundleID AND @DiscountedPrice < @FinalPrice
	IF (@DiscountedPrice > @FinalPrice) SET @Valid = 0;
GO

DECLARE @out INT
EXEC gitSteamed.UpdateBundlePrice 1208, 6000, @out OUTPUT
SELECT @out
EXEC gitSteamed.GetBundleStats 1208