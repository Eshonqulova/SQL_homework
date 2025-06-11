create database hw_17
use hw_17

--### 1. You must provide a report of all distributors and their sales by region.  
--If a distributor did not have any sales for a region, rovide a zero-dollar value for that day.  Assume there is at least one sale for each region

DROP TABLE IF EXISTS #RegionSales;
GO
CREATE TABLE #RegionSales (
  Region      VARCHAR(100),
  Distributor VARCHAR(100),
  Sales       INTEGER NOT NULL,
  PRIMARY KEY (Region, Distributor)
);
GO
INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10), ('South','ACE',67), ('East','ACE',54),
('North','ACME',65), ('South','ACME',9), ('East','ACME',1), ('West','ACME',7),
('North','Direct Parts',8), ('South','Direct Parts',7), ('West','Direct Parts',12);

--**Input:**
--```
--|Region       |Distributor    | Sales |
--|-------------|---------------|--------
--|North        |ACE            |   10  |
--|South        |ACE            |   67  |
--|East         |ACE            |   54  |
--|North        |Direct Parts   |   8   |
--|South        |Direct Parts   |   7   |
--|West         |Direct Parts   |   12  |
--|North        |ACME           |   65  |
--|South        |ACME           |   9   |
--|East         |ACME           |   1   |
--|West         |ACME           |   7   |

--**Expected Output:**
--```
--|Region |Distributor   | Sales |
--|-------|--------------|-------|
--|North  |ACE           | 10    |
--|South  |ACE           | 67    |
--|East   |ACE           | 54    |
--|West   |ACE           | 0     |
--|North  |Direct Parts  | 8     |
--|South  |Direct Parts  | 7     |
--|East   |Direct Parts  | 0     |
--|West   |Direct Parts  | 12    |
--|North  |ACME          | 65    |
--|South  |ACME          | 9     |
--|East   |ACME          | 1     |
--|West   |ACME          | 7     |

;with distinctregion as (
select distinct Region from #RegionSales
),
distinctdistributor as (
select distinct Distributor from #RegionSales
),
unioncolumns as (
select dr.Region,dd.Distributor from distinctregion dr
cross join distinctdistributor dd)
select ucol.Region,ucol.Distributor,ISNULL(rs.Sales,0) Sales from unioncolumns ucol left join #RegionSales rs
on ucol.Region=rs.Region and ucol.Distributor=rs.Distributor
ORDER BY ucol.Distributor, ucol.Region;

--### 2. Find managers with at least five direct reports

CREATE TABLE Employee (id INT, name VARCHAR(255), department VARCHAR(255), managerId INT);
TRUNCATE TABLE Employee;
INSERT INTO Employee VALUES
(101, 'John', 'A', NULL), (102, 'Dan', 'A', 101), (103, 'James', 'A', 101),
(104, 'Amy', 'A', 101), (105, 'Anne', 'A', 101), (106, 'Ron', 'B', 101);

--**Input:**
--```
--| id  | name  | department | managerId |
--+-----+-------+------------+-----------+
--| 101 | John  | A          | null      |
--| 102 | Dan   | A          | 101       |
--| 103 | James | A          | 101       |
--| 104 | Amy   | A          | 101       |
--| 105 | Anne  | A          | 101       |
--| 106 | Ron   | B          | 101       |

--**Expected Output:**

--+------+
--| name |
--+------+
--| John |
--+------+

;with cte as(
select a.name from Employee a join Employee b on a.id=b.managerId

)select c.name from cte c
group by c.name
having  COUNT(c.name)>=5

--### 3. Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.

CREATE TABLE Products (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
CREATE TABLE Orders (product_id INT, order_date DATE, unit INT);
TRUNCATE TABLE Products;
INSERT INTO Products VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'), (4, 'Lenovo', 'Laptop'), (5, 'Leetcode Kit', 'T-shirt');
TRUNCATE TABLE Orders;
INSERT INTO Orders VALUES
(1,'2020-02-05',60),(1,'2020-02-10',70),
(2,'2020-01-18',30),(2,'2020-02-11',80),
(3,'2020-02-17',2),(3,'2020-02-24',3),
(4,'2020-03-01',20),(4,'2020-03-04',30),(4,'2020-03-04',60),
(5,'2020-02-25',50),(5,'2020-02-27',50),(5,'2020-03-01',50);

--**Input:**
--```
--| product_id  | product_name          | product_category |
--+-------------+-----------------------+------------------+
--| 1           | Leetcode Solutions    | Book             |
--| 2           | Jewels of Stringology | Book             |
--| 3           | HP                    | Laptop           |
--| 4           | Lenovo                | Laptop           |
--| 5           | Leetcode Kit          | T-shirt          |

--**Expected Output:**
--```
--| product_name       | unit  |
--+--------------------+-------+
--| Leetcode Solutions | 130   |
--| Leetcode Kit       | 100   |
--### 3. Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.
select * from Products
select * from Orders
DECLARE @year int = 2020, @month int = 2;
;with cte as(select * from Orders o
where MONTH(order_date)=@month and YEAR(order_date)=@year) select b.product_name,sum(a.unit) as total_unit from cte a 

join products b on a.product_id=b.product_id
group by b.product_name
having sum(a.unit)>=100

--### 4. Write an SQL statement that returns the vendor from which each customer has placed the most orders

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
  OrderID    INTEGER PRIMARY KEY,
  CustomerID INTEGER NOT NULL,
  [Count]    MONEY NOT NULL,
  Vendor     VARCHAR(100) NOT NULL
);
INSERT INTO Orders VALUES
(1,1001,12,'Direct Parts'), (2,1001,54,'Direct Parts'), (3,1001,32,'ACME'),
(4,2002,7,'ACME'), (5,2002,16,'ACME'), (6,2002,5,'Direct Parts');

--**Input:**
--```
--|Order ID   | Customer ID | Order Count|     Vendor     |
-----------------------------------------------------------
--|Ord195342  |     1001    |      12    |  Direct Parts  |
--|Ord245532  |     1001    |      54    |  Direct Parts  |
--|Ord344394  |     1001    |      32    |     ACME       |
--|Ord442423  |     2002    |      7     |     ACME       |
--|Ord524232  |     2002    |      16    |     ACME       |
--|Ord645363  |     2002    |      5     |  Direct Parts  |
--```

--**Expected Output:**
--```
--| CustomerID | Vendor       |
--|------------|--------------|
--| 1001       | Direct Parts |
--| 2002       | ACME         |
--Write an SQL statement that returns the vendor from which each customer has placed the most orders

select a.CustomerID,a.Vendor from Orders a
group by a.CustomerID,a.Vendor
having sum(a.count)=(select max(sub.sum_count)from(select sum(b.Count) sum_count from Orders b where a.CustomerID=b.CustomerID group by b.Vendor)sub)

--### 5. You will be given a number as a variable called @Check_Prime check if this number is prime then return 'This number is prime' else eturn 'This number is not prime'

declare @prime int =117
declare @b int=2
declare @is_prime int=1

if @prime<0
	begin
		set @is_prime=0
	end
else
	begin 
	while @b<@prime
			begin
				if @prime%@b=0
					begin
						set @is_prime=0
						break
					end
				set	@b=@b+1

			end
	end

if @is_prime=1
print('Bu son tub son ')
else
print('Bu son tub son emas')



declare @son int =1970
declare @boluvchi int =2
declare @tubmi int =1

if @son<0
begin 
 set @tubmi=0
end
else 
begin
	while @boluvchi <@son
	begin
		if @son%@boluvchi=0
			set @tubmi=0
		break
			end
		set @boluvchi=@boluvchi+1
end
if @tubmi=1
 print('tub son')
else
 print('tub son emas')
	

declare @num int =10
declare @tubsmi int=1

;with tub_sonmi as(
select 2 as boluvchi
union all
select boluvchi+1 as boluvchi from tub_sonmi
where boluvchi+1<@num
) select @tubsmi=0 from tub_sonmi
where @num%boluvchi=0

IF @num <= 1
    SET @tubsmi = 0; -- 1 va undan kichik sonlar tub emas

-- Natijani ko‘rsatish
IF @tubsmi = 1
    PRINT CAST(@num AS VARCHAR) + ' - bu tub son';
ELSE
    PRINT CAST(@num AS VARCHAR) + ' - bu tub son emas';

	 
--### 6. Write an SQL query to return the number of locations,in which location most signals sent, and total number of signal for each device from the given table.


CREATE TABLE Device(
  Device_id INT,
  Locations VARCHAR(25)
);
INSERT INTO Device VALUES
(12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'),
(12,'Hosur'), (12,'Hosur'),
(13,'Hyderabad'), (13,'Hyderabad'), (13,'Secunderabad'),
(13,'Secunderabad'), (13,'Secunderabad');

--**Expected Output:**
--```
--| Device_id | no_of_location | max_signal_location | no_of_signals |
--|-----------|----------------|---------------------|---------------|
--| 12        | 2              | Bangalore           | 6             |
--| 13        | 2              | Secunderabad        | 5             |

--Write an SQL query to return the number of locations,

;with cte as(
select Device_id,
count(distinct Locations) no_of_location, 
count(Device_id) no_of_signals from Device
group by Device_id),
cte2 as(
select Device_id, Locations ,count(Locations) count_loc from Device group by Device_id,Locations),
cte3 as(
select Device_id,max(count_loc) max_signal from cte2 group by Device_id
)
select a.Device_id,a.no_of_location,b.Locations max_signal_location,a.no_of_signals from cte3 c 
join cte a on a.Device_id=c.Device_id 
join cte2 b on a.Device_id=b.Device_id and b.count_loc=c.max_signal
order by Device_id

--### 7. Write a SQL  to find all Employees who earn more than the average salary in their corresponding department. 
--Return EmpID, EmpName,Salary in your output
drop table if exists Employee
CREATE TABLE Employee (
  EmpID INT,
  EmpName VARCHAR(30),
  Salary FLOAT,
  DeptID INT
);
INSERT INTO Employee VALUES
(1001,'Mark',60000,2), (1002,'Antony',40000,2), (1003,'Andrew',15000,1),
(1004,'Peter',35000,1), (1005,'John',55000,1), (1006,'Albert',25000,3), (1007,'Donald',35000,3);

--**Expected Output:**
--| EmpID | EmpName | Salary |
--|-------|---------|--------|
--| 1001  | Mark    | 60000  |
--| 1004  | Peter   | 35000  |
--| 1005  | John    | 55000  |
--| 1007  | Donald  | 35000  |
select EmpID,EmpName,Salary  from Employee a
where Salary>(
	select AVG(Salary)
	from Employee b 
	where a.DeptID=b.DeptID)
order by EmpID
--### 8. You are part of an office lottery pool where you keep a table of the winning lottery numbers along with a table of each ticket’s chosen numbers.
--If a ticket has some but not all the winning numbers, you win $10.  If a ticket has all the winning numbers, you win $100.   
--Calculate the total winnings for today’s drawing.

--**Winning Numbers:**

--|Number|
----------
--|  25  |
--|  45  |
--|  78  |

--**Tickets:**
--```
--| Ticket ID | Number |
--|-----------|--------|
--| A23423    | 25     |
--| A23423    | 45     |
--| A23423    | 78     |
--| B35643    | 25     |
--| B35643    | 45     |
--| B35643    | 98     |
--| C98787    | 67     |
--| C98787    | 86     |
--| C98787    | 91     |
--```
CREATE TABLE Tickets (
    TicketID VARCHAR(20),
    Number INT
);

INSERT INTO Tickets (TicketID, Number) VALUES
('A23423', 25),
('A23423', 45),
('A23423', 78),
('B35643', 25),
('B35643', 45),
('B35643', 98),
('C98787', 67),
('C98787', 86),
('C98787', 91);

CREATE TABLE WinningNumbers (
    Number INT
);

INSERT INTO WinningNumbers (Number) VALUES
(25),
(45),
(78);
select * from Tickets
select * from WinningNumbers
;with cte as(select a.TicketID,a.Number from Tickets a join WinningNumbers b on a.Number=b.Number),
cte2 as(select TicketID,count(Number) countnum from cte group by TicketID)
select SUM(case when countnum=3 then 100
	when countnum>=1 then 10
	else 0 end) as Prize from cte2
	
--### 9. The Spending table keeps the logs of the spendings history of users that make purchases from an online shopping
--website which has a desktop and a mobile devices.

--## Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only 
--and both mobile and desktop together for each date.


CREATE TABLE Spending (
  User_id INT,
  Spend_date DATE,
  Platform VARCHAR(10),
  Amount INT
);
INSERT INTO Spending VALUES
(1,'2019-07-01','Mobile',100),
(1,'2019-07-01','Desktop',100),
(2,'2019-07-01','Mobile',100),
(2,'2019-07-02','Mobile',100),
(3,'2019-07-01','Desktop',100),
(3,'2019-07-02','Desktop',100);

--**Expected Output:**

--| Row | Spend_date | Platform | Total_Amount | Total_users |
--|-----|------------|----------|--------------|-------------|
--| 1   | 2019-07-01 | Mobile   | 100          | 1           |
--| 2   | 2019-07-01 | Desktop  | 100          | 1           |
--| 3   | 2019-07-01 | Both     | 200          | 1           |
--| 4   | 2019-07-02 | Mobile   | 100          | 1           |
--| 5   | 2019-07-02 | Desktop  | 100          | 1           |
--| 6   | 2019-07-02 | Both     | 0            | 0           |
select * from Spending
;with cte as(
select User_id,Spend_date,
SUM(case when Platform='Mobile' then Amount else 0 end) as Mobile_amount,
SUM(case when Platform='Desktop' then Amount else 0 end) as Desktop_amount,
count(distinct case when Platform='Desktop' then 'Desktop' end) as Desktop_has,
COUNT(distinct case when Platform='Mobile' then 'Mobile' end) as Mobile_has
from Spending
group by User_id,Spend_date
),
cte2 as(select Spend_date,
case when Desktop_has=1 and Mobile_has=1 then 'Both'
	 when Mobile_has=1 then 'Mobile'
	 when Desktop_has=1 then 'Desktop'
end as Platform,
Mobile_amount+Desktop_amount as Amount,
User_id
from cte)
select User_id as Row,Spend_date,Platform,sum(Amount) as Total_Amount, COUNT(distinct User_id) as Total_users from cte2 a
group by User_id,Spend_date,Platform
order by case when Platform=' Mobile ' then 1
			  when Platform='Desktop' then 2
			  when Platform='Both ' then 3 end

--### 10. Write an SQL Statement to de-group the following data.


--|Product  |Quantity|
----------------------
--|Pencil   |   3    |
--|Eraser   |   4    |
--|Notebook |   2    |
--```

--**Expected Output:**
--```
--|Product  |Quantity|
----------------------
--|Pencil   |   1    |
--|Pencil   |   1    |
--|Pencil   |   1    |
--|Eraser   |   1    |
--|Eraser   |   1    |
--|Eraser   |   1    |
--|Eraser   |   1    |
--|Notebook |   1    |
--|Notebook |   1    |

DROP TABLE IF EXISTS Grouped;
CREATE TABLE Grouped
(
  Product  VARCHAR(100) PRIMARY KEY,
  Quantity INTEGER NOT NULL
);
INSERT INTO Grouped (Product, Quantity) VALUES
('Pencil', 3), ('Eraser', 4), ('Notebook', 2);

;WITH numbers AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM numbers WHERE n < 100
), expanded AS (
  SELECT g.Product, 1 AS Quantity
  FROM Grouped g
  JOIN numbers n ON n.n <= g.Quantity
)
SELECT Product, Quantity FROM expanded
ORDER BY Product
OPTION (MAXRECURSION 0);
