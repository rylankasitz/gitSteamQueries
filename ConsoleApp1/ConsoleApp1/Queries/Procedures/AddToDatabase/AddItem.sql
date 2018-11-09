drop table if exists gitSteamed.BundleContents
GO
drop table if exists gitSteamed.Items
GO
drop table if exists gitSteamed.Bundles
GO
DROP TABLE IF EXISTS gitSteamed.Reviews;
GO
DROP TABLE IF EXISTS gitSteamed.Users;
GO
DROP TABLE IF EXISTS gitSteamed.Libraries;
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

create table gitSteamed.BundleContents
(
	BundleContentsID int not null primary key identity(1,1),
	BundleID int not null foreign key references gitSteamed.Bundles(BundleID),
	ItemID int not null foreign key references gitSteamed.Items(ItemID),

	unique(BundleID, ItemID)
)
GO

create table gitSteamed.Items
(
	ItemID int not null primary key identity(1,1),
	Genre nvarchar(64) not null,
	Price float not null,
	[URL] nvarchar(256) not null unique,
	[Name] nvarchar(64) not null
)
GO

create table gitSteamed.Bundles
(
	BundleID int not null identity(1,1) primary key,
	[Name] NVARCHAR(128) not null,
	[URL] NVARCHAR(256) not null unique,
	FinalPrice float not null,
	DiscountPrice float null
)
GO


CREATE TABLE gitSteamed.Reviews (
	ReviewID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Username NVARCHAR(64) NOT NULL FOREIGN KEY
								REFERENCES gitSteamed.Users(Username),
	ItemId INT NOT NULL FOREIGN KEY
								REFERENCES gitSteamed.Items(ItemID),
	Funny INT NOT NULL DEFAULT(0),
	Posted DATETIMEOFFSET NOT NULL DEFAULT(SYSDATETIMEOFFSET()),
	LastEdited DATETIMEOFFSET NOT NULL DEFAULT(SYSDATETIMEOFFSET()),
	Helpful INT NULL,
	Recommend BIT NOT NULL,
	[Description] NVARCHAR(512) NOT NULL DEFAULT(N'No text'),
	CONSTRAINT [UK_gitSteamed_Library_Username_TermId] UNIQUE
	(
		Username ASC,
		ItemId ASC
	)
)
GO

CREATE TABLE gitSteamed.Libraries (
	LibraryID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Username NVARCHAR(64) NOT NULL FOREIGN KEY
								REFERENCES gitSteamed.Users(Username),
	ItemId INT NOT NULL FOREIGN KEY
								REFERENCES gitSteamed.Items(ItemID),
	TimePlayedForever INT NOT NULL DEFAULT(0),
	TimePlayed2Weeks INT NOT NULL DEFAULT(0),
	CONSTRAINT [UK_gitSteamed_Library_Username_TermId] UNIQUE
	(
		Username ASC,
		ItemId ASC
	)
)
GO
