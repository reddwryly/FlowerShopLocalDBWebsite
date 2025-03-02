DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS [Order];

CREATE TABLE Customer (
    Email TEXT NOT NULL,
    LastName TEXT NOT NULL,
    FirstName TEXT NOT NULL,
    --maybe some kind of returning customer indicator 
    CONSTRAINT customerPK PRIMARY KEY (Email));

--    CONSTRAINT emailLengthPreAT CHECK (
--        LENGTH(SUBSTR(Email, 1, INSTR('@' IN Email ) - 1)) <= 64),
--    CONSTRAINT emailLengthPostAT CHECK (
--        LENGTH(SUBSTR(Email, 1, INSTR('@' IN Email ) + 1)) <= 255)); add to trigger sql lite does not support these methods in a check

CREATE TABLE [Order] (
	OrderNumber INT IDENTITY(1,1),
	PickUpCode TEXT UNIQUE,
	Email VARCHAR(320) NOT NULL,
	CONSTRAINT customerPK PRIMARY KEY (OrderNumber),
    FOREIGN KEY (Email) REFERENCES Customer (Email));
    
--	CONSTRAINT OrderCodeLength CHECK (LENGTH(PickUpCode) = 6)); --trigger will be needed to create random unique code and enforce length
	

--CREATE TABLE cart --stores the items currently in the cart I want the default to be empty and empties after check out
