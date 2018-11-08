drop table if exists gitSteamed.BundleContents
GO
drop table if exists gitSteamed.Items
GO
drop table if exists gitSteamed.Bundles
go


create table gitSteamed.BundleContents
(
	BundleContentsID int not null primary key identity(1,1),
	BundleID int not null foreign key references gitSteamed.Bundles(BundleID),
	ItemID int not null foreign key references gitSteamed.Items(ItemID),

	unique(BundleID, ItemID)
)

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
