--# Lesson 2: DDL and DML Commands

--Notes before doing the tasks: Tasks should be solved using SQL Server. It does not matter the solutions are uppercase or lowercase, which means case insensitive. Using alies names does not matter in scoring your work. It does not matter whether we close queries with ; or not
-----
use [F24_class2]
--### **Basic-Level Tasks (10)**  

--1. Create a table `Employees` with columns: `EmpID` INT, `Name` (VARCHAR(50)), and `Salary` (DECIMAL(10,2)).  
create table employees (EmpID int, Name varchar(50), Salary decimal(10,2))

--2. Insert three records into the `Employees` table using different INSERT INTO approaches (single-row insert and multiple-row insert).  
insert into employees values (1,'Ali', 500.5)
insert into employees(EmpID, Name,Salary)
values
(2,'Salim', 500),
(3,'Olim', 1500),
(4,'Olima', 700.5),
(5,'Nurbek', 800)
delete employees
select * from employees

--3. Update the `Salary` of an employee where `EmpID = 1`.  
update employees set Salary=7500 where EmpID=1
update employees set Salary=7200 where EmpID=5
update employees set Name='Alisher' where EmpID=4
update employees set EmpID=5 where EmpID=4
update employees set Name='Husan' where EmpID=5

--4. Delete a record from the `Employees` table where `EmpID = 2`.  
delete employees where EmpID=2

--5. Demonstrate the difference between `DELETE`, `TRUNCATE`, and `DROP` commands on a test table. 
--3. drop 
drop table test
create table test(id int, name varchar(30))
insert into test(id,name) values
(11,'Guli'),
(22,'Ali'),
(31,'Hasan'),
(43,'Vali')
select * from test
--1. delete
delete test where id=23
insert into test(id,name) values
(12,'Gulinor'),
(23,'Alibek'),
(32,'Humoyun'),
(44,'Sobir')
select * from test

--2. truncate
truncate table test
insert into test(id,name) values
(12,'Gulinor'),
(23,'Alibek'),
(32,'Humoyun'),
(44,'Sobir')
select * from test

--6. Modify the `Name` column in the `Employees` table to `VARCHAR(100)`.  
alter table employees 
alter column Name varchar(100)

alter table employees 
alter column Name nvarchar(60)

--7. Add a new column `Department` (`VARCHAR(50)`) to the `Employees` table.  
alter table employees 
add Department varchar(50) 

alter table employees 
add Newcolumn varchar(20)

select * from employees

--8. Change the data type of the `Salary` column to `FLOAT`.  
alter table employees alter column Salary float

--9. Create another table `Departments` with columns `DepartmentID` (INT, PRIMARY KEY) and `DepartmentName` (VARCHAR(50)). 
create table Departments(DepartmentID int primary key, DepartmentName varchar(50))
select * from Departments

--10. Remove all records from the `Employees` table without deleting its structure.  

truncate table Employees
select * from employees

--### **Intermediate-Level Tasks (6)**  
--11. Insert five records into the `Departments` table using `INSERT INTO SELECT` from an existing table.  
INSERT INTO Departments values 
(1,'Nodir'),
(2,'Karim'),
(3,'Nodira'),
(4,'Karima'),
(5,'Naima')
select * from Departments
drop table Departments
--12. Update the `Department` of all employees where `Salary > 5000` to 'Management'.  
alter table Departments 
add Salary int 
update Departments
set Salary = case DepartmentID
	when 1 then 5000
	when 2 then 4500
	when 3 then 3800
	when 4 then 8000
	when 5 then 5500
end
where DepartmentID in (1,2,3,4,5)

UPDATE Departments
SET DepartmentName = 'Management'
WHERE Salary > 5000;
--13. Write a query that removes all employees but keeps the table structure intact.   
--14. Drop the `Department` column from the `Employees` table.   
--15. Rename the `Employees` table to `StaffMembers` using SQL commands.  
--16. Write a query to completely remove the `Departments` table from the database.  

-----

--### **Advanced-Level Tasks (9)**        
--17. Create a table named Products with at least 5 columns, including: ProductID (Primary Key), ProductName (VARCHAR), Category (VARCHAR), Price (DECIMAL)
--18. Add a CHECK constraint to ensure Price is always greater than 0.
--19. Modify the table to add a StockQuantity column with a DEFAULT value of 50.
--20. Rename Category to ProductCategory
--21. Insert 5 records into the Products table using standard INSERT INTO queries.
--22. Use SELECT INTO to create a backup table called Products_Backup containing all Products data.
--23. Rename the Products table to Inventory.
--24. Alter the Inventory table to change the data type of Price from DECIMAL(10,2) to FLOAT.
--25. Add an IDENTITY column named ProductCode that starts from 1000 and increments by 5.