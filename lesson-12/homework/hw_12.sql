create database hw_12
use hw_12



--# 1. Combine Two Tables

--**Table: Person**
--```
--| Column Name | Type    |
--+-------------+---------+
--| personId    | int     |
--| lastName    | varchar |
--| firstName   | varchar |

--**personId is the primary key (column with unique values) for this table.**
--**This table contains information about the ID of some persons and their first and last names.**

--**Table: Address**


--| Column Name | Type    |
--+-------------+---------+
--| addressId   | int     |
--| personId    | int     |
--| city        | varchar |
--| state       | varchar |


--**AddressId is the primary key (column with unique values) for this table.**
--**Each row of this table contains information about the city and state of one person with ID = PersonId.**


--**Write a solution to report the first name, last name, city, and state of each person in the Person table.**
--**If the address of a personId is not present in the Address table, report null instead.**

--**The result format is in the following example.**

--**Input: Person table:**
--```
--| personId | lastName | firstName |
--+----------+----------+-----------+
--| 1        | Wang     | Allen     |
--| 2        | Alice    | Bob       |
--```

--**Address table:**
--```
--| addressId | personId | city          | state      |
--+-----------+----------+---------------+------------+
--| 1         | 2        | New York City | New York   |
--| 2         | 3        | Leetcode      | California |
--```

--**Output:**
--```

--| firstName | lastName | city          | state    |
--+-----------+----------+---------------+----------+
--| Allen     | Wang     | Null          | Null     |
--| Bob       | Alice    | New York City | New York |


--# Explanation: 
--There is no address in the address table for the personId = 1 so we return null in their city and state.
--addressId = 1 contains information about the address of personId = 2.

Create table Person (personId int, firstName varchar(255), lastName varchar(255))
Create table Address (addressId int, personId int, city varchar(255), state varchar(255))
Truncate table Person
insert into Person (personId, lastName, firstName) values ('1', 'Wang', 'Allen')
insert into Person (personId, lastName, firstName) values ('2', 'Alice', 'Bob')
Truncate table Address
insert into Address (addressId, personId, city, state) values ('1', '2', 'New York City', 'New York')
insert into Address (addressId, personId, city, state) values ('2', '3', 'Leetcode', 'California')

select a.firstName, a.lastName, b.city, b.state from Person a left join Address b on a.personId=b.personId


--# 2. Employees Earning More Than Their Managers

--**Table: Employee**
--```
--| Column Name | Type    |
--+-------------+---------+
--| id          | int     |
--| name        | varchar |
--| salary      | int     |
--| managerId   | int     |
--```

--**Id is the primary key (column with unique values) for this table.**
--**Each row of this table indicates the ID of an employee, their name, salary, and the ID of their manager.**

-----

--**Write a solution to find the employees who earn more than their managers.**

--The result format is in the following example.

--**Input:**
--**Employee table:**
--```
--| id | name  | salary | managerId |
--+----+-------+--------+-----------+
--| 1  | Joe   | 70000  | 3         |
--| 2  | Henry | 80000  | 4         |
--| 3  | Sam   | 60000  | Null      |
--| 4  | Max   | 90000  | Null      |
--```

--**Output:**
--```
--| Employee |
--+----------+
--| Joe      |
--```

--# Explanation: Joe is the only employee who earns more than his manager.


Create table Employee (id int, name varchar(255), salary int, managerId int)
Truncate table Employee
insert into Employee (id, name, salary, managerId) values ('1', 'Joe', '70000', '3')
insert into Employee (id, name, salary, managerId) values ('2', 'Henry', '80000', '4')
insert into Employee (id, name, salary, managerId) values ('3', 'Sam', '60000', NULL)
insert into Employee (id, name, salary, managerId) values ('4', 'Max', '90000', NULL)
 select a.name Employee from Employee a join Employee b on a.managerId=b.id and a.salary>b.salary

--# 3. Duplicate Emails

--| Column Name | Type    |
--+-------------+---------+
--| id          | int     |
--| email       | varchar |

--**Id is the primary key (column with unique values) for this table.**
--**Each row of this table contains an email. The emails will not contain uppercase letters.**

--**Write a solution to report all the duplicate emails. Note that it''s guaranteed that the email field is not NULL.**

--**The result format is in the following example.**

--**Input:**
--**Person table:**
--```
--| id | email   |
--+----+---------+
--| 1  | a@b.com |
--| 2  | c@d.com |
--| 3  | a@b.com |
--```

--**Output:**
--```
--| Email   |
--+---------+
--| a@b.com |
--```

--# Explanation: a@b.com is repeated two times.

drop table Person
Create table  Person (id int, email varchar(255))
Truncate table Person
insert into Person (id, email) values ('1', 'a@b.com')
insert into Person (id, email) values ('2', 'c@d.com')
insert into Person (id, email) values ('3', 'a@b.com')

select Email, count(person.email) from Person 
group by Email
having count(person.email)>=2


--# 4. Delete Duplicate Emails

--**Table: Person**
--```
--| Column Name | Type    |
--+-------------+---------+
--| id          | int     |
--| email       | varchar |
--```

--**Id is the primary key (column with unique values) for this table.**
--**Each row of this table contains an email. The emails will not contain uppercase letters.**
 

--**Write a solution to delete all duplicate emails, keeping only one unique email with the smallest id.**

--**Please note that you are supposed to write a DELETE statement and not a SELECT one.**



--After running your script, the answer shown is the Person table.
--The driver will first compile and run your piece of code and then show the Person table.
--The final order of the Person table does not matter.

--The result format is in the following example.
-----

--**Input:**
--**Person table:**
--```
--| id | email            |
--+----+------------------+
--| 1  | john@example.com |
--| 2  | bob@example.com  |
--| 3  | john@example.com |
--```

--**Output:**

--```
--| id | email            |
--+----+------------------+
--| 1  | john@example.com |
--| 2  | bob@example.com  |
--```
--# Explanation: john@example.com is repeated two times. We keep the row with the smallest Id = 1.

CREATE TABLE  Person (
    id INT PRIMARY KEY,
    email VARCHAR(255)
);
INSERT INTO Person (id, email) VALUES
(1, 'john@example.com'),
(2, 'bob@example.com'),
(3, 'john@example.com');


delete from person 
where id not in (
select min(id) from Person
group by email )

--# 5. Find those parents who has only girls. Return Parent Name only.
CREATE TABLE boys (
    Id INT PRIMARY KEY,
    name VARCHAR(100),
    ParentName VARCHAR(100)
);

CREATE TABLE girls (
    Id INT PRIMARY KEY,
    name VARCHAR(100),
    ParentName VARCHAR(100)
);

INSERT INTO boys (Id, name, ParentName) 
VALUES 
(1, 'John', 'Michael'),  
(2, 'David', 'James'),   
(3, 'Alex', 'Robert'),   
(4, 'Luke', 'Michael'),  
(5, 'Ethan', 'David'),    
(6, 'Mason', 'George');  

INSERT INTO girls (Id, name, ParentName) 
VALUES 
(1, 'Emma', 'Mike'),  
(2, 'Olivia', 'James'),  
(3, 'Ava', 'Robert'),    
(4, 'Sophia', 'Mike'),  
(5, 'Mia', 'John'),      
(6, 'Isabella', 'Emily'),
(7, 'Charlotte', 'George');

select a.ParentName from  girls a  left join boys b on a.ParentName=b.ParentName 
where  b.ParentName is null 
group by a.ParentName
having count(a.name)=1

--# 6. Total over 50 and least
--**Find total Sales amount for the orders which weights more than 50 for each customer along with their least weight.(from TSQL2012 database, Sales.Orders Table)**

--**You can find tsql2012 database in here: https://gist.github.com/alejotima/cac70484db23834591b142ad07e79e67**

select * from Sales.Orders
select custid, sum(Sales) [total Sales], min(weight) from Sales.Orders
group by custid
having weight>50


--# 7. Carts

--**You have the tables below, write a query to get the expected output**

DROP TABLE IF EXISTS Cart1;
DROP TABLE IF EXISTS Cart2;
GO

CREATE TABLE Cart1
(
Item  VARCHAR(100) PRIMARY KEY
);
GO

CREATE TABLE Cart2
(
Item  VARCHAR(100) PRIMARY KEY
);
GO

INSERT INTO Cart1 (Item) VALUES
('Sugar'),('Bread'),('Juice'),('Soda'),('Flour');
GO

INSERT INTO Cart2 (Item) VALUES
('Sugar'),('Bread'),('Butter'),('Cheese'),('Fruit');
GO

--**Expected Output.**

--```
--| Item Cart 1 | Item Cart 2 |  
--|-------------|-------------|  
--| Sugar       | Sugar       | 
--| Bread       | Bread       |  
--| Juice       |             |  
--| Soda        |             |  
--| Flour       |             |
--|             | Butter      |  
--|             | Cheese      |  
--|             | Fruit       |
select isnull(a.Item,'') as [ Item Cart 1],isnull(b.Item,'')as [Item Cart 2] from Cart1 a full join Cart2 b on a.Item=b.Item
order by case when a.Item = b.Item  then 1
			  when a.Item is not null  then 2 
			  else 3  end, a.Item desc, b.Item 

--# 8. Customers Who Never Order
-----

--**Table: Customers**
--```
--| Column Name | Type    |
--+-------------+---------+
--| id          | int     |
--| name        | varchar |
--```


--**Id is the primary key (column with unique values) for this table.**
--**Each row of this table indicates the ID and name of a customer.**


--**Table: Orders**
--```
--| Column Name | Type |
--+-------------+------+
--| id          | int  |
--| customerId  | int  |
--```

--**Id is the primary key (column with unique values) for this table.**
--**customerId is a foreign key (reference columns) of the ID from the Customers table.**
--**Each row of this table indicates the ID of an order and the ID of the customer who ordered it.**

-----

--**Write a solution to find all customers who never order anything.**

--**Return the result table in any order.**

--**The result format is in the following example.**

-----

--**Input:**
--**Customers table:**
--```
--| id | name  |
--+----+-------+
--| 1  | Joe   |
--| 2  | Henry |
--| 3  | Sam   |
--| 4  | Max   |
--```

--**Orders table:**
--```
--| id | customerId |
--+----+------------+
--| 1  | 3          |
--| 2  | 1          |
--```

--**Output:**
--```
--| Customers |
--+-----------+
--| Henry     |
--| Max       |


Create table Customers (id int, name varchar(255))
Create table Orders (id int, customerId int)
Truncate table Customers
insert into Customers (id, name) values ('1', 'Joe')
insert into Customers (id, name) values ('2', 'Henry')
insert into Customers (id, name) values ('3', 'Sam')
insert into Customers (id, name) values ('4', 'Max')
Truncate table Orders
insert into Orders (id, customerId) values ('1', '3')
insert into Orders (id, customerId) values ('2', '1')

select a.name from Customers a 
left join Orders b 
on a.id=b.customerId 
where  b.id is null

--# 9. Students and Examinations
-----

--**Table: Students**

--```
--| Column Name   | Type    |
--+---------------+---------+
--| student_id    | int     |
--| student_name  | varchar |
--```

--**student_id is the primary key (column with unique values) for this table.**
--**Each row of this table contains the ID and the name of one student in the school.**
 

--**Table: Subjects**

--```
--| Column Name  | Type    |
--+--------------+---------+
--| subject_name | varchar |
--```

--**subject_name is the primary key (column with unique values) for this table.**
--**Each row of this table contains the name of one subject in the school.**

--**Table: Examinations**

--```
--| Column Name  | Type    |
--+--------------+---------+
--| student_id   | int     |
--| subject_name | varchar |
--```


--**There is no primary key (column with unique values) for this table. It may contain duplicates.**
--**Each student from the Students table takes every course from the Subjects table.**
--**Each row of this table indicates that a student with ID student_id attended the exam of subject_name.**

----- 


--**Write a solution to find the number of times each student attended each exam.**

--**Return the result table ordered by student_id and subject_name.**

--**The result format is in the following example.**

-----

--**Input: Students table:**
--```
--| student_id | student_name |
--+------------+--------------+
--| 1          | Alice        |
--| 2          | Bob          |
--| 13         | John         |
--| 6          | Alex         |
--```


--**Subjects table:**
--```
--| subject_name |
--+--------------+
--| Math         |
--| Physics      |
--| Programming  |
--```

--**Examinations table:**
--```
--| student_id | subject_name |
--+------------+--------------+
--| 1          | Math         |
--| 1          | Physics      |
--| 1          | Programming  |
--| 2          | Programming  |
--| 1          | Physics      |
--| 1          | Math         |
--| 13         | Math         |
--| 13         | Programming  |
--| 13         | Physics      |
--| 2          | Math         |
--| 1          | Math         |
--```


--**Output:**
--```
--| student_id | student_name | subject_name | attended_exams |
--+------------+--------------+--------------+----------------+
--| 1          | Alice        | Math         | 3              |
--| 1          | Alice        | Physics      | 2              |
--| 1          | Alice        | Programming  | 1              |
--| 2          | Bob          | Math         | 1              |
--| 2          | Bob          | Physics      | 0              |
--| 2          | Bob          | Programming  | 1              |
--| 6          | Alex         | Math         | 0              |
--| 6          | Alex         | Physics      | 0              |
--| 6          | Alex         | Programming  | 0              |
--| 13         | John         | Math         | 1              |
--| 13         | John         | Physics      | 1              |
--| 13         | John         | Programming  | 1              |


Create table Students (student_id int, student_name varchar(20))
Create table Subjects (subject_name varchar(20))
Create table Examinations (student_id int, subject_name varchar(20))
Truncate table Students
insert into Students (student_id, student_name) values ('1', 'Alice')
insert into Students (student_id, student_name) values ('2', 'Bob')
insert into Students (student_id, student_name) values ('13', 'John')
insert into Students (student_id, student_name) values ('6', 'Alex')
Truncate table Subjects
insert into Subjects (subject_name) values ('Math')
insert into Subjects (subject_name) values ('Physics')
insert into Subjects (subject_name) values ('Programming')
Truncate table Examinations
insert into Examinations (student_id, subject_name) values ('1', 'Math')
insert into Examinations (student_id, subject_name) values ('1', 'Physics')
insert into Examinations (student_id, subject_name) values ('1', 'Programming')
insert into Examinations (student_id, subject_name) values ('2', 'Programming')
insert into Examinations (student_id, subject_name) values ('1', 'Physics')
insert into Examinations (student_id, subject_name) values ('1', 'Math')
insert into Examinations (student_id, subject_name) values ('13', 'Math')
insert into Examinations (student_id, subject_name) values ('13', 'Programming')
insert into Examinations (student_id, subject_name) values ('13', 'Physics')
insert into Examinations (student_id, subject_name) values ('2', 'Math')
insert into Examinations (student_id, subject_name) values ('1', 'Math')

select * from Students 
select * from Subjects 
select * from Examinations 


--**Write a solution to find the number of times each student attended each exam.**

--**Return the result table ordered by student_id and subject_name.**


select a.student_id,b.subject_name, count(b.subject_name) [attended exam] from Students a  
left join Examinations  b 
on a.student_id=b.student_id
left  join Subjects c 
on b.subject_name=c.subject_name
group by a.student_id,b.subject_name

