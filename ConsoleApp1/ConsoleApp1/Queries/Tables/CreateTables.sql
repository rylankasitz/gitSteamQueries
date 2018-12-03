drop table if exists gitSteamed.BundleContents
GO
DROP TABLE IF EXISTS gitSteamed.Libraries;
GO
DROP TABLE IF EXISTS gitSteamed.ArchivedReviews
GO
DROP TABLE IF EXISTS gitSteamed.Reviews;
GO
DROP TABLE IF EXISTS gitSteamed.ItemsGenreContents;
GO
drop table if exists gitSteamed.Items
GO
drop table if exists gitSteamed.Bundles
GO
DROP TABLE IF EXISTS gitSteamed.Users;
GO
DROP TABLE IF EXISTS gitSteamed.Genres;
GO

CREATE TABLE gitSteamed.Users (
	Username NVARCHAR(64) NOT NULL PRIMARY KEY,
	ItemCount INT NOT NULL,
	[Url] NVARCHAR(256) NULL,
)
GO

CREATE TABLE gitSteamed.Genres
(
	GenreID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[Name] NVARCHAR(32) NOT NULL
)

create table gitSteamed.Items
(
	ItemID int not null primary key,
	Price float null,
	[URL] nvarchar(256) null,
	[Name] nvarchar(128) NULL
)
GO

CREATE TABLE gitSteamed.ItemsGenreContents
(
	ItemsGenreID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	GenreID INT NULL FOREIGN KEY REFERENCES gitSteamed.Genres(GenreID),
	ItemID INT NULL FOREIGN KEY REFERENCES gitSteamed.Items(ItemID), 
	CONSTRAINT [UK_gitSteamed_Genres_Items] UNIQUE
	(
		GenreID ASC,
		ItemID ASC
	)
)

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

CREATE TABLE gitSteamed.ArchivedReviews(
	ArchivedID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
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