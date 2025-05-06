INSERT INTO Customer (Email, LastName, FirstName)
VALUES
	("manguy@email.com", "Man", "Guy"),
	("someone@email.com", "One", "Some"),
	("nextperson@email.com", "Person", "Next");

INSERT INTO Product (ProductName, Category, Price, Cost, QuantityInStock, InStock, Image)
VALUES
	("BlueFlower", "Flower", 3.25, 2, 0, 0, "blueFlower.png"),
	("RedFlower", "Flower", 5.50, 2, 2, 1, "redFlower.png"),
	("GreenFlower", "Flower", 4.66, 2, 5, 1, "greenFlower.png");

INSERT INTO Cart (CartStatus)
VALUES
	(0);

INSERT INTO CartItems (CartID, Quantity, ProductID)
VALUES
	(1, 2, 2),
	(1, 5, 3);

