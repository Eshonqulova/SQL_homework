create database hw_20
use hw_20

CREATE TABLE #Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    Price DECIMAL(10,2),
    SaleDate DATE
);

INSERT INTO #Sales (CustomerName, Product, Quantity, Price, SaleDate) VALUES
('Alice', 'Laptop', 1, 1200.00, '2024-01-15'),
('Bob', 'Smartphone', 2, 800.00, '2024-02-10'),
('Charlie', 'Tablet', 1, 500.00, '2024-02-20'),
('David', 'Laptop', 1, 1300.00, '2024-03-05'),
('Eve', 'Smartphone', 3, 750.00, '2024-03-12'),
('Frank', 'Headphones', 2, 100.00, '2024-04-08'),
('Grace', 'Smartwatch', 1, 300.00, '2024-04-25'),
('Hannah', 'Tablet', 2, 480.00, '2024-05-05'),
('Isaac', 'Laptop', 1, 1250.00, '2024-05-15'),
('Jack', 'Smartphone', 1, 820.00, '2024-06-01');

--1. Find customers who purchased at least one item in March 2024 using EXISTS

SELECT DISTINCT s1.CustomerName FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s2.CustomerName = s1.CustomerName
      AND s2.SaleDate >= '2024-03-01'
      AND s2.SaleDate < '2024-04-01'
);

--2. Find the product with the highest total sales revenue using a subquery.
 
;WITH cte AS (
    SELECT Product, SUM(Quantity * Price) AS total_revenue_per_product
    FROM #Sales
    GROUP BY Product
)
SELECT Product, total_revenue_per_product
FROM cte
WHERE total_revenue_per_product = (
    SELECT MAX(total_revenue_per_product) FROM cte
);

--3. Find the second highest sale amount using a subquery
;with cte as (select Product,SUM(Quantity * Price) AS total_revenue from #Sales
group by Product)
select top 1 * from cte 
where total_revenue<(select MAX(total_revenue) from cte)
order by total_revenue desc

;with cte as (select Product,SUM(Quantity * Price) AS total_revenue from #Sales
group by Product)
select * from cte 
order by total_revenue desc
offset 1 rows fetch next 1 row only

--4. Find the total quantity of products sold per month using a subquery
 select  month(saledate) as month,sum(Quantity) as total_quantity  from #Sales 
group by  month(saledate) 

SELECT 
	DISTINCT MONTH(s1.SaleDate) AS Month, 
	s1.Product, 
	( SELECT SUM(s2.Quantity)  FROM #Sales AS s2  
	WHERE MONTH(s2.SaleDate) = MONTH(s1.SaleDate) AND s2.Product = s1.Product) AS total_quantity FROM #Sales AS s1
ORDER BY Month, Product;

--5. Find customers who bought same products as another customer using EXISTS

SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s1.Product = s2.Product
      AND s1.CustomerName <> s2.CustomerName
);

--6. Return how many fruits does each person have in individual fruit level
SELECT Name, 
       ISNULL([Apple], 0) AS Apple, 
       ISNULL([Orange], 0) AS Orange, 
       ISNULL([Banana], 0) AS Banana
FROM (
    SELECT Name, Fruit
    FROM Fruits
) AS src
PIVOT (
    COUNT(Fruit)
    FOR Fruit IN ([Apple], [Orange], [Banana])
) AS p;

  
--Expected Output

--+-----------+-------+--------+--------+
--| Name      | Apple | Orange | Banana |
--+-----------+-------+--------+--------+
--| Francesko |   3   |   2    |   1    |
--| Li        |   2   |   1    |   1    |
--| Mario     |   3   |   1    |   2    |
--+-----------+-------+--------+--------+
--7. Return older people in the family with younger ones
--create table Family(ParentId int, ChildID int)
--insert into Family values (1, 2), (2, 3), (3, 4)
--1 Oldest person in the family --grandfather 2 Father 3 Son 4 Grandson

--Expected output

--+-----+-----+
--| PID |CHID |
--+-----+-----+
--|  1  |  2  |
--|  1  |  3  |
--|  1  |  4  |
--|  2  |  3  |
--|  2  |  4  |
--|  3  |  4  |
--+-----+-----+
-- Create the table and insert sample data
CREATE TABLE Family (ParentID INT, ChildID INT);
INSERT INTO Family VALUES (1, 2), (2, 3), (3, 4);

-- Recursive query to get all ancestor-descendant pairs
WITH Ancestors AS (
    SELECT ParentID AS PID, ChildID AS CHID
    FROM Family
    UNION ALL
    SELECT a.PID, f.ChildID
    FROM Ancestors a
    JOIN Family f ON a.CHID = f.ParentID
)
SELECT * FROM Ancestors
ORDER BY PID, CHID;

--8. Write an SQL statement given the following requirements. For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas
CREATE TABLE #Orders
(
CustomerID     INTEGER,
OrderID        INTEGER,
DeliveryState  VARCHAR(100) NOT NULL,
Amount         MONEY NOT NULL,
PRIMARY KEY (CustomerID, OrderID)
);


INSERT INTO #Orders (CustomerID, OrderID, DeliveryState, Amount) VALUES
(1001,1,'CA',340),(1001,2,'TX',950),(1001,3,'TX',670),
(1001,4,'TX',860),(2002,5,'WA',320),(3003,6,'CA',650),
(3003,7,'CA',830),(4004,8,'TX',120);

-- Create and insert into the Orders table
CREATE TABLE #Orders
(
    CustomerID     INTEGER,
    OrderID        INTEGER,
    DeliveryState  VARCHAR(100) NOT NULL,
    Amount         MONEY NOT NULL,
    PRIMARY KEY (CustomerID, OrderID)
);

INSERT INTO #Orders (CustomerID, OrderID, DeliveryState, Amount) VALUES
(1001,1,'CA',340),(1001,2,'TX',950),(1001,3,'TX',670),
(1001,4,'TX',860),(2002,5,'WA',320),(3003,6,'CA',650),
(3003,7,'CA',830),(4004,8,'TX',120);

-- Query to get Texas orders for customers who had at least one delivery to California
SELECT *
FROM #Orders o
WHERE o.DeliveryState = 'TX'
  AND EXISTS (
      SELECT 1
      FROM #Orders o2
      WHERE o2.CustomerID = o.CustomerID
        AND o2.DeliveryState = 'CA'
  )
ORDER BY o.CustomerID, o.OrderID;


--9. Insert the names of residents if they are missing
create table #residents(resid int identity, fullname varchar(50), address varchar(100))

insert into #residents values 
('Dragan', 'city=Bratislava country=Slovakia name=Dragan age=45'),
('Diogo', 'city=Lisboa country=Portugal age=26'),
('Celine', 'city=Marseille country=France name=Celine age=21'),
('Theo', 'city=Milan country=Italy age=28'),
('Rajabboy', 'city=Tashkent country=Uzbekistan age=22')
UPDATE #residents
SET fullname = 
    SUBSTRING(
        address,
        CHARINDEX('name=', address) + 5,
        CHARINDEX(' ', address + ' ', CHARINDEX('name=', address)) - CHARINDEX('name=', address) - 5
    )
WHERE fullname NOT LIKE '%' + SUBSTRING(
        address,
        CHARINDEX('name=', address) + 5,
        CHARINDEX(' ', address + ' ', CHARINDEX('name=', address)) - CHARINDEX('name=', address) - 5
    ) + '%';

--10. Write a query to return the route to reach from Tashkent to Khorezm. The result should include the cheapest and the most expensive routes
CREATE TABLE #Routes
(
RouteID        INTEGER NOT NULL,
DepartureCity  VARCHAR(30) NOT NULL,
ArrivalCity    VARCHAR(30) NOT NULL,
Cost           MONEY NOT NULL,
PRIMARY KEY (DepartureCity, ArrivalCity)
);

INSERT INTO #Routes (RouteID, DepartureCity, ArrivalCity, Cost) VALUES
(1,'Tashkent','Samarkand',100),
(2,'Samarkand','Bukhoro',200),
(3,'Bukhoro','Khorezm',300),
(4,'Samarkand','Khorezm',400),
(5,'Tashkent','Jizzakh',100),
(6,'Jizzakh','Samarkand',50);
--Expected Output

--|             Route                                 |Cost |
--|Tashkent - Samarkand - Khorezm                     | 500 |
--|Tashkent - Jizzakh - Samarkand - Bukhoro - Khorezm | 650 |

-- Recursive CTE to find all paths from Tashkent to Khorezm
WITH Paths AS (
    -- Anchor member: start from Tashkent
    SELECT 
        RouteID,
        DepartureCity,
        ArrivalCity,
        CAST(DepartureCity + ' - ' + ArrivalCity AS VARCHAR(MAX)) AS Route,
        Cost
    FROM #Routes
    WHERE DepartureCity = 'Tashkent'

    UNION ALL

    -- Recursive member: keep joining where arrival = departure of next segment
    SELECT 
        r.RouteID,
        p.DepartureCity,
        r.ArrivalCity,
        CAST(p.Route + ' - ' + r.ArrivalCity AS VARCHAR(MAX)) AS Route,
        p.Cost + r.Cost AS Cost
    FROM Paths p
    JOIN #Routes r ON p.ArrivalCity = r.DepartureCity
    WHERE p.Route NOT LIKE '%' + r.ArrivalCity + '%' -- avoid cycles
)

-- Final selection: only those that end in Khorezm
SELECT Route, Cost
FROM Paths
WHERE ArrivalCity = 'Khorezm'
ORDER BY Cost;

--11. Rank products based on their order of insertion.
CREATE TABLE #RankingPuzzle
(
     ID INT
    ,Vals VARCHAR(10)
)

 
INSERT INTO #RankingPuzzle VALUES
(1,'Product'),
(2,'a'),
(3,'a'),
(4,'a'),
(5,'a'),
(6,'Product'),
(7,'b'),
(8,'b'),
(9,'Product'),
(10,'c')

WITH ProductGroups AS (
    SELECT *,
           COUNT(CASE WHEN Vals = 'Product' THEN 1 END) 
               OVER (ORDER BY ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS GroupRank
    FROM #RankingPuzzle
)
SELECT ID, Vals, GroupRank
FROM ProductGroups
WHERE Vals <> 'Product'
ORDER BY ID;

/**Question 12
Find employees whose sales were higher than the average sales in their department**/
CREATE TABLE #EmployeeSales (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    SalesAmount DECIMAL(10,2),
    SalesMonth INT,
    SalesYear INT
);

INSERT INTO #EmployeeSales (EmployeeName, Department, SalesAmount, SalesMonth, SalesYear) VALUES
('Alice', 'Electronics', 5000, 1, 2024),
('Bob', 'Electronics', 7000, 1, 2024),
('Charlie', 'Furniture', 3000, 1, 2024),
('David', 'Furniture', 4500, 1, 2024),
('Eve', 'Clothing', 6000, 1, 2024),
('Frank', 'Electronics', 8000, 2, 2024),
('Grace', 'Furniture', 3200, 2, 2024),
('Hannah', 'Clothing', 7200, 2, 2024),
('Isaac', 'Electronics', 9100, 3, 2024),
('Jack', 'Furniture', 5300, 3, 2024),
('Kevin', 'Clothing', 6800, 3, 2024),
('Laura', 'Electronics', 6500, 4, 2024),
('Mia', 'Furniture', 4000, 4, 2024),
('Nathan', 'Clothing', 7800, 4, 2024);
SELECT *
FROM #EmployeeSales e
WHERE SalesAmount > (
    SELECT AVG(SalesAmount)
    FROM #EmployeeSales
    WHERE Department = e.Department
);

/**13. Find employees who had the highest sales in any given month using EXISTS**/

SELECT e1.EmployeeName, e1.SalesMonth, e1.SalesYear, e1.SalesAmount
FROM #EmployeeSales e1
WHERE EXISTS (
    SELECT 1
    FROM #EmployeeSales e2
    WHERE e1.SalesMonth = e2.SalesMonth
      AND e1.SalesYear = e2.SalesYear
    GROUP BY e2.SalesMonth, e2.SalesYear
    HAVING e1.SalesAmount = MAX(e2.SalesAmount)
);

/**14. Find employees who made sales in every month using NOT EXISTS**/
CREATE TABLE Products (
    ProductID   INT PRIMARY KEY,
    Name        VARCHAR(50),
    Category    VARCHAR(50),
    Price       DECIMAL(10,2),
    Stock       INT
);

INSERT INTO Products (ProductID, Name, Category, Price, Stock) VALUES
(1, 'Laptop', 'Electronics', 1200.00, 15),
(2, 'Smartphone', 'Electronics', 800.00, 30),
(3, 'Tablet', 'Electronics', 500.00, 25),
(4, 'Headphones', 'Accessories', 150.00, 50),
(5, 'Keyboard', 'Accessories', 100.00, 40),
(6, 'Monitor', 'Electronics', 300.00, 20),
(7, 'Mouse', 'Accessories', 50.00, 60),
(8, 'Chair', 'Furniture', 200.00, 10),
(9, 'Desk', 'Furniture', 400.00, 5),
(10, 'Printer', 'Office Supplies', 250.00, 12),
(11, 'Scanner', 'Office Supplies', 180.00, 8),
(12, 'Notebook', 'Stationery', 10.00, 100),
(13, 'Pen', 'Stationery', 2.00, 500),
(14, 'Backpack', 'Accessories', 80.00, 30),
(15, 'Lamp', 'Furniture', 60.00, 25);

SELECT DISTINCT e1.EmployeeName
FROM #EmployeeSales e1
WHERE NOT EXISTS (
    SELECT DISTINCT SalesMonth
    FROM #EmployeeSales
    WHERE NOT EXISTS (
        SELECT 1
        FROM #EmployeeSales e2
        WHERE e2.EmployeeName = e1.EmployeeName
          AND e2.SalesMonth = #EmployeeSales.SalesMonth
    )
);

--15. Retrieve the names of products that are more expensive than the average price of all products.

SELECT Name, Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);

--16. Find the products that have a stock count lower than the highest stock count.
SELECT Name, Stock
FROM Products
WHERE Stock < (SELECT MAX(Stock) FROM Products);

--17. Get the names of products that belong to the same category as 'Laptop'.
SELECT Name, Category
FROM Products
WHERE Category = (
    SELECT Category
    FROM Products
    WHERE Name = 'Laptop'
);

--18. Retrieve products whose price is greater than the lowest price in the Electronics category.
SELECT Name, Price
FROM Products
WHERE Price > (
    SELECT MIN(Price)
    FROM Products
    WHERE Category = 'Electronics'
);

--19. Find the products that have a higher price than the average price of their respective category.
CREATE TABLE Orders (
    OrderID    INT PRIMARY KEY,
    ProductID  INT,
    Quantity   INT,
    OrderDate  DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Orders (OrderID, ProductID, Quantity, OrderDate) VALUES
(1, 1, 2, '2024-03-01'),
(2, 3, 5, '2024-03-05'),
(3, 2, 3, '2024-03-07'),
(4, 5, 4, '2024-03-10'),
(5, 8, 1, '2024-03-12'),
(6, 10, 2, '2024-03-15'),
(7, 12, 10, '2024-03-18'),
(8, 7, 6, '2024-03-20'),
(9, 6, 2, '2024-03-22'),
(10, 4, 3, '2024-03-25'),
(11, 9, 2, '2024-03-28'),
(12, 11, 1, '2024-03-30'),
(13, 14, 4, '2024-04-02'),
(14, 15, 5, '2024-04-05'),
(15, 13, 20, '2024-04-08');

SELECT p.Name, p.Category, p.Price
FROM Products p
WHERE p.Price > (
    SELECT AVG(p2.Price)
    FROM Products p2
    WHERE p2.Category = p.Category
);

--20. Find the products that have been ordered at least once.
SELECT ProductID, SUM(Quantity) AS TotalQuantity
FROM Orders
GROUP BY ProductID
HAVING SUM(Quantity) >= 1;

--21. Retrieve the names of products that have been ordered more than the average quantity ordered.
SELECT p.Name, SUM(o.Quantity) AS TotalQuantity
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.Name
HAVING SUM(o.Quantity) > (
    SELECT AVG(Quantity)
    FROM Orders
);

--22. Find the products that have never been ordered.
SELECT p.ProductID, p.Name
FROM Products p
LEFT JOIN Orders o ON p.ProductID = o.ProductID
WHERE o.ProductID IS NULL;

--23. Retrieve the product with the highest total quantity ordered.
SELECT TOP 1 p.Name, SUM(o.Quantity) AS TotalQuantity
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.Name
ORDER BY SUM(o.Quantity) DESC;
