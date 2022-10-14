USE cArDorm
GO

CREATE FUNCTION getExistingVendorID (@VendorName VARCHAR(50), @VendorEmail VARCHAR(50), @VendorPhoneNumber VARCHAR(15))
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @vendor_id VARCHAR(50)
	SELECT @vendor_id = VendorID
	FROM MsVendor
	WHERE VendorName = @VendorName AND VendorEmail = @VendorEmail AND VendorPhoneNumber = @VendorPhoneNumber
	RETURN @vendor_id
END

GO

CREATE FUNCTION getExistingCustomerID (@CustomerName VARCHAR(50), @CustomerGender VARCHAR(10), @CustomerEmail VARCHAR(50), @CustomerPhoneNumber VARCHAR(15))
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @customer_id VARCHAR(5)
	SELECT @customer_id = CustomerID
	FROM MsCustomer
	WHERE CustomerName = @CustomerName AND CustomerEmail = @CustomerEmail AND CustomerPhoneNumber = @CustomerPhoneNumber AND CustomerGender = @CustomerGender
	RETURN @customer_id
END

GO

CREATE FUNCTION countPurchase ()
RETURNS INT
AS
BEGIN
	DECLARE @id INT
	SELECT @id = COUNT(PurchaseID) + 1
	FROM PurchaseHeader
	RETURN @id
END

GO

CREATE FUNCTION getPurchaseID ()
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @number INT
	EXEC @number = countPurchase
	IF @number BETWEEN 0 AND 9
	BEGIN
		RETURN CONCAT('PU00', CAST(@number AS VARCHAR))
	END
	IF @number BETWEEN 10 AND 99
	BEGIN
		RETURN CONCAT('PU0', CAST(@number AS VARCHAR))
	END
	IF @number BETWEEN 100 AND 999
	BEGIN
		RETURN CONCAT('PU', CAST(@number AS VARCHAR))
	END
	RETURN -1
END

GO

CREATE FUNCTION countTransaction ()
RETURNS INT
AS
BEGIN
	DECLARE @id INT
	SELECT @id = COUNT(TransactionID) + 1
	FROM TransactionHeader
	RETURN @id
END

GO

CREATE FUNCTION getTransactionID ()
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @number INT
	EXEC @number = countTransaction
	IF @number BETWEEN 0 AND 9
	BEGIN
		RETURN CONCAT('TR00', CAST(@number AS VARCHAR))
	END
	IF @number BETWEEN 10 AND 99
	BEGIN
		RETURN CONCAT('TR0', CAST(@number AS VARCHAR))
	END
	IF @number BETWEEN 100 AND 999
	BEGIN
		RETURN CONCAT('TR', CAST(@number AS VARCHAR))
	END
	RETURN -1
END

GO

CREATE FUNCTION getExistingCarID (@BrandName VARCHAR(50), @CarName VARCHAR(50))
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @id CHAR(5)
	SELECT @id = CarID
	FROM MsCar mc JOIN MsBrand mb
	ON mc.BrandID = mb.BrandID
	WHERE BrandName = @BrandName AND CarName = @CarName
	RETURN @id
END

GO

CREATE FUNCTION countCar ()
RETURNS INT
AS
BEGIN
	DECLARE @id INT
	SELECT @id = COUNT(CarID) + 1
	FROM MsCar
	RETURN @id
END

GO

CREATE FUNCTION getCarID ()
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @number INT
	EXEC @number = countCar
	IF @number BETWEEN 0 AND 9
	BEGIN
		RETURN CONCAT('CA00', CAST(@number AS VARCHAR))
	END
	IF @number BETWEEN 10 AND 99
	BEGIN
		RETURN CONCAT('CA0', CAST(@number AS VARCHAR))
	END
	IF @number BETWEEN 100 AND 999
	BEGIN
		RETURN CONCAT('CA', CAST(@number AS VARCHAR))
	END
	RETURN -1
END

GO

CREATE FUNCTION getExistingBrandID (@BrandName VARCHAR(50))
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @id CHAR(5)
	SELECT @id = BrandID
	FROM MsBrand
	WHERE BrandName = @BrandName
	RETURN @id
END

GO

CREATE FUNCTION countBrand ()
RETURNS INT
AS
BEGIN
	DECLARE @id INT
	SELECT @id = COUNT(BrandID) + 1
	FROM MsBrand
	RETURN @id
END

GO

CREATE FUNCTION getBrandID ()
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @number INT
	EXEC @number = countBrand
	IF @number BETWEEN 0 AND 9
	BEGIN
		RETURN CONCAT('CB00', CAST(@number AS VARCHAR))
	END
	IF @number BETWEEN 10 AND 99
	BEGIN
		RETURN CONCAT('CB0', CAST(@number AS VARCHAR))
	END
	IF @number BETWEEN 100 AND 999
	BEGIN
		RETURN CONCAT('CB', CAST(@number AS VARCHAR))
	END
	RETURN -1
END

GO

CREATE FUNCTION countVendor ()
RETURNS INT
AS
BEGIN
	DECLARE @id INT
	SELECT @id = COUNT(VendorID) + 1
	FROM MsVendor
	RETURN @id
END

GO

CREATE FUNCTION getVendorID ()
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @number INT
	EXEC @number = countVendor
	IF @number BETWEEN 0 AND 9
	BEGIN
		RETURN CONCAT('VE00', CAST(@number AS VARCHAR))
	END
	IF @number BETWEEN 10 AND 99
	BEGIN
		RETURN CONCAT('VE0', CAST(@number AS VARCHAR))
	END
	IF @number BETWEEN 100 AND 999
	BEGIN
		RETURN CONCAT('VE', CAST(@number AS VARCHAR))
	END
	RETURN -1
END

GO

CREATE FUNCTION countCustomer ()
RETURNS INT
AS
BEGIN
	DECLARE @id INT
	SELECT @id = COUNT(CustomerID) + 1
	FROM MsCustomer
	RETURN @id
END

GO

CREATE FUNCTION getCustomerID ()
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @number INT
	EXEC @number = countCustomer
	IF @number BETWEEN 0 AND 9
	BEGIN
		RETURN CONCAT('CU00', CAST(@number AS VARCHAR))
	END
	IF @number BETWEEN 10 AND 99
	BEGIN
		RETURN CONCAT('CU0', CAST(@number AS VARCHAR))
	END
	IF @number BETWEEN 100 AND 999
	BEGIN
		RETURN CONCAT('CU', CAST(@number AS VARCHAR))
	END
	RETURN -1
END

GO

CREATE PROCEDURE purchase_query (@VendorName VARCHAR(50), @VendorEmail VARCHAR(50),
@VendorPhoneNumber VARCHAR(15), @VendorAddress VARCHAR(100), @StaffID CHAR(5), @BrandName VARCHAR(50), @CarName VARCHAR(50), @Stock INT, @Price BIGINT)
AS
BEGIN
	DECLARE @VendorID CHAR(5)
	DECLARE @PurchaseID CHAR(5)
	DECLARE @CarID CHAR(5)
	DECLARE @BrandID CHAR(5)
	EXEC @PurchaseID = getPurchaseID

	IF EXISTS(SELECT * FROM MsVendor WHERE VendorName = @VendorName AND VendorPhoneNumber = @VendorPhoneNumber AND VendorEmail = @VendorEmail) --vendor exists
	BEGIN
		EXEC @VendorID = getExistingVendorID @VendorName, @VendorEmail, @VendorPhoneNumber
		IF EXISTS(SELECT * FROM MsBrand mb JOIN MsCar mc ON mb.BrandID = mc.BrandID WHERE BrandName = @BrandName AND CarName = @CarName AND Price = @Price) --brand and car exists
		BEGIN
			EXEC @CarID = getExistingCarID @BrandName, @CarName
			UPDATE MsCar
			SET Stock = Stock + @Stock WHERE CarID = @CarID

			INSERT INTO PurchaseHeader VALUES (@PurchaseID, @StaffID, @VendorID, CONVERT(VARCHAR, GETDATE(), 23))
			INSERT INTO PurchaseDetail VALUES (@PurchaseID, @CarID, @Stock)
			RETURN
		END
		IF EXISTS(SELECT * FROM MsBrand WHERE BrandName = @BrandName) --car does not exist
		BEGIN
			EXEC @CarID = getCarID
			EXEC @BrandID = getExistingBrandID @BrandName
			INSERT INTO MsCar VALUES (@CarID, @BrandID, @CarName, @Price, @Stock)
			INSERT INTO PurchaseHeader VALUES (@PurchaseID, @StaffID, @VendorID, CONVERT(VARCHAR, GETDATE(), 23))
			INSERT INTO PurchaseDetail VALUES (@PurchaseID, @CarID, @Stock)
			RETURN
		END
		EXEC @BrandID = getBrandID
		EXEC @CarID = getCarID
		INSERT INTO MsBrand VALUES (@BrandID, @BrandName)
		INSERT INTO MsCar VALUES (@CarID, @BrandID, @CarName, @Price, @Stock)
		INSERT INTO PurchaseHeader VALUES (@PurchaseID, @StaffID, @VendorID, CONVERT(VARCHAR, GETDATE(), 23))
		INSERT INTO PurchaseDetail VALUES (@PurchaseID, @CarID, @Stock)
		RETURN
	END
	ELSE
	BEGIN
		EXEC @VendorID = getVendorID --vendorID ga eksis
		INSERT INTO MsVendor VALUES (@VendorID, @VendorName, @VendorEmail, @VendorPhoneNumber, @VendorAddress)
		IF EXISTS(SELECT * FROM MsBrand mb JOIN MsCar mc ON mb.BrandID = mc.BrandID WHERE BrandName = @BrandName AND CarName = @CarName AND Price = @Price) --brand and car exists
		BEGIN
			EXEC @CarID = getExistingCarID @BrandName, @CarName
			UPDATE MsCar
			SET Stock = Stock + @Stock WHERE CarID = @CarID

			INSERT INTO PurchaseHeader VALUES (@PurchaseID, @StaffID, @VendorID, CONVERT(VARCHAR, GETDATE(), 23))
			INSERT INTO PurchaseDetail VALUES (@PurchaseID, @CarID, @Stock)
			RETURN
		END
		IF EXISTS(SELECT * FROM MsBrand WHERE BrandName = @BrandName) --car does not exist
		BEGIN
			EXEC @CarID = getCarID
			EXEC @BrandID = getExistingBrandID @BrandName
			INSERT INTO MsCar VALUES (@CarID, @BrandID, @CarName, @Price, @Stock)
			INSERT INTO PurchaseHeader VALUES (@PurchaseID, @StaffID, @VendorID, CONVERT(VARCHAR, GETDATE(), 23))
			INSERT INTO PurchaseDetail VALUES (@PurchaseID, @CarID, @Stock)
			RETURN
		END -- brand and car does not exist
		EXEC @BrandID = getBrandID
		EXEC @CarID = getCarID
		INSERT INTO MsBrand VALUES (@BrandID, @BrandName)
		INSERT INTO MsCar VALUES (@CarID, @BrandID, @CarName, @Price, @Stock)
		INSERT INTO PurchaseHeader VALUES (@PurchaseID, @StaffID, @VendorID, CONVERT(VARCHAR, GETDATE(), 23))
		INSERT INTO PurchaseDetail VALUES (@PurchaseID, @CarID, @Stock)
		RETURN
	END
END

GO

CREATE PROCEDURE transaction_query (@CustomerName VARCHAR(50), @CustomerGender VARCHAR(10), @CustomerEmail VARCHAR(50),
@CustomerPhoneNumber VARCHAR(15), @CustomerAddress VARCHAR(100), @StaffID CHAR(5), @BrandName VARCHAR(50), @CarName VARCHAR(50), @Quantity INT)
AS
BEGIN
	DECLARE @CustomerID CHAR(5)
	DECLARE @TransactionID CHAR(5)
	DECLARE @CarID CHAR(5)
	DECLARE @BrandID CHAR(5)
	EXEC @TransactionID = getTransactionID
	EXEC @CarID = getExistingCarID @BrandName, @CarName

	IF EXISTS(SELECT * FROM MsCustomer WHERE CustomerName = @CustomerName AND CustomerGender = @CustomerGender AND CustomerEmail = @CustomerEmail AND CustomerPhoneNumber = @CustomerPhoneNumber) -- customer exists
	BEGIN
		EXEC @CustomerID = getExistingCustomerID @CustomerName, @CustomerGender, @CustomerEmail, @CustomerPhoneNumber
		
		UPDATE MsCar
		SET Stock = Stock - @Quantity WHERE CarID = @CarID

		INSERT INTO TransactionHeader VALUES (@TransactionID, @StaffID, @CustomerID, CONVERT(VARCHAR, GETDATE(), 23))
		INSERT INTO TransactionDetail VALUES (@TransactionID, @CarID, @Quantity)
		RETURN
	END
	ELSE
	BEGIN
		EXEC @CustomerID = getCustomerID -- customer does not exist
		INSERT INTO MsCustomer VALUES (@CustomerID, @CustomerName, @CustomerGender, @CustomerAddress, @CustomerPhoneNumber, @CustomerEmail)

		UPDATE MsCar
		SET Stock = Stock - @Quantity WHERE CarID = @CarID

		INSERT INTO TransactionHeader VALUES (@TransactionID, @StaffID, @CustomerID, CONVERT(VARCHAR, GETDATE(), 23))
		INSERT INTO TransactionDetail VALUES (@TransactionID, @CarID, @Quantity)
		RETURN
	END
END

GO

-- Purchase simulation
EXEC purchase_query 'PT Sinar Matahari', 'sinarmatahari@gmail.com', '+62234567890', 'jln. palmerah utama no. 93', 'ST001', 'Tayato', 'Outlander', 10, '630000000'
EXEC purchase_query 'PT Asri Mobil', 'ASRIMOBIL@yahoo.com', '+6261671031', 'Jl. R.C. Veteran No.24 Bintaro, Jakarta Selatan, 12330', 'ST003', 'Sabura', 'WRX', 23, '490000000'

-- Transaction simulation
EXEC transaction_query 'Alice', 'Female', 'alice99@gmail.com', '+6244441231', 'jln. tigaraksa no. 23', 'ST007', 'Mutsibushu', 'Camaro', 1
EXEC transaction_query 'Wendy Morgana', 'Female', 'wendy.morgana@gmail.com', '0861 0060 1943', 'Kpg. Otista No. 671', 'ST009', 'Luxes', 'CRV', 1