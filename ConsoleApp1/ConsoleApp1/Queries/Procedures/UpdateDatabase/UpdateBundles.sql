DROP PROCEDURE IF EXISTS gitSteamed.UpdateBundlePrice
GO

CREATE OR ALTER PROCEDURE gitSteamed.UpdateBundlePrice
	@BundleID INT,
	@FinalPrice FLOAT,
	@DiscountedPrice FLOAT
AS
	UPDATE gitSteamed.Bundles
	SET FinalPrice = @FinalPrice, DiscountPrice = @DiscountedPrice
	WHERE BundleID = @BundleID
GO

EXEC gitSteamed.UpdateBundlePrice 1208, 5000, 5000
EXEC gitSteamed.GetBundleStats 1208