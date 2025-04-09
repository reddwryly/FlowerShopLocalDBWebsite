DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Cart;
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

CREATE TABLE CustomBouquet (
	CustomBouquetID INTEGER PRIMARY KEY AUTOINCREMENT,
	[Size] TEXT NOT NULL,
	Price REAL NOT NULL,
	Quantity INTEGER NOT NULL,
	CONSTRAINT SizeOptions CHECK ([Size] IN ('Small', 'Medium', 'Large')),
	CONSTRAINT PriceAmount CHECK (Price >= 0),
	CONSTRAINT QuantityAmount CHECK (Quantity >=0));

CREATE TABLE CustomBouquetOptions (
	CustomBouquetID INTEGER,
	ProductID INTEGER NOT NULL, 
	Category TEXT NOT NULL,
	Price REAL NOT NULL, 
	CONSTRAINT CustomBouquetOptionsPK PRIMARY KEY (CustomBouquetID), --conposite primary key with prduct id
	FOREIGN KEY (CustomBouquetID) REFERENCES CustomBouquet (CustomBouquetID),
	FOREIGN KEY (ProductID) REFERENCES Product (ProductID),
	CONSTRAINT CategoryOptionsBouquet CHECK (Category IN ('Flower1', 'Flower2', 'Filler', 'Foliage', 'Vase', 'Ribbon')),
	CONSTRAINT PriceAmount CHECK (Price >= 0));
	
CREATE TABLE Cart (
	CartID INTEGER PRIMARY KEY AUTOINCREMENT,
	Quantity INTEGER NOT NULL, 
	Price REAL NOT NULL,
	CartStatus BOOLEAN NOT NULL, -- 0 for not yet purchased, 1 for purchased
	ProductID INTEGER NOT NULL, 
	CustomBouquetID INTEGER NOT NULL,
	FOREIGN KEY (ProductID) REFERENCES Product (ProductID),
	FOREIGN KEY (CustomBouquetID) REFERENCES CustomBouquet (CustomBouquetID),
	CONSTRAINT QuantityAmount CHECK (Quantity >= 0),
	CONSTRAINT PriceAmount CHECK (Price >= 0 ),
	CONSTRAINT CartStatusOptions CHECK (CartStatus IN('Current','Past')));

CREATE TABLE OrderDetails (
	OrderNumber INTEGER PRIMARY KEY AUTOINCREMENT,
	Quantity INTEGER NOT NULL,
	Price REAL NOT NULL,
	OrderStatus TEXT NOT NULL,
	PickUpCode TEXT UNIQUE, --create trigger to make the random 6 character code
	Email TEXT NOT NULL,
	ProductID INTEGER NOT NULL,
	CartID INTEGER NOT NULL,
    FOREIGN KEY (Email) REFERENCES Customer (Email),
	FOREIGN KEY (ProductID) REFERENCES Product (ProductID),
	FOREIGN KEY (CartID) REFERENCES Cart (CartID),
	CONSTRAINT QuantityAmount CHECK (Quantity >= 0),
	CONSTRAINT PriceAmount CHECK (Price >= 0 ),
	CONSTRAINT OrderStatusOptions CHECK (OrderStatus IN ('Preparing', 'ReadyForPickUp', 'Completed')));
    