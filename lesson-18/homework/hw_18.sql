create database hw_18
use hw_18

--You're working in a database for a Retail Sales System. The database contains the following tables:
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products (ProductID, ProductName, Category, Price)
VALUES
(1, 'Samsung Galaxy S23', 'Electronics', 899.99),
(2, 'Apple iPhone 14', 'Electronics', 999.99),
(3, 'Sony WH-1000XM5 Headphones', 'Electronics', 349.99),
(4, 'Dell XPS 13 Laptop', 'Electronics', 1249.99),
(5, 'Organic Eggs (12 pack)', 'Groceries', 3.49),
(6, 'Whole Milk (1 gallon)', 'Groceries', 2.99),
(7, 'Alpen Cereal (500g)', 'Groceries', 4.75),
(8, 'Extra Virgin Olive Oil (1L)', 'Groceries', 8.99),
(9, 'Mens Cotton T-Shirt', 'Clothing', 12.99),
(10, 'Womens Jeans - Blue', 'Clothing', 39.99),
(11, 'Unisex Hoodie - Grey', 'Clothing', 29.99),
(12, 'Running Shoes - Black', 'Clothing', 59.95),
(13, 'Ceramic Dinner Plate Set (6 pcs)', 'Home & Kitchen', 24.99),
(14, 'Electric Kettle - 1.7L', 'Home & Kitchen', 34.90),
(15, 'Non-stick Frying Pan - 28cm', 'Home & Kitchen', 18.50),
(16, 'Atomic Habits - James Clear', 'Books', 15.20),
(17, 'Deep Work - Cal Newport', 'Books', 14.35),
(18, 'Rich Dad Poor Dad - Robert Kiyosaki', 'Books', 11.99),
(19, 'LEGO City Police Set', 'Toys', 49.99),
(20, 'Rubiks Cube 3x3', 'Toys', 7.99);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate)
VALUES
(1, 1, 2, '2025-04-01'),
(2, 1, 1, '2025-04-05'),
(3, 2, 1, '2025-04-10'),
(4, 2, 2, '2025-04-15'),
(5, 3, 3, '2025-04-18'),
(6, 3, 1, '2025-04-20'),
(7, 4, 2, '2025-04-21'),
(8, 5, 10, '2025-04-22'),
(9, 6, 5, '2025-04-01'),
(10, 6, 3, '2025-04-11'),
(11, 10, 2, '2025-04-08'),
(12, 12, 1, '2025-04-12'),
(13, 12, 3, '2025-04-14'),
(14, 19, 2, '2025-04-05'),
(15, 20, 4, '2025-04-19'),
(16, 1, 1, '2025-03-15'),
(17, 2, 1, '2025-03-10'),
(18, 5, 5, '2025-02-20'),
(19, 6, 6, '2025-01-18'),
(20, 10, 1, '2024-12-25'),
(21, 1, 1, '2024-04-20');

--### 1. Create a temporary table named MonthlySales to store the total quantity sold and total revenue for each product 
--in the current month. Return: ProductID, TotalQuantity, TotalRevenue**
CREATE TABLE #MonthlySales1 (
    ProductID INT,
    TotalQuantity INT,
    TotalRevenue DECIMAL(18, 2)
);

insert into #Monthlysales1 (ProductID, TotalQuantity, TotalRevenue)
SELECT 
    a.ProductID,year(a.SaleDate) AS SaleYear ,month(a.SaleDate)AS SaleMonth,
    SUM(a.Quantity) AS TotalQuantity,
    SUM(a.Quantity * b.Price) AS TotalRevenue
FROM Sales a
JOIN Products b ON a.ProductID = b.ProductID
--where a.SaleDate between '2025-03-01' and '2025-03-31'
GROUP BY a.ProductID,year(a.SaleDate),month(a.SaleDate)
order by SaleYear,SaleMonth

-- function orqali ishlaymiz
create function dbo.fn_GetMonthlySales
(
	@StartDate date,
	@EndDate date
)
returns table
as 
return
(
select 
a.ProductID,
YEAR(a.SaleDate) as saleyear, 
MONTH(a.SaleDate) as salemonth,
SUM(a.Quantity) as totalQuantity,
SUM(a.Quantity*b.Price) as totalRevenue
from Sales a 
join Products b on a.ProductID=b.ProductID
where a.SaleDate between @StartDate and @EndDate
group by
a.ProductID,
YEAR(a.SaleDate) , 
MONTH(a.SaleDate) 
)

select * from dbo.fn_GetMonthlySales('2025-01-01','2025-02-27')

--### 2. Create a view named vw_ProductSalesSummary that returns product info along with total sales quantity across all time.
--**Return: ProductID, ProductName, Category, TotalQuantitySold**
drop view vw_ProductSalesSummary
create view vw_ProductSalesSummary as
select 
	a.ProductID,
	a.ProductName,
	a.Category, 
	sum(b.Quantity) as Total_Quantity_Sold 
from Products a 
join Sales b 
on a.ProductID=b.ProductID
group by 
	a.ProductID,
	a.ProductName,
	a.Category

select * from vw_ProductSalesSummary

--### 3. Create a function named fn_GetTotalRevenueForProduct(@ProductID INT)
--**Return: total revenue for the given product ID**
drop function dbo.fn_GetTotalRevenueForProduct
create function dbo.fn_GetTotalRevenueForProduct
(
@ProductID int
)
returns table 
as 
return(
select 
sum(a.Price*b.Quantity) as total_revenue_for_the_given_product
from Products a 
join Sales b 
on a.ProductID=b.ProductID
where a.ProductID= @ProductID)

select * from dbo.fn_GetTotalRevenueForProduct(5)

--### 4. Create an function fn_GetSalesByCategory(@Category VARCHAR(50))
--**Return: ProductName, TotalQuantity, TotalRevenue for all products in that category.**
create function fn_GetSalesByCategory(@Category varchar(50))
returns table 
as
return
(select 
	b.ProductName,
	sum(a.Quantity) as totalQuantity, 
	SUM(a.Quantity*b.Price) as total_revenue 
from Sales a 
join Products b 
on a.ProductID=b.ProductID
where b.Category=@Category
group by b.ProductName
)
select * from dbo.fn_GetSalesByCategory('electronics')

--### 5. You have to create a function that get one argument as input from user and 
--the function should return 'Yes' if the input number is a prime number and 'No' otherwise. You can start it like this:

Create function dbo.fn_IsPrime 
(
@Number INT
)
returns varchar(3) 
as 

begin
	 declare @i int=2;
	 declare @is_prime BIT =1;
	 DECLARE @result VARCHAR(3);

	 if @Number<=1
	 begin
		set @result= 'NO';
		return @result
	end
	 while @i*@i<=@Number
	 begin
		if @Number%@i=0
		begin 
			set @is_prime=0;
			break;
		end
		set @i=@i+1;
	 end

	 if @is_prime=1
		set @result='Yes';
	else
		set @result= 'NO';
	return @result
end

select dbo.fn_IsPrime(197) 

--### 6. Create a table-valued function named fn_GetNumbersBetween that accepts two integers as input:
alter function fn_GetNumbersBetween(@Start INT,@End INT)
returns @result table( Number  int)
as
begin
	with numberscte as(
	select @Start as Number
	union all
	select Number+2 from numberscte
	where Number+2<=@End
	)
	insert into @result
	select Number from numberscte;

	return;
end

select * from dbo.fn_GetNumbersBetween(15,105)

--### 7. Write a SQL query to return the Nth highest distinct salary from the 
--Employee table. If there are fewer than N distinct salaries, return NULL. 
create table employee(
id int,
salary int)
insert into employee(id,salary) values
(1,100),
(2,200),
(3,300)

select * from employee

create function dbo.getNthHighestSalary( @n int)
returns @result 
table
(highestNsalary int)
as 
begin
	insert into @result(highestNsalary)
	select salary from
	(
	select distinct salary,
	DENSE_RANK() over(order by salary desc) 
	as rnk from employee
	) as ranked_salaries
	where rnk=@n

	if not exists (select 1 from @result)
	insert into @result values(null)
	return
end

select * from dbo.getNthHighestSalary(4)

--stored proc da ishlanishi

CREATE PROCEDURE dbo.sp_GetNthHighestSalary @n INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Temp table yoki inline query orqali natija chiqarish
    SELECT TOP 1 salary AS HighestNSalary
    FROM (
        SELECT DISTINCT salary,
               DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
        FROM employee
    ) AS ranked_salaries
    WHERE rnk = @n;

    -- Agar hech narsa topilmasa NULL qaytarish
    IF @@ROWCOUNT = 0
        SELECT CAST(NULL AS INT) AS HighestNSalary;
END;
EXEC dbo.sp_GetNthHighestSalary @n = 1;

--### n = 2

--**Output:**

--| getNthHighestSalary(2) |


--|    HighestNSalary      |
--|------------------------|
--| 200                    |


create table employees(id int , salary int)

insert into employees values
(1,100)

create function dbo.getNthHighestSalary2(@n int)
returns @result  


--### Example 2:

--**Input.Employee table:**

--| id | salary |
--|----|--------|
--| 1  | 100    |

--### n = 2

--**Output:**

| getNthHighestSalary(2) |


|    HighestNSalary      |
|        null            |



--### 8. Write a SQL query to find the person who has the most friends.

--**Return: Their id, The total number of friends they have**

--#### Friendship is mutual. For example, if user A sends a request to user B and it's accepted, both A and B are considered friends with each other. The test case is guaranteed to have only one user with the most friends.

--**Input.RequestAccepted table:**


--| requester_id | accepter_id | accept_date |
--+--------------+-------------+-------------+
--| 1            | 2           | 2016/06/03  |
--| 1            | 3           | 2016/06/08  |
--| 2            | 3           | 2016/06/08  |
--| 3            | 4           | 2016/06/09  |


--**Output:** 

--| id | num |
--+----+-----+
--| 3  | 3   |

CREATE TABLE RequestAccepted (
    requester_id INT,
    accepter_id INT,
    accept_date DATE
);

INSERT INTO RequestAccepted (requester_id, accepter_id, accept_date) VALUES
(1, 2, '2016-06-03'),
(1, 3, '2016-06-08'),
(2, 3, '2016-06-08'),
(3, 4, '2016-06-09');

SELECT TOP 1 
    id, 
    COUNT(*) AS num
FROM (
    SELECT requester_id AS id FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS id FROM RequestAccepted
) AS all_friends
GROUP BY id
ORDER BY num DESC;


--**Explanation: The person with id 3 is a friend of people 1, 2, and 4, so he has three friends in total, which is the most number than any others.**

--**You can also solve this in Leetcode: https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/description/?envType=study-plan-v2&envId=top-sql-50**

--### 9. Create a View for Customer Order Summary. 

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    order_date DATE,
    amount DECIMAL(10,2)
);

INSERT INTO Customers (customer_id, name, city)
VALUES
(1, 'Alice Smith', 'New York'),
(2, 'Bob Jones', 'Chicago'),
(3, 'Carol White', 'Los Angeles');

INSERT INTO Orders (order_id, customer_id, order_date, amount)
VALUES
(101, 1, '2024-12-10', 120.00),
(102, 1, '2024-12-20', 200.00),
(103, 1, '2024-12-30', 220.00),
(104, 2, '2025-01-12', 120.00),
(105, 2, '2025-01-20', 180.00);

--**Create a view called vw_CustomerOrderSummary that returns a summary of customer orders. The view must contain the following columns:**

--> - Column Name | Description
--> - customer_id | Unique identifier of the customer
--> - name | Full name of the customer
--> - total_orders | Total number of orders placed by the customer
--> - total_amount | Cumulative amount spent across all orders
--> - last_order_date | Date of the most recent order placed by the customer

CREATE VIEW vw_CustomerOrderSummary AS
SELECT
  c.customer_id,
  c.name,
  COUNT(o.order_id) AS total_orders,
  COALESCE(SUM(o.amount), 0) AS total_amount,
  MAX(o.order_date) AS last_order_date
FROM
  Customers c
LEFT JOIN
  Orders o ON c.customer_id = o.customer_id
GROUP BY
  c.customer_id, c.name;

  select * from vw_CustomerOrderSummary

--### 10. Write an SQL statement to fill in the missing gaps. You have to write only select statement, no need to modify the table.

--| RowNumber | Workflow |
--|----------------------|
--| 1         | Alpha    |
--| 2         |          |
--| 3         |          |
--| 4         |          |
--| 5         | Bravo    |
--| 6         |          |
--| 7         |          |
--| 8         |          |
--| 9         |          |
--| 10        | Charlie  |
--| 11        |          |
--| 12        |          |


--**Here is the expected output.**

--| RowNumber | Workflow |
--|----------------------|
--| 1         | Alpha    |
--| 2         | Alpha    |
--| 3         | Alpha    |
--| 4         | Alpha    |
--| 5         | Bravo    |
--| 6         | Bravo    |
--| 7         | Bravo    |
--| 8         | Bravo    |
--| 9         | Bravo    |
--| 10        | Charlie  |
--| 11        | Charlie  |
--| 12        | Charlie  |

CREATE TABLE Gaps
(
RowNumber   INTEGER PRIMARY KEY,
TestCase    VARCHAR(100) NULL
);

INSERT INTO Gaps (RowNumber, TestCase) VALUES
(1,'Alpha'),(2,NULL),(3,NULL),(4,NULL),
(5,'Bravo'),(6,NULL),(7,'Charlie'),(8,NULL),(9,NULL);

SELECT 
    RowNumber,
    MAX(TestCase) OVER (
        ORDER BY RowNumber
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS Workflow
FROM Gaps;
