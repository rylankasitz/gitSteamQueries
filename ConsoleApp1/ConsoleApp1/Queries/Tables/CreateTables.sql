﻿drop table if exists gitSteamed.BundleContents
GO
DROP TABLE IF EXISTS gitSteamed.Libraries;
GO
DROP TABLE IF EXISTS gitSteamed.Reviews;
GO
drop table if exists gitSteamed.Items
GO
drop table if exists gitSteamed.Bundles
GO
DROP TABLE IF EXISTS gitSteamed.Users;
GO


DROP TABLE IF EXISTS gitSteamed.ArchivedItems
GO


CREATE TABLE gitSteamed.Users (
	Username NVARCHAR(64) NOT NULL PRIMARY KEY,
	ItemCount INT NOT NULL,
	[Url] NVARCHAR(256) NOT NULL,
	CONSTRAINT [UK_gitSteamed_Users_Url] UNIQUE
	(
		[Url] ASC
	)
)
GO

create table gitSteamed.Items
(
	ItemID int not null primary key,
	Genre nvarchar(128) null,
	Price float null,
	[URL] nvarchar(256) null,
	[Name] nvarchar(128) NULL
)
GO

create table gitSteamed.Bundles
(
	BundleID int not null primary key,
	[Name] NVARCHAR(128) not null,
	[URL] NVARCHAR(512) not null unique,
	FinalPrice float not null,
	DiscountPrice float null
)
GO

create table gitSteamed.BundleContents
(
	BundleContentsID int not null primary key identity(1,1),
	BundleID int not null foreign key references gitSteamed.Bundles(BundleID),
	ItemID int not null foreign key references gitSteamed.Items(ItemID),

	unique(BundleID, ItemID)
)
GO

CREATE TABLE gitSteamed.Reviews (
	ReviewID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Username NVARCHAR(64) NOT NULL FOREIGN KEY
								REFERENCES gitSteamed.Users(Username),
	ItemID INT NOT NULL FOREIGN KEY
								REFERENCES gitSteamed.Items(ItemID),
	Funny INT NOT NULL DEFAULT(0),
	Posted DATETIMEOFFSET NOT NULL DEFAULT(SYSDATETIMEOFFSET()),
	LastEdited DATETIMEOFFSET NOT NULL DEFAULT(SYSDATETIMEOFFSET()),
	Helpful INT NULL,
	Recommend BIT NOT NULL,
	[Description] NVARCHAR(4000) NOT NULL DEFAULT(N'No text')
	/*CONSTRAINT [UK_gitSteamed_Reviews_Username_ItemID] UNIQUE
	(
		Username ASC,
		ItemID ASC
	)*/
)
GO

CREATE TABLE gitSteamed.Libraries (
	LibraryID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Username NVARCHAR(64) NOT NULL FOREIGN KEY
								REFERENCES gitSteamed.Users(Username),
	ItemID INT NOT NULL FOREIGN KEY
								REFERENCES gitSteamed.Items(ItemID),
	TimePlayedForever INT NOT NULL DEFAULT(0),
	TimePlayed2Weeks INT NOT NULL DEFAULT(0),
	CONSTRAINT [UK_gitSteamed_Library_Username_ItemID] UNIQUE
	(
		Username ASC,
		ItemId ASC
	)
)
GO

CREATE TABLE gitSteamed.ArchivedItems (
	ArchivedId INT NOT NULL IDENTITY(1,1),
	ItemID int not null FOREIGN KEY 
				REFERENCES gitSteamed.Items(ItemID),
	Genre nvarchar(128) null,
	Price float null,
	[URL] nvarchar(256) null,
	[Name] nvarchar(128) NULL,
	Archived DATETIMEOFFSET NOT NULL DEFAULT(SYSDATETIMEOFFSET())
)
GO