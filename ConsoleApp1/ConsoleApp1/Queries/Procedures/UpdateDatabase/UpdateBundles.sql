CREATE OR ALTER PROCEDURE gitSteamed.UpdateBundlePrice
	@BundleID INT,
	@FinalPrice FLOAT,
	@DiscountedPrive FLOAT
AS
	UPDATE gitSteamed.Bundles
	SET FinalPrice = @FinalPrice, DiscountPrice = @DiscountedPrive
	WHERE BundleID = @BundleID
GO