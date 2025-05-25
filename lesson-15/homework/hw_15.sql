create database hw_15
use hw_15


--## Level 1: Basic Subqueries

--# 1. Find Employees with Minimum Salary

--**Task: Retrieve employees who earn the minimum salary in the company.**
--**Tables: employees (columns: id, name, salary)**

drop table employees
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2)
);

INSERT INTO employees (id, name, salary ) VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 50000);

select *from employees
where salary=(select min(salary) from employees)

--# 2. Find Products Above Average Price

--**Task: Retrieve products priced above the average price.**
--**Tables: products (columns: id, product_name, price)**
drop table products
CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

INSERT INTO products (id, product_name, price) VALUES
(1, 'Laptop', 1200),
(2, 'Tablet', 400),
(3, 'Smartphone', 800),
(4, 'Monitor', 300);

select * from products
where price>(select avg(price) from products)

--## Level 2: Nested Subqueries with Conditions

--**3. Find Employees in Sales Department**
--**Task: Retrieve employees who work in the "Sales" department.**
--**Tables: employees (columns: id, name, department_id), departments (columns: id, department_name)**
drop table departments
CREATE TABLE departments (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);
drop table employees
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

INSERT INTO departments (id, department_name) VALUES
(1, 'Sales'),
(2, 'HR');

INSERT INTO employees (id, name, department_id) VALUES
(1, 'David', 1),
(2, 'Eve', 2),
(3, 'Frank', 1);

select e.id,e.name,a.department_name from departments a
join  employees e on a.id=e.id and department_name='sales'

;WITH SalesEmployees AS (
    SELECT e.id, e.name, d.department_name
    FROM employees e
    JOIN 
        departments d ON e.id = d.id
    WHERE 
        d.department_name = 'Sales'
)
SELECT * FROM SalesEmployees;

--# 4. Find Customers with No Orders
--**Task: Retrieve customers who have not placed any orders.**
--**Tables: customers (columns: customer_id, name), orders (columns: order_id, customer_id)**

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100)
);
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
INSERT INTO customers (customer_id, name) VALUES
(1, 'Grace'),
(2, 'Heidi'),
(3, 'Ivan');
INSERT INTO orders (order_id, customer_id) VALUES
(1, 1),
(2, 1);
select * from customers
select * from orders

;with no_orders as(select a.customer_id,a.name from customers a 
left join orders b 
on a.customer_id=b.customer_id 
where  b.order_id is null)
select * from no_orders

--## Level 3: Aggregation and Grouping in Subqueries

--# 5. Find Products with Max Price in Each Category
--**Task: Retrieve products with the highest price in each category.**
--**Tables: products (columns: id, product_name, price, category_id)**
drop table products
CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT
);

INSERT INTO products (id, product_name, price, category_id) VALUES
(1, 'Tablet', 400, 1),
(2, 'Laptop', 1500, 1),
(3, 'Headphones', 200, 2),
(4, 'Speakers', 300, 2);
select * from products
;with cte as (select category_id, max(price)  max_price from products
group by category_id) select a.category_id,a.product_name,b.max_price from products a join cte b
on a.category_id=b.category_id and a.price=b.max_price

--# 6. Find Employees in Department with Highest Average Salary

--**Task: Retrieve employees working in the department with the highest average salary.**
--**Tables: employees (columns: id, name, salary, department_id), departments (columns: id, department_name)**
drop table if exists departments
CREATE TABLE departments (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);
drop table if exists employees
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);
INSERT INTO departments (id, department_name) VALUES
(1, 'IT'),
(2, 'Sales');

INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Jack', 80000, 1),
(2, 'Karen', 70000, 1),
(3, 'Leo', 60000, 2);

select * from employees
select * from departments

;with avg_salary_per_dept as (select department_id,avg(salary) as avg_salary from employees
group by department_id),
max_avg_dept AS (
    SELECT TOP 1 department_id
    FROM avg_salary_per_dept
    ORDER BY avg_salary DESC
)
SELECT *
FROM employees
WHERE department_id IN (SELECT department_id FROM max_avg_dept);

--## Level 4: Correlated Subqueries

--# 7. Find Employees Earning Above Department Average

--**Task: Retrieve employees earning more than the average salary in their department.**
--**Tables: employees (columns: id, name, salary, department_id)**
drop table if exists employees
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT
);

INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Mike', 50000, 1),
(2, 'Nina', 75000, 1),
(3, 'Olivia', 40000, 2),
(4, 'Paul', 55000, 2);
select * from employees
;with cte as(select a.id,a.name,a.salary from employees a join employees b on a.department_id=b.id 
where a.salary>(select avg( salary) from employees)) select * from cte

--# 8. Find Students with Highest Grade per Course

--**Task: Retrieve students who received the highest grade in each course.**
--**Tables: students (columns: student_id, name), grades (columns: student_id, course_id, grade)**

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE grades (
    student_id INT,
    course_id INT,
    grade DECIMAL(4, 2),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

INSERT INTO students (student_id, name) VALUES
(1, 'Sarah'),
(2, 'Tom'),
(3, 'Uma');

INSERT INTO grades (student_id, course_id, grade) VALUES
(1, 101, 95),
(2, 101, 85),
(3, 102, 90),
(1, 102, 80);
select * from students
select * from grades
;with max_grade as (select course_id,max(grade) max_grade from students a join grades b on a.student_id=b.student_id 
group by course_id) select a.student_id,a.name,b.course_id,c.max_grade from students a join grades b on a.student_id=b.student_id
join max_grade c on c.course_id=b.course_id and c.max_grade=b.grade

--## Level 5: Subqueries with Ranking and Complex Conditions

--**9. Find Third-Highest Price per Category**
--**Task: Retrieve products with the third-highest price in each category.**
--**Tables: products (columns: id, product_name, price, category_id)**
drop table if exists products
CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT
);
INSERT INTO products (id, product_name, price, category_id) VALUES
(1, 'Phone', 800, 1),
(2, 'Laptop', 1500, 1),
(3, 'Tablet', 600, 1),
(4, 'Smartwatch', 300, 1),
(5, 'Headphones', 200, 2),
(6, 'Speakers', 300, 2),
(7, 'Earbuds', 100, 2);

select  top 1* from (select top 3 * from products order by price desc ) ranked order by price

select * from products as a 
where 3=(select COUNT(price) from products as b where a.price<=b.price)

--# 10. Find Employees whose Salary Between Company Average and Department Max Salary

--**Task: Retrieve employees with salaries above the company average but below the maximum in their department.**
--**Tables: employees (columns: id, name, salary, department_id)**
drop table if exists employees
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT
);
INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Alex', 70000, 1),
(2, 'Blake', 90000, 1),
(3, 'Casey', 50000, 2),
(4, 'Dana', 60000, 2),
(5, 'Evan', 75000, 1);

;with company_avg as(select AVG(salary) avg_salary from employees),
dep_max as(select department_id,max(salary) max_salary from employees
group by department_id)
select a.*  from employees a join company_avg b on b.avg_salary<a.salary
join dep_max c on a.department_id=c.department_id and a.salary<c.max_salary

;with company_avg as(select AVG(salary) as avg_salary from employees ),
dept_max_salary as(select department_id,MAX(salary) max_salary_dep from employees group by department_id)
select a.* from employees a join company_avg b on a.salary>b.avg_salary
join dept_max_salary c on a.department_id=c.department_id and a.salary<c.max_salary_dep


