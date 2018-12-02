﻿DROP TABLE IF EXISTS gitSteamed.ArchivedItems
GO

DROP TABLE IF EXISTS gitSteamed.ArchivedReviews
GO

CREATE TABLE gitSteamed.ArchivedItems (
	ArchivedId INT NOT NULL IDENTITY(1,1),
	ItemID int not null FOREIGN KEY 
				REFERENCES gitSteamed.Items(ItemID),
	Price float null,
	[URL] nvarchar(256) null,
	[Name] nvarchar(128) NULL,
	Archived DATETIMEOFFSET NOT NULL DEFAULT(SYSDATETIMEOFFSET())
)
GO

CREATE TABLE gitSteamed.ArchivedReviews(
	ArchivedId INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	ReviewID INT NOT NULL FOREIGN KEY REFERENCES gitSteamed.Reviews(ReviewID),
	Username NVARCHAR(64) NOT NULL FOREIGN KEY
								REFERENCES gitSteamed.Users(Username),
	ItemID INT NOT NULL FOREIGN KEY
								REFERENCES gitSteamed.Items(ItemID),
	Funny INT NOT NULL DEFAULT(0),
	Posted DATETIMEOFFSET NOT NULL DEFAULT(SYSDATETIMEOFFSET()),
	LastEdited DATETIMEOFFSET NOT NULL DEFAULT(SYSDATETIMEOFFSET()),
	Helpful INT NULL,
	Recommend BIT NOT NULL,
	[Description] NVARCHAR(4000) NOT NULL DEFAULT(N'No text'),
	Archived DATETIMEOFFSET NOT NULL DEFAULT(SYSDATETIMEOFFSET())
)