DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Cart;
DROP TABLE IF EXISTS CartItems;
DROP TABLE IF EXISTS CustomBouquetOptions;
DROP TABLE IF EXISTS CustomBouquet;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Customer;

CREATE TABLE Customer (
    Email TEXT,
    LastName TEXT NOT NULL,
    FirstName TEXT NOT NULL,
    CONSTRAINT CustomerPK PRIMARY KEY (Email), 
	CONSTRAINT LastNameLength CHECK (LENGTH(LastName) <= 35), 
	CONSTRAINT FirstNameLength CHECK (LENGTH(FirstName) <= 35),
    CONSTRAINT emailLengthPreAT CHECK (
        LENGTH(SUBSTR(Email, 1, INSTR(Email, '@') - 1)) <= 64),
    CONSTRAINT emailLengthPostAT CHECK (
        LENGTH(SUBSTR(Email, 1, INSTR(Email, '@') + 1)) <= 255));

CREATE TABLE Product (
	ProductID INTEGER PRIMARY KEY AUTOINCREMENT,
	ProductName TEXT NOT NULL,
	Category TEXT NOT NULL,
	Price REAL NOT NULL,
	Cost REAL NOT NULL,
	QuantityInStock INTEGER NOT NULL, 
	InStock Boolean NOT NULL,
	Image TEXT,
	CONSTRAINT ProductNameLength CHECK (Length(ProductName) <= 35),
	CONSTRAINT CategoryOptionsProduct CHECK (Category IN ('Bouquet', 'Flower', 'Filler', 'Foliage', 'Vase', 'Ribbon', 'Cards')),
	CONSTRAINT PriceAmount CHECK (Price >= 0),
	CONSTRAINT CostAmount CHECK (Cost >= 0),
	CONSTRAINT QuantityInStockAmount CHECK (QuantityInStock >= 0),
    CONSTRAINT InStockQuantityCheck CHECK (
        (QuantityInStock > 0 AND InStock = 1) OR (QuantityInStock = 0 AND InStock = 0)));

CREATE TABLE CustomBouquetOptions (
	CustomBouquetID INTEGER,
	ProductID INTEGER NOT NULL, 
	Category TEXT NOT NULL,
	CONSTRAINT customBouquetpk PRIMARY KEY (CustomBouquetID), 
	FOREIGN KEY (CustomBouquetID) REFERENCES CustomBouquet (CustomBouquetID),
	FOREIGN KEY (ProductID) REFERENCES Product (ProductID),
	CONSTRAINT CategoryOptionsBouquet CHECK (Category IN ('Flower1', 'Flower2', 'Filler', 'Foliage', 'Vase', 'Ribbon')));

CREATE TABLE CustomBouquet (
	CustomBouquetID INTEGER PRIMARY KEY AUTOINCREMENT,
	Price REAL NOT NULL,
	Quantity INTEGER NOT NULL,
	CONSTRAINT PriceAmount CHECK (Price >= 0),
	CONSTRAINT QuantityAmount CHECK (Quantity >= 0));

CREATE TABLE Cart (
	CartID INTEGER PRIMARY KEY AUTOINCREMENT,
	Current TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CartStatus BOOLEAN DEFAULT 0, -- 0 for not yet purchased, 1 for purchased
	CONSTRAINT CartStatusOptions CHECK (CartStatus IN(0,1)));

CREATE TABLE CartItems (
	CartID INTEGER,
	Quantity INTEGER NOT NULL, 
	ProductID INTEGER, --trigger to add the correct productID for customBouquet (constant) when CustomBouquet != Null
	CustomBouquetID INTEGER,
	CONSTRAINT CartItemsPK PRIMARY KEY (CartID, ProductID),
	FOREIGN KEY (CartID) REFERENCES Cart (CartID),
	FOREIGN KEY (ProductID) REFERENCES Product (ProductID),
	FOREIGN KEY (CustomBouquetID) REFERENCES CustomBouquet (CustomBouquetID),
	CONSTRAINT pkNotNull CHECK (ProductID IS NOT NULL OR CustomBouquetID IS NOT NULL),
	CONSTRAINT QuantityAmount CHECK (Quantity >= 0));

CREATE TABLE OrderDetails (
	OrderNumber INTEGER PRIMARY KEY AUTOINCREMENT,
	Total REAL NOT NULL,
	OrderStatus TEXT NOT NULL,
	Email TEXT NOT NULL,
	CartID INTEGER NOT NULL,
    FOREIGN KEY (Email) REFERENCES Customer (Email),
	FOREIGN KEY (CartID) REFERENCES Cart (CartID),
	CONSTRAINT PriceAmount CHECK (Total >= 0 ),
	CONSTRAINT OrderStatusOptions CHECK (OrderStatus IN ('Preparing', 'ReadyForPickUp', 'Completed')));
    