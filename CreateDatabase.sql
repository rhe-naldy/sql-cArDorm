CREATE DATABASE cArDorm
GO

USE cArDorm
GO

--create table
CREATE TABLE [MsVendor](
	VendorID CHAR(5) PRIMARY KEY,
	VendorName VARCHAR(50) NOT NULL,
	VendorEmail VARCHAR(50) NOT NULL,
	VendorPhoneNumber VARCHAR(15) NOT NULL,
	VendorAddress VARCHAR(100) NOT NULL
)

CREATE TABLE [MsCustomer](
	CustomerID CHAR(5) PRIMARY KEY,
	CustomerName VARCHAR(50) NOT NULL,
	CustomerGender VARCHAR(10) NOT NULL,
	CustomerAddress VARCHAR(100) NOT NULL,
	CustomerPhoneNumber VARCHAR(15) NOT NULL,
	CustomerEmail VARCHAR(50) NOT NULL
)

CREATE TABLE [MsStaff](
	StaffID CHAR(5) PRIMARY KEY,
	StaffName VARCHAR(50) NOT NULL,
	StaffGender VARCHAR(10) NOT NULL,
	StaffEmail VARCHAR(50) NOT NULL,
	StaffPhoneNumber VARCHAR(15) NOT NULL,
	StaffAddress VARCHAR(100) NOT NULL,
	StaffSalary INT NOT NULL
)

CREATE TABLE [MsBrand](
	BrandID CHAR(5) PRIMARY KEY,
	BrandName VARCHAR(50) NOT NULL
)

CREATE TABLE [MsCar](
	CarID CHAR(5) PRIMARY KEY,
	BrandID CHAR(5) FOREIGN KEY REFERENCES MsBrand(BrandID),
	CarName VARCHAR(50) NOT NULL,
	Price BIGINT NOT NULL,
	Stock INT NOT NULL
)

CREATE TABLE [PurchaseHeader](
	PurchaseID CHAR(5) PRIMARY KEY,
	StaffID CHAR(5) FOREIGN KEY REFERENCES MsStaff(StaffID),
	VendorID CHAR(5) FOREIGN KEY REFERENCES MsVendor(VendorID),
	PurchaseDate DATE NOT NULL
)

CREATE TABLE [TransactionHeader](
	TransactionID CHAR(5) PRIMARY KEY,
	StaffID CHAR(5) FOREIGN KEY REFERENCES MsStaff(StaffID),
	CustomerID CHAR(5) FOREIGN KEY REFERENCES MsCustomer(CustomerID),
	TransactionDate DATE NOT NULL
)

CREATE TABLE [PurchaseDetail](
	PurchaseID CHAR(5) FOREIGN KEY REFERENCES PurchaseHeader(PurchaseID),
	CarID CHAR(5) FOREIGN KEY REFERENCES MsCar(CarID),
	Quantity INT NOT NULL,
	PRIMARY KEY(PurchaseID, CarID)
)

CREATE TABLE [TransactionDetail](
	TransactionID CHAR(5) FOREIGN KEY REFERENCES TransactionHeader(TransactionID),
	CarID CHAR(5) FOREIGN KEY REFERENCES MsCar(CarID),
	Quantity INT NOT NULL,
	PRIMARY KEY(TransactionID, CarID)
)
GO

-- add constraints for MsStaff
ALTER TABLE [MsStaff]
ADD CONSTRAINT check_staff_id CHECK(StaffID LIKE 'ST[0-9][0-9][0-9]')

ALTER TABLE [MsStaff]
ADD CONSTRAINT check_staff_gender CHECK(StaffGender LIKE 'Male' OR StaffGender LIKE 'Female')

ALTER TABLE [MsStaff]
ADD CONSTRAINT check_staff_email CHECK(StaffEmail LIKE '%_@gmail.com' OR StaffEmail LIKE '%_@yahoo.com')

ALTER TABLE [MsStaff]
ADD CONSTRAINT check_staff_salary CHECK(StaffSalary >= 5000000 AND StaffSalary <= 10000000)

-- add constraints for Vendor
ALTER TABLE [MsVendor]
ADD CONSTRAINT check_vendor_id CHECK(VendorID LIKE 'VE[0-9][0-9][0-9]')

ALTER TABLE [MsVendor]
ADD CONSTRAINT check_vendor_email CHECK(VendorEmail LIKE '%_@gmail.com' OR VendorEmail LIKE '%_@yahoo.com')

-- add constraints for PurchaseHeader
ALTER TABLE [PurchaseHeader]
ADD CONSTRAINT check_purc_date CHECK(DATEDIFF(DAY, PurchaseDate, GETDATE()) >= 0)

ALTER TABLE [PurchaseHeader]
ADD CONSTRAINT check_purc_id CHECK(PurchaseID LIKE 'PU[0-9][0-9][0-9]')

-- add constraints for Customer
ALTER TABLE [MsCustomer]
ADD CONSTRAINT check_cust_id CHECK(CustomerID LIKE 'CU[0-9][0-9][0-9]')

ALTER TABLE [MsCustomer]
ADD CONSTRAINT check_cust_name CHECK(CustomerName LIKE '__%')

ALTER TABLE [MsCustomer]
ADD CONSTRAINT check_cust_gender CHECK(CustomerGender LIKE 'Male' OR CustomerGender LIKE 'Female')

ALTER TABLE [MsCustomer]
ADD CONSTRAINT check_cust_email CHECK(CustomerEmail LIKE '%_@gmail.com' OR CustomerEmail LIKE '%_@yahoo.com')

-- add constraint for TransactionDate
ALTER TABLE [TransactionHeader]
ADD CONSTRAINT check_trans_date CHECK(DATEDIFF(DAY, TransactionDate, GETDATE()) >= 0)

ALTER TABLE [TransactionHeader]
ADD CONSTRAINT check_trans_id CHECK(TransactionID LIKE 'TR[0-9][0-9][0-9]')

-- add constraint for MsCar
ALTER TABLE [MsCar]
ADD CONSTRAINT check_car_id CHECK(CarID LIKE 'CA[0-9][0-9][0-9]')

ALTER TABLE [MsBrand]
ADD CONSTRAINT check_car_brand_id CHECK(BrandID LIKE 'CB[0-9][0-9][0-9]')