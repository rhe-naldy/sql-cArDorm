# sql-cArDorm

cArDorm is a group project for Database Systems course in the third semester, being a database made for a car shop. The project required us to create:
1. Entity Relationship Diagram
2. Query to create the database system
3. Query to insert data into tables
4. Query to simulate the transaction processes
5. Query to answer the 10 cases given through the instructions








# 5. Query to answer the 10 cases given through the instructions
The file containing answer to the 10 cases given can be found within the file *PUTLINKHERE*.

Below are the 10 cases given through the instructions:
1.	Display CustomerName (obtained from the CustomerName starts with ‘Mrs. ’), CustomerGender (obtained from the CustomerGender with uppercase format), and Total Transaction (obtained from the count of transaction that have been done by customer) for each customer name contains two words and customer gender is ‘Female’

2.	Display CarId, CarName, CarBrandName, CarPrice, and Total of Car That Has Been Sold (obtained from the sum of quantity from the transaction that has been done by customer and ends with ‘ Car(s)’) for each CarPrice more than 300000000, three last characters from CarId is odd, and Total of Car That Has Been Sold more than 1.

3.	Display StaffId (obtained from the StaffId by replacing ‘ST’ with ‘Staff ’), StaffName, Total Transaction Handled (obtained from the count of transaction that has been handled by staff), and Maximum Quantity in One Transaction (obtained from the max of car quantity in one transaction that has been handled by staff) for every transaction made in ‘April’, Staff Name consists of two words, Total Transaction Handled more than 1 and descending sort by Maximum Purchases in One Transaction.

4.	Display CustomerName, CustomerGender (obtained from the first character of CustomerGender), Total Purchase (obtained from the count of transaction that has been done by customer), and Total of Car That Has Been Purchased (obtained from the sum of car quantity in transaction that has been done by customer) for every customer email ends with ‘@gmail.com’ and Total of Car That Has Been Purchased more than 2.

5.	Display VendorName (obtained from the VendorName by replacing ‘PT’ with ‘Perseroan Trebatas’), VendorPhoneNumber, Purchase ID Number (obtained from the three last characters from PurchaseId), and Quantity for every Quantity more than average of the Quantity in transaction that has been handled by vendor and VendorName contains ‘a’.
(alias subquery)

6.	Display Name (obtained from the CarBrandName and CarName in uppercase format with space between them), Price (obtained from the CarPrice starts with ‘Rp. ’), and Stock (obtained from the CarStock starts with ‘ Stock(s)’) for every CarPrice more than average of the CarPrice and CarName contains ‘e’.
(alias subquery)

7.	Display Car ID Number (obtained from the three last characters from CarId), CarName, Brand (obtained from the CarBranName in uppercase format), Price (obtained from the CarPrice starts with ‘Rp. ’), and Total of Car That Has Been Sold (obtained from the sum of car quantity purchased for each car brand name and car name) for every CarPrice more than 200000000 , CarName contains ‘o’, and Total of Car That Has Been Sold more than average of the sum of car quantity purchased for each car brand name and car name.
(alias subquery)

8.	Display Staff First Name (obtained from the first word in StaffName), Staff Last Name (obtained from the last word of Staff Name), and Total of Car That Has Been Sold (obtained from the sum of car quantity sold for each transaction) for every StaffName contains two words and Total of Car That Has Been Sold more than average of the sum of car quantity sold for all transaction.
(alias subquery)

9.	Create a view named ‘Vendor_Transaction_Handled_and_Minimum_View’ to display Vendor ID (obtained from the VendorId by replacing ‘VE’ with ‘Vendor ’), VendorName, Total Transaction Handled (obtained from the count of purchase that has been handled by vendor), and Minimum Purchases in One Transaction (obtained from the minimum of quantity in one purchase that has been handled by vendor) for every PurchaseDate made in ‘May’ and VendorName contains ‘a’.

10.	Create a view named ‘Staff_Total_Purchase_and_Max_Car_Purchase_View’ to display StaffID, StaffName, StaffEmail (obtained from the StaffEmail in uppercase format), Total Purchase (obtained from the count of purchase that has been done by staff), and Maximum of Car That Has Been Purchased in One Purchase (obtained from the max of car quantity in purchase that has been done by staff), for every StaffEmail ends with ‘@yahoo.com’ and StaffGender is ‘Female’.
