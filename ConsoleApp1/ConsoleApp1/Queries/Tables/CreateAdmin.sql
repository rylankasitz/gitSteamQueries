﻿DROP TABLE IF EXISTS gitSteamed.Admin;
GO


CREATE TABLE gitSteamed.Admin (
	Username NVARCHAR(64) NOT NULL PRIMARY KEY,
	[Password] NVARCHAR(256) NOT NULL
)
GO
