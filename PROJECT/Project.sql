CREATE DATABASE AmericanEagle

Go 

USE AmericanEagle

/*
Statements to drop all tables
DROP TABLE tblBillingAddress
DROP TABLE tblShippingAddress
DROP TABLE tblCompany
DROP TABLE tblTax
DROP TABLE tblOrder
DROP TABLE tblShippingMethod
DROP TABLE tblList
DROP TABLE tblItems
*/


SET NOCOUNT ON;

CREATE TABLE tblBillingAddress
(
	BillingAddressID INT IDENTITY(1,1) PRIMARY KEY,
	FirstName NVARCHAR(50),
	LastName NVARCHAR(50),
	Street NVARCHAR(50),
	StateName NVARCHAR(50),
	CityName NVARCHAR(50),
	ZipCode VARCHAR(10),
	Country NVARCHAR(20)
)
GO

CREATE TABLE tblShippingAddress
(
	ShippingAddressID INT IDENTITY(1,1) PRIMARY KEY,
	FirstName NVARCHAR(50),
	LastName NVARCHAR(50),
	Street NVARCHAR(50),
	StateName NVARCHAR(50),
	CityName NVARCHAR(50),
	ZipCode VARCHAR(10),
	Country NVARCHAR(20)
)
GO

CREATE TABLE tblCompany
(
	CompanyID INT IDENTITY(1,1) PRIMARY KEY,
	CompanyName NVARCHAR(50)
)
GO

CREATE TABLE tblTax
(
	TaxID INT IDENTITY(1,1) PRIMARY KEY,
	TaxRate DECIMAL(5,2)
)
GO

CREATE TABLE tblOrder
(
	OrderID INT IDENTITY(1,1) PRIMARY KEY,
	OrderNumber NVARCHAR(20),
	OrderDate DATETIME,
	Merchandise DECIMAL(5,2),
	Shipping DECIMAL(5,2),
	Total DECIMAL(10,2),
	OrderStatus NVARCHAR(10)
)
GO

CREATE TABLE tblShippingMethod
(
	ShippingMethodID INT IDENTITY(1,1) PRIMARY KEY,
	ShippingMethod NVARCHAR(20)
)
GO

CREATE TABLE tblList
(
	ListID INT IDENTITY(1,1) PRIMARY KEY,
	Quantity INT,
	ExtendedPrice DECIMAL(10,2)
)
GO

CREATE TABLE tblItem
(
	ItemID INT IDENTITY(1,1) PRIMARY KEY,
	ItemDescription NVARCHAR(50),
	Size VARCHAR(5),
	Price DECIMAL(10,2),
	Color NVARCHAR(50)
)
GO