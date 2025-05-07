--1. **Return**: `OrderID`, `CustomerName`, `OrderDate`  
--   **Task**: Show all orders placed after 2022 along with the names of the customers who placed them.  
--   **Tables Used**: `Orders`, `Customers`

select a.OrderID, b.FirstName CustomerName, a.OrderDate from Orders a 
join Customers b 
on a.CustomerID=b.CustomerID
where year(a.OrderDate)>2022

--2. **Return**: `EmployeeName`, `DepartmentName`  
--   **Task**: Display the names of employees who work in either the Sales or Marketing department.  
--   **Tables Used**: `Employees`, `Departments`

select a.Name EmployeeName, b.DepartmentName from Employees a 
join Departments b 
on b.DepartmentID=a.DepartmentID
where b.DepartmentName in ('Sales','Marketing')

--3. **Return**: `DepartmentName`,  `MaxSalary`  
--   **Task**: Show the highest salary for each department.  
--   **Tables Used**: `Departments`, `Employees`

select a.DepartmentName ,max(b.Salary) MaxSalary from Departments a 
join Employees b 
on a.DepartmentID=b.DepartmentID
group by a.DepartmentName

--4. **Return**: `CustomerName`, `OrderID`, `OrderDate`  
--   **Task**: List all customers from the USA who placed orders in the year 2023.  
--   **Tables Used**: `Customers`, `Orders`

select a.FirstName CustomerName, b.OrderID, b.OrderDate from Customers a 
join Orders b 
on a.CustomerID=b.CustomerID and a.Country='USA' and year(OrderDate)=2023

--5. **Return**: `CustomerName`, `TotalOrders`  
--   **Task**: Show how many orders each customer has placed.  
--   **Tables Used**: `Orders` , `Customers`
select * from Orders
select * from Customers

select a.FirstName CustomerName, count( b.Quantity) TotalOrders from Customers a 
join Orders b 
on a.CustomerID=b.CustomerID 
group by a.FirstName 

--6. **Return**: `ProductName`, `SupplierName`  
--   **Task**: Display the names of products that are supplied by either Gadget Supplies or Clothing Mart.  
--   **Tables Used**: `Products`, `Suppliers`

select a.ProductName, b.SupplierName from Products a 
join Suppliers b 
on a.SupplierID=b.SupplierID
where b.SupplierName in('Gadget Supplies','Clothing Mart')

--7. **Return**: `CustomerName`, `MostRecentOrderDate`  
--   **Task**: For each customer, show their most recent order. Include customers who haven't placed any orders.  
--   **Tables Used**: `Customers`, `Orders`

select distinct a.FirstName, max(b.OrderDate) MostRecentOrderDate from Customers a 
left join Orders b 
on a.CustomerID=b.CustomerID
group by  a.FirstName
order by  MostRecentOrderDate desc, a.FirstName

--8. **Return**: `CustomerName`,  `OrderTotal`  
--   **Task**: Show the customers who have placed an order where the total amount is greater than 500.  
--   **Tables Used**: `Orders`, `Customers`

select b.FirstName CustomerName, sum(a.TotalAmount) OrderTotal from Orders a 
 join Customers b 
on a.CustomerID=b.CustomerID
group by  b.FirstName
having sum (a.TotalAmount)>500

--9. **Return**: `ProductName`, `SaleDate`, `SaleAmount`  
--   **Task**: List product sales where the sale was made in 2022 or the sale amount exceeded 400.  
--   **Tables Used**: `Products`, `Sales`

select a.ProductName, b.SaleDate, b.SaleAmount from Products a 
 join Sales b 
on a.ProductID=b.ProductID and year(b.SaleDate)=2022 or b.SaleAmount>400

--10. **Return**: `ProductName`, `TotalSalesAmount`  
--    **Task**: Display each product along with the total amount it has been sold for.  
--    **Tables Used**: `Sales`, `Products`

select a.ProductName, sum( b.SaleAmount) TotalSalesAmount from Products a 
 join Sales b 
on a.ProductID=b.ProductID 
group by  a.ProductName

--11. **Return**: `EmployeeName`, `DepartmentName`, `Salary`  
--    **Task**: Show the employees who work in the HR department and earn a salary greater than 60000.  
--    **Tables Used**: `Employees`, `Departments`

select a.Name EmployeeName, b.DepartmentName, a.Salary from Employees a 
 join Departments b 
on a.DepartmentID=b.DepartmentID and b.DepartmentName='HR' and a.Salary>60000

--12. **Return**: `ProductName`, `SaleDate`, `StockQuantity`  
--    **Task**: List the products that were sold in 2023 and had more than 100 units in stock at the time.  
--    **Tables Used**: `Products`, `Sales`

select a.ProductName, b.SaleDate, a.StockQuantity from Products a 
 join Sales b 
on a.ProductID=b.ProductID and year(b.SaleDate)=2023 and a.StockQuantity>100

--13. **Return**: `EmployeeName`, `DepartmentName`, `HireDate`  
--    **Task**: Show employees who either work in the Sales department or were hired after 2020.  
--    **Tables Used**: `Employees`, `Departments`

select a.Name EmployeeName, b.DepartmentName, a.HireDate from Employees a 
 join Departments b 
on a.DepartmentID=b.DepartmentID 
where b.DepartmentName='Sales' or year(a.HireDate)<2020

--14. **Return**: `CustomerName`, `OrderID`, `Address`, `OrderDate`  
--    **Task**: List all orders made by customers in the USA whose address starts with 4 digits.  
--    **Tables Used**: `Customers`, `Orders`

select a.FirstName CustomerName, b.OrderID, a.Address, b.OrderDate  from Customers a 
 join Orders b 
on a.CustomerID=b.CustomerID and a.Country='USA' 
where  a.Address like '%[0-9]%[0-9]%[0-9]%[0-9]%'

--15. **Return**: `ProductName`, `Category`, `SaleAmount`  
--    **Task**: Display product sales for items in the Electronics category or where the sale amount exceeded 350.  
--    **Tables Used**: `Products`, `Sales`

select a.ProductName, a.Category, b.SaleAmount from Products a 
 join Sales b 
on a.ProductID=b.ProductID and b.SaleAmount>350 or a.Category='Electronics'

--16. **Return**: `CategoryName`, `ProductCount`  
--    **Task**: Show the number of products available in each category.  
--    **Tables Used**: `Products`, `Categories`

select b.CategoryName, count(a.ProductName) ProductCount from Products a 
 join Categories b 
on a.Category=b.CategoryID
group by b.CategoryName

--17. **Return**: `CustomerName`, `City`, `OrderID`, `Amount`  
--    **Task**: List orders where the customer is from Los Angeles and the order amount is greater than 300.  
--    **Tables Used**: `Customers`, `Orders`

select a.FirstName CustomerName, a.City,b.OrderID,sum(b.TotalAmount) Amount from Customers a 
left join Orders b 
on a.CustomerID=b.CustomerID and a.City='Los Angeles'
group by  a.FirstName, a.City,b.OrderID
having sum(b.TotalAmount)>300

--18. **Return**: `EmployeeName`, `DepartmentName`  
--    **Task**: Display employees who are in the HR or Finance department, or whose name contains at least 4 vowels.  
--    **Tables Used**: `Employees`, `Departments`

select a.Name EmployeeName, b.DepartmentName, a.HireDate from Employees a 
 join Departments b 
on a.DepartmentID=b.DepartmentID and b.DepartmentName  in ('HR', 'Finance')
where a.Name like '%[a,o,e,i,u]%[a,o,e,i,u]%[a,o,e,i,u]%[a,o,e,i,u]%'

--19. **Return**: `EmployeeName`, `DepartmentName`, `Salary`  
--    **Task**: Show employees who are in the Sales or Marketing department and have a salary above 60000.  
--    **Tables Used**: `Employees`, `Departments`

select a.Name EmployeeName, b.DepartmentName, a.Salary from Employees a 
 join Departments b 
on a.DepartmentID=b.DepartmentID and b.DepartmentName  in ('Sales', 'Marketing') and a.Salary>60000
