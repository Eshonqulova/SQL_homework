--Basic-Level Tasks (10)
create database [database_2]

--1.Create a table Employees with columns: EmpID INT, Name (VARCHAR(50)), and Salary (DECIMAL(10,2)).
use [database_2]
create table Employees (EmpID int, Name varchar(50), Salary decimal(10,2))
select * from Employees

--2. Insert three records into the Employees table using different INSERT INTO approaches (single-row insert and multiple-row insert).
insert into Employees values(1,'Ali',8000)
insert into Employees(EmpID, Name, Salary) values
(2, 'Nodir', 5000),
(3, 'Sobir', 6500),
(4, 'Karima', 7000)

insert into Employees (EmpID, Name, Salary) values
(1, 'Nozima',2300),
(6, 'Asror',4500),
(7, 'Feruza', 7700)

--3. Update the Salary of an employee where EmpID = 1.
update Employees set Salary=4900 where EmpID=1
update Employees set Salary = 5000 where EmpID=5
update Employees set Salary = 7000 where Name = 'Ali'

--4. Delete a record from the Employees table where EmpID = 2.
delete Employees where EmpID=2
select * from Employees

--5. Demonstrate the difference between DELETE, TRUNCATE, and DROP commands on a test table.
delete Employees
insert into Employees(EmpID, Name, Salary) values
(1, 'Aziz', 5000),
(2,'Sayyora', 4500)

--6. truncate va delete bir xil funksiya bajardi misolda
truncate table Employees
insert into Employees(EmpID, Name, Salary) values
(1,'Shoxruh',7500),
(2,'Aliya',4400)

drop table Employees
insert into Employees values(1,'Ali',4500) -- drop butunlay o'chiradi jadvalni va unga information kiritib bo'lmaydi drop qilinganidan so'ng.

--7. Modify the Name column in the Employees table to VARCHAR(100).
alter table Employees 
alter column Name varchar (100)
alter table Employees
alter column Name varchar(70)
alter table Employees
alter column EmpID int

--8. Add a new column Department (VARCHAR(50)) to the Employees table.
alter table Employees 
add Department varchar(50)
select * from Employees

--9. Change the data type of the Salary column to FLOAT.
alter table Employees
alter column Salary float

--10. Create another table Departments with columns DepartmentID (INT, PRIMARY KEY) and DepartmentName (VARCHAR(50)).
create table Departments(DepartmentID int primary key, DepartmentName varchar(50))
select * from Departments
insert into Departments(DepartmentID, DepartmentName) values
(1,'Qadoqlash'),
(2,'Filtrlash'),
(3, 'Solish'),
(4,'Tozalash'),
(5,'Hisoblash'),
(6, 'royxatdan_otkizish')

--11. Remove all records from the Employees table without deleting its structure.
truncate table Employees 

--12. Intermediate-Level Tasks (6)
create table Departments1(DepartmentID1 int , DepartmentName1 varchar(50)) 
select * from Departments1
insert into Departments1(DepartmentID1, DepartmentName1) values
(3,'depid'),
(4,'dep1'),
(5, 'dep2'),
(6,'dep3'),
(7,'dep4'),
(8, 'dep5')
alter table Departments
drop constraint PK__Departme__B2079BCDB5C8CECC

alter table Departments
alter column DepartmentID int
truncate table Departments
--13. Insert five records into the Departments table using INSERT INTO SELECT from an existing table.

INSERT INTO Departments (DepartmentID, DepartmentName)
SELECT DepartmentID1, DepartmentName1
FROM Departments1
WHERE DepartmentID1 <= 5;

--14. Update the Department of all employees where Salary > 5000 to 'Management'.
select * from Employees
insert into Employees values 
(3, 'Mosh',7500,1),
(5,'Li',7700,5)
update Employees
set Department = 'Management'
where Salary > 5000;

--15. Write a query that removes all employees but keeps the table structure intact.
truncate table Employees
select * from Employees

--16. Drop the Department column from the Employees table.
alter table Employees
drop column Department

--17. Rename the Employees table to StaffMembers using SQL commands.
--alter table Employees rename to StaffMembers
exec sp_rename 'Employees', 'StaffMembers'

--18.Write a query to completely remove the Departments table from the database.
drop table Departments

-- Advanced-Level Tasks (9)

--20. Create a table named Products with at least 5 columns, including: 
--ProductID (Primary Key), ProductName (VARCHAR), Category (VARCHAR), Price (DECIMAL)
create table Products 
(
ProductID int primary key, 
ProductName varchar(50), 
Category varchar(50), 
Price decimal(6,2)
)
select * from Products 
drop table Products

--21. Add a CHECK constraint to ensure Price is always greater than 0.
alter table Products
add check(Price>0)

--22. Modify the table to add a StockQuantity column with a DEFAULT value of 50.
alter table Products
add StockQuantity int DEFAULT 50

--23. Rename Category to ProductCategory
exec sp_rename 'Products.Category', 'ProductCategory','column'

--24. Insert 5 records into the Products table using standard INSERT INTO queries.
insert into Products values 
(1,'apple','fruit',5000,2),
(2,'banana','fruit',2000,2),
(3,'cherry','fruit',8000,2),
(4,'potato','vegetable',4000,5),
(5,'onion','vegetable',7000,5)

--25. Use SELECT INTO to create a backup table called Products_Backup containing all Products data.
select * into Products_Backup from Products 
select * from Products_Backup

--26. Rename the Products table to Inventory.
exec sp_rename 'Products','Inventory'
select * from Inventory

--27. Alter the Inventory table to change the data type of Price from DECIMAL(10,2) to FLOAT.
alter table Inventory
drop constraint CK__Products__Price__778AC167

--constraintni olib tashlab keyin o'zgartirish kiritish mumkin ekan
alter table Inventory
alter column Price float

--28. Add an IDENTITY column named ProductCode starts from 1000 and increments by 5.
create table ProductCode(ID int identity(1000,5), Name varchar(50) unique not null )


insert into ProductCode values(
'Ali'),('Nozim'),('Li')
select * from ProductCode
