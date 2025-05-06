CREATE TRIGGER CartItemsPKNotNULL AFTER INSERT ON CartItems
FOR EACH ROW
WHEN NEW.CustomBouquetID IS NOT NULL
BEGIN
    UPDATE CartItems
    SET ProductID = 12345 --constant value of ProductID for the product 'CustomBouquet'
    WHERE CustomBouquetID = NEW.CustomBouquetID --not the pk but the same CustomBouquetID wont be included in the same cart twice
		AND CartID = NEW.CartID;
END;