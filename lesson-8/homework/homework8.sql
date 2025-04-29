use homework_8

--##  Easy-Level Tasks 
--1. Using Products table, find the total number of products available in each category.

SELECT CATEGORY, COUNT(*) COUNT_PRODUCTS FROM PRODUCTS
GROUP BY CATEGORY

--2. Using Products table, get the average price of products in the 'Electronics' category.

SELECT  AVG(PRICE) AVG_PRICE FROM Products
where CATEGORY='Electronics'

--3. Using Customers table, list all customers from cities that start with 'L'.

SELECT * FROM Customers
WHERE CITY LIKE 'L%'

--4. Using Products table, get all product names that end with 'er'.

SELECT PRODUCTNAME FROM Products
WHERE PRODUCTNAME LIKE '%er'

--5. Using Customers table, list all customers from countries ending in 'A'.

SELECT * FROM Customers
WHERE COUNTRY LIKE '%a'

--6. Using Products table, show the highest price among all products.

SELECT MAX(PRICE) MAX_PRICE FROM Products

--7. Using Products table, use IIF to label stock as 'Low Stock' if quantity < 30, else 'Sufficient'.

SELECT 
	*,
	IIF(STOCKQUANTITY<30,'Low Stock','Sufficient') AS CATEGORYbySTOCKQUANTITY
FROM Products
 
--8. Using Customers table, find the total number of customers in each country.

SELECT COUNTRY, COUNT(*) TOTAL_CUSTOMERS FROM Customers
GROUP BY COUNTRY

--9. Using Orders table, find the minimum and maximum quantity ordered.

SELECT MAX(QUANTITY) MAX_QUANTITY, MIN(QUANTITY) MIN_QUANTITY FROM Orders

--##  Medium-Level Tasks 
--10. Using Orders and Invoices tables, list customer IDs who placed orders in 2023 (using EXCEPT) to find those who did not have invoices.

SELECT CustomerID FROM Orders 
WHERE YEAR(OrderDate)=2023
EXCEPT
SELECT CustomerID FROM Invoices 
WHERE YEAR(InvoiceDate)=2023

--11. Using Products and Products_Discounted table, Combine all product names from Products and Products_Discounted including duplicates.

select ProductName from Products 
union all
select ProductName from Products_Discounted

--12. Using Products and Products_Discounted table, Combine all product names from Products and Products_Discounted without duplicates.

select ProductName from Products 
union 
select ProductName from Products_Discounted

--13. Using Orders table, find the average order amount by year.

select year(OrderDate)[year], avg(TotalAmount) avg_amount from Orders
group by  year(OrderDate)

--14. Using Products table, use CASE to group products based on price: 'Low' (<100), 'Mid' (100-500), 'High' (>500). Return productname and pricegroup.

select ProductName, case 
		  when price<100 then 'Low'
		  when price <500 then 'Mid'
		  else 'High' 
end as Pricegroup
from Products

--15. Using Customers table, list all unique cities where customers live, sorted alphabetically.

select distinct City from Customers
order by City asc

--16. Using Sales table, find total sales per product Id.

select ProductID, sum(SaleAmount) total_sales from Sales
group by ProductID

--17. Using Products table, use wildcard to find products that contain 'oo' in the name. Return productname.

select * from Products
where ProductName like '%oo%'

--18. Using Products and Products_Discounted tables, compare product IDs using INTERSECT.

select ProductID from Products 
intersect
select ProductID from Products_Discounted

--##  Hard-Level Tasks 
--19. Using Invoices table, show top 3 customers with the highest total invoice amount. Return CustomerID and Totalspent.

select top 3 CustomerID, sum(TotalAmount) Totalspent from Invoices
group by  CustomerID 
order by  Totalspent desc

--20. Find product ID and productname that are present in Products but not in Products_Discounted.

select ProductID, ProductName from Products
except
select ProductID, ProductName from Products_Discounted

--21. Using Products and Sales tables, list product names and the number of times each has been sold. (Research for Joins)

select p.ProductName,count(s.ProductID) count_sales from Products p 
join Sales s 
on p.ProductID=s.ProductID
group by p.ProductName

--22. Using Orders table, find top 5 products (by ProductID) with the highest order quantities.

select top 5 ProductID, sum(Quantity) total_quantity from Orders
group by ProductID
order by total_quantity desc




