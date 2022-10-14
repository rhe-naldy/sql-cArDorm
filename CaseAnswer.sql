USE cArDorm
GO

-- No 1

SELECT CONCAT('Mrs. ', CustomerName) [CustomerName], UPPER(CustomerGender) [CustomerGender], COUNT(TransactionID) [Total Transaction]

FROM MsCustomer mc JOIN TransactionHeader th
	ON mc.CustomerID = th.CustomerID

WHERE CustomerName LIKE '% %' AND CustomerGender = 'Female'

GROUP BY CustomerName, CustomerGender

-- No 2

SELECT mca.CarID [CarId], CarName, BrandName [CarBrandName], Price [CarPrice], CONCAT(SUM(Quantity), ' Car(s)') [Total of Car That Has Been Sold]

FROM TransactionDetail td JOIN MsCar mca
	ON mca.CarID = td.CarID JOIN MsBrand mb
	ON mca.BrandID = mb.BrandID

WHERE Price > 300000000 AND CAST(RIGHT(mca.CarID, 3) AS INT) % 2 = 1

GROUP BY mca.CarID, CarName, BrandName, Price

HAVING SUM(Quantity) > 1

-- No 3

SELECT REPLACE(ms.StaffID, 'ST', 'Staff ') [StaffId], StaffName, COUNT(th.TransactionID) [Total Transaction Handled], MAX(Quantity) [Maximum Quantity in One Transaction]

FROM TransactionDetail td JOIN TransactionHeader th
	ON td.TransactionID = th.TransactionID JOIN MsStaff ms
	ON th.StaffID = ms.StaffID

WHERE MONTH(TransactionDate) = 4 AND StaffName LIKE '%_%'

GROUP BY ms.StaffID, StaffName

HAVING COUNT(th.TransactionID) > 1

ORDER BY [Maximum Quantity in One Transaction] DESC

-- No 4

SELECT CustomerName, LEFT(CustomerGender, 1) [CustomerGender], COUNT(DISTINCT th.TransactionID) [Total Purchase], SUM(Quantity) [Total of Car That Has Been Purchased]

FROM MsCustomer mc JOIN TransactionHeader th
	ON mc.CustomerID = th.CustomerID JOIN TransactionDetail td
	ON th.TransactionID = td.TransactionID

WHERE CustomerEmail LIKE '%_@gmail.com'

GROUP BY CustomerName, CustomerGender

HAVING SUM(Quantity) > 2

-- No 5

SELECT REPLACE(VendorName, 'PT', 'Perseroan Terbatas') [VendorName], VendorPhoneNumber, RIGHT(ph.PurchaseID, 3) [Purchase ID Number], Quantity

FROM MsVendor mv JOIN PurchaseHeader ph
	ON mv.VendorID = ph.VendorID JOIN PurchaseDetail pd
	ON ph.PurchaseID = pd.PurchaseID,
	(
		SELECT AVG(x.Quantity) AS avgQuantity

		FROM
		(
			SELECT REPLACE(VendorName, 'PT', 'Perseroan Terbatas') [VendorName], VendorPhoneNumber, RIGHT(ph.PurchaseID, 3) [Purchase ID Number], Quantity

			FROM MsVendor mv JOIN PurchaseHeader ph
				ON mv.VendorID = ph.VendorID JOIN PurchaseDetail pd
				ON ph.PurchaseID = pd.PurchaseID
		) x
	) y
WHERE VendorName LIKE '%a%'

GROUP BY VendorName, VendorPhoneNumber, ph.PurchaseID, Quantity, y.avgQuantity

HAVING Quantity > y.avgQuantity

-- No 6

SELECT CONCAT(UPPER(BrandName), ' ', UPPER(CarName)) [Name], CONCAT('Rp. ', Price) [Price], CONCAT(Stock, ' Stock(s)') [Stock]

FROM MsBrand mb JOIN MsCar mc
	ON mb.BrandID = mc.BrandID,
	(
		SELECT AVG(x.Price) AS avgCarPrice

		FROM
		(
			SELECT CONCAT(UPPER(BrandName), ' ', UPPER(CarName)) [Name], Price, CONCAT(Stock, ' Stock(s)') [Stock]

			FROM MsBrand mb JOIN MsCar mc
				ON mb.BrandID = mc.BrandID
		
		) x
	) y

WHERE CarName LIKE '%e%'

GROUP BY BrandName, CarName, Price, Stock, y.avgCarPrice

HAVING Price > y.avgCarPrice

-- No 7

SELECT RIGHT(mc.CarID, 3) [CarIDNumber], CarName, UPPER(BrandName) [Brand], CONCAT('Rp. ', Price) [Price], SUM(Quantity) [Total of Car That Has Been Sold]

FROM MsBrand mb JOIN MsCar mc
	ON mb.BrandID = mc.BrandID JOIN TransactionDetail td
	ON mc.CarID = td.CarID,
	(
		SELECT AVG(x.[Total of Car That Has Been Sold]) AS avgQuantity

		FROM
		(
			SELECT RIGHT(mc.CarID, 3) [CarIDNumber], CarName, UPPER(BrandName) [Brand], CONCAT('Rp. ', Price) [Price], SUM(Quantity) [Total of Car That Has Been Sold]

			FROM MsBrand mb JOIN MsCar mc
				ON mb.BrandID = mc.BrandID JOIN TransactionDetail td
				ON mc.CarID = td.CarID

			GROUP BY mc.CarID, CarName, BrandName, Price
		) x
	) y

GROUP BY mc.CarID, CarName, BrandName, Price, y.avgQuantity

HAVING SUM(Quantity) > y.avgQuantity

-- No 8

SELECT SUBSTRING(StaffName, 1, CHARINDEX(' ', StaffName + ' ')-1) [Staff First Name], 
	SUBSTRING(StaffName, CHARINDEX(' ', StaffName + ' ')+1, LEN(StaffName)) [Staff Last Name], SUM(Quantity) AS [Total of Car That Has Been Sold]

FROM TransactionDetail td JOIN TransactionHeader th
	ON td.TransactionID = th.TransactionID JOIN MsStaff ms
	ON ms.StaffID = th.StaffID,
	(
		SELECT AVG(x.[Total of Car That Has Been Sold]) AS avgQuantity

		FROM
		(
			SELECT TransactionID, SUM(Quantity) AS [Total of Car That Has Been Sold]

			FROM TransactionDetail

			GROUP BY TransactionID
		) x
	) y

WHERE StaffName LIKE '% %'

GROUP BY StaffName, y.avgQuantity

HAVING SUM(Quantity) > y.avgQuantity

-- No 9

CREATE VIEW Vendor_Transaction_Handled_and_Minimum_View AS

SELECT REPLACE(mv.VendorID, 'VE', 'Vendor ') [Vendor ID], VendorName, COUNT(ph.PurchaseID) [Total Transaction Handled], MIN(Quantity) [Minimum Purchases in One Transaction]

FROM MsVendor mv JOIN PurchaseHeader ph
	ON mv.VendorID = ph.VendorID JOIN PurchaseDetail pd
	ON ph.PurchaseID = pd.PurchaseID

WHERE MONTH(PurchaseDate) = 5
	AND VendorName LIKE '%a%'

GROUP BY mv.VendorID, VendorName

SELECT * FROM Vendor_Transaction_Handled_and_Minimum_View

-- No 10

CREATE VIEW Staff_Total_Purchase_and_Max_Car_Purchase_View AS

SELECT ms.StaffID, StaffName, UPPER(StaffEmail) [StaffEmail], COUNT(DISTINCT ph.PurchaseID) [Total Purchase], MAX(x.QuantityPerPurchase) [Maximum of Car That Has Been Purchased in One Purchase]

FROM MsStaff ms JOIN PurchaseHeader ph
	ON ms.StaffID = ph.StaffID JOIN PurchaseDetail pd
	ON ph.PurchaseID = pd.PurchaseID,
	(
		SELECT pd.PurchaseID, SUM(Quantity) AS QuantityPerPurchase
		FROM PurchaseDetail pd JOIN PurchaseHeader ph
			ON pd.PurchaseID = ph.PurchaseID JOIN MsStaff ms
			ON ms.StaffID = ph.StaffID
		WHERE StaffEmail LIKE '%@yahoo.com' AND StaffGender = 'Female'

		GROUP BY ms.StaffID, StaffName, StaffEmail, pd.PurchaseID
	) x

WHERE StaffEmail LIKE '%@yahoo.com'
	AND StaffGender = 'Female'

GROUP BY ms.StaffID, StaffName, StaffEmail

SELECT * FROM Staff_Total_Purchase_and_Max_Car_Purchase_View