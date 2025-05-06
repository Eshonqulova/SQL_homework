--1. **Using the `Employees` and `Departments` tables**, write a query to return the names and salaries of employees whose salary is greater than 50000, along with their department names.  
--   🔁 *Expected Columns:* `EmployeeName`, `Salary`, `DepartmentName`

select e.Name EmployeeName, e.Salary , d.DepartmentName  from Employees e 
join Departments d 
on e.DepartmentID=d.DepartmentID
where e.salary>50000

--2. **Using the `Customers` and `Orders` tables**, write a query to display customer names and order dates for orders placed in the year 2023.  
--   🔁 *Expected Columns:* `FirstName`, `LastName`, `OrderDate`

select c.FirstName, c.LastName, o.OrderDate  from Customers c
join Orders o 
on c.CustomerID=o.CustomerID
where year(o.OrderDate)=2023

--3. **Using the `Employees` and `Departments` tables**, write a query to show all employees along with their department names. Include employees who do not belong to any department.  
--   🔁 *Expected Columns:* `EmployeeName`, `DepartmentName`  

select e.Name EmployeeName, d.DepartmentName DepartmentName from Employees e
left join Departments d 
on e.DepartmentID=d.DepartmentID

--4. **Using the `Products` and `Suppliers` tables**, write a query to list all suppliers and the products they supply. Show suppliers even if they don’t supply any product.  
--   🔁 *Expected Columns:* `SupplierName`, `ProductName`

select s.SupplierName, p.ProductName from Products p 
right join Suppliers s 
on s.SupplierID=p.SupplierID

--5. **Using the `Orders` and `Payments` tables**, write a query to return all orders and their corresponding payments. Include orders without payments and payments not linked to any order.  
--   🔁 *Expected Columns:* `OrderID`, `OrderDate`, `PaymentDate`, `Amount`

select o.OrderID, o.OrderDate, p.PaymentDate, p.Amount from  Orders o 
full join  Payments p
on o.OrderID=p.OrderID

--6. **Using the `Employees` table**, write a query to show each employee's name along with the name of their manager.  
--   🔁 *Expected Columns:* `EmployeeName`, `ManagerName`

select a.Name EmployeeName, b.Name from Employees a 
join Employees b 
on a.ManagerID=b.EmployeeID

--7. **Using the `Students`, `Courses`, and `Enrollments` tables**, write a query to list the names of students who are enrolled in the course named 'Math 101'.  
--   🔁 *Expected Columns:* `StudentName`, `CourseName`

select a.Name, b.CourseName from Students a 
join Enrollments c 
on a.StudentID=c.StudentID
join Courses b 
on b.CourseID=c.CourseID
where b.CourseName='Math 101'

--8. **Using the `Customers` and `Orders` tables**, write a query to find customers who have placed an order with more than 3 items. Return their name and the quantity they ordered.  
--   🔁 *Expected Columns:* `FirstName`, `LastName`, `Quantity`

select c.FirstName, c.LastName, o.Quantity from Customers c
join  Orders o
on o.CustomerID=c.CustomerID
where o.Quantity>3

--9. **Using the `Employees` and `Departments` tables**, write a query to list employees working in the 'Human Resources' department.  
--   🔁 *Expected Columns:* `EmployeeName`, `DepartmentName`  

select a.Name EmployeeName, b.DepartmentName from Employees a
join  Departments b
on a.DepartmentID=b.DepartmentID
where b.DepartmentName='Human Resources'

--10. **Using the `Employees` and `Departments` tables**, write a query to return department names that have more than 5 employees.  
--   🔁 *Expected Columns:* `DepartmentName`, `EmployeeCount`

select b.DepartmentName, count(b.DepartmentName) EmployeeCount from Employees a 
join Departments b 
on a.DepartmentID=b.DepartmentID
group by  b.DepartmentName
having count(b.DepartmentName)>5

--11. **Using the `Products` and `Sales` tables**, write a query to find products that have never been sold.  
--   🔁 *Expected Columns:* `ProductID`, `ProductName`

select a.ProductID, a.ProductName from Products a 
left join Sales b 
on a.ProductID=b.ProductID
where b.ProductID is null

--12. **Using the `Customers` and `Orders` tables**, write a query to return customer names who have placed at least one order.  
--   🔁 *Expected Columns:* `FirstName`, `LastName`, `TotalOrders`

select a.FirstName,a.LastName, count(b.Quantity) TotalOrders from Customers a 
 join  Orders b 
on a.CustomerID=b.CustomerID
group by a.FirstName,a.LastName
having count(b.Quantity)>=1

--13. **Using the `Employees` and `Departments` tables**, write a query to show only those records where both employee and department exist (no NULLs).  
--   🔁 *Expected Columns:* `EmployeeName`, `DepartmentName`  

select a.Name EmployeeName, b.DepartmentName from Employees a
join Departments b
on a.DepartmentID=b.DepartmentID

--14. **Using the `Employees` table**, write a query to find pairs of employees who report to the same manager.  
--   🔁 *Expected Columns:* `Employee1`, `Employee2`, `ManagerID`

select a.Name Employee1, b.Name Employee2, a.ManagerID from Employees a
join Employees b
on a.ManagerID=b.ManagerID and  a.EmployeeID<b.EmployeeID
order by a.ManagerID
--15. **Using the `Orders` and `Customers` tables**, write a query to list all orders placed in 2022 along with the customer name.  
--   🔁 *Expected Columns:* `OrderID`, `OrderDate`, `FirstName`, `LastName`

select a.OrderID, a.OrderDate, b.FirstName, b.LastName from Orders a 
join Customers b 
on a.CustomerID=b.CustomerID
where year(a.OrderDate)=2022

--16. **Using the `Employees` and `Departments` tables**, write a query to return employees from the 'Sales' department whose salary is above 60000.  
--   🔁 *Expected Columns:* `EmployeeName`, `Salary`, `DepartmentName`

select * from Employees a 
join Departments b 
on a.DepartmentID=b.DepartmentID
where b.DepartmentName='Sales' and a.Salary>60000

--17. **Using the `Orders` and `Payments` tables**, write a query to return only those orders that have a corresponding payment.  
--   🔁 *Expected Columns:* `OrderID`, `OrderDate`, `PaymentDate`, `Amount`

select a.OrderID, a.OrderDate, b.PaymentDate, b.Amount from Orders a  
join Payments b 
on a.OrderID=b.OrderID

--18. **Using the `Products` and `Orders` tables**, write a query to find products that were never ordered.  
--   🔁 *Expected Columns:* `ProductID`, `ProductName`

select a.ProductID,a.ProductName from Products a 
left join Orders b 
on a.ProductID=b.ProductID
where b.Quantity is null

--19. **Using the `Employees` table**, write a query to find employees whose salary is greater than the average salary in their own departments.  
--   🔁 *Expected Columns:* `EmployeeName`, `Salary`

select a.Name, a.Salary from Employees a 
where a.salary>(select avg(Salary) from Employees where DepartmentID = a.DepartmentID)

--20. **Using the `Orders` and `Payments` tables**, write a query to list all orders placed before 2020 that have no corresponding payment.  
--   🔁 *Expected Columns:* `OrderID`, `OrderDate`

select a.OrderID, a.OrderDate from Orders a 
left join Payments b 
on a.OrderID=b.OrderID 
where  year(a.OrderDate)<2020 and b.PaymentID is null

--21. **Using the `Products` and `Categories` tables**, write a query to return products that do not have a matching category.  
--   🔁 *Expected Columns:* `ProductID`, `ProductName`

select p.ProductID,p.ProductName from Products p 
left join Categories c 
on p.Category=c.CategoryID
where c.categoryid is  null

--22. **Using the `Employees` table**, write a query to find employees who report to the same manager and earn more than 60000.  
--   🔁 *Expected Columns:* `Employee1`, `Employee2`, `ManagerID`, `Salary`
--a.Name Employee1, b.Name  Employee2, b.ManagerID, a.Salary

select a.Name Employee1, b.Name Employee2, a.ManagerID, a.Salary from Employees a
join Employees b 
on a.ManagerID = b.ManagerID and a.EmployeeID < b.EmployeeID
where a.Salary > 60000 and b.Salary > 60000

--23. **Using the `Employees` and `Departments` tables**, write a query to return employees who work in departments which name starts with the letter 'M'.  
--   🔁 *Expected Columns:* `EmployeeName`, `DepartmentName`

select e.Name EmployeeName, d.DepartmentName from Employees e 
join  Departments d 
on e.DepartmentID=d.DepartmentID
where d.DepartmentName like 'M%'

--24. **Using the `Products` and `Sales` tables**, write a query to list sales where the amount is greater than 500, including product names.  
--   🔁 *Expected Columns:* `SaleID`, `ProductName`, `SaleAmount`

select b.SaleID, a.ProductName, b.SaleAmount from Products a 
join  Sales b 
on a.ProductID=b.ProductID
where b.SaleAmount>500

--25. **Using the `Students`, `Courses`, and `Enrollments` tables**, write a query to find students who have **not** enrolled in the course 'Math 101'.  
--   🔁 *Expected Columns:* `StudentID`, `StudentName`

select  a.StudentID, a.Name StudentName from Students a 
where a.StudentID not in (
select b.StudentID from Enrollments b join Courses c 
on b.CourseID=c.CourseID 
where c.CourseName='Math 101')

select s.StudentID, s.Name as StudentName
from Students s
left join Enrollments e 
on s.StudentID = e.StudentID
left join Courses c 
on e.CourseID = c.CourseID and c.CourseName = 'Math 101'
where c.CourseID is null

--26. **Using the `Orders` and `Payments` tables**, write a query to return orders that are missing payment details.  
--   🔁 *Expected Columns:* `OrderID`, `OrderDate`, `PaymentID`

select a.OrderID, a.OrderDate, b.PaymentID from Orders a 
left join  Payments b on a.OrderID=b.OrderID
where  b.PaymentID is null

--27. **Using the `Products` and `Categories` tables**, write a query to list products that belong to either the 'Electronics' or 'Furniture' category.  
--   🔁 *Expected Columns:* `ProductID`, `ProductName`, `CategoryName`

select a.ProductID, a.ProductName, b.CategoryName from Products a 
join Categories b 
on a.Category=b.CategoryID
where b.CategoryName in('Electronics' , 'Furniture')
