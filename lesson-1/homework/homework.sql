--Lesson 1: Introduction to SQL Server and SSMS
--Notes before doing the tasks: Tasks should be solved using SQL Server. It does not matter the solutions are uppercase or lowercase, which means case insensitive. Using alies names does not matter in scoring your work. Students are scored based on what their query returns(does it fulfill the requirments). One way of solution is enough if it is true, other ways might be suggested but should not affect the score.
--Easy
--1--Define the following terms: data, database, relational database, and table.
--1. Data is a information which is belong to a spesific organization.
--2. A database is used to collect, store, and manage information.
--3. A relational database is a type of database that organizes data into rows and columns, which collectively form a table where the data points are related to each other.
--4. A table use to illustrate datas understandeble and it helps us to sorts the list

--2--List five key features of SQL Server.
--a) Data Storage and Management
--SQL Server provides efficient storage and management of data in the form of tables, views, and indexes. It allows users to store and retrieve large amounts of data securely and reliably.
--b) Security Features
--SQL Server offers robust security features, including user authentication, data encryption, role-based access control, and auditing. This ensures that only authorized users can access or modify data.
--c) High Availability and Disaster Recovery
--SQL Server includes features like Always On Availability Groups, database mirroring, and log shipping, which ensure high availability and disaster recovery, minimizing downtime and data loss.
--d) Advanced Querying and Data Manipulation
--SQL Server supports SQL querying through Transact-SQL (T-SQL) for data manipulation, including SELECT, INSERT, UPDATE, and DELETE operations, as well as advanced querying capabilities like joins, subqueries, and aggregations.
--f) Business Intelligence (BI) and Analytics

--3.	What are the different authentication modes available when connecting to SQL Server? (Give at least 2)
--There are two possible modes: Windows Authentication mode and mixed mode. Windows Authentication mode enables Windows Authentication and disables SQL Server Authentication. 
--Mixed mode enables both Windows Authentication and SQL Server Authentication.

--Medium

--4.	Create a new database in SSMS named SchoolDB.
create database SchoolDB
use [SchoolDB]
--5.	Write and execute a query to create a table called Students with columns: StudentID 
--(INT, PRIMARY KEY), Name (VARCHAR(50)), Age (INT).
create table Students(StudentID int primary key, Name varchar(50),Age int) 

--6.	Describe the differences between SQL Server, SSMS, and SQL.
-- SQL Server is a relational database management system (RDBMS) developed by Microsoft. It is used to store and manage data in a structured format using tables, rows, and columns.
-- SSMS is a graphical user interface (GUI) tool provided by Microsoft for managing SQL Server databases. It allows you to interact with SQL Server, configure, manage, and query the databases through a visual interface.
-- SQL is a programming language used to communicate with and manipulate databases. It is the standard language for querying and managing relational databases.

--Hard

--7.	Research and explain the different SQL commands: DQL, DML, DDL, DCL, TCL with examples.
--1. DQL - bunga faqat select kiradi. bu ma'lumotlarni ma'lumotlar bazasidan olish va so'rash uchun ishlatiladi.
select * from Students
--2. DML - bunga insert, update,delete kiradi va ushbu jarayonda faqat ma'lumotlar ustida ishlaydi.
insert into Students values (1,'Ali', 30) 
update Students set Name='Sobir' where StudentID=1

--3. DDL - create, drop, truncate, alter kiradi hamda ma'lumotlarni tuzilmasi, strukturasi ustida ishlaydi.
alter table Students
alter column Name nvarchar(30)
--4. DCL - revoke, grant xavfsizlikni ta'minlash uchun ishlatiladi. bunda foydalanuvchiga ma'lum bir ruxsatlar berish yoki taqiqlar qo'yish mumkin.
--grant - foydalanuvchiga ma'lum ruxsatlar beradi.
--revoka - foydalanuvchidan ruxsatlarni oladi.
--5. TCL - o'tkazmalarni ustida ishlaydi
begin transaction
insert into Students values
(2,'Nizom',18),
(3,'Rayhona',21)
commit
--8.	Write a query to insert three records into the Students table.
insert into Students(StudentID, Name, Age )  values
(4,'Ali',19),
(5,'Guli',24),
(6,'Olim',27)
--9.	Create a backup of your SchoolDB database and restore it. (write its steps to submit)


