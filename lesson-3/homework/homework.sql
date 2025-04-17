--# Lesson 3: Constraints. Importing and Exporting Data
use class_3
--✅ Importing Data Exporting Data
--✅ Comments, Identity column, NULL/NOT NULL values
--✅ Unique Key, Primary Key, Foreign Key, Check Constraint
--✅ Differences between UNIQUE KEY and PRIMARY KEY

--________________________________________

--## 🟢 Easy-Level Tasks (10)
--1. Define and explain the purpose of BULK INSERT in SQL Server.
--bulk insert is used to import data from .txt and .csv files into a SQl server table. it mainly used for importing large amounts of data from externel text files. For example:
-- First of all, we should create a new table with columns that match the columns of the importing file.

create table city1 (ID int primary key identity(1,1),Name varchar(50), CountryCode varchar(50), District varchar(50), Population int)
drop table city1
bulk insert city1 from 'C:\SQL_homework\city1.csv'
with(
firstrow = 2,
fieldterminator=';',
rowterminator='\n')

select * from city1

--2. List four file formats that can be imported into SQL Server.
--1. csv - ya'ni comma separated values file
--2. txt - ya'ni plain text file
--3. xls yoki xlsx - excel file
--4. xml - extensible mercup landuage file
-- yana json file ham bor. javascript object notation fayli

--3. Create a table Products with columns: ProductID (INT, PRIMARY KEY), ProductName (VARCHAR(50)), Price (DECIMAL(10,2)).
create table Products (ProductID int primary key, ProductName varchar(50), Price decimal(10,2))

--4. Insert three records into the Products table using INSERT INTO.
insert into Products values
(1, 'Pen', 5000),
(2, 'Pencil', 7000),
(3, 'Eraser', 5000)
select * from Products

--5. Explain the difference between NULL and NOT NULL with examples.
-- null asosan data mavjud bo'lmagan cellni to'ldirish uchun ishlatiadi. 
-- not null asosan cells null qiymatga teng bo'lmasligi uchun ishlatiladi. for example:
insert into Products(ProductID, ProductName) values
(4,'paper') -- u holatda Products jadvalidagi 4-row 3- ustuniga null qiymat beriladi va shu cell ga null qiymat beriladi. 
-- bu holat doim ham qulay emas chunki null hechqanday qiymatga ega emas yani qiymatsiz. bu holatda null ni ishlatmaslik uchun biz jadvalga o'zgartirish kiritib not null deb yozishimiz kerak bo'ladi. misol uchun
delete from Products
where ProductID=4
alter table Products
alter column Price decimal(10,2) not null -- deb kiritsak endi bu column null qabul qilmaydi.

--6. Add a UNIQUE constraint to the ProductName column in the Products table.
alter table Products
add constraint cons_ProductName unique(ProductName) 

--7. Write a comment in a SQL query explaining its purpose.
--1. "--" type is used to explain our code and it helps us to remember and note our notions.
--2. "/* and */" type is also used to note our ideas like a "--". both of them use the same purpose.

--8. Create a table Categories with a CategoryID as PRIMARY KEY and a CategoryName as UNIQUE.
create table Categories (CategoryID  int primary key,CategoryName varchar(50) unique)

--9. Explain the purpose of the IDENTITY column in SQL Server.
--identity use default state as identity(1,1) ya'ni 1 dan boshlab keyingi rowlarga 1 qo'shib boraveradi.
-- boshqa holatda ham ishlatsak bo'ladi. For instance, id int identitiy(50,5) deb kiritsak bu id ustundagi raqamlar 50 dan boshlanib, o'zidan keyingi songa 5 qo'shib boradi. yani 50,55,60,65,... kabi.
--________________________________________

--## 🟠 Medium-Level Tasks (10)
--10. Use BULK INSERT to import data from a text file into the Products table.
drop table Products
create table Products(
ID int, 
Name varchar(50), 
CountryCode varchar(30), 
District varchar(50),
Population int)

bulk insert Products
from 'C:\SQL_homework\city1.csv'
with (
firstrow=2,
fieldterminator=';',
rowterminator='\n')

select * from products

select * from Categories

--11. Create a FOREIGN KEY in the Products table that references the Categories table.

alter table Products
add constraint Fk_CategoryName
foreign key (District)
references Categories(CategoryName)

--12. Explain the differences between PRIMARY KEY and UNIQUE KEY with examples.
--A chosen table should have a unique and not null constraint = primary key. A primary key cannot accept null values.
--A unique key can accept null or any number, but only once.
-- A primary key is mainly used for ID columns because of values cannot repeating .

--13. Add a CHECK constraint to the Products table ensuring Price > 0.
alter table Products
add  Price int,
check (Price>0)

--14. Modify the Products table to add a column Stock (INT, NOT NULL).
alter table products
add Stock int not null
select * from products

--15. Use the ISNULL function to replace NULL values in a column with a default value.
update  products
set District=isnull(District,0)
where District is null

--16. Describe the purpose and usage of FOREIGN KEY constraints in SQL Server.
-- it helps us to connect the exact table with another tables. in that way we should exchange data properly as well as easy for uploading data among  tables.

--________________________________________

--## 🔴 Hard-Level Tasks (10)
--17. Write a script to create a Customers table with a CHECK constraint ensuring Age >= 18.
create table Customers (ID int primary key, Cus_Name varchar(50), Cus_phone varchar(40) default 'Taqdim etilmagan', PassportID varchar(50) unique, age int check(Age>18))

--18. Create a table with an IDENTITY column starting at 100 and incrementing by 10.
create table Salary(id int primary key identity(100,10))

--19. Write a query to create a composite PRIMARY KEY in a new table OrderDetails.
create table Bookshop(
OrderID int,
ProductName varchar(50),
ProductID int,
Price decimal(10,2),
primary key(OrderID, ProductID)
)
select * from Bookshop

--20. Explain with examples the use of COALESCE and ISNULL functions for handling NULL values.
-- firstly, i should create a table with null values in orer to use handling null.

create table teachers1(id int primary key, Name varchar(50), specialty varchar(50), lesson int) 
insert into teachers1 values
(1,'Ali','math',null),
(2,null,'biology',null),
(3,null,'history',1)
select * from teachers1
select id, isnull([Name],0) as name, isnull(specialty,0) specialty, isnull([lesson],0) as lesson from teachers1

drop table  students1
create table students1(id int primary key, firstname varchar(50), lastname varchar(50),address varchar(50), course int)
insert into students1 values
(1,'Sevinch', null,'amir temur2',1),
(2, null, null,null,2),
(3,'Nurxon','Aliyev',null,1),
(4,null,'Sardorov','chexov11',null)
select coalesce (firstname,lastname,  'not provided') as name from students1

--21. Create a table Employees with both PRIMARY KEY on EmpID and UNIQUE KEY on Email.
Create table Employees (EmpID int  primary key, Email varchar(60) unique)
--22. Write a query to create a FOREIGN KEY with ON DELETE CASCADE and ON UPDATE CASCADE options.
drop table minishops-- o'shirishda tartib bilan avval child table, keyin parent table o'chiriladi.
drop table shops1

create table minishops(
id int, 
productid int primary key,
sales int)
insert into minishops values
(1,111,50),
(2,112,40),
(3,113,35),
(4,114,510)

create table shops1(
id int primary key,
productname varchar(50), 
productid int,
foreign key (productid) references minishops(productid)
on delete cascade
on update cascade)

insert into shops1 values
(1,'apple',111),
(2,'banana',112),
(3,'apricot',114),
(4,'juice',113),
(5,'pomigrata',113)

 select * from minishops
select * from shops1

delete minishops  --parent->child o'chiradi elementni, child->parent bo'lsa fatqat childda o'chida va parentda o'chmaydi. BU holatda faqat bir tomonlama jarayon amalga oshar ekan.
where id=4

