USE [YallaBaityDB]
GO
/****** Object:  Schema [Auth]    Script Date: 2023-02-25 11:18:20 AM ******/
CREATE SCHEMA [Auth]
GO
/****** Object:  Schema [common]    Script Date: 2023-02-25 11:18:20 AM ******/
CREATE SCHEMA [common]
GO
/****** Object:  Schema [food]    Script Date: 2023-02-25 11:18:20 AM ******/
CREATE SCHEMA [food]
GO
/****** Object:  Schema [order]    Script Date: 2023-02-25 11:18:20 AM ******/
CREATE SCHEMA [order]
GO
/****** Object:  Schema [user]    Script Date: 2023-02-25 11:18:20 AM ******/
CREATE SCHEMA [user]
GO
/****** Object:  UserDefinedFunction [food].[CalculateDistanceKM]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [food].[CalculateDistanceKM] (
    @Latitude1 FLOAT,
    @Longitude1 FLOAT,
    @Latitude2 FLOAT,
    @Longitude2 FLOAT
)
RETURNS FLOAT
AS
BEGIN
 
    DECLARE @PI FLOAT = PI()
 
    DECLARE @lat1Radianos FLOAT = @Latitude1 * @PI / 180
    DECLARE @lng1Radianos FLOAT = @Longitude1 * @PI / 180
    DECLARE @lat2Radianos FLOAT = @Latitude2 * @PI / 180
    DECLARE @lng2Radianos FLOAT = @Longitude2 * @PI / 180
 
    RETURN (ACOS(COS(@lat1Radianos) * COS(@lng1Radianos) * COS(@lat2Radianos) * COS(@lng2Radianos) + COS(@lat1Radianos) * SIN(@lng1Radianos) * COS(@lat2Radianos) * SIN(@lng2Radianos) + SIN(@lat1Radianos) * SIN(@lat2Radianos)) * 6371) * 1.15
 
END
GO
/****** Object:  UserDefinedFunction [food].[IsFavorite]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [food].[IsFavorite] (
    @UserId int,
    @FoodId int
)
RETURNS bit
AS
BEGIN 
  declare @result bit;
  select @result=iif( COUNT(*)>0,'True','False') from [user].UsersFavorite where [user].UsersFavorite.UserId=@UserId and [user].UsersFavorite.FoodId=@FoodId;
 RETURN @result;
END
GO
/****** Object:  Table [Auth].[DashBoardUsers]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Auth].[DashBoardUsers](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](50) NULL,
	[GroupId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_DashBoardUsers] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Auth].[GroupPermissions]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Auth].[GroupPermissions](
	[GroupPermissionId] [int] IDENTITY(1,1) NOT NULL,
	[GroupId] [int] NOT NULL,
	[PageId] [int] NOT NULL,
 CONSTRAINT [PK_GroupPermission] PRIMARY KEY CLUSTERED 
(
	[GroupPermissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Auth].[Groups]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Auth].[Groups](
	[GroupId] [int] IDENTITY(1,1) NOT NULL,
	[GroupAname] [nvarchar](50) NOT NULL,
	[GroupEname] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Groups] PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Auth].[Pages]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Auth].[Pages](
	[PageId] [int] IDENTITY(1,1) NOT NULL,
	[PageAname] [nvarchar](50) NOT NULL,
	[PageEname] [nvarchar](50) NOT NULL,
	[PageKey] [nvarchar](50) NULL,
	[PagesTabId] [int] NOT NULL,
 CONSTRAINT [PK_Pages] PRIMARY KEY CLUSTERED 
(
	[PageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Auth].[PagesTabs]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Auth].[PagesTabs](
	[PagesTabId] [int] IDENTITY(1,1) NOT NULL,
	[PagesTabAname] [nvarchar](50) NOT NULL,
	[PagesTabEname] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_PagesTap] PRIMARY KEY CLUSTERED 
(
	[PagesTabId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [common].[Information]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [common].[Information](
	[InformationId] [int] IDENTITY(1,1) NOT NULL,
	[About] [nvarchar](max) NULL,
	[TermsAndPrivacy] [nvarchar](max) NULL,
 CONSTRAINT [PK_Information] PRIMARY KEY CLUSTERED 
(
	[InformationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [food].[Ads]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [food].[Ads](
	[AdsId] [int] NOT NULL,
	[AdsImage] [nvarchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Ads] PRIMARY KEY CLUSTERED 
(
	[AdsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [food].[Basket]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [food].[Basket](
	[BasketId] [int] IDENTITY(1,1) NOT NULL,
	[FoodId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
 CONSTRAINT [PK_Basket] PRIMARY KEY CLUSTERED 
(
	[BasketId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [food].[BasketSizes]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [food].[BasketSizes](
	[BasketSizesId] [int] IDENTITY(1,1) NOT NULL,
	[FoodsSizesId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[BasketId] [int] NOT NULL,
 CONSTRAINT [PK_BasketSizes] PRIMARY KEY CLUSTERED 
(
	[BasketSizesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [food].[Categories]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [food].[Categories](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryAname] [nvarchar](50) NOT NULL,
	[CategoryEname] [nvarchar](50) NOT NULL,
	[CategoryADescription] [nvarchar](100) NULL,
	[CategoryEDescription] [nvarchar](100) NULL,
	[ImagePath] [nvarchar](100) NOT NULL,
	[BackgroundColor] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[IsDelete] [bit] NOT NULL,
 CONSTRAINT [PK_Categorys] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [food].[FoodCategories]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [food].[FoodCategories](
	[FoodCategoriesId] [int] IDENTITY(1,1) NOT NULL,
	[FoodId] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
 CONSTRAINT [PK_FoodCategories] PRIMARY KEY CLUSTERED 
(
	[FoodCategoriesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [food].[Foods]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [food].[Foods](
	[FoodId] [int] NOT NULL,
	[FoodName] [nvarchar](50) NOT NULL,
	[Price] [decimal](18, 2) NOT NULL,
	[Description] [nvarchar](500) NOT NULL,
	[PreparationTime] [int] NULL,
	[UserId] [int] NOT NULL,
	[IsApproved] [bit] NOT NULL,
	[IsDelete] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Items] PRIMARY KEY CLUSTERED 
(
	[FoodId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [food].[FoodsImages]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [food].[FoodsImages](
	[FoodsImagesId] [int] IDENTITY(1,1) NOT NULL,
	[ImagePath] [nvarchar](100) NOT NULL,
	[FoodId] [int] NOT NULL,
 CONSTRAINT [PK_ItemImages] PRIMARY KEY CLUSTERED 
(
	[FoodsImagesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [food].[FoodsSizes]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [food].[FoodsSizes](
	[FoodsSizesId] [int] IDENTITY(1,1) NOT NULL,
	[Price] [decimal](18, 2) NOT NULL,
	[SizeId] [int] NOT NULL,
	[SizeDescription] [nvarchar](100) NULL,
	[FoodId] [int] NOT NULL,
 CONSTRAINT [PK_ItemSizes] PRIMARY KEY CLUSTERED 
(
	[FoodsSizesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [food].[Sizes]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [food].[Sizes](
	[SizeId] [int] IDENTITY(1,1) NOT NULL,
	[SizeAName] [nvarchar](50) NOT NULL,
	[SizeEName] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsDelete] [bit] NOT NULL,
 CONSTRAINT [PK_Sizes] PRIMARY KEY CLUSTERED 
(
	[SizeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [order].[Drivers]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [order].[Drivers](
	[DriverId] [int] IDENTITY(1,1) NOT NULL,
	[DriverName] [nvarchar](50) NOT NULL,
	[Phone] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[NationalIDCardFace] [nvarchar](100) NOT NULL,
	[NationalIDCardBack] [nvarchar](100) NOT NULL,
	[HealthCertificateFace] [nvarchar](100) NOT NULL,
	[HealthCertificateBack] [nvarchar](100) NOT NULL,
	[DrivingLicenseFace] [nvarchar](100) NOT NULL,
	[DrivingLicenseBack] [nvarchar](100) NOT NULL,
	[PersonalLicenseFace] [nvarchar](100) NOT NULL,
	[PersonalLicenseBack] [nvarchar](100) NOT NULL,
	[IsDelete] [bit] NOT NULL,
	[IsApproved] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Driver] PRIMARY KEY CLUSTERED 
(
	[DriverId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [order].[FoodOrders]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [order].[FoodOrders](
	[OrderId] [int] IDENTITY(1,1) NOT NULL,
	[OrderCode] [nvarchar](50) NULL,
	[OrderDate] [datetime] NOT NULL,
	[DriverId] [int] NULL,
	[UserId] [int] NOT NULL,
	[IsSchedule] [bit] NULL,
	[HandDate] [datetime] NULL,
	[DeliveryCost] [decimal](18, 2) NOT NULL,
	[Total] [decimal](18, 2) NOT NULL,
	[NetTotal] [decimal](18, 2) NOT NULL,
	[OrderStatusId] [int] NULL,
	[UsersAddressId] [int] NOT NULL,
	[PaymentMethodsId] [int] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [order].[OrderDetails]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [order].[OrderDetails](
	[OrderDetailsId] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[FoodId] [int] NOT NULL,
 CONSTRAINT [PK_OrderDetails] PRIMARY KEY CLUSTERED 
(
	[OrderDetailsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [order].[OrderSizes]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [order].[OrderSizes](
	[OrderSizesId] [int] IDENTITY(1,1) NOT NULL,
	[FoodsSizesId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[OrderDetailsId] [int] NOT NULL,
 CONSTRAINT [PK_OrderSizes] PRIMARY KEY CLUSTERED 
(
	[OrderSizesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [order].[OrderStatus]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [order].[OrderStatus](
	[OrderStatusId] [int] NOT NULL,
	[OrderStatusAName] [nvarchar](50) NOT NULL,
	[OrderStatusEName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_OrderStatus] PRIMARY KEY CLUSTERED 
(
	[OrderStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [order].[PaymentMethods]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [order].[PaymentMethods](
	[PaymentMethodsId] [int] NOT NULL,
	[PaymentMethodsAName] [nvarchar](50) NOT NULL,
	[PaymentMethodsEName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_PaymentMethods] PRIMARY KEY CLUSTERED 
(
	[PaymentMethodsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [user].[Governorates]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [user].[Governorates](
	[GovernorateId] [int] IDENTITY(1,1) NOT NULL,
	[GovernorateAName] [nvarchar](50) NOT NULL,
	[GovernorateEName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Governorates] PRIMARY KEY CLUSTERED 
(
	[GovernorateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [user].[UserRating]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [user].[UserRating](
	[UserRatingId] [int] IDENTITY(1,1) NOT NULL,
	[FoodId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[Rating] [int] NOT NULL,
	[Description] [nvarchar](400) NULL,
	[RatingDate] [date] NULL,
 CONSTRAINT [PK_UserRating] PRIMARY KEY CLUSTERED 
(
	[UserRatingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [user].[Users]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [user].[Users](
	[UserId] [int] NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[Phone] [nvarchar](15) NOT NULL,
	[Image] [nvarchar](100) NULL,
	[Gender] [bit] NOT NULL,
	[IsProvider] [bit] NOT NULL,
	[Latitude] [float] NULL,
	[Longitude] [float] NULL,
	[GovernorateId] [int] NULL,
	[Address] [nvarchar](500) NULL,
	[NationalIDCard1] [nvarchar](100) NULL,
	[NationalIDCard2] [nvarchar](100) NULL,
	[IsApproved] [bit] NULL,
	[IsActive] [bit] NOT NULL,
	[IsDelete] [bit] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[OTPCode] [int] NULL,
	[OTPNumberOfTimesSent] [int] NULL,
	[OTPDateOfLastSent] [datetime] NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [user].[UsersAddress]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [user].[UsersAddress](
	[UsersAddressId] [int] IDENTITY(1,1) NOT NULL,
	[UsersAddressName] [nvarchar](100) NOT NULL,
	[UserId] [int] NOT NULL,
	[Address] [nvarchar](900) NOT NULL,
	[ApartmentNo] [int] NOT NULL,
	[BuildingNo] [int] NOT NULL,
	[Street] [nvarchar](100) NOT NULL,
	[Floor] [int] NOT NULL,
	[Latitude] [float] NOT NULL,
	[Longitude] [float] NOT NULL,
 CONSTRAINT [PK_UsersAddress] PRIMARY KEY CLUSTERED 
(
	[UsersAddressId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [user].[UsersFavorite]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [user].[UsersFavorite](
	[UsersFavoriteId] [int] IDENTITY(1,1) NOT NULL,
	[FoodId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
 CONSTRAINT [PK_UsersLikes] PRIMARY KEY CLUSTERED 
(
	[UsersFavoriteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [user].[UsersViews]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [user].[UsersViews](
	[UsersViewsId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[FoodId] [int] NOT NULL,
 CONSTRAINT [PK_UsersViews] PRIMARY KEY CLUSTERED 
(
	[UsersViewsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [user].[Wallet]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [user].[Wallet](
	[UserId] [int] NOT NULL,
	[Balance] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_Wallet_1] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [user].[WalletHistory]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [user].[WalletHistory](
	[WalletHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[Balance] [decimal](18, 2) NOT NULL,
	[Effect] [int] NOT NULL,
	[Commission] [decimal](18, 2) NOT NULL,
	[OrderId] [int] NULL,
 CONSTRAINT [PK_WalletHistory] PRIMARY KEY CLUSTERED 
(
	[WalletHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [food].[VwFood]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [food].[VwFood]
AS
SELECT ROW_NUMBER() OVER (ORDER BY FoodId) AS 'Serial', food.Foods.*, [user].Users.UserName AS 'CookName', [user].Users.Latitude, [user].Users.Longitude,
    (SELECT ImagePath
     FROM      food.FoodsImages
     WHERE   food.FoodsImages.FoodId = food.Foods.FoodId
     ORDER BY food.FoodsImages.FoodId OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY) AS 'ImagePath',
       ISNULL((SELECT ROUND(cast(sum(Rating) AS decimal) / COUNT(*), 2)FROM [user].UserRating WHERE   FoodId = food.Foods.FoodId),0) AS 'Rate',
    (SELECT COUNT(*)
     FROM      [user].UserRating
     WHERE   FoodId = food.Foods.FoodId) AS 'RateCount',
    (SELECT COUNT(*)
     FROM      [order].OrderDetails
     WHERE   [order].OrderDetails.FoodId = food.Foods.FoodId) AS MostPopular,
    (SELECT COUNT(*)
     FROM      [user].UsersViews
     WHERE   [user].UsersViews.FoodId = food.Foods.FoodId) AS MostWatched, cast('False' AS bit) AS IsFavorited, iif(DATEDIFF(DAY, food.Foods.CreationDate, GETDATE()) = 0, 'ToDay', iif(DATEDIFF(DAY, food.Foods.CreationDate, GETDATE()) <= 29, 
Cast(DATEDIFF(DAY, food.Foods.CreationDate, GETDATE()) AS nvarchar) + ' Day', iif(DATEDIFF(month, food.Foods.CreationDate, GETDATE()) < 12, Cast(DATEDIFF(month, food.Foods.CreationDate, GETDATE()) AS nvarchar) + ' Month', 
Cast(DATEDIFF(year, food.Foods.CreationDate, GETDATE()) AS nvarchar) + ' Year'))) AS [Date]
FROM     food.Foods JOIN
                  [user].Users ON [user].Users.UserId = food.Foods.UserId
WHERE  food.Foods.IsDelete = 'false'
GO
/****** Object:  View [food].[VwBasket]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [food].[VwBasket]
AS
SELECT food.Basket.BasketId, food.BasketSizes.FoodsSizesId, food.Basket.UserId, food.VwFood.FoodId, food.VwFood.FoodName, food.VwFood.CookName, food.VwFood.PreparationTime, food.VwFood.Rate, food.BasketSizes.Quantity, 
                  food.FoodsSizes.Price, food.VwFood.ImagePath, food.Sizes.SizeEName, food.Sizes.SizeAName
FROM     food.BasketSizes INNER JOIN
                  food.FoodsSizes ON food.FoodsSizes.FoodsSizesId = food.BasketSizes.FoodsSizesId INNER JOIN
                  food.Sizes ON food.Sizes.SizeId = food.FoodsSizes.SizeId INNER JOIN
                  food.Basket ON food.Basket.BasketId = food.BasketSizes.BasketId INNER JOIN
                  food.VwFood ON food.VwFood.FoodId = food.Basket.FoodId
GO
/****** Object:  View [order].[VwOrderDetails]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [order].[VwOrderDetails]
AS
SELECT [order].OrderDetails.OrderDetailsId,
 [order].FoodOrders.OrderId, [order].OrderSizes.Quantity, food.FoodsSizes.Price, food.VwFood.FoodId, food.VwFood.FoodName, food.VwFood.CookName, food.VwFood.ImagePath, 
 iif(DATEDIFF(DAY,[order].FoodOrders.OrderDate, GETDATE()) = 0, 'ToDay', iif(DATEDIFF(DAY,[order].FoodOrders.OrderDate, GETDATE()) <= 29, 
Cast(DATEDIFF(DAY, [order].FoodOrders.OrderDate, GETDATE()) AS nvarchar) + ' Day', iif(DATEDIFF(month, [order].FoodOrders.OrderDate, GETDATE()) < 12, Cast(DATEDIFF(month,[order].FoodOrders.OrderDate, GETDATE()) AS nvarchar) + ' Month', 
Cast(DATEDIFF(year, [order].FoodOrders.OrderDate, GETDATE()) AS nvarchar) + ' Year'))) AS [ShortDate],
                  [order].FoodOrders.OrderDate, [order].FoodOrders.UserId, [order].FoodOrders.NetTotal, [order].FoodOrders.Total, [order].FoodOrders.DeliveryCost, food.VwFood.UserId AS ProviderId, [order].FoodOrders.OrderCode, 
                  [order].OrderStatus.OrderStatusAName, [order].OrderStatus.OrderStatusEName, [order].PaymentMethods.PaymentMethodsAName, [order].PaymentMethods.PaymentMethodsEName, [order].FoodOrders.IsSchedule, 
                  food.Sizes.SizeEName, food.Sizes.SizeAName
FROM     [order].FoodOrders INNER JOIN
                  [order].OrderStatus ON [order].OrderStatus.OrderStatusId = [order].FoodOrders.OrderStatusId INNER JOIN
                  [order].OrderDetails ON [order].FoodOrders.OrderId = [order].OrderDetails.OrderId INNER JOIN
                  [order].OrderSizes ON [order].OrderDetails.OrderDetailsId = [order].OrderSizes.OrderDetailsId INNER JOIN
                  food.FoodsSizes ON [order].OrderSizes.FoodsSizesId = food.FoodsSizes.FoodsSizesId INNER JOIN
                  food.Sizes ON food.FoodsSizes.SizeId = food.Sizes.SizeId AND food.FoodsSizes.SizeId = food.Sizes.SizeId AND food.FoodsSizes.SizeId = food.Sizes.SizeId AND food.FoodsSizes.SizeId = food.Sizes.SizeId INNER JOIN
                  [order].PaymentMethods ON [order].FoodOrders.PaymentMethodsId = [order].PaymentMethods.PaymentMethodsId LEFT OUTER JOIN
                  food.VwFood ON food.FoodsSizes.FoodId = food.VwFood.FoodId
GO
/****** Object:  View [Auth].[VwDashBoardUsers]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Auth].[VwDashBoardUsers]
AS
SELECT  ROW_NUMBER() OVER (ORDER BY UserId) AS 'Serial',Auth.DashBoardUsers.UserId, Auth.DashBoardUsers.UserName, Auth.DashBoardUsers.Password, Auth.DashBoardUsers.Email, Auth.DashBoardUsers.GroupId, Auth.DashBoardUsers.IsActive, Auth.Groups.GroupAname, 
                  Auth.Groups.GroupEname
FROM     Auth.Groups INNER JOIN
                  Auth.DashBoardUsers ON Auth.Groups.GroupId = Auth.DashBoardUsers.GroupId
GO
/****** Object:  View [Auth].[VwGroups]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Auth].[VwGroups]
AS
SELECT ROW_NUMBER() OVER (ORDER BY GroupId) AS 'Serial', Auth.Groups.*
FROM     Auth.Groups
GO
/****** Object:  View [Auth].[VwPagesGroupPermission]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Auth].[VwPagesGroupPermission]
AS
SELECT ROW_NUMBER() OVER (ORDER BY GroupPermissionId) AS 'Serial', Auth.GroupPermissions.GroupPermissionId, Auth.GroupPermissions.GroupId, Auth.GroupPermissions.PageId, Auth.Pages.PageKey
FROM     Auth.GroupPermissions INNER JOIN
                  Auth.Pages ON Auth.GroupPermissions.PageId = Auth.Pages.PageId
GO
/****** Object:  View [food].[VwCategories]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [food].[VwCategories]
AS
SELECT ROW_NUMBER() OVER (ORDER BY CategoryId) AS 'Serial', food.Categories.*
FROM   food.Categories
WHERE  isDelete = 'false'
GO
/****** Object:  View [food].[VwFoodCategories]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [food].[VwFoodCategories]
AS
SELECT food.FoodCategories.FoodCategoriesId, food.FoodCategories.FoodId, food.FoodCategories.CategoryId, food.Foods.UserId
FROM     food.FoodCategories INNER JOIN
                  food.Foods ON food.FoodCategories.FoodId = food.Foods.FoodId
GO
/****** Object:  View [food].[VwFoodsSizes]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [food].[VwFoodsSizes]
AS
SELECT food.FoodsSizes.FoodsSizesId, food.FoodsSizes.Price, food.FoodsSizes.SizeDescription, food.FoodsSizes.FoodId, food.FoodsSizes.SizeId, food.Sizes.SizeAName, food.Sizes.SizeEName
FROM     food.FoodsSizes INNER JOIN
                  food.Sizes ON food.Sizes.SizeId = food.FoodsSizes.SizeId
WHERE  (food.Sizes.IsActive = 'True')
GO
/****** Object:  View [food].[VwSizes]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [food].[VwSizes]
AS
SELECT ROW_NUMBER() OVER (ORDER BY SizeId) AS 'Serial', food.Sizes.*
FROM     food.Sizes
WHERE  isDelete = 'false'
GO
/****** Object:  View [order].[VwFoodOrders]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [order].[VwFoodOrders]
AS
SELECT [order].FoodOrders.OrderId, [order].FoodOrders.OrderCode, 
 iif(DATEDIFF(DAY,[order].FoodOrders.OrderDate, GETDATE()) = 0, 'ToDay', iif(DATEDIFF(DAY,[order].FoodOrders.OrderDate, GETDATE()) <= 29, 
Cast(DATEDIFF(DAY, [order].FoodOrders.OrderDate, GETDATE()) AS nvarchar) + ' Day', iif(DATEDIFF(month, [order].FoodOrders.OrderDate, GETDATE()) < 12, Cast(DATEDIFF(month,[order].FoodOrders.OrderDate, GETDATE()) AS nvarchar) + ' Month', 
Cast(DATEDIFF(year, [order].FoodOrders.OrderDate, GETDATE()) AS nvarchar) + ' Year'))) AS [ShortDate],

[order].FoodOrders.OrderDate,

 [order].FoodOrders.DriverId, [order].FoodOrders.UserId, [order].FoodOrders.HandDate, [order].FoodOrders.DeliveryCost, 
                  [order].FoodOrders.Total, [order].FoodOrders.NetTotal, [order].FoodOrders.UsersAddressId, [user].UsersAddress.UsersAddressName, [user].UsersAddress.BuildingNo, [user].UsersAddress.ApartmentNo, [user].UsersAddress.Street, 
                  [user].UsersAddress.Floor, [user].UsersAddress.Latitude, [user].UsersAddress.Longitude, [user].UsersAddress.Address, [order].FoodOrders.OrderStatusId, [order].OrderStatus.OrderStatusAName, 
                  [order].OrderStatus.OrderStatusEName, [order].PaymentMethods.PaymentMethodsAName, [order].PaymentMethods.PaymentMethodsEName, [order].FoodOrders.IsSchedule
FROM     [order].FoodOrders INNER JOIN
                  [user].UsersAddress ON [order].FoodOrders.UsersAddressId = [user].UsersAddress.UsersAddressId INNER JOIN
                  [order].OrderStatus ON [order].OrderStatus.OrderStatusId = [order].FoodOrders.OrderStatusId INNER JOIN
                  [order].PaymentMethods ON [order].FoodOrders.PaymentMethodsId = [order].PaymentMethods.PaymentMethodsId
GO
/****** Object:  View [user].[VwProviders]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [user].[VwProviders]
AS
SELECT UserId AS CookId, UserName AS CookName, Gender,
                      (SELECT COUNT(Rating) AS Expr1
                       FROM      [user].UserRating
                       WHERE   (FoodId IN
                                             (SELECT FoodId
                                              FROM      food.Foods
                                              WHERE   (UserId = [user].Users.UserId)))) AS RateCount,
                      (SELECT SUM(Rating) / COUNT(Rating) AS Expr1
                       FROM      [user].UserRating AS UserRating_1
                       WHERE   (FoodId IN
                                             (SELECT FoodId
                                              FROM      food.Foods AS Foods_1
                                              WHERE   (UserId = [user].Users.UserId)))) AS Rate
FROM     [user].Users
GO
/****** Object:  View [user].[VwUserRating]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [user].[VwUserRating]
AS
SELECT [user].UserRating.UserRatingId, [user].UserRating.FoodId, [user].UserRating.UserId, [user].UserRating.Rating, [user].UserRating.Description, [user].Users.UserName, iif(DATEDIFF(DAY, [user].UserRating.RatingDate, GETDATE()) = 0, 
                  'ToDay', iif(DATEDIFF(DAY, [user].UserRating.RatingDate, GETDATE()) <= 29, Cast(DATEDIFF(DAY, [user].UserRating.RatingDate, GETDATE()) AS nvarchar) + ' Day', iif(DATEDIFF(month, [user].UserRating.RatingDate, GETDATE()) < 12, 
                  Cast(DATEDIFF(month, [user].UserRating.RatingDate, GETDATE()) AS nvarchar) + ' Month', Cast(DATEDIFF(year, [user].UserRating.RatingDate, GETDATE()) AS nvarchar) + ' Year'))) AS RatingDate
FROM     [user].UserRating JOIN
                  [user].Users ON [user].Users.UserId = [user].UserRating.UserId
GO
/****** Object:  View [user].[VwUsers]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [user].[VwUsers]
AS
SELECT ROW_NUMBER() OVER (ORDER BY UserId) AS 'Serial', [user].Users.*, [user].Governorates.GovernorateAName, [user].Governorates.GovernorateEName
FROM     [user].Users LEFT OUTER JOIN
                  [user].Governorates ON [user].Users.GovernorateId = [user].Governorates.GovernorateId
GO
/****** Object:  View [user].[VwWalletHistory]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [user].[VwWalletHistory]
AS
SELECT UserId, Date, Amount, Balance, WalletHistoryId, Commission, Effect, OrderId
FROM     [user].WalletHistory
GO
SET IDENTITY_INSERT [Auth].[DashBoardUsers] ON 

INSERT [Auth].[DashBoardUsers] ([UserId], [UserName], [Password], [Email], [GroupId], [IsActive]) VALUES (1, N'Omar', N'e9+Jav4K/IY=', N'omarh9084@gmail.com', 1, 1)
INSERT [Auth].[DashBoardUsers] ([UserId], [UserName], [Password], [Email], [GroupId], [IsActive]) VALUES (2, N'ahmed', N'e9+Jav4K/IY=', N'omar@gmail.com', 1, 1)
INSERT [Auth].[DashBoardUsers] ([UserId], [UserName], [Password], [Email], [GroupId], [IsActive]) VALUES (3, N'Adel', N'e9+Jav4K/IY=', N'adel@gmail.com', 1, 1)
SET IDENTITY_INSERT [Auth].[DashBoardUsers] OFF
GO
SET IDENTITY_INSERT [Auth].[GroupPermissions] ON 

INSERT [Auth].[GroupPermissions] ([GroupPermissionId], [GroupId], [PageId]) VALUES (16, 1, 3)
INSERT [Auth].[GroupPermissions] ([GroupPermissionId], [GroupId], [PageId]) VALUES (17, 1, 2)
INSERT [Auth].[GroupPermissions] ([GroupPermissionId], [GroupId], [PageId]) VALUES (18, 1, 1)
SET IDENTITY_INSERT [Auth].[GroupPermissions] OFF
GO
SET IDENTITY_INSERT [Auth].[Groups] ON 

INSERT [Auth].[Groups] ([GroupId], [GroupAname], [GroupEname], [IsActive]) VALUES (1, N'المدير', N'Manager', 1)
INSERT [Auth].[Groups] ([GroupId], [GroupAname], [GroupEname], [IsActive]) VALUES (4, N'المستخدمين', N'Users', 1)
INSERT [Auth].[Groups] ([GroupId], [GroupAname], [GroupEname], [IsActive]) VALUES (5, N'w', N'w', 1)
SET IDENTITY_INSERT [Auth].[Groups] OFF
GO
SET IDENTITY_INSERT [Auth].[Pages] ON 

INSERT [Auth].[Pages] ([PageId], [PageAname], [PageEname], [PageKey], [PagesTabId]) VALUES (1, N'المستخدمين', N'Users', N'users', 1)
INSERT [Auth].[Pages] ([PageId], [PageAname], [PageEname], [PageKey], [PagesTabId]) VALUES (2, N'المجموعات', N'Groups', N'groups', 1)
INSERT [Auth].[Pages] ([PageId], [PageAname], [PageEname], [PageKey], [PagesTabId]) VALUES (3, N'صلاحيات المجموعات', N'Group Permissions', N'group_permissions', 1)
SET IDENTITY_INSERT [Auth].[Pages] OFF
GO
SET IDENTITY_INSERT [Auth].[PagesTabs] ON 

INSERT [Auth].[PagesTabs] ([PagesTabId], [PagesTabAname], [PagesTabEname]) VALUES (1, N'الصلاحيات', N'Authentication')
SET IDENTITY_INSERT [Auth].[PagesTabs] OFF
GO
SET IDENTITY_INSERT [common].[Information] ON 

INSERT [common].[Information] ([InformationId], [About], [TermsAndPrivacy]) VALUES (1, N'about us', N'terms')
SET IDENTITY_INSERT [common].[Information] OFF
GO
INSERT [food].[Ads] ([AdsId], [AdsImage], [IsActive]) VALUES (1, N'/uploads/ads/ads1.jpg', 1)
INSERT [food].[Ads] ([AdsId], [AdsImage], [IsActive]) VALUES (2, N'/uploads/ads/ads2.jpg', 1)
INSERT [food].[Ads] ([AdsId], [AdsImage], [IsActive]) VALUES (3, N'/uploads/ads/ads3.jpg', 1)
INSERT [food].[Ads] ([AdsId], [AdsImage], [IsActive]) VALUES (4, N'/uploads/ads/ads4.jpg', 1)
GO
SET IDENTITY_INSERT [food].[Basket] ON 

INSERT [food].[Basket] ([BasketId], [FoodId], [UserId]) VALUES (59, 52, 1)
SET IDENTITY_INSERT [food].[Basket] OFF
GO
SET IDENTITY_INSERT [food].[BasketSizes] ON 

INSERT [food].[BasketSizes] ([BasketSizesId], [FoodsSizesId], [Quantity], [BasketId]) VALUES (122, 244, 1, 59)
INSERT [food].[BasketSizes] ([BasketSizesId], [FoodsSizesId], [Quantity], [BasketId]) VALUES (123, 245, 1, 59)
SET IDENTITY_INSERT [food].[BasketSizes] OFF
GO
SET IDENTITY_INSERT [food].[Categories] ON 

INSERT [food].[Categories] ([CategoryId], [CategoryAname], [CategoryEname], [CategoryADescription], [CategoryEDescription], [ImagePath], [BackgroundColor], [IsActive], [IsDelete]) VALUES (1, N'اكل بيتي جاهز', N'Homade Food', N'Homade Food', N'Homade Food', N'/Uploads/Categorys/eat_home.jpg', 0, 1, 0)
INSERT [food].[Categories] ([CategoryId], [CategoryAname], [CategoryEname], [CategoryADescription], [CategoryEDescription], [ImagePath], [BackgroundColor], [IsActive], [IsDelete]) VALUES (2, N'معجنات و حلويت', N'Pastries and sweets', N'Pastries and sweets', N'Pastries and sweets', N'/Uploads/Categorys/fast_food.jpg', 0, 1, 0)
INSERT [food].[Categories] ([CategoryId], [CategoryAname], [CategoryEname], [CategoryADescription], [CategoryEDescription], [ImagePath], [BackgroundColor], [IsActive], [IsDelete]) VALUES (3, N'لانش بوكس مينيو', N'Lunch box menu', N'Lunch box menu', N'Lunch box menu', N'/Uploads/Categorys/fish_food.jpg', 255, 1, 0)
INSERT [food].[Categories] ([CategoryId], [CategoryAname], [CategoryEname], [CategoryADescription], [CategoryEDescription], [ImagePath], [BackgroundColor], [IsActive], [IsDelete]) VALUES (4, N'سندوتشات', N'Sandwiches', N'Sandwiches', N'Sandwiches', N'/Uploads/Categorys/juice.jpg', 3822, 1, 0)
INSERT [food].[Categories] ([CategoryId], [CategoryAname], [CategoryEname], [CategoryADescription], [CategoryEDescription], [ImagePath], [BackgroundColor], [IsActive], [IsDelete]) VALUES (12, N'سوشي بيتي', N'Homemade sushi', N'Homemade sushi', N'Homemade sushi', N'/Uploads/Categorys/school_sandwich.jpg', 0, 1, 0)
INSERT [food].[Categories] ([CategoryId], [CategoryAname], [CategoryEname], [CategoryADescription], [CategoryEDescription], [ImagePath], [BackgroundColor], [IsActive], [IsDelete]) VALUES (13, N'فاست فود بيتي', N'Homemade Fast Food', N'Homemade Fast Food', N'Homemade Fast Food', N'/Uploads/Categorys/seafood.jpg', 0, 1, 0)
INSERT [food].[Categories] ([CategoryId], [CategoryAname], [CategoryEname], [CategoryADescription], [CategoryEDescription], [ImagePath], [BackgroundColor], [IsActive], [IsDelete]) VALUES (14, N'ماكولات سوريه', N'Syrian Food', N'Syrian Food', N'Syrian Food', N'/Uploads/Categorys/sweets.jpg', 0, 1, 0)
INSERT [food].[Categories] ([CategoryId], [CategoryAname], [CategoryEname], [CategoryADescription], [CategoryEDescription], [ImagePath], [BackgroundColor], [IsActive], [IsDelete]) VALUES (15, N'ماكولات ايطاليه', N'Italian Food', N'Italian Food', N'Italian Food', N'/Uploads/Categorys/syrian_sandwich.jpg', 0, 1, 0)
INSERT [food].[Categories] ([CategoryId], [CategoryAname], [CategoryEname], [CategoryADescription], [CategoryEDescription], [ImagePath], [BackgroundColor], [IsActive], [IsDelete]) VALUES (17, N'كاترنج', N'Ready to Cook', N'Ready to Cook', N'Ready to Cook', N'/Uploads/Categorys/syrian_sandwich.jpg', 0, 1, 0)
INSERT [food].[Categories] ([CategoryId], [CategoryAname], [CategoryEname], [CategoryADescription], [CategoryEDescription], [ImagePath], [BackgroundColor], [IsActive], [IsDelete]) VALUES (18, N'اكل عاي التسويه', N'Catering', N'Catering', N'Catering', N'/Uploads/Categorys/syrian_sandwich.jpg', 0, 1, 0)
INSERT [food].[Categories] ([CategoryId], [CategoryAname], [CategoryEname], [CategoryADescription], [CategoryEDescription], [ImagePath], [BackgroundColor], [IsActive], [IsDelete]) VALUES (19, N'فسيخ و رنجه', N'Feseekh and Herring', N'Feseekh and Herring', N'Feseekh and Herring', N'/Uploads/Categorys/syrian_sandwich.jpg', 0, 1, 0)
INSERT [food].[Categories] ([CategoryId], [CategoryAname], [CategoryEname], [CategoryADescription], [CategoryEDescription], [ImagePath], [BackgroundColor], [IsActive], [IsDelete]) VALUES (21, N'عصائر', N'Fresh Juice', N'Fresh Juice', N'Fresh Juice', N'/Uploads/Categorys/syrian_sandwich.jpg', 0, 1, 0)
SET IDENTITY_INSERT [food].[Categories] OFF
GO
SET IDENTITY_INSERT [food].[FoodCategories] ON 

INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (55, 1, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (56, 1, 2)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (57, 2, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (58, 2, 2)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (59, 3, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (60, 3, 2)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (61, 4, 3)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (62, 4, 4)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (63, 5, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (64, 5, 4)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (65, 6, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (66, 6, 4)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (67, 7, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (68, 7, 2)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (69, 7, 4)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (70, 8, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (71, 8, 3)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (72, 8, 4)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (73, 9, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (74, 9, 3)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (75, 9, 4)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (76, 10, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (77, 10, 2)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (78, 11, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (79, 11, 2)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (80, 12, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (81, 12, 2)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (82, 13, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (83, 13, 2)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (84, 14, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (85, 14, 2)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (86, 15, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (87, 15, 2)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (88, 16, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (89, 16, 2)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (90, 17, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (91, 17, 2)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (92, 18, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (93, 18, 2)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (94, 19, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (95, 19, 2)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (96, 20, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (97, 20, 2)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (98, 21, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (99, 21, 2)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (100, 22, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (101, 22, 2)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (102, 23, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (103, 23, 2)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (104, 24, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (105, 24, 2)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (106, 25, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (107, 25, 2)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (108, 26, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (109, 26, 4)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (110, 27, 2)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (111, 27, 3)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (112, 28, 2)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (113, 28, 3)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (114, 29, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (115, 29, 3)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (116, 30, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (117, 30, 3)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (118, 31, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (119, 31, 3)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (120, 32, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (121, 32, 3)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (122, 33, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (123, 33, 3)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (124, 34, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (125, 34, 3)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (126, 35, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (127, 35, 3)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (128, 36, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (129, 36, 3)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (130, 37, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (131, 37, 3)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (132, 38, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (133, 38, 4)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (134, 39, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (135, 39, 4)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (136, 40, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (137, 40, 4)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (138, 41, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (139, 41, 4)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (140, 42, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (141, 42, 4)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (142, 43, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (143, 43, 4)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (144, 44, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (145, 44, 4)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (146, 45, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (147, 45, 4)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (148, 46, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (149, 46, 4)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (150, 47, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (151, 47, 4)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (152, 48, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (153, 48, 4)
GO
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (154, 49, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (155, 49, 4)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (156, 50, 1)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (157, 50, 4)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (184, 51, 3)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (185, 51, 4)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (186, 52, 2)
INSERT [food].[FoodCategories] ([FoodCategoriesId], [FoodId], [CategoryId]) VALUES (187, 52, 4)
SET IDENTITY_INSERT [food].[FoodCategories] OFF
GO
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (1, N'عرض كلاسيك باندل', CAST(350.00 AS Decimal(18, 2)), N'1 وجبة وابر لحم وسط و 1 وجبة تشيكن رويال وسط', 10, 1, 1, 0, 1, CAST(N'2022-12-01T23:15:23.153' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (2, N'عرض فاميلي باندل', CAST(500.00 AS Decimal(18, 2)), N'2 ساندوتش بيف وابر، 2 ساندوتش تشيكن رويال، 2 ساندوتش وابر جونيور بيف، 2 ساندوتش برجر دجاج، 2 بطاطس محمرة كبيرة و 2 لتر مشروب غازي من إختيارك', 20, 1, 1, 0, 1, CAST(N'2022-12-01T23:16:32.453' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (3, N'عرض كراون باندل', CAST(500.00 AS Decimal(18, 2)), N'ساندوتش وابر بيف، ساندوتش تشيكن رويال، ساندوتش تشيكن كرانشي، بيج كينج حجم أكبر، بطاطس محمرة كبيرة و لتر كوكا كولا', 25, 2, 1, 0, 1, CAST(N'2022-12-01T23:17:02.580' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (4, N'دبل وابر لحم بقرى', CAST(50.00 AS Decimal(18, 2)), N'ساندوتش وابر بيف، ساندوتش تشيكن رويال، ساندوتش تشيكن كرانشي، بيج كينج حجم أكبر، بطاطس محمرة كبيرة و لتر كوكا كولا', 30, 2, 1, 0, 1, CAST(N'2022-12-01T23:17:34.160' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (5, N'بيج كينج سنجل لحم بقرى', CAST(15.00 AS Decimal(18, 2)), N'ساندوتش وابر بيف، ساندوتش تشيكن رويال، ساندوتش تشيكن كرانشي، بيج كينج حجم أكبر، بطاطس محمرة كبيرة و لتر كوكا كولا', 35, 2, 1, 0, 1, CAST(N'2022-12-01T23:18:40.930' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (6, N'تشيز برجر لحم بقرى', CAST(60.00 AS Decimal(18, 2)), N'2 ساندوتش بيف وابر، 2 ساندوتش تشيكن رويال، 2 ساندوتش وابر جونيور بيف، 2 ساندوتش برجر دجاج، 2 بطاطس محمرة كبيرة و 2 لتر مشروب غازي من إختيارك
ساندوتش وابر بيف، ساندوتش تشيكن رويال، ساندوتش تشيكن كرانشي، بيج كينج حجم أكبر، بطاطس محمرة كبيرة و لتر كوكا كولا', 40, 2, 1, 0, 1, CAST(N'2022-12-01T23:19:05.043' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (7, N'استيك هاوس لحم بقرى', CAST(80.00 AS Decimal(18, 2)), N'2 ساندوتش بيف وابر، 2 ساندوتش تشيكن رويال، 2 ساندوتش وابر جونيور بيف، 2 ساندوتش برجر دجاج، 2 بطاطس محمرة كبيرة و 2 لتر مشروب غازي من إختيارك
ساندوتش وابر بيف، ساندوتش تشيكن رويال، ساندوتش تشيكن كرانشي، بيج كينج حجم أكبر، بطاطس محمرة كبيرة و لتر كوكا كولا', 15, 1, 1, 0, 1, CAST(N'2022-12-01T23:19:39.623' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (8, N'بطاطس سوري
', CAST(22.00 AS Decimal(18, 2)), N'قطعة لحم بقري لذيذ مشوي على نار، تعلوهما شرائح جبن ذائبة، وقطع خس طازجة، وبصل مقرمش، ومخلات مميزة، وصلصة حلوة لا مثيل لها مُتبلة بطريقة ثاوزند ايلند، ويوضع كل ذلك على خبز محمص بسمسم.
لن تندم على اختيارك تشيز برجر لذيذ، بلحم مشوي على اللهب، ومغطى بشريحة ذائبة جبن أمريكي، وقطع مخلل، وكاتشب ومسطردة صفراء شهية، بداخل خبز محمصة مغطاة بسمسم.', 20, 2, 1, 0, 1, CAST(N'2022-12-01T23:22:47.017' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (9, N'شاورما لحم سورى
', CAST(90.00 AS Decimal(18, 2)), N'قطعة لحم بقري لذيذ مشوي على نار، تعلوهما شرائح جبن ذائبة، وقطع خس طازجة، وبصل مقرمش، ومخلات مميزة، وصلصة حلوة لا مثيل لها مُتبلة بطريقة ثاوزند ايلند، ويوضع كل ذلك على خبز محمص بسمسم.
لن تندم على اختيارك تشيز برجر لذيذ، بلحم مشوي على اللهب، ومغطى بشريحة ذائبة جبن أمريكي، وقطع مخلل، وكاتشب ومسطردة صفراء شهية، بداخل خبز محمصة مغطاة بسمسم.', 60, 2, 1, 0, 1, CAST(N'2022-12-01T23:23:06.080' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (10, N'وجبة ربع فرخة صدر
', CAST(10.00 AS Decimal(18, 2)), N'تقدم مع ارز بسمتى، خبز، ثومية ، مخلل، سمبوسك، بطاطس

', 84, 1, 1, 0, 1, CAST(N'2022-12-01T23:24:03.443' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (11, N'طبق عربي فراخ
', CAST(15.00 AS Decimal(18, 2)), N'طبق عربي فراخ

', 50, 2, 1, 0, 1, CAST(N'2022-12-01T23:24:42.320' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (12, N'وجبة نص فرخة
', CAST(90.00 AS Decimal(18, 2)), N'نصف فرخة مشوية، ارز بسمتى، خبز، ثومية، مخلل، سمبوسك، بطاطس', 60, 2, 1, 0, 1, CAST(N'2022-12-01T23:25:08.640' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (13, N'فتة ميكس', CAST(90.00 AS Decimal(18, 2)), N'شاورما لحمة و فراخ و يقدم مع ارز بسمتى، صوص كريمة، خبز محمص، ثومية، مخلل', 90, 2, 1, 0, 1, CAST(N'2022-12-01T23:25:54.463' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (14, N'شوربة لسان بالفراخ', CAST(70.00 AS Decimal(18, 2)), N'شاورما لحمة و فراخ و يقدم مع ارز بسمتى، صوص كريمة، خبز محمص، ثومية، مخلل', 80, 2, 1, 0, 1, CAST(N'2022-12-01T23:26:50.860' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (15, N'سلطة خضراء
', CAST(12.00 AS Decimal(18, 2)), N'شاورما لحمة و فراخ و يقدم مع ارز بسمتى، صوص كريمة، خبز محمص، ثومية، مخلل', 10, 2, 1, 0, 1, CAST(N'2022-12-01T23:26:56.930' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (16, N'سلطة خضراء
', CAST(12.00 AS Decimal(18, 2)), N'شاورما لحمة و فراخ و يقدم مع ارز بسمتى، صوص كريمة، خبز محمص، ثومية، مخلل', 20, 2, 1, 0, 1, CAST(N'2022-12-01T23:27:10.937' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (17, N'سلطة خضراء
', CAST(12.00 AS Decimal(18, 2)), N'شاورما لحمة و فراخ و يقدم مع ارز بسمتى، صوص كريمة، خبز محمص، ثومية، مخلل', 30, 2, 1, 0, 1, CAST(N'2022-12-01T23:27:12.230' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (18, N'سلطة خضراء
', CAST(12.00 AS Decimal(18, 2)), N'شاورما لحمة و فراخ و يقدم مع ارز بسمتى، صوص كريمة، خبز محمص، ثومية، مخلل', 40, 2, 1, 0, 1, CAST(N'2022-12-01T23:27:13.473' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (19, N'سلطة خضراء
', CAST(12.00 AS Decimal(18, 2)), N'شاورما لحمة و فراخ و يقدم مع ارز بسمتى، صوص كريمة، خبز محمص، ثومية، مخلل', 50, 2, 1, 0, 1, CAST(N'2022-12-01T23:27:14.747' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (20, N'سلطة خضراء
', CAST(12.00 AS Decimal(18, 2)), N'شاورما لحمة و فراخ و يقدم مع ارز بسمتى، صوص كريمة، خبز محمص، ثومية، مخلل', 60, 2, 1, 0, 1, CAST(N'2022-12-01T23:27:15.913' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (21, N'سلطة خضراء
', CAST(12.00 AS Decimal(18, 2)), N'شاورما لحمة و فراخ و يقدم مع ارز بسمتى، صوص كريمة، خبز محمص، ثومية، مخلل', 70, 2, 1, 0, 1, CAST(N'2022-12-01T23:27:17.077' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (22, N'سلطة خضراء
', CAST(12.00 AS Decimal(18, 2)), N'شاورما لحمة و فراخ و يقدم مع ارز بسمتى، صوص كريمة، خبز محمص، ثومية، مخلل', 80, 2, 1, 0, 1, CAST(N'2022-12-01T23:27:18.297' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (23, N'سلطة خضراء
', CAST(12.00 AS Decimal(18, 2)), N'شاورما لحمة و فراخ و يقدم مع ارز بسمتى، صوص كريمة، خبز محمص، ثومية، مخلل', 90, 2, 1, 0, 1, CAST(N'2022-12-01T23:27:19.483' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (24, N'سلطة خضراء
', CAST(12.00 AS Decimal(18, 2)), N'شاورما لحمة و فراخ و يقدم مع ارز بسمتى، صوص كريمة، خبز محمص، ثومية، مخلل', 100, 2, 1, 0, 1, CAST(N'2022-12-01T23:27:20.413' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (25, N'سلطة خضراء
', CAST(12.00 AS Decimal(18, 2)), N'شاورما لحمة و فراخ و يقدم مع ارز بسمتى، صوص كريمة، خبز محمص، ثومية، مخلل', 110, 2, 1, 0, 1, CAST(N'2022-12-01T23:27:21.567' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (26, N'سلطة خضراء
', CAST(12.00 AS Decimal(18, 2)), N'شاورما لحمة و فراخ و يقدم مع ارز بسمتى، صوص كريمة، خبز محمص، ثومية، مخلل', 120, 2, 1, 0, 1, CAST(N'2022-12-01T23:27:31.593' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (27, N'وجبة المونديال', CAST(60.00 AS Decimal(18, 2)), N'رغيف حواوشي، 2 قطعة شيش، 2 كفتة مشوية علي الفحم، ارز برياني، سلطة، 2 خبز جاد', 130, 1, 1, 0, 1, CAST(N'2022-12-01T23:28:55.310' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (28, N'سمبوسك جبنة', CAST(800.00 AS Decimal(18, 2)), N'عجينة سمبوسك 3 قطع، جبنه بيضاء', 140, 2, 1, 0, 1, CAST(N'2022-12-01T23:31:12.407' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (29, N'ساندوتش فول بالخلطة', CAST(800.00 AS Decimal(18, 2)), N'فول، سلطة خضراء، طحينة، زيت', 5, 2, 1, 0, 1, CAST(N'2022-12-01T23:31:55.547' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (30, N'ساندوتش فول اسكندراني', CAST(800.00 AS Decimal(18, 2)), N'فول، سلطة خضراء، طحينة، زيت', 10, 2, 1, 0, 1, CAST(N'2022-12-01T23:32:15.807' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (31, N'ساندوتش فول بزيت الزيتون
', CAST(100.00 AS Decimal(18, 2)), N'فول، زيت زيتون، سلطة خضراء، طحينة', 12, 3, 1, 0, 1, CAST(N'2022-12-01T23:32:42.847' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (32, N'ساندوتش فول بزيت الزيتون
', CAST(100.00 AS Decimal(18, 2)), N'فول، زيت زيتون، سلطة خضراء، طحينة', 15, 3, 1, 0, 1, CAST(N'2022-12-01T23:32:56.563' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (33, N'ساندوتش فول بزيت الزيتون
', CAST(100.00 AS Decimal(18, 2)), N'فول، زيت زيتون، سلطة خضراء، طحينة', 30, 3, 1, 0, 1, CAST(N'2022-12-01T23:32:57.927' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (34, N'ساندوتش فول بزيت الزيتون
', CAST(100.00 AS Decimal(18, 2)), N'فول، زيت زيتون، سلطة خضراء، طحينة', 30, 3, 1, 0, 1, CAST(N'2022-12-01T23:32:59.187' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (35, N'ساندوتش فول بزيت الزيتون
', CAST(100.00 AS Decimal(18, 2)), N'فول، زيت زيتون، سلطة خضراء، طحينة', 30, 3, 1, 0, 1, CAST(N'2022-12-01T23:33:00.477' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (36, N'ساندوتش فول بزيت الزيتون
', CAST(100.00 AS Decimal(18, 2)), N'فول، زيت زيتون، سلطة خضراء، طحينة', 20, 3, 1, 0, 1, CAST(N'2022-12-01T23:33:01.723' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (37, N'فول، زيت زيتون، سلطة خضراء، طحينة', CAST(50.00 AS Decimal(18, 2)), N'فول، زيت حار، سلطة خضراء، طحينة', 15, 3, 1, 0, 1, CAST(N'2022-12-01T23:33:30.353' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (38, N'ساندوتش فول بالصلصة', CAST(120.00 AS Decimal(18, 2)), N'فول، صلصة، طماطم، فلفل رومي، بصل', 18, 3, 1, 0, 1, CAST(N'2022-12-01T23:34:13.037' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (39, N'ساندوتش فول بالصلصة', CAST(120.00 AS Decimal(18, 2)), N'فول، صلصة، طماطم، فلفل رومي، بصل', 80, 3, 1, 0, 1, CAST(N'2022-12-01T23:34:16.767' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (40, N'ساندوتش فول بالصلصة', CAST(120.00 AS Decimal(18, 2)), N'فول، صلصة، طماطم، فلفل رومي، بصل', 60, 3, 1, 0, 1, CAST(N'2022-12-01T23:34:18.167' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (41, N'ساندوتش فول بالصلصة', CAST(120.00 AS Decimal(18, 2)), N'فول، صلصة، طماطم، فلفل رومي، بصل', 50, 3, 1, 0, 1, CAST(N'2022-12-01T23:34:19.743' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (42, N'ساندوتش فول بالصلصة', CAST(120.00 AS Decimal(18, 2)), N'فول، صلصة، طماطم، فلفل رومي، بصل', 40, 3, 1, 0, 1, CAST(N'2022-12-01T23:34:21.300' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (43, N'ساندوتش فول بالصلصة', CAST(120.00 AS Decimal(18, 2)), N'فول، صلصة، طماطم، فلفل رومي، بصل', 20, 3, 1, 0, 1, CAST(N'2022-12-01T23:34:23.087' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (44, N'ساندوتش فول بالصلصة', CAST(120.00 AS Decimal(18, 2)), N'فول، صلصة، طماطم، فلفل رومي، بصل', 10, 3, 1, 0, 1, CAST(N'2022-12-01T23:34:24.690' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (45, N'ساندوتش فول بالصلصة', CAST(120.00 AS Decimal(18, 2)), N'فول، صلصة، طماطم، فلفل رومي، بصل', 60, 3, 1, 0, 1, CAST(N'2022-12-01T23:34:26.390' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (46, N'ساندوتش فول بالصلصة', CAST(120.00 AS Decimal(18, 2)), N'فول، صلصة، طماطم، فلفل رومي، بصل', 80, 3, 1, 0, 1, CAST(N'2022-12-01T23:34:28.067' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (47, N'ساندوتش فول بالصلصة', CAST(120.00 AS Decimal(18, 2)), N'فول، صلصة، طماطم، فلفل رومي، بصل', 10, 3, 1, 0, 1, CAST(N'2022-12-01T23:34:29.727' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (48, N'ساندوتش فول بالصلصة', CAST(120.00 AS Decimal(18, 2)), N'فول، صلصة، طماطم، فلفل رومي، بصل', 33, 3, 1, 0, 1, CAST(N'2022-12-01T23:34:31.517' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (49, N'ساندوتش فول بالصلصة', CAST(120.00 AS Decimal(18, 2)), N'فول، صلصة، طماطم، فلفل رومي، بصل', 44, 3, 1, 0, 1, CAST(N'2022-12-01T23:34:33.463' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (50, N'ساندوتش فول بالصلصة', CAST(120.00 AS Decimal(18, 2)), N'فول، صلصة، طماطم، فلفل رومي، بصل', 55, 3, 1, 0, 1, CAST(N'2022-12-01T23:34:35.113' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (51, N'شاورما فراخ سوري صاج', CAST(500.00 AS Decimal(18, 2)), N'بطاطس وبيبسى حلو', 60, 1, 1, 0, 1, CAST(N'2022-12-03T23:43:58.063' AS DateTime))
INSERT [food].[Foods] ([FoodId], [FoodName], [Price], [Description], [PreparationTime], [UserId], [IsApproved], [IsDelete], [IsActive], [CreationDate]) VALUES (52, N'شاورما فراخ سوري صاج', CAST(500.00 AS Decimal(18, 2)), N'desc', 50, 1, 1, 0, 1, CAST(N'2022-12-06T21:34:46.450' AS DateTime))
GO
SET IDENTITY_INSERT [food].[FoodsImages] ON 

INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (85, N'\Uploads\Foods\1\jdee4b1e.kgn.webp', 1)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (86, N'\Uploads\Foods\1\majp4mhk.nln.webp', 1)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (87, N'\Uploads\Foods\1\2teuh0gp.trg.webp', 1)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (88, N'\Uploads\Foods\1\ogmaa03i.tei.webp', 1)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (89, N'\Uploads\Foods\1\ximpq1ma.hqc.webp', 1)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (90, N'\Uploads\Foods\2\qe4x5rcg.cjs.webp', 2)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (91, N'\Uploads\Foods\2\gbwzskvj.qm1.webp', 2)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (92, N'\Uploads\Foods\2\m0jftptx.u5d.webp', 2)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (93, N'\Uploads\Foods\2\rtobiwpe.5pc.webp', 2)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (94, N'\Uploads\Foods\2\rncu33cl.qyv.webp', 2)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (95, N'\Uploads\Foods\3\3qild43w.u0j.webp', 3)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (96, N'\Uploads\Foods\3\05yuguv1.gq1.webp', 3)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (97, N'\Uploads\Foods\3\ehimzu3o.zob.webp', 3)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (98, N'\Uploads\Foods\3\rg52drrv.zwd.webp', 3)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (99, N'\Uploads\Foods\3\frlfuoju.snp.webp', 3)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (100, N'\Uploads\Foods\4\rzio5ent.jfs.webp', 4)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (101, N'\Uploads\Foods\4\eblo1ida.k3r.webp', 4)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (102, N'\Uploads\Foods\4\jssgktgm.jtv.webp', 4)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (103, N'\Uploads\Foods\4\iyzog4gg.snr.webp', 4)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (104, N'\Uploads\Foods\4\4xncb4gz.ul4.webp', 4)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (105, N'\Uploads\Foods\5\frylmgiw.kfh.webp', 5)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (106, N'\Uploads\Foods\5\jqqyptf0.qud.webp', 5)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (107, N'\Uploads\Foods\5\vqss0l3r.jmh.webp', 5)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (108, N'\Uploads\Foods\5\0b5thxfi.mvb.webp', 5)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (109, N'\Uploads\Foods\5\pc1c1tfx.4kw.webp', 5)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (110, N'\Uploads\Foods\6\n1wb2rvw.rcd.webp', 6)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (111, N'\Uploads\Foods\6\qy1nh3yw.0ld.webp', 6)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (112, N'\Uploads\Foods\6\fyxvcl2i.dve.webp', 6)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (113, N'\Uploads\Foods\6\qluh4cva.xjc.webp', 6)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (114, N'\Uploads\Foods\6\rwwucloo.dg5.webp', 6)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (115, N'\Uploads\Foods\7\stn3pvdc.gde.webp', 7)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (116, N'\Uploads\Foods\7\f4c1fz2f.kye.webp', 7)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (117, N'\Uploads\Foods\7\qfproije.3jn.webp', 7)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (118, N'\Uploads\Foods\7\gwtmd2kn.0jj.webp', 7)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (119, N'\Uploads\Foods\7\rg35quqf.s32.webp', 7)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (120, N'\Uploads\Foods\8\nulodq3o.oco.webp', 8)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (121, N'\Uploads\Foods\8\bqqyndtl.xdz.webp', 8)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (122, N'\Uploads\Foods\8\wgoyjvu1.yyk.webp', 8)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (123, N'\Uploads\Foods\8\kthcvm45.hei.webp', 8)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (124, N'\Uploads\Foods\8\5uf5qcvj.zik.webp', 8)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (125, N'\Uploads\Foods\9\vgai2aeu.50m.webp', 9)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (126, N'\Uploads\Foods\9\514ibr41.bj4.webp', 9)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (127, N'\Uploads\Foods\9\4ofvz5rs.3pr.webp', 9)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (128, N'\Uploads\Foods\9\5qdfpl1l.afe.webp', 9)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (129, N'\Uploads\Foods\9\4nvf3mki.i5u.webp', 9)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (130, N'\Uploads\Foods\10\1uytz4rz.4zt.webp', 10)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (131, N'\Uploads\Foods\10\4jjc0jkz.2kv.webp', 10)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (132, N'\Uploads\Foods\10\yt03o1he.ju2.webp', 10)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (133, N'\Uploads\Foods\10\1vewe1h1.g1i.webp', 10)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (134, N'\Uploads\Foods\10\amnkjw25.bsn.webp', 10)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (135, N'\Uploads\Foods\11\4jsgwzd1.z4w.webp', 11)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (136, N'\Uploads\Foods\11\cfwv1vzc.mtu.webp', 11)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (137, N'\Uploads\Foods\11\n2eb4mis.jyn.webp', 11)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (138, N'\Uploads\Foods\11\afa3q4a0.gur.webp', 11)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (139, N'\Uploads\Foods\11\5yglpfmr.fiw.webp', 11)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (140, N'\Uploads\Foods\12\0krarfaa.1hv.webp', 12)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (141, N'\Uploads\Foods\12\pzpq4imh.kpe.webp', 12)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (142, N'\Uploads\Foods\12\mq5zmjue.foj.webp', 12)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (143, N'\Uploads\Foods\12\xamzlcvm.05p.webp', 12)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (144, N'\Uploads\Foods\12\tj3yktql.4rn.webp', 12)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (145, N'\Uploads\Foods\13\wu4whzpv.jkd.webp', 13)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (146, N'\Uploads\Foods\13\54dcbkkt.4qp.webp', 13)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (147, N'\Uploads\Foods\13\1qjakg2i.v2j.webp', 13)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (148, N'\Uploads\Foods\13\plety5ad.rnr.webp', 13)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (149, N'\Uploads\Foods\13\ah30dmyp.05c.webp', 13)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (150, N'\Uploads\Foods\14\yrsarfri.nyu.webp', 14)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (151, N'\Uploads\Foods\14\xjh2i4a4.ok2.webp', 14)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (152, N'\Uploads\Foods\14\0aodpu2y.nia.webp', 14)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (153, N'\Uploads\Foods\14\2nohnv0v.m4z.webp', 14)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (154, N'\Uploads\Foods\14\kgnxsbgk.vpu.webp', 14)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (155, N'\Uploads\Foods\15\xusz3dvr.nfj.webp', 15)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (156, N'\Uploads\Foods\15\ib5hm0b4.xw5.webp', 15)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (157, N'\Uploads\Foods\15\y3xpeozc.goi.webp', 15)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (158, N'\Uploads\Foods\15\4jwws32k.y0p.webp', 15)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (159, N'\Uploads\Foods\15\rdfb2umr.dv2.webp', 15)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (160, N'\Uploads\Foods\16\a1b3aevx.jjd.webp', 16)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (161, N'\Uploads\Foods\16\u4mjcm0b.uko.webp', 16)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (162, N'\Uploads\Foods\16\zqvt1t2u.r2t.webp', 16)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (163, N'\Uploads\Foods\16\qbg1fak0.xcz.webp', 16)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (164, N'\Uploads\Foods\16\2o2ibxfs.0x1.webp', 16)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (165, N'\Uploads\Foods\17\0ug1sbok.nhu.webp', 17)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (166, N'\Uploads\Foods\17\eqikwyu2.1k4.webp', 17)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (167, N'\Uploads\Foods\17\p5zma3he.le4.webp', 17)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (168, N'\Uploads\Foods\17\0sf1k4xl.uub.webp', 17)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (169, N'\Uploads\Foods\17\ci3mnstt.eon.webp', 17)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (170, N'\Uploads\Foods\18\j3lrdgnz.aii.webp', 18)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (171, N'\Uploads\Foods\18\aeox03ya.bly.webp', 18)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (172, N'\Uploads\Foods\18\atibx0oi.z3u.webp', 18)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (173, N'\Uploads\Foods\18\3jdqenaj.ju5.webp', 18)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (174, N'\Uploads\Foods\18\y402dxoi.q34.webp', 18)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (175, N'\Uploads\Foods\19\2pdy4ada.qeo.webp', 19)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (176, N'\Uploads\Foods\19\pymaei5q.qe1.webp', 19)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (177, N'\Uploads\Foods\19\cnagfsiz.ou4.webp', 19)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (178, N'\Uploads\Foods\19\jbuojp1x.yuq.webp', 19)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (179, N'\Uploads\Foods\19\3n4vp12g.kiz.webp', 19)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (180, N'\Uploads\Foods\20\efmapqwl.bsq.webp', 20)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (181, N'\Uploads\Foods\20\huexxqab.03j.webp', 20)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (182, N'\Uploads\Foods\20\hbmjtcz0.nq2.webp', 20)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (183, N'\Uploads\Foods\20\vjabgjzm.5m0.webp', 20)
GO
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (184, N'\Uploads\Foods\20\zbusfbb5.zyh.webp', 20)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (185, N'\Uploads\Foods\21\txcl1e4x.xrx.webp', 21)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (186, N'\Uploads\Foods\21\reakarmx.zfg.webp', 21)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (187, N'\Uploads\Foods\21\mqistzmp.plw.webp', 21)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (188, N'\Uploads\Foods\21\dblfbmdb.ims.webp', 21)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (189, N'\Uploads\Foods\21\xxlh42eq.5fj.webp', 21)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (190, N'\Uploads\Foods\22\fi1iwwgw.z4l.webp', 22)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (191, N'\Uploads\Foods\22\n112ctax.f5u.webp', 22)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (192, N'\Uploads\Foods\22\brkdakxu.qnz.webp', 22)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (193, N'\Uploads\Foods\22\zjwvkdwd.jgi.webp', 22)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (194, N'\Uploads\Foods\22\vgex33oo.ucl.webp', 22)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (195, N'\Uploads\Foods\23\yvulxqp0.uj2.webp', 23)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (196, N'\Uploads\Foods\23\ctuptvw0.v4l.webp', 23)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (197, N'\Uploads\Foods\23\rptdamhh.kwc.webp', 23)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (198, N'\Uploads\Foods\23\lbdv3dli.1r4.webp', 23)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (199, N'\Uploads\Foods\23\szjjxzwc.zmq.webp', 23)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (200, N'\Uploads\Foods\24\h3lezrqp.154.webp', 24)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (201, N'\Uploads\Foods\24\adi3hwdy.cqx.webp', 24)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (202, N'\Uploads\Foods\24\xb21qh1w.nev.webp', 24)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (203, N'\Uploads\Foods\24\rxasft0f.q3z.webp', 24)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (204, N'\Uploads\Foods\24\0aw0wim1.4ib.webp', 24)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (205, N'\Uploads\Foods\25\hqlp5aa5.vvq.webp', 25)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (206, N'\Uploads\Foods\25\fc41lqbu.x2c.webp', 25)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (207, N'\Uploads\Foods\25\zrctiddq.li4.webp', 25)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (208, N'\Uploads\Foods\25\wqssoym2.yvg.webp', 25)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (209, N'\Uploads\Foods\25\1llr40ak.4lu.webp', 25)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (210, N'\Uploads\Foods\26\upsonncr.yup.webp', 26)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (211, N'\Uploads\Foods\26\t4pnb4mo.tgn.webp', 26)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (212, N'\Uploads\Foods\26\151b21n0.frp.webp', 26)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (213, N'\Uploads\Foods\26\cjjagcs1.hsh.webp', 26)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (214, N'\Uploads\Foods\26\4bchgojn.yyz.webp', 26)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (215, N'\Uploads\Foods\27\hwkrduk1.1me.webp', 27)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (216, N'\Uploads\Foods\27\ppkmyjna.nsg.webp', 27)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (217, N'\Uploads\Foods\27\qh3qavcr.bxh.webp', 27)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (218, N'\Uploads\Foods\27\igroggjj.eep.webp', 27)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (219, N'\Uploads\Foods\27\j4hpmsjh.tad.webp', 27)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (220, N'\Uploads\Foods\28\bczizffm.dth.webp', 28)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (221, N'\Uploads\Foods\28\1t5xmekz.fpc.webp', 28)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (222, N'\Uploads\Foods\28\o5ilmomq.xli.webp', 28)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (223, N'\Uploads\Foods\28\e4ybsh45.f1n.webp', 28)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (224, N'\Uploads\Foods\28\h043qcla.ayi.webp', 28)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (225, N'\Uploads\Foods\29\hoqiyw23.ll1.webp', 29)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (226, N'\Uploads\Foods\29\ldax5gvi.jc4.webp', 29)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (227, N'\Uploads\Foods\29\bvjybe4l.sgy.webp', 29)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (228, N'\Uploads\Foods\29\k1x5zc15.la5.webp', 29)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (229, N'\Uploads\Foods\29\2zykxnae.g4b.webp', 29)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (230, N'\Uploads\Foods\30\bnbqmxmc.xtu.webp', 30)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (231, N'\Uploads\Foods\30\szf1p0ry.mqt.webp', 30)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (232, N'\Uploads\Foods\30\4qmsyht0.pop.webp', 30)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (233, N'\Uploads\Foods\30\0to1wiz4.3zm.webp', 30)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (234, N'\Uploads\Foods\30\szhc1gfc.5ud.webp', 30)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (235, N'\Uploads\Foods\31\1oaet2gw.nuu.webp', 31)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (236, N'\Uploads\Foods\31\dp0q5as5.nih.webp', 31)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (237, N'\Uploads\Foods\31\io5j1uqz.z4m.webp', 31)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (238, N'\Uploads\Foods\31\tx4crlpu.0iu.webp', 31)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (239, N'\Uploads\Foods\31\goaytw3d.aca.webp', 31)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (240, N'\Uploads\Foods\32\kcgytcx4.dec.webp', 32)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (241, N'\Uploads\Foods\32\0snpm1aa.u2g.webp', 32)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (242, N'\Uploads\Foods\32\0vumvra4.2uo.webp', 32)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (243, N'\Uploads\Foods\32\20anjcbj.g0f.webp', 32)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (244, N'\Uploads\Foods\32\jnxbs2fi.01f.webp', 32)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (245, N'\Uploads\Foods\33\ssibs2jz.41c.webp', 33)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (246, N'\Uploads\Foods\33\li3j1t4o.wg4.webp', 33)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (247, N'\Uploads\Foods\33\msjh5ru2.z04.webp', 33)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (248, N'\Uploads\Foods\33\urb4e3vp.vvv.webp', 33)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (249, N'\Uploads\Foods\33\x2aiupif.owp.webp', 33)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (250, N'\Uploads\Foods\34\rcqsfzi3.emr.webp', 34)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (251, N'\Uploads\Foods\34\ajaeu3qo.vh3.webp', 34)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (252, N'\Uploads\Foods\34\2ztvenfg.lg5.webp', 34)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (253, N'\Uploads\Foods\34\psetcxiz.uji.webp', 34)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (254, N'\Uploads\Foods\34\vh0ojmdp.btl.webp', 34)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (255, N'\Uploads\Foods\35\1qhld2bf.zda.webp', 35)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (256, N'\Uploads\Foods\35\nk0ruwqa.alq.webp', 35)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (257, N'\Uploads\Foods\35\44nduf0a.qid.webp', 35)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (258, N'\Uploads\Foods\35\tzomikcr.gjd.webp', 35)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (259, N'\Uploads\Foods\35\p3ahzd1q.rcs.webp', 35)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (260, N'\Uploads\Foods\36\qhyjqouz.1qj.webp', 36)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (261, N'\Uploads\Foods\36\ykhlpapj.0ik.webp', 36)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (262, N'\Uploads\Foods\36\qhpyueo4.xgr.webp', 36)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (263, N'\Uploads\Foods\36\nnj3nahc.uxi.webp', 36)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (264, N'\Uploads\Foods\36\oqfzggiz.dzt.webp', 36)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (265, N'\Uploads\Foods\37\n4lazx32.gv0.webp', 37)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (266, N'\Uploads\Foods\37\22c43akz.etz.webp', 37)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (267, N'\Uploads\Foods\37\2luy3kby.xh2.webp', 37)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (268, N'\Uploads\Foods\37\j0iwcmzb.udu.webp', 37)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (269, N'\Uploads\Foods\37\3dophsdu.ttv.webp', 37)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (270, N'\Uploads\Foods\38\qcszn4sl.2p2.webp', 38)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (271, N'\Uploads\Foods\38\nrzwjmxw.mnt.webp', 38)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (272, N'\Uploads\Foods\38\312th5fn.4gm.webp', 38)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (273, N'\Uploads\Foods\38\xy0cq2ae.1ny.webp', 38)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (274, N'\Uploads\Foods\38\b4pbjwuc.ahc.webp', 38)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (275, N'\Uploads\Foods\39\2fvu33or.vt3.webp', 39)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (276, N'\Uploads\Foods\39\bw0ilfj0.y1v.webp', 39)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (277, N'\Uploads\Foods\39\vma0304u.goh.webp', 39)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (278, N'\Uploads\Foods\39\t33qm3rk.rlj.webp', 39)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (279, N'\Uploads\Foods\39\kvzvhhuj.20v.webp', 39)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (280, N'\Uploads\Foods\40\gofzndg0.xw2.webp', 40)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (281, N'\Uploads\Foods\40\1pdrfoq1.44f.webp', 40)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (282, N'\Uploads\Foods\40\pzs5bhzo.fdm.webp', 40)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (283, N'\Uploads\Foods\40\c3wnplyz.kfp.webp', 40)
GO
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (284, N'\Uploads\Foods\40\zinitxkc.syw.webp', 40)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (285, N'\Uploads\Foods\41\qj1tqzn2.zcr.webp', 41)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (286, N'\Uploads\Foods\41\h4wzd32u.4qr.webp', 41)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (287, N'\Uploads\Foods\41\lymp5wvf.2pf.webp', 41)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (288, N'\Uploads\Foods\41\pwztqudh.qub.webp', 41)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (289, N'\Uploads\Foods\41\0kc3wctv.kcd.webp', 41)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (290, N'\Uploads\Foods\42\vfeuivzp.dqs.webp', 42)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (291, N'\Uploads\Foods\42\hhwfu50b.wf2.webp', 42)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (292, N'\Uploads\Foods\42\tygthbwz.vbb.webp', 42)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (293, N'\Uploads\Foods\42\bmma5p3o.gqc.webp', 42)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (294, N'\Uploads\Foods\42\1qp4mkvo.zsr.webp', 42)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (295, N'\Uploads\Foods\43\g12mcb05.q3c.webp', 43)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (296, N'\Uploads\Foods\43\hqzhsqd5.ums.webp', 43)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (297, N'\Uploads\Foods\43\t5xdr1dg.vpr.webp', 43)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (298, N'\Uploads\Foods\43\ohcb1jzt.hup.webp', 43)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (299, N'\Uploads\Foods\43\usxg0bof.nja.webp', 43)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (300, N'\Uploads\Foods\44\ddqvjpvw.edl.webp', 44)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (301, N'\Uploads\Foods\44\5dpedbsi.ul0.webp', 44)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (302, N'\Uploads\Foods\44\jhgasnog.p2p.webp', 44)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (303, N'\Uploads\Foods\44\nquysgds.rs0.webp', 44)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (304, N'\Uploads\Foods\44\d30ffbj2.zzd.webp', 44)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (305, N'\Uploads\Foods\45\rr3akd5b.ljm.webp', 45)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (306, N'\Uploads\Foods\45\errc0oo5.ey0.webp', 45)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (307, N'\Uploads\Foods\45\pys45h03.ozp.webp', 45)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (308, N'\Uploads\Foods\45\khtqogvk.zxy.webp', 45)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (309, N'\Uploads\Foods\45\b0husv0b.eaq.webp', 45)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (310, N'\Uploads\Foods\46\c24xlle3.qnw.webp', 46)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (311, N'\Uploads\Foods\46\stl1wfya.ox4.webp', 46)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (312, N'\Uploads\Foods\46\xe2rprin.4tc.webp', 46)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (313, N'\Uploads\Foods\46\4x2wq4b4.cft.webp', 46)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (314, N'\Uploads\Foods\46\wrwue2g2.4hx.webp', 46)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (315, N'\Uploads\Foods\47\l1feodte.wt0.webp', 47)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (316, N'\Uploads\Foods\47\jwbw1mil.sll.webp', 47)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (317, N'\Uploads\Foods\47\vokrd1pa.t3b.webp', 47)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (318, N'\Uploads\Foods\47\zu20lzkd.e5g.webp', 47)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (319, N'\Uploads\Foods\47\xfdrka5i.tmx.webp', 47)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (320, N'\Uploads\Foods\48\05hze0bz.3nq.webp', 48)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (321, N'\Uploads\Foods\48\zvi4mhxv.kt4.webp', 48)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (322, N'\Uploads\Foods\48\q5wqufai.312.webp', 48)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (323, N'\Uploads\Foods\48\clhx5ehv.wt3.webp', 48)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (324, N'\Uploads\Foods\48\qox0otwf.2i3.webp', 48)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (325, N'\Uploads\Foods\49\5jhdkcp5.pgx.webp', 49)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (326, N'\Uploads\Foods\49\mhidrahf.unu.webp', 49)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (327, N'\Uploads\Foods\49\agjb4kvm.tuf.webp', 49)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (328, N'\Uploads\Foods\49\s314uy0k.mzd.webp', 49)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (329, N'\Uploads\Foods\49\5z0eufzk.5sr.webp', 49)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (330, N'\Uploads\Foods\50\ktayiyeq.juh.webp', 50)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (331, N'\Uploads\Foods\50\buelavdg.1bb.webp', 50)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (332, N'\Uploads\Foods\50\3ucrgced.ilz.webp', 50)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (333, N'\Uploads\Foods\50\dumpzuyk.c1p.webp', 50)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (334, N'\Uploads\Foods\50\xfc504am.5vo.webp', 50)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (394, N'\Uploads\Foods\51\tumhqtps.wux.webp', 51)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (395, N'\Uploads\Foods\51\hdznnv4h.thb.webp', 51)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (396, N'\Uploads\Foods\51\vmgl25m2.bot.webp', 51)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (397, N'\Uploads\Foods\51\2ar4y0go.cb3.webp', 51)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (398, N'\Uploads\Foods\51\f4dn4tye.xev.webp', 51)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (399, N'\Uploads\Foods\52\prszakgv.ge5.webp', 52)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (400, N'\Uploads\Foods\52\3t2yo3sp.hdx.webp', 52)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (401, N'\Uploads\Foods\52\mor10ei1.hra.webp', 52)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (402, N'\Uploads\Foods\52\aoodnvz3.s0l.webp', 52)
INSERT [food].[FoodsImages] ([FoodsImagesId], [ImagePath], [FoodId]) VALUES (403, N'\Uploads\Foods\52\0zxmoc1y.33i.webp', 52)
SET IDENTITY_INSERT [food].[FoodsImages] OFF
GO
SET IDENTITY_INSERT [food].[FoodsSizes] ON 

INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (70, CAST(220.00 AS Decimal(18, 2)), 1, N'very large', 1)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (71, CAST(520.00 AS Decimal(18, 2)), 2, N'very beautiful', 1)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (72, CAST(220.00 AS Decimal(18, 2)), 1, N'very large', 2)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (73, CAST(520.00 AS Decimal(18, 2)), 2, N'very beautiful', 2)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (74, CAST(220.00 AS Decimal(18, 2)), 1, N'very large', 3)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (75, CAST(520.00 AS Decimal(18, 2)), 2, N'very beautiful', 3)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (76, CAST(220.00 AS Decimal(18, 2)), 1, N'very large', 4)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (77, CAST(520.00 AS Decimal(18, 2)), 2, N'very beautiful', 4)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (78, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 5)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (79, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 5)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (80, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 5)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (81, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 6)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (82, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 6)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (83, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 6)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (84, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 7)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (85, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 7)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (86, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 7)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (87, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 8)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (88, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 8)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (89, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 8)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (90, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 9)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (91, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 9)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (92, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 9)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (93, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 10)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (94, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 10)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (95, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 10)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (96, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 11)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (97, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 11)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (98, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 11)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (99, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 12)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (100, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 12)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (101, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 12)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (102, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 13)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (103, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 13)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (104, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 13)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (105, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 14)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (106, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 14)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (107, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 14)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (108, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 15)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (109, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 15)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (110, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 15)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (111, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 16)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (112, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 16)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (113, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 16)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (114, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 17)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (115, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 17)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (116, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 17)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (117, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 18)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (118, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 18)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (119, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 18)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (120, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 19)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (121, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 19)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (122, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 19)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (123, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 20)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (124, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 20)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (125, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 20)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (126, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 21)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (127, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 21)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (128, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 21)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (129, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 22)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (130, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 22)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (131, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 22)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (132, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 23)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (133, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 23)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (134, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 23)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (135, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 24)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (136, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 24)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (137, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 24)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (138, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 25)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (139, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 25)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (140, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 25)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (141, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 26)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (142, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 26)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (143, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 26)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (144, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 27)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (145, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 27)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (146, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 27)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (147, CAST(20.00 AS Decimal(18, 2)), 1, N'very large', 28)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (148, CAST(25.00 AS Decimal(18, 2)), 2, N'very beautiful', 28)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (149, CAST(55.00 AS Decimal(18, 2)), 3, N'very nice', 28)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (150, CAST(30.00 AS Decimal(18, 2)), 1, N'very large', 29)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (151, CAST(50.00 AS Decimal(18, 2)), 2, N'very beautiful', 29)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (152, CAST(90.00 AS Decimal(18, 2)), 3, N'very nice', 29)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (153, CAST(30.00 AS Decimal(18, 2)), 1, N'very large', 30)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (154, CAST(50.00 AS Decimal(18, 2)), 2, N'very beautiful', 30)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (155, CAST(90.00 AS Decimal(18, 2)), 3, N'very nice', 30)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (156, CAST(30.00 AS Decimal(18, 2)), 1, N'very large', 31)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (157, CAST(50.00 AS Decimal(18, 2)), 2, N'very beautiful', 31)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (158, CAST(90.00 AS Decimal(18, 2)), 3, N'very nice', 31)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (159, CAST(30.00 AS Decimal(18, 2)), 1, N'very large', 32)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (160, CAST(50.00 AS Decimal(18, 2)), 2, N'very beautiful', 32)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (161, CAST(90.00 AS Decimal(18, 2)), 3, N'very nice', 32)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (162, CAST(30.00 AS Decimal(18, 2)), 1, N'very large', 33)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (163, CAST(50.00 AS Decimal(18, 2)), 2, N'very beautiful', 33)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (164, CAST(90.00 AS Decimal(18, 2)), 3, N'very nice', 33)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (165, CAST(30.00 AS Decimal(18, 2)), 1, N'very large', 34)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (166, CAST(50.00 AS Decimal(18, 2)), 2, N'very beautiful', 34)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (167, CAST(90.00 AS Decimal(18, 2)), 3, N'very nice', 34)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (168, CAST(30.00 AS Decimal(18, 2)), 1, N'very large', 35)
GO
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (169, CAST(50.00 AS Decimal(18, 2)), 2, N'very beautiful', 35)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (170, CAST(90.00 AS Decimal(18, 2)), 3, N'very nice', 35)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (171, CAST(30.00 AS Decimal(18, 2)), 1, N'very large', 36)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (172, CAST(50.00 AS Decimal(18, 2)), 2, N'very beautiful', 36)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (173, CAST(90.00 AS Decimal(18, 2)), 3, N'very nice', 36)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (174, CAST(30.00 AS Decimal(18, 2)), 1, N'very large', 37)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (175, CAST(50.00 AS Decimal(18, 2)), 2, N'very beautiful', 37)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (176, CAST(90.00 AS Decimal(18, 2)), 3, N'very nice', 37)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (177, CAST(30.00 AS Decimal(18, 2)), 1, N'very large', 38)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (178, CAST(50.00 AS Decimal(18, 2)), 2, N'very beautiful', 38)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (179, CAST(90.00 AS Decimal(18, 2)), 3, N'very nice', 38)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (180, CAST(30.00 AS Decimal(18, 2)), 1, N'very large', 39)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (181, CAST(50.00 AS Decimal(18, 2)), 2, N'very beautiful', 39)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (182, CAST(90.00 AS Decimal(18, 2)), 3, N'very nice', 39)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (183, CAST(30.00 AS Decimal(18, 2)), 1, N'very large', 40)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (184, CAST(50.00 AS Decimal(18, 2)), 2, N'very beautiful', 40)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (185, CAST(90.00 AS Decimal(18, 2)), 3, N'very nice', 40)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (186, CAST(30.00 AS Decimal(18, 2)), 1, N'very large', 41)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (187, CAST(50.00 AS Decimal(18, 2)), 2, N'very beautiful', 41)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (188, CAST(90.00 AS Decimal(18, 2)), 3, N'very nice', 41)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (189, CAST(30.00 AS Decimal(18, 2)), 1, N'very large', 42)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (190, CAST(50.00 AS Decimal(18, 2)), 2, N'very beautiful', 42)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (191, CAST(90.00 AS Decimal(18, 2)), 3, N'very nice', 42)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (192, CAST(30.00 AS Decimal(18, 2)), 1, N'very large', 43)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (193, CAST(50.00 AS Decimal(18, 2)), 2, N'very beautiful', 43)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (194, CAST(90.00 AS Decimal(18, 2)), 3, N'very nice', 43)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (195, CAST(30.00 AS Decimal(18, 2)), 1, N'very large', 44)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (196, CAST(50.00 AS Decimal(18, 2)), 2, N'very beautiful', 44)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (197, CAST(90.00 AS Decimal(18, 2)), 3, N'very nice', 44)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (198, CAST(30.00 AS Decimal(18, 2)), 1, N'very large', 45)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (199, CAST(50.00 AS Decimal(18, 2)), 2, N'very beautiful', 45)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (200, CAST(90.00 AS Decimal(18, 2)), 3, N'very nice', 45)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (201, CAST(30.00 AS Decimal(18, 2)), 1, N'very large', 46)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (202, CAST(50.00 AS Decimal(18, 2)), 2, N'very beautiful', 46)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (203, CAST(90.00 AS Decimal(18, 2)), 3, N'very nice', 46)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (204, CAST(30.00 AS Decimal(18, 2)), 1, N'very large', 47)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (205, CAST(50.00 AS Decimal(18, 2)), 2, N'very beautiful', 47)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (206, CAST(90.00 AS Decimal(18, 2)), 3, N'very nice', 47)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (207, CAST(30.00 AS Decimal(18, 2)), 1, N'very large', 48)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (208, CAST(50.00 AS Decimal(18, 2)), 2, N'very beautiful', 48)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (209, CAST(90.00 AS Decimal(18, 2)), 3, N'very nice', 48)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (210, CAST(30.00 AS Decimal(18, 2)), 1, N'very large', 49)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (211, CAST(50.00 AS Decimal(18, 2)), 2, N'very beautiful', 49)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (212, CAST(90.00 AS Decimal(18, 2)), 3, N'very nice', 49)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (213, CAST(30.00 AS Decimal(18, 2)), 1, N'very large', 50)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (214, CAST(50.00 AS Decimal(18, 2)), 2, N'very beautiful', 50)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (215, CAST(90.00 AS Decimal(18, 2)), 3, N'very nice', 50)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (216, CAST(400.00 AS Decimal(18, 2)), 3, N'good', 2)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (242, CAST(30.00 AS Decimal(18, 2)), 2, N'بطاطس وبيبسى وسط', 51)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (243, CAST(50.00 AS Decimal(18, 2)), 3, N'بطاطس وبيبسى كبير', 51)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (244, CAST(200.00 AS Decimal(18, 2)), 1, N'dsc', 52)
INSERT [food].[FoodsSizes] ([FoodsSizesId], [Price], [SizeId], [SizeDescription], [FoodId]) VALUES (245, CAST(30.00 AS Decimal(18, 2)), 3, N'edsc2', 52)
SET IDENTITY_INSERT [food].[FoodsSizes] OFF
GO
SET IDENTITY_INSERT [food].[Sizes] ON 

INSERT [food].[Sizes] ([SizeId], [SizeAName], [SizeEName], [IsActive], [IsDelete]) VALUES (1, N'صغير', N'Small', 1, 0)
INSERT [food].[Sizes] ([SizeId], [SizeAName], [SizeEName], [IsActive], [IsDelete]) VALUES (2, N'متوسط', N'Medium', 1, 0)
INSERT [food].[Sizes] ([SizeId], [SizeAName], [SizeEName], [IsActive], [IsDelete]) VALUES (3, N'كبير', N'Large ', 1, 0)
SET IDENTITY_INSERT [food].[Sizes] OFF
GO
SET IDENTITY_INSERT [order].[Drivers] ON 

INSERT [order].[Drivers] ([DriverId], [DriverName], [Phone], [Password], [NationalIDCardFace], [NationalIDCardBack], [HealthCertificateFace], [HealthCertificateBack], [DrivingLicenseFace], [DrivingLicenseBack], [PersonalLicenseFace], [PersonalLicenseBack], [IsDelete], [IsApproved], [IsActive]) VALUES (1, N'adel', N'01019522376', N'12345', N'1', N'1', N'1', N'1', N'1', N'1', N'1', N'1', 0, 1, 1)
SET IDENTITY_INSERT [order].[Drivers] OFF
GO
SET IDENTITY_INSERT [order].[FoodOrders] ON 

INSERT [order].[FoodOrders] ([OrderId], [OrderCode], [OrderDate], [DriverId], [UserId], [IsSchedule], [HandDate], [DeliveryCost], [Total], [NetTotal], [OrderStatusId], [UsersAddressId], [PaymentMethodsId], [IsDeleted]) VALUES (7, N'0001', CAST(N'2022-12-01T00:00:00.000' AS DateTime), 1, 1, NULL, CAST(N'2022-12-01T00:00:00.000' AS DateTime), CAST(20.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), 1, 1, 1, NULL)
INSERT [order].[FoodOrders] ([OrderId], [OrderCode], [OrderDate], [DriverId], [UserId], [IsSchedule], [HandDate], [DeliveryCost], [Total], [NetTotal], [OrderStatusId], [UsersAddressId], [PaymentMethodsId], [IsDeleted]) VALUES (10, N'0002', CAST(N'2020-12-02T00:00:00.000' AS DateTime), 1, 1, NULL, CAST(N'2022-12-03T00:00:00.000' AS DateTime), CAST(30.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), CAST(400.00 AS Decimal(18, 2)), 2, 1, 2, NULL)
INSERT [order].[FoodOrders] ([OrderId], [OrderCode], [OrderDate], [DriverId], [UserId], [IsSchedule], [HandDate], [DeliveryCost], [Total], [NetTotal], [OrderStatusId], [UsersAddressId], [PaymentMethodsId], [IsDeleted]) VALUES (11, N'0003', CAST(N'2020-12-03T00:00:00.000' AS DateTime), 1, 1, NULL, CAST(N'2022-12-01T00:00:00.000' AS DateTime), CAST(40.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), CAST(300.00 AS Decimal(18, 2)), 3, 1, 1, NULL)
INSERT [order].[FoodOrders] ([OrderId], [OrderCode], [OrderDate], [DriverId], [UserId], [IsSchedule], [HandDate], [DeliveryCost], [Total], [NetTotal], [OrderStatusId], [UsersAddressId], [PaymentMethodsId], [IsDeleted]) VALUES (13, N'00012', CAST(N'2022-12-17T10:24:35.447' AS DateTime), NULL, 1, 0, NULL, CAST(0.00 AS Decimal(18, 2)), CAST(2880.00 AS Decimal(18, 2)), CAST(2880.00 AS Decimal(18, 2)), 1, 1, 1, NULL)
INSERT [order].[FoodOrders] ([OrderId], [OrderCode], [OrderDate], [DriverId], [UserId], [IsSchedule], [HandDate], [DeliveryCost], [Total], [NetTotal], [OrderStatusId], [UsersAddressId], [PaymentMethodsId], [IsDeleted]) VALUES (14, N'00014', CAST(N'2022-12-17T10:31:39.760' AS DateTime), NULL, 1, 0, NULL, CAST(0.00 AS Decimal(18, 2)), CAST(2880.00 AS Decimal(18, 2)), CAST(2880.00 AS Decimal(18, 2)), 1, 1, 1, NULL)
INSERT [order].[FoodOrders] ([OrderId], [OrderCode], [OrderDate], [DriverId], [UserId], [IsSchedule], [HandDate], [DeliveryCost], [Total], [NetTotal], [OrderStatusId], [UsersAddressId], [PaymentMethodsId], [IsDeleted]) VALUES (15, N'00015', CAST(N'2022-12-17T11:20:39.647' AS DateTime), NULL, 1, 1, CAST(N'2022-12-17T11:20:00.000' AS DateTime), CAST(0.00 AS Decimal(18, 2)), CAST(320.00 AS Decimal(18, 2)), CAST(320.00 AS Decimal(18, 2)), 1, 1, 1, NULL)
INSERT [order].[FoodOrders] ([OrderId], [OrderCode], [OrderDate], [DriverId], [UserId], [IsSchedule], [HandDate], [DeliveryCost], [Total], [NetTotal], [OrderStatusId], [UsersAddressId], [PaymentMethodsId], [IsDeleted]) VALUES (16, N'00016', CAST(N'2022-12-17T12:21:31.753' AS DateTime), NULL, 1, 1, CAST(N'2022-12-17T12:21:00.000' AS DateTime), CAST(0.00 AS Decimal(18, 2)), CAST(230.00 AS Decimal(18, 2)), CAST(230.00 AS Decimal(18, 2)), 1, 1, 1, NULL)
INSERT [order].[FoodOrders] ([OrderId], [OrderCode], [OrderDate], [DriverId], [UserId], [IsSchedule], [HandDate], [DeliveryCost], [Total], [NetTotal], [OrderStatusId], [UsersAddressId], [PaymentMethodsId], [IsDeleted]) VALUES (17, N'00017', CAST(N'2022-12-17T12:26:42.250' AS DateTime), NULL, 1, 0, CAST(N'2000-01-01T12:00:00.000' AS DateTime), CAST(0.00 AS Decimal(18, 2)), CAST(80.00 AS Decimal(18, 2)), CAST(80.00 AS Decimal(18, 2)), 1, 1, 1, NULL)
INSERT [order].[FoodOrders] ([OrderId], [OrderCode], [OrderDate], [DriverId], [UserId], [IsSchedule], [HandDate], [DeliveryCost], [Total], [NetTotal], [OrderStatusId], [UsersAddressId], [PaymentMethodsId], [IsDeleted]) VALUES (18, N'00018', CAST(N'2023-02-16T20:06:55.977' AS DateTime), NULL, 1, 1, CAST(N'2023-02-23T20:06:00.000' AS DateTime), CAST(0.00 AS Decimal(18, 2)), CAST(1580.00 AS Decimal(18, 2)), CAST(1580.00 AS Decimal(18, 2)), 1, 1, 1, NULL)
SET IDENTITY_INSERT [order].[FoodOrders] OFF
GO
SET IDENTITY_INSERT [order].[OrderDetails] ON 

INSERT [order].[OrderDetails] ([OrderDetailsId], [OrderId], [FoodId]) VALUES (18, 7, 2)
INSERT [order].[OrderDetails] ([OrderDetailsId], [OrderId], [FoodId]) VALUES (19, 7, 3)
INSERT [order].[OrderDetails] ([OrderDetailsId], [OrderId], [FoodId]) VALUES (24, 10, 46)
INSERT [order].[OrderDetails] ([OrderDetailsId], [OrderId], [FoodId]) VALUES (25, 10, 47)
INSERT [order].[OrderDetails] ([OrderDetailsId], [OrderId], [FoodId]) VALUES (26, 10, 48)
INSERT [order].[OrderDetails] ([OrderDetailsId], [OrderId], [FoodId]) VALUES (28, 11, 49)
INSERT [order].[OrderDetails] ([OrderDetailsId], [OrderId], [FoodId]) VALUES (29, 11, 50)
INSERT [order].[OrderDetails] ([OrderDetailsId], [OrderId], [FoodId]) VALUES (32, 14, 50)
INSERT [order].[OrderDetails] ([OrderDetailsId], [OrderId], [FoodId]) VALUES (33, 14, 2)
INSERT [order].[OrderDetails] ([OrderDetailsId], [OrderId], [FoodId]) VALUES (34, 15, 52)
INSERT [order].[OrderDetails] ([OrderDetailsId], [OrderId], [FoodId]) VALUES (35, 15, 10)
INSERT [order].[OrderDetails] ([OrderDetailsId], [OrderId], [FoodId]) VALUES (36, 16, 52)
INSERT [order].[OrderDetails] ([OrderDetailsId], [OrderId], [FoodId]) VALUES (37, 17, 51)
INSERT [order].[OrderDetails] ([OrderDetailsId], [OrderId], [FoodId]) VALUES (38, 18, 52)
INSERT [order].[OrderDetails] ([OrderDetailsId], [OrderId], [FoodId]) VALUES (39, 18, 44)
INSERT [order].[OrderDetails] ([OrderDetailsId], [OrderId], [FoodId]) VALUES (40, 18, 2)
SET IDENTITY_INSERT [order].[OrderDetails] OFF
GO
SET IDENTITY_INSERT [order].[OrderSizes] ON 

INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (1, 73, 5, 18)
INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (2, 74, 3, 19)
INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (5, 72, 1, 24)
INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (6, 71, 1, 25)
INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (7, 70, 3, 26)
INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (9, 74, 4, 28)
INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (10, 75, 2, 29)
INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (15, 215, 2, 33)
INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (16, 72, 1, 33)
INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (17, 73, 4, 33)
INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (18, 216, 1, 33)
INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (19, 244, 1, 35)
INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (20, 93, 2, 35)
INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (21, 94, 1, 35)
INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (22, 95, 1, 35)
INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (23, 244, 1, 36)
INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (24, 245, 1, 36)
INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (25, 242, 1, 37)
INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (26, 243, 1, 37)
INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (27, 244, 1, 40)
INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (28, 245, 1, 40)
INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (29, 195, 1, 40)
INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (30, 73, 1, 40)
INSERT [order].[OrderSizes] ([OrderSizesId], [FoodsSizesId], [Quantity], [OrderDetailsId]) VALUES (31, 216, 2, 40)
SET IDENTITY_INSERT [order].[OrderSizes] OFF
GO
INSERT [order].[OrderStatus] ([OrderStatusId], [OrderStatusAName], [OrderStatusEName]) VALUES (1, N'جاري التحضير', N'Preparing')
INSERT [order].[OrderStatus] ([OrderStatusId], [OrderStatusAName], [OrderStatusEName]) VALUES (2, N'في الطريق', N'in the way ')
INSERT [order].[OrderStatus] ([OrderStatusId], [OrderStatusAName], [OrderStatusEName]) VALUES (3, N'تم التوصيل', N'Delivered')
GO
INSERT [order].[PaymentMethods] ([PaymentMethodsId], [PaymentMethodsAName], [PaymentMethodsEName]) VALUES (1, N'نقدي', N'Cash')
INSERT [order].[PaymentMethods] ([PaymentMethodsId], [PaymentMethodsAName], [PaymentMethodsEName]) VALUES (2, N'فيزا', N'Visa')
GO
SET IDENTITY_INSERT [user].[Governorates] ON 

INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (1, N'الأسكندرية', N'Alexandria')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (2, N'الإسماعيلية', N'Ismailia')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (3, N'أسوان', N'Aswan')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (4, N'أسيوط', N'Asyut')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (5, N'الأقصر', N'Luxor')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (6, N'البحر الأحمر', N'Red Sea ')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (7, N'البحيرة', N'Beheira')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (8, N'بني سويف', N'Bani Sweif')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (9, N'بورسعيد', N'Port Said')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (10, N'جنوب سيناء', N'North Sinai')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (11, N'الجيزة', N'Giza')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (12, N'الدقهلية', N'Dakahlia')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (13, N'دمياط', N'Damietta')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (14, N'سوهاج', N'Sohag')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (15, N'السويس', N'Suez')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (16, N'الشرقية', N'Sharqia')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (17, N'شمال سيناء', N'North Sinai')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (18, N'الغربية', N'Gharbia')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (19, N'الفيوم', N'Fayoum')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (20, N'القاهرة', N'Cairo')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (21, N'القليوبية', N'Qalyubia')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (22, N'قنا', N'Qena')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (23, N'كفر الشيخ', N'Kafr El Sheikh')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (24, N'مطروح', N'Matrouh')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (25, N'المنوفية', N'Monufia')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (26, N'المنيا', N'El-Minya')
INSERT [user].[Governorates] ([GovernorateId], [GovernorateAName], [GovernorateEName]) VALUES (27, N'الوادي الجديد', N'new Valley')
SET IDENTITY_INSERT [user].[Governorates] OFF
GO
SET IDENTITY_INSERT [user].[UserRating] ON 

INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (1, 50, 1, 2, N'very good', CAST(N'2022-12-01' AS Date))
INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (2, 49, 2, 1, N'very nice', CAST(N'2022-11-30' AS Date))
INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (3, 48, 3, 2, N'very nice', CAST(N'2022-11-28' AS Date))
INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (4, 47, 1, 3, N'very nice', CAST(N'2022-11-27' AS Date))
INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (5, 46, 2, 4, N'very nice', CAST(N'2022-11-26' AS Date))
INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (6, 45, 3, 5, N'very good', CAST(N'2022-11-25' AS Date))
INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (7, 44, 1, 5, N'very good', CAST(N'2022-11-24' AS Date))
INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (8, 1, 2, 5, N'very good', CAST(N'2022-11-23' AS Date))
INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (9, 2, 3, 5, N'very good', CAST(N'2022-11-22' AS Date))
INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (10, 3, 1, 5, N'very nice', CAST(N'2022-11-21' AS Date))
INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (11, 4, 2, 4, N'very nice', CAST(N'2022-11-20' AS Date))
INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (12, 5, 3, 3, N'very nice', CAST(N'2022-11-19' AS Date))
INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (13, 6, 1, 3, N'very good', CAST(N'2022-11-18' AS Date))
INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (15, 7, 2, 2, N'very good', CAST(N'2022-11-17' AS Date))
INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (16, 8, 3, 2, N'very good', CAST(N'2022-07-16' AS Date))
INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (17, 9, 1, 4, N'very nice', CAST(N'2022-08-15' AS Date))
INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (18, 10, 2, 4, N'very nice', CAST(N'2022-09-14' AS Date))
INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (19, 11, 3, 4, N'very good', CAST(N'2022-10-13' AS Date))
INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (20, 12, 1, 2, N'very nice', CAST(N'2022-11-12' AS Date))
INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (21, 13, 2, 5, N'very good', CAST(N'2018-12-11' AS Date))
INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (22, 14, 3, 2, N'very nice', CAST(N'2019-12-10' AS Date))
INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (23, 15, 1, 3, N'very good', CAST(N'2021-12-09' AS Date))
INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (24, 16, 2, 2, N'very nice', CAST(N'2020-12-18' AS Date))
INSERT [user].[UserRating] ([UserRatingId], [FoodId], [UserId], [Rating], [Description], [RatingDate]) VALUES (25, 2, 1, 3, N'good', CAST(N'2022-12-02' AS Date))
SET IDENTITY_INSERT [user].[UserRating] OFF
GO
INSERT [user].[Users] ([UserId], [UserName], [Password], [Phone], [Image], [Gender], [IsProvider], [Latitude], [Longitude], [GovernorateId], [Address], [NationalIDCard1], [NationalIDCard2], [IsApproved], [IsActive], [IsDelete], [CreationDate], [OTPCode], [OTPNumberOfTimesSent], [OTPDateOfLastSent]) VALUES (1, N'Omar', N'EmWxmohgIvk=', N'01019522376', N'\Uploads\Users\1\ymrbqnmd.eez.webp', 1, 1, 29.972417, 30.944531, 11, N'giza', N'\Uploads\Users\4\ct34hzco.1xc.webp', N'\Uploads\Users\4\ct34hzco.1xc.webp', 1, 1, 0, CAST(N'2020-05-05T00:00:00.000' AS DateTime), 0, 3, CAST(N'2023-01-18T01:12:58.543' AS DateTime))
INSERT [user].[Users] ([UserId], [UserName], [Password], [Phone], [Image], [Gender], [IsProvider], [Latitude], [Longitude], [GovernorateId], [Address], [NationalIDCard1], [NationalIDCard2], [IsApproved], [IsActive], [IsDelete], [CreationDate], [OTPCode], [OTPNumberOfTimesSent], [OTPDateOfLastSent]) VALUES (2, N'محمد', N'e9+Jav4K/IY=', N'01219522376', NULL, 1, 1, 29.972417, 30.944531, 2, NULL, N'\Uploads\Users\4\ct34hzco.1xc.webp', N'\Uploads\Users\4\ct34hzco.1xc.webp', 1, 1, 0, CAST(N'2020-05-05T00:00:00.000' AS DateTime), 0, 1, CAST(N'2022-11-27T22:19:00.253' AS DateTime))
INSERT [user].[Users] ([UserId], [UserName], [Password], [Phone], [Image], [Gender], [IsProvider], [Latitude], [Longitude], [GovernorateId], [Address], [NationalIDCard1], [NationalIDCard2], [IsApproved], [IsActive], [IsDelete], [CreationDate], [OTPCode], [OTPNumberOfTimesSent], [OTPDateOfLastSent]) VALUES (3, N'سعد', N'e9+Jav4K/IY=', N'01015233478', N'\Uploads\Users\3\2wmv53xs.s02.webp', 1, 1, 29.972417, 30.944531, 3, NULL, N'\Uploads\Users\4\ct34hzco.1xc.webp', N'\Uploads\Users\4\ct34hzco.1xc.webp', 1, 1, 0, CAST(N'2020-05-05T00:00:00.000' AS DateTime), 0, 2, CAST(N'2022-11-27T22:19:00.253' AS DateTime))
INSERT [user].[Users] ([UserId], [UserName], [Password], [Phone], [Image], [Gender], [IsProvider], [Latitude], [Longitude], [GovernorateId], [Address], [NationalIDCard1], [NationalIDCard2], [IsApproved], [IsActive], [IsDelete], [CreationDate], [OTPCode], [OTPNumberOfTimesSent], [OTPDateOfLastSent]) VALUES (4, N'user omar', N'e9+Jav4K/IY=', N'01019522377', NULL, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 0, CAST(N'2022-12-05T23:12:20.530' AS DateTime), 0, 1, CAST(N'2022-12-05T23:12:20.733' AS DateTime))
INSERT [user].[Users] ([UserId], [UserName], [Password], [Phone], [Image], [Gender], [IsProvider], [Latitude], [Longitude], [GovernorateId], [Address], [NationalIDCard1], [NationalIDCard2], [IsApproved], [IsActive], [IsDelete], [CreationDate], [OTPCode], [OTPNumberOfTimesSent], [OTPDateOfLastSent]) VALUES (5, N'koko', N'e9+Jav4K/IY=', N'01019522333', NULL, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, CAST(N'2023-01-18T00:43:18.893' AS DateTime), 1234, 1, CAST(N'2023-01-18T00:43:19.070' AS DateTime))
INSERT [user].[Users] ([UserId], [UserName], [Password], [Phone], [Image], [Gender], [IsProvider], [Latitude], [Longitude], [GovernorateId], [Address], [NationalIDCard1], [NationalIDCard2], [IsApproved], [IsActive], [IsDelete], [CreationDate], [OTPCode], [OTPNumberOfTimesSent], [OTPDateOfLastSent]) VALUES (6, N'leo', N'EmWxmohgIvk=', N'01587233499', N'\Uploads\Users\6\k5fnytb4.5yn.webp', 1, 1, 29.9696295, 31.0053332, 1, N'cairo', N'\Uploads\Users\6\rdapjha1.toz.webp', N'\Uploads\Users\6\mkuugv5k.gqw.webp', 0, 1, 0, CAST(N'2023-01-28T16:14:35.767' AS DateTime), NULL, NULL, NULL)
INSERT [user].[Users] ([UserId], [UserName], [Password], [Phone], [Image], [Gender], [IsProvider], [Latitude], [Longitude], [GovernorateId], [Address], [NationalIDCard1], [NationalIDCard2], [IsApproved], [IsActive], [IsDelete], [CreationDate], [OTPCode], [OTPNumberOfTimesSent], [OTPDateOfLastSent]) VALUES (7, N'eau leo', N'e9+Jav4K/IY=', N'01587233411', N'\Uploads\Users\7\a143vjkx.ejk.webp', 1, 1, 29.9696295, 31.0053332, 1, N'cairo', N'\Uploads\Users\7\31yyuiid.qqr.webp', N'\Uploads\Users\7\u0svqllx.yn3.webp', 0, 1, 0, CAST(N'2023-01-28T16:25:24.013' AS DateTime), NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [user].[UsersAddress] ON 

INSERT [user].[UsersAddress] ([UsersAddressId], [UsersAddressName], [UserId], [Address], [ApartmentNo], [BuildingNo], [Street], [Floor], [Latitude], [Longitude]) VALUES (1, N'Home', 1, N'cairo', 1, 2, N'3', 4, 29.972417, 30.944531)
INSERT [user].[UsersAddress] ([UsersAddressId], [UsersAddressName], [UserId], [Address], [ApartmentNo], [BuildingNo], [Street], [Floor], [Latitude], [Longitude]) VALUES (3, N'Home', 1, N'cairo', 1, 2, N'3', 4, 29.972417, 30.944531)
INSERT [user].[UsersAddress] ([UsersAddressId], [UsersAddressName], [UserId], [Address], [ApartmentNo], [BuildingNo], [Street], [Floor], [Latitude], [Longitude]) VALUES (4, N'work', 1, N'address', 3, 2, N'1', 4, 29.972417, 30.944531)
SET IDENTITY_INSERT [user].[UsersAddress] OFF
GO
SET IDENTITY_INSERT [user].[UsersFavorite] ON 

INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (13, 1, 1)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (14, 2, 1)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (15, 3, 1)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (16, 4, 1)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (17, 5, 1)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (18, 6, 1)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (19, 7, 1)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (20, 8, 1)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (21, 9, 1)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (22, 10, 1)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (23, 11, 1)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (24, 12, 1)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (25, 13, 1)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (26, 14, 1)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (27, 15, 1)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (28, 16, 1)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (29, 17, 1)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (30, 18, 1)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (31, 19, 1)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (32, 20, 1)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (33, 1, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (34, 2, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (35, 3, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (36, 4, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (37, 5, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (38, 6, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (39, 7, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (40, 8, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (41, 9, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (42, 10, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (43, 11, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (44, 12, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (45, 13, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (46, 14, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (47, 15, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (48, 16, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (49, 17, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (50, 18, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (51, 19, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (52, 20, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (53, 50, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (54, 49, 1)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (55, 48, 3)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (56, 47, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (57, 46, 1)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (58, 45, 3)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (59, 44, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (60, 43, 1)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (61, 42, 3)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (62, 40, 2)
INSERT [user].[UsersFavorite] ([UsersFavoriteId], [FoodId], [UserId]) VALUES (63, 39, 1)
SET IDENTITY_INSERT [user].[UsersFavorite] OFF
GO
SET IDENTITY_INSERT [user].[UsersViews] ON 

INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (7, 1, 1)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (9, 1, 2)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (10, 1, 3)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (11, 1, 4)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (12, 1, 5)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (13, 1, 6)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (14, 1, 7)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (15, 1, 8)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (16, 2, 9)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (17, 2, 10)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (18, 2, 11)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (19, 2, 12)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (20, 2, 13)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (21, 2, 14)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (22, 2, 15)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (23, 2, 16)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (24, 3, 17)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (25, 3, 18)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (26, 3, 19)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (27, 2, 20)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (28, 2, 21)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (29, 2, 22)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (30, 2, 23)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (31, 2, 24)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (32, 2, 25)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (33, 2, 26)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (36, 1, 27)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (37, 1, 28)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (38, 1, 29)
INSERT [user].[UsersViews] ([UsersViewsId], [UserId], [FoodId]) VALUES (39, 1, 30)
SET IDENTITY_INSERT [user].[UsersViews] OFF
GO
INSERT [user].[Wallet] ([UserId], [Balance]) VALUES (1, CAST(450.00 AS Decimal(18, 2)))
GO
SET IDENTITY_INSERT [user].[WalletHistory] ON 

INSERT [user].[WalletHistory] ([WalletHistoryId], [UserId], [Date], [Amount], [Balance], [Effect], [Commission], [OrderId]) VALUES (1, 1, CAST(N'2023-02-15T00:00:00.000' AS DateTime), CAST(50.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), 1, CAST(0.00 AS Decimal(18, 2)), NULL)
INSERT [user].[WalletHistory] ([WalletHistoryId], [UserId], [Date], [Amount], [Balance], [Effect], [Commission], [OrderId]) VALUES (2, 1, CAST(N'2023-02-16T00:00:00.000' AS DateTime), CAST(50.00 AS Decimal(18, 2)), CAST(100.00 AS Decimal(18, 2)), 1, CAST(0.00 AS Decimal(18, 2)), NULL)
INSERT [user].[WalletHistory] ([WalletHistoryId], [UserId], [Date], [Amount], [Balance], [Effect], [Commission], [OrderId]) VALUES (10, 1, CAST(N'2023-02-18T21:16:15.970' AS DateTime), CAST(50.00 AS Decimal(18, 2)), CAST(50.00 AS Decimal(18, 2)), -1, CAST(0.00 AS Decimal(18, 2)), NULL)
INSERT [user].[WalletHistory] ([WalletHistoryId], [UserId], [Date], [Amount], [Balance], [Effect], [Commission], [OrderId]) VALUES (11, 1, CAST(N'2023-02-18T21:16:19.043' AS DateTime), CAST(50.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), -1, CAST(0.00 AS Decimal(18, 2)), NULL)
INSERT [user].[WalletHistory] ([WalletHistoryId], [UserId], [Date], [Amount], [Balance], [Effect], [Commission], [OrderId]) VALUES (12, 1, CAST(N'2023-02-18T21:16:37.790' AS DateTime), CAST(500.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), 1, CAST(0.00 AS Decimal(18, 2)), NULL)
INSERT [user].[WalletHistory] ([WalletHistoryId], [UserId], [Date], [Amount], [Balance], [Effect], [Commission], [OrderId]) VALUES (13, 1, CAST(N'2023-02-18T21:17:03.267' AS DateTime), CAST(50.00 AS Decimal(18, 2)), CAST(450.00 AS Decimal(18, 2)), -1, CAST(0.00 AS Decimal(18, 2)), NULL)
SET IDENTITY_INSERT [user].[WalletHistory] OFF
GO
ALTER TABLE [Auth].[DashBoardUsers]  WITH CHECK ADD  CONSTRAINT [FK_DashBoardUsers_Groups] FOREIGN KEY([GroupId])
REFERENCES [Auth].[Groups] ([GroupId])
GO
ALTER TABLE [Auth].[DashBoardUsers] CHECK CONSTRAINT [FK_DashBoardUsers_Groups]
GO
ALTER TABLE [Auth].[GroupPermissions]  WITH CHECK ADD  CONSTRAINT [FK_GroupPermission_Groups] FOREIGN KEY([GroupId])
REFERENCES [Auth].[Groups] ([GroupId])
GO
ALTER TABLE [Auth].[GroupPermissions] CHECK CONSTRAINT [FK_GroupPermission_Groups]
GO
ALTER TABLE [Auth].[GroupPermissions]  WITH CHECK ADD  CONSTRAINT [FK_GroupPermission_Pages] FOREIGN KEY([PageId])
REFERENCES [Auth].[Pages] ([PageId])
GO
ALTER TABLE [Auth].[GroupPermissions] CHECK CONSTRAINT [FK_GroupPermission_Pages]
GO
ALTER TABLE [Auth].[Pages]  WITH CHECK ADD  CONSTRAINT [FK_Pages_PagesTap] FOREIGN KEY([PagesTabId])
REFERENCES [Auth].[PagesTabs] ([PagesTabId])
GO
ALTER TABLE [Auth].[Pages] CHECK CONSTRAINT [FK_Pages_PagesTap]
GO
ALTER TABLE [food].[Basket]  WITH CHECK ADD  CONSTRAINT [FK_Basket_Foods] FOREIGN KEY([FoodId])
REFERENCES [food].[Foods] ([FoodId])
GO
ALTER TABLE [food].[Basket] CHECK CONSTRAINT [FK_Basket_Foods]
GO
ALTER TABLE [food].[Basket]  WITH CHECK ADD  CONSTRAINT [FK_Basket_Users] FOREIGN KEY([UserId])
REFERENCES [user].[Users] ([UserId])
GO
ALTER TABLE [food].[Basket] CHECK CONSTRAINT [FK_Basket_Users]
GO
ALTER TABLE [food].[BasketSizes]  WITH CHECK ADD  CONSTRAINT [FK_BasketSizes_Basket] FOREIGN KEY([BasketId])
REFERENCES [food].[Basket] ([BasketId])
GO
ALTER TABLE [food].[BasketSizes] CHECK CONSTRAINT [FK_BasketSizes_Basket]
GO
ALTER TABLE [food].[BasketSizes]  WITH CHECK ADD  CONSTRAINT [FK_BasketSizes_FoodsSizes] FOREIGN KEY([FoodsSizesId])
REFERENCES [food].[FoodsSizes] ([FoodsSizesId])
GO
ALTER TABLE [food].[BasketSizes] CHECK CONSTRAINT [FK_BasketSizes_FoodsSizes]
GO
ALTER TABLE [food].[FoodCategories]  WITH CHECK ADD  CONSTRAINT [FK_FoodCategories_Categorys] FOREIGN KEY([CategoryId])
REFERENCES [food].[Categories] ([CategoryId])
GO
ALTER TABLE [food].[FoodCategories] CHECK CONSTRAINT [FK_FoodCategories_Categorys]
GO
ALTER TABLE [food].[FoodCategories]  WITH CHECK ADD  CONSTRAINT [FK_FoodCategories_Foods] FOREIGN KEY([FoodId])
REFERENCES [food].[Foods] ([FoodId])
GO
ALTER TABLE [food].[FoodCategories] CHECK CONSTRAINT [FK_FoodCategories_Foods]
GO
ALTER TABLE [food].[FoodsImages]  WITH CHECK ADD  CONSTRAINT [FK_ItemImages_Items] FOREIGN KEY([FoodId])
REFERENCES [food].[Foods] ([FoodId])
GO
ALTER TABLE [food].[FoodsImages] CHECK CONSTRAINT [FK_ItemImages_Items]
GO
ALTER TABLE [food].[FoodsSizes]  WITH CHECK ADD  CONSTRAINT [FK_ItemSizes_Items] FOREIGN KEY([FoodId])
REFERENCES [food].[Foods] ([FoodId])
GO
ALTER TABLE [food].[FoodsSizes] CHECK CONSTRAINT [FK_ItemSizes_Items]
GO
ALTER TABLE [food].[FoodsSizes]  WITH CHECK ADD  CONSTRAINT [FK_ItemSizes_Sizes] FOREIGN KEY([SizeId])
REFERENCES [food].[Sizes] ([SizeId])
GO
ALTER TABLE [food].[FoodsSizes] CHECK CONSTRAINT [FK_ItemSizes_Sizes]
GO
ALTER TABLE [order].[FoodOrders]  WITH CHECK ADD  CONSTRAINT [FK_FoodOrders_OrderStatus1] FOREIGN KEY([OrderStatusId])
REFERENCES [order].[OrderStatus] ([OrderStatusId])
GO
ALTER TABLE [order].[FoodOrders] CHECK CONSTRAINT [FK_FoodOrders_OrderStatus1]
GO
ALTER TABLE [order].[FoodOrders]  WITH CHECK ADD  CONSTRAINT [FK_FoodOrders_PaymentMethods] FOREIGN KEY([PaymentMethodsId])
REFERENCES [order].[PaymentMethods] ([PaymentMethodsId])
GO
ALTER TABLE [order].[FoodOrders] CHECK CONSTRAINT [FK_FoodOrders_PaymentMethods]
GO
ALTER TABLE [order].[FoodOrders]  WITH CHECK ADD  CONSTRAINT [FK_FoodOrders_UsersAddress] FOREIGN KEY([UsersAddressId])
REFERENCES [user].[UsersAddress] ([UsersAddressId])
GO
ALTER TABLE [order].[FoodOrders] CHECK CONSTRAINT [FK_FoodOrders_UsersAddress]
GO
ALTER TABLE [order].[FoodOrders]  WITH CHECK ADD  CONSTRAINT [FK_Order_Driver] FOREIGN KEY([DriverId])
REFERENCES [order].[Drivers] ([DriverId])
GO
ALTER TABLE [order].[FoodOrders] CHECK CONSTRAINT [FK_Order_Driver]
GO
ALTER TABLE [order].[FoodOrders]  WITH CHECK ADD  CONSTRAINT [FK_Order_Users] FOREIGN KEY([UserId])
REFERENCES [user].[Users] ([UserId])
GO
ALTER TABLE [order].[FoodOrders] CHECK CONSTRAINT [FK_Order_Users]
GO
ALTER TABLE [order].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Items] FOREIGN KEY([FoodId])
REFERENCES [food].[Foods] ([FoodId])
GO
ALTER TABLE [order].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_Items]
GO
ALTER TABLE [order].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Order] FOREIGN KEY([OrderId])
REFERENCES [order].[FoodOrders] ([OrderId])
GO
ALTER TABLE [order].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_Order]
GO
ALTER TABLE [order].[OrderSizes]  WITH CHECK ADD  CONSTRAINT [FK_OrderSizes_FoodsSizes] FOREIGN KEY([FoodsSizesId])
REFERENCES [food].[FoodsSizes] ([FoodsSizesId])
GO
ALTER TABLE [order].[OrderSizes] CHECK CONSTRAINT [FK_OrderSizes_FoodsSizes]
GO
ALTER TABLE [order].[OrderSizes]  WITH CHECK ADD  CONSTRAINT [FK_OrderSizes_OrderDetails] FOREIGN KEY([OrderDetailsId])
REFERENCES [order].[OrderDetails] ([OrderDetailsId])
GO
ALTER TABLE [order].[OrderSizes] CHECK CONSTRAINT [FK_OrderSizes_OrderDetails]
GO
ALTER TABLE [user].[UserRating]  WITH CHECK ADD  CONSTRAINT [FK_UserRating_Items] FOREIGN KEY([FoodId])
REFERENCES [food].[Foods] ([FoodId])
GO
ALTER TABLE [user].[UserRating] CHECK CONSTRAINT [FK_UserRating_Items]
GO
ALTER TABLE [user].[UserRating]  WITH CHECK ADD  CONSTRAINT [FK_UserRating_Users] FOREIGN KEY([UserId])
REFERENCES [user].[Users] ([UserId])
GO
ALTER TABLE [user].[UserRating] CHECK CONSTRAINT [FK_UserRating_Users]
GO
ALTER TABLE [user].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_Governorates] FOREIGN KEY([GovernorateId])
REFERENCES [user].[Governorates] ([GovernorateId])
GO
ALTER TABLE [user].[Users] CHECK CONSTRAINT [FK_Users_Governorates]
GO
ALTER TABLE [user].[UsersAddress]  WITH CHECK ADD  CONSTRAINT [FK_UsersAddress_Users] FOREIGN KEY([UserId])
REFERENCES [user].[Users] ([UserId])
GO
ALTER TABLE [user].[UsersAddress] CHECK CONSTRAINT [FK_UsersAddress_Users]
GO
ALTER TABLE [user].[UsersFavorite]  WITH CHECK ADD  CONSTRAINT [FK_UsersLikes_Foods] FOREIGN KEY([FoodId])
REFERENCES [food].[Foods] ([FoodId])
GO
ALTER TABLE [user].[UsersFavorite] CHECK CONSTRAINT [FK_UsersLikes_Foods]
GO
ALTER TABLE [user].[UsersFavorite]  WITH CHECK ADD  CONSTRAINT [FK_UsersLikes_Users] FOREIGN KEY([UserId])
REFERENCES [user].[Users] ([UserId])
GO
ALTER TABLE [user].[UsersFavorite] CHECK CONSTRAINT [FK_UsersLikes_Users]
GO
ALTER TABLE [user].[UsersViews]  WITH CHECK ADD  CONSTRAINT [FK_UsersViews_Items] FOREIGN KEY([FoodId])
REFERENCES [food].[Foods] ([FoodId])
GO
ALTER TABLE [user].[UsersViews] CHECK CONSTRAINT [FK_UsersViews_Items]
GO
ALTER TABLE [user].[UsersViews]  WITH CHECK ADD  CONSTRAINT [FK_UsersViews_Users] FOREIGN KEY([UserId])
REFERENCES [user].[Users] ([UserId])
GO
ALTER TABLE [user].[UsersViews] CHECK CONSTRAINT [FK_UsersViews_Users]
GO
ALTER TABLE [user].[Wallet]  WITH CHECK ADD  CONSTRAINT [FK_Wallet_Users1] FOREIGN KEY([UserId])
REFERENCES [user].[Users] ([UserId])
GO
ALTER TABLE [user].[Wallet] CHECK CONSTRAINT [FK_Wallet_Users1]
GO
ALTER TABLE [user].[WalletHistory]  WITH CHECK ADD  CONSTRAINT [FK_WalletHistory_FoodOrders] FOREIGN KEY([OrderId])
REFERENCES [order].[FoodOrders] ([OrderId])
GO
ALTER TABLE [user].[WalletHistory] CHECK CONSTRAINT [FK_WalletHistory_FoodOrders]
GO
ALTER TABLE [user].[WalletHistory]  WITH CHECK ADD  CONSTRAINT [FK_WalletHistory_Wallet] FOREIGN KEY([UserId])
REFERENCES [user].[Wallet] ([UserId])
GO
ALTER TABLE [user].[WalletHistory] CHECK CONSTRAINT [FK_WalletHistory_Wallet]
GO
/****** Object:  StoredProcedure [Auth].[LoadGroupPermissions]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Auth].[LoadGroupPermissions]
	 @groupId int,@tapId int
AS
BEGIN 
	SET NOCOUNT ON;
	select
	pages.PageId,
	pages.PageAname,
	pages.PageEname,
	iif((select COUNT(*) from [Auth].GroupPermissions as permission where permission.PageId=pages.PageId and permission.GroupId=@groupId)>0,'True','False') as 'State'
	from [Auth].Pages as pages where pages.PagesTabId=@tapId;
END
GO
/****** Object:  StoredProcedure [food].[LastSeen]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [food].[LastSeen]
@userId int
as
begin
select *  from food.VwFood  
join [user].UsersViews on [user].UsersViews.FoodId=food.VwFood.FoodId
where [user].UsersViews.UserId=@userId and food.VwFood.IsApproved='True'
order by [user].UsersViews.UsersViewsId desc
end
GO
/****** Object:  Trigger [order].[tr_FoodOrdersToBasket]    Script Date: 2023-02-25 11:18:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [order].[tr_FoodOrdersToBasket] on [order].[FoodOrders] after insert
 as
begin
declare @userId int;
declare @orderId int;
select @userId=UserId,@orderId=OrderId from Inserted;

insert into [order].OrderDetails(OrderId,FoodId) ( select @orderId,FoodId from food.Basket  where UserId=@userId);

declare @orderDetailsId int;
 
SELECT TOP 1 @orderDetailsId=OrderDetailsId FROM [order].OrderDetails ORDER BY OrderDetailsId DESC;

insert into [order].OrderSizes (FoodsSizesId,Quantity,OrderDetailsId)( select FoodsSizesId,Quantity,@orderDetailsId from food.BasketSizes where food.BasketSizes.BasketId in(select BasketId from food.Basket where UserId=@userId))

delete from food.BasketSizes   where food.BasketSizes.BasketId in(select BasketId from food.Basket where UserId=@userId)
delete from food.Basket where UserId=@userId;
end
 
GO
ALTER TABLE [order].[FoodOrders] ENABLE TRIGGER [tr_FoodOrdersToBasket]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[46] 4[15] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Groups (Auth)"
            Begin Extent = 
               Top = 7
               Left = 339
               Bottom = 212
               Right = 533
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DashBoardUsers (Auth)"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 254
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 3840
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'Auth', @level1type=N'VIEW',@level1name=N'VwDashBoardUsers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'Auth', @level1type=N'VIEW',@level1name=N'VwDashBoardUsers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'Auth', @level1type=N'VIEW',@level1name=N'VwGroups'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'Auth', @level1type=N'VIEW',@level1name=N'VwGroups'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[10] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'Auth', @level1type=N'VIEW',@level1name=N'VwPagesGroupPermission'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'Auth', @level1type=N'VIEW',@level1name=N'VwPagesGroupPermission'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[37] 4[3] 2[26] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "BasketSizes (food)"
            Begin Extent = 
               Top = 7
               Left = 290
               Bottom = 170
               Right = 484
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FoodsSizes (food)"
            Begin Extent = 
               Top = 7
               Left = 532
               Bottom = 234
               Right = 730
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Sizes (food)"
            Begin Extent = 
               Top = 7
               Left = 778
               Bottom = 170
               Right = 972
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Basket (food)"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VwFood (food)"
            Begin Extent = 
               Top = 7
               Left = 1020
               Bottom = 264
               Right = 1225
            End
            DisplayFlags = 280
            TopColumn = 5
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 12
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
      End
   End
   Begi' , @level0type=N'SCHEMA',@level0name=N'food', @level1type=N'VIEW',@level1name=N'VwBasket'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'n CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'food', @level1type=N'VIEW',@level1name=N'VwBasket'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'food', @level1type=N'VIEW',@level1name=N'VwBasket'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'food', @level1type=N'VIEW',@level1name=N'VwCategories'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'food', @level1type=N'VIEW',@level1name=N'VwCategories'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[34] 4[3] 2[33] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 22
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'food', @level1type=N'VIEW',@level1name=N'VwFood'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'food', @level1type=N'VIEW',@level1name=N'VwFood'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "FoodCategories (food)"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 248
               Right = 261
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Foods (food)"
            Begin Extent = 
               Top = 7
               Left = 309
               Bottom = 262
               Right = 512
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'food', @level1type=N'VIEW',@level1name=N'VwFoodCategories'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'food', @level1type=N'VIEW',@level1name=N'VwFoodCategories'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "FoodsSizes (food)"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 246
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Sizes (food)"
            Begin Extent = 
               Top = 125
               Left = 420
               Bottom = 288
               Right = 614
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'food', @level1type=N'VIEW',@level1name=N'VwFoodsSizes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'food', @level1type=N'VIEW',@level1name=N'VwFoodsSizes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'food', @level1type=N'VIEW',@level1name=N'VwSizes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'food', @level1type=N'VIEW',@level1name=N'VwSizes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[30] 4[20] 2[34] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -360
         Left = -61
      End
      Begin Tables = 
         Begin Table = "FoodOrders (order)"
            Begin Extent = 
               Top = 367
               Left = 109
               Bottom = 530
               Right = 332
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UsersAddress (user)"
            Begin Extent = 
               Top = 535
               Left = 109
               Bottom = 698
               Right = 332
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OrderStatus (order)"
            Begin Extent = 
               Top = 703
               Left = 109
               Bottom = 844
               Right = 332
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PaymentMethods (order)"
            Begin Extent = 
               Top = 850
               Left = 109
               Bottom = 991
               Right = 369
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 26
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         ' , @level0type=N'SCHEMA',@level0name=N'order', @level1type=N'VIEW',@level1name=N'VwFoodOrders'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'Width = 1200
         Width = 1200
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 3528
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'order', @level1type=N'VIEW',@level1name=N'VwFoodOrders'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'order', @level1type=N'VIEW',@level1name=N'VwFoodOrders'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[42] 4[17] 2[25] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "FoodOrders (order)"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 271
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OrderStatus (order)"
            Begin Extent = 
               Top = 175
               Left = 48
               Bottom = 316
               Right = 271
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OrderDetails (order)"
            Begin Extent = 
               Top = 322
               Left = 48
               Bottom = 463
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OrderSizes (order)"
            Begin Extent = 
               Top = 469
               Left = 48
               Bottom = 632
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FoodsSizes (food)"
            Begin Extent = 
               Top = 7
               Left = 784
               Bottom = 244
               Right = 982
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Sizes (food)"
            Begin Extent = 
               Top = 7
               Left = 1030
               Bottom = 170
               Right = 1224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PaymentMethods (order)"
            Begin Extent = 
               Top = 637
               Left = 48
               Bottom = 778
 ' , @level0type=N'SCHEMA',@level0name=N'order', @level1type=N'VIEW',@level1name=N'VwOrderDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'              Right = 308
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VwFood (food)"
            Begin Extent = 
               Top = 175
               Left = 1030
               Bottom = 338
               Right = 1235
            End
            DisplayFlags = 280
            TopColumn = 3
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 18
         Width = 284
         Width = 1200
         Width = 1740
         Width = 2136
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'order', @level1type=N'VIEW',@level1name=N'VwOrderDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'order', @level1type=N'VIEW',@level1name=N'VwOrderDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Users (user)"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 308
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 21
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'user', @level1type=N'VIEW',@level1name=N'VwProviders'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'user', @level1type=N'VIEW',@level1name=N'VwProviders'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'user', @level1type=N'VIEW',@level1name=N'VwUserRating'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'user', @level1type=N'VIEW',@level1name=N'VwUserRating'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[18] 4[16] 2[47] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 19
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 2568
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'user', @level1type=N'VIEW',@level1name=N'VwUsers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'user', @level1type=N'VIEW',@level1name=N'VwUsers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "WalletHistory (user)"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 286
               Right = 582
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'user', @level1type=N'VIEW',@level1name=N'VwWalletHistory'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'user', @level1type=N'VIEW',@level1name=N'VwWalletHistory'
GO
