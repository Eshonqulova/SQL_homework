
use homework_9_

--🟢 Easy-Level Tasks (10)

--1. Using Products, Suppliers table. List all combinations of product names and supplier names.

select p.ProductName, s.SupplierName  from Products p 
cross join Suppliers s

--2. Using Departments, Employees table. Get all combinations of departments and employees.

select * from Departments d cross join Employees e 

--3. Using Products, Suppliers table
--List only the combinations where the supplier actually supplies the product. Return supplier name and product name

select s.SupplierName, p.ProductName from Suppliers s join Products p on s.SupplierID=p.SupplierID

--4. Using Orders, Customers table. List customer names and their orders ID.

select FirstName+' '+LastName CustomerName, o.OrderID from Orders o 
join  Customers c 
on o.CustomerID=c.CustomerID

--5. Using Courses, Students table. Get all combinations of students and courses.

select s.Name, c.CourseName from Courses c cross join Students s

--6. Using Products, Orders table. Get product names and orders where product IDs match.

select p.ProductName, o.OrderID from  Products p 
join Orders o 
on p.ProductID=o.ProductID

--7. Using Departments, Employees table. List employees whose DepartmentID matches the department.

select e.Name , d.DepartmentName  from Departments d join Employees e on d.DepartmentID=e.DepartmentID

--8. Using Students, Enrollments table. List student names and their enrolled course IDs.

select s.Name, e.EnrollmentID from  Students s join Enrollments e on s.StudentID=e.StudentID

--9. Using Payments, Orders table. List all orders that have matching payments.

select p.PaymentID,o.ProductID,o.Quantity,p.Amount,p.PaymentMethod from  Payments p 
join Orders o 
on p.OrderID=o.OrderID

--10. Using Orders, Products table. Show orders where product price is more than 100.

select p.ProductName, p.Price from  Orders o join Products p on o.ProductID=p.ProductID
where price>=100

--## 🟡 Medium (10 puzzles)
--11. Using Employees, Departments table
--List employee names and department names where department IDs are not equal. It means: Show all mismatched employee-department combinations.

select e.Name, d.DepartmentName from Employees e 
join Departments d 
on e.DepartmentID<>d.DepartmentID

--12. Using Orders, Products table. Show orders where ordered quantity is greater than stock quantity.

select o.OrderID,o.Quantity from Orders o 
join Products p
on o.ProductID = p.ProductID
where o.Quantity>p.StockQuantity

--13. Using Customers, Sales table. List customer names and product IDs where sale amount is 500 or more.

select c.FirstName,s.ProductID,s.SaleAmount from Customers c 
join Sales s
on c.CustomerID=s.CustomerID
where s.SaleAmount>=500

--14. Using Courses, Enrollments, Students table. List student names and course names they’re enrolled in.

select s.Name,c.CourseName from Courses c 
join  Enrollments e
on c.CourseID=e.CourseID
join  Students s
on s.StudentID=e.StudentID

--15. Using Products, Suppliers table. List product and supplier names where supplier name contains “Tech”.

select p.ProductName, s.SupplierName from  Products p
join Suppliers s
on p.SupplierID=s.SupplierID
where SupplierName like '%Tech%'

--16. Using Orders, Payments table. Show orders where payment amount is less than total amount.

select o.OrderID,p.Amount 
from Orders o 
join Payments p
on o.OrderID = p.OrderID
where p.Amount< o.TotalAmount

--17. Using Employees table. List employee names with salaries greater than their manager’s salary.

select * from Employees e1
join Employees e2
on e1.ManagerID=e2.EmployeeID
where e1.Salary>e2.Salary

--18. Using Products, Categories table. Show products where category is either 'Electronics' or 'Furniture'.

select p.ProductName, c.CategoryName from Products p 
join Categories c
on p.Category=c.CategoryID
where c.CategoryName= 'Electronics' or c.CategoryName='Furniture'

--19. Using Sales, Customers table. Show all sales from customers who are from 'USA'.

select s.SaleID,s.SaleAmount,c.Country from Sales s 
join Customers c
on s.CustomerID=c.CustomerID
where c.Country='USA'

--20. Using Orders, Customers table. List orders made by customers from 'Germany' and order total > 100.

select c.FirstName,c.LastName,c.Country,o.TotalAmount from Orders o 
join  Customers c
on o.CustomerID=c.CustomerID
where c.Country='Germany' and o.TotalAmount>100

--## 🔴 Hard (5 puzzles)
--21. Using Employees table. List all pairs of employees from different departments.

select e1.Name empName, e2.Name OtherDeptName from Employees e1 
join Employees e2
on e1.EmployeeID<>e2.EmployeeID and e1.DepartmentID<>e2.DepartmentID

--22. Using Payments, Orders, Products table. List payment details where the paid amount is not equal to (Quantity × Product Price).

select pro.ProductName,o.Quantity,pro.Price, p.Amount from Payments p
join  Orders o 
on o.OrderID=p.OrderID
join Products pro 
on pro.ProductID=o.ProductID
where p.Amount<>o.Quantity*pro.Price

--23. Using Students, Enrollments, Courses table. Find students who are not enrolled in any course.

select s.StudentID,s.Name,s.Age,s.Major from Students s
left join  Enrollments e on e.StudentID=s.StudentID
where e.CourseID is null

--24. Using Employees table. List employees who are managers of someone, 
--but their salary is less than or equal to the person they manage.

select e1.Name, e1.Salary EmpSalary, e2.Salary DeptSalary from Employees e1 
join Employees e2
on e1.EmployeeID=e2.ManagerID
where e1.Salary<=e2.Salary

--25. Using Orders, Payments, Customers table. List customers who have made an order, but no payment has been recorded for it.

select c.FirstName,o.ProductID,p.PaymentID from Orders o
join Customers c on c.CustomerID=o.CustomerID
left join Payments p on p.OrderID=o.OrderID
where p.PaymentID is null and o.ProductID is not null
