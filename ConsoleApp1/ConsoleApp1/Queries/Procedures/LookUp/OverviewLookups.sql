DROP PROCEDURE IF EXISTS gitSteamed.GetTotalUsers
GO

CREATE OR ALTER PROCEDURE gitSteamed.GetTotalUsers
AS
	SELECT COUNT(*) TotalUsers FROM gitSteamed.Users
GO

EXEC gitSteamed.GetTotalUsers