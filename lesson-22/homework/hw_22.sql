create database hw_22
use hw_22

--1. **Compute Running Total Sales per Customer**
select 
	*,
	sum(total_amount) over(partition by customer_name order by order_date) as Running_Total 
from sales_data a

--2. **Count the Number of Orders per Product Category**
select distinct a.product_category,
count(*) over(partition by product_category ) as [Number of Orders] 
from sales_data a

--3. **Find the Maximum Total Amount per Product Category**
select distinct product_category ,
MAX(total_amount) over(partition by product_category) as [Maximum Total Amount] 
from sales_data

--4. **Find the Minimum Price of Products per Product Category**
select distinct product_category,
MIN(unit_price) over(partition by product_category) as [Minimum Price] 
from sales_data

--5. **Compute the Moving Average of Sales of 3 days (prev day, curr day, next day)**
select *
,AVG(total_amount) over(order by order_date rows between 1 preceding and 1 following) as[Sales of 3 days] 
from sales_data

--6. **Find the Total Sales per Region**
select distinct region,
sum(total_amount) over(partition by region) as [Total Sales per Region] 
from sales_data

--7. **Compute the Rank of Customers Based on Their Total Purchase Amount**
SELECT 
  customer_id,
  customer_name,
  SUM(total_amount) AS total_purchase,
  DENSE_RANK() OVER (ORDER BY SUM(total_amount) DESC) AS purchase_rank
FROM sales_data
GROUP BY customer_id, customer_name;

--8. **Calculate the Difference Between Current and Previous Sale Amount per Customer**
;with cte as(
select customer_name, 
order_date,
total_amount-lag(total_amount) over(partition by customer_name order by order_date)as difference_amount 
from sales_data a
) 
select * from cte where difference_amount is not null

--9. **Find the Top 3 Most Expensive Products in Each Category**
declare @n int=3
;with cte as(
select   a.customer_id
		,a.customer_name
		,a.product_category
		,a.unit_price
		,ROW_NUMBER() over(partition by product_category order by unit_price desc) as row_num 
from sales_data a)
select * from cte
where row_num<=@n

--10. **Compute the Cumulative Sum of Sales Per Region by Order Date**
select 
	a.region,
	a.order_date,
	sum(total_amount) over(partition by region order by order_date ROWS UNBOUNDED PRECEDING) as [Cumulative Sum of Sales] 
from sales_data a

--11. **Compute Cumulative Revenue per Product Category**
select 
	distinct a.product_category,
	sum(total_amount) over(partition by product_category) as [Cumulative Revenue per Product Category] 
from sales_data a

--12. **Here you need to find out the sum of previous values. Please go through the sample input and expected output.**

--**Sample Input**

--| ID |
--|----|
--|  1 |
--|  2 |
--|  3 |
--|  4 |
--|  5 |

--**Expected Output**

--| ID | SumPreValues |
--|----|--------------|
--|  1 |            1 |
--|  2 |            3 |
--|  3 |            6 |
--|  4 |           10 |
--|  5 |           15 |
create table num (id int)
insert into num values(1),(2),(3),(4),(5)

select 
	*,
	sum(id ) over(order by id rows unbounded preceding) as SumPreValues 
from num

--13. **Sum of Previous Values to Current Value**

CREATE TABLE OneColumn (
    Value SMALLINT
);
INSERT INTO OneColumn VALUES (10), (20), (30), (40), (100);


--**Sample Input**

--| Value |
--|-------|
--|    10 |
--|    20 |
--|    30 |
--|    40 |
--|   100 |

--**Expected Output**

--| Value | Sum of Previous |
--|-------|-----------------|
--|    10 |              10 |
--|    20 |              30 |
--|    30 |              50 |
--|    40 |              70 |
--|   100 |             140 |

select 
	* , 
	sum(Value) over(order by value rows between 1 preceding and current row )as [Sum of Previous] 
from OneColumn

--14. **Generate row numbers for the given data. The condition is that the first row number for every partition should be odd number.
--For more details please check the sample input and expected output.**

CREATE TABLE Row_Nums (
    Id INT,
    Vals VARCHAR(10)
);
INSERT INTO Row_Nums VALUES
(101,'a'), (102,'b'), (102,'c'), (103,'f'), (103,'e'), (103,'q'), (104,'r'), (105,'p');


--**Sample Input**

--| Id  | Vals |  
--|-----|------|  
--| 101 |    a |  
--| 102 |    b |  
--| 102 |    c |  
--| 103 |    f |  
--| 103 |    e |  
--| 103 |    q |  
--| 104 |    r |  
--| 105 |    p |

--**Expected Output**

--| Id  | Vals | RowNumber |
--|-----|------|-----------|
--| 101 | a    | 1         |
--| 102 | b    | 3         |
--| 102 | c    | 4         |
--| 103 | f    | 5         |
--| 103 | e    | 6         |
--| 103 | q    | 7         |
--| 104 | r    | 9         |
--| 105 | p    | 11        |

;with cte as (
select 
	*,
	ROW_NUMBER() over(partition by id order by vals) as rn,
	ROW_NUMBER() over(order by id)*2-1 as base_odd
	from Row_Nums
)
select 
	id,
	Vals,
	base_odd+rn-1 as row_num 
from cte
order by row_num

--15. **Find customers who have purchased items from more than one product_category**

;with cte as (
select customer_id, customer_name,
count(distinct product_category) as category_count 
from sales_data 
group by customer_id, customer_name)
select customer_name from cte
where category_count>1

select * from sales_data

--16. **Find Customers with Above-Average Spending in Their Region**

;with cte as(
select *,AVG(total_amount) over(partition by region) as avg_amountby_region from sales_data
)
select a.customer_id,a.customer_name,a.total_amount,a.region,a.avg_amountby_region from cte a
where total_amount>avg_amountby_region

--17. **Rank customers based on their total spending (total_amount) within each region. 
--If multiple customers have the same spending, they should receive the same rank.**

;with customer_total as(
select customer_id,customer_name,region,SUM(total_amount)  total_amount_by_region from sales_data
group by customer_id,customer_name,region
),
ranked_customer as(
select   
	 customer_id
	,customer_name
	,region
	,total_amount_by_region
	,rank() over(partition by region order  by total_amount_by_region) as ranking_by_tamount 
from customer_total
) select * from ranked_customer

--18. **Calculate the running total (cumulative_sales) of total_amount for each customer_id, ordered by order_date.**

select 
	*,
	sum(total_amount) over(
		partition by customer_id 
		order by order_date
		rows between unbounded preceding and current row
		) as cumulative_sales
from sales_data

--19. **Calculate the sales growth rate (growth_rate) for each month compared to the previous month.**

 ;with cte as(
 select 
	 a.customer_id,
	 a.customer_name,
	 a.order_date,
	 a.total_amount,
	 lag(total_amount,1) over(
		 partition by customer_id 
		 order by order_date) as prew_amount
 from sales_data a) 
 select *,total_amount-prew_amount as growth_rate from cte
 where prew_amount is not null

--20. **Identify customers whose total_amount is higher than their last order's total_amount.(Table sales_data)**

;with cte as(select a.customer_id,
	 a.customer_name,
	 a.order_date,
	 a.total_amount,
	 lead(total_amount,1) over(
		 partition by customer_id 
		 order by order_date) as lead_amount_ikkinchi
 from sales_data a)
 select b.customer_id,b.customer_name,b.total_amount from cte b
 where total_amount>lead_amount_ikkinchi

--21. **Identify Products that prices are above the average product price**

select a.product_name,a.unit_price from sales_data a
where a.unit_price>(select AVG(unit_price) from sales_data)

;with cte as(
select AVG(unit_price) as avg_price from sales_data)
select a.product_name,a.unit_price,b.avg_price from sales_data a
cross join cte b
where a.unit_price>b.avg_price

--22. **In this puzzle you have to find the sum of val1 and val2 for each group and put that value at the beginning of the group in the new column. 
--The challenge here is to do this in a single select. For more details please see the sample input and expected output.**

CREATE TABLE MyData (
    Id INT, Grp INT, Val1 INT, Val2 INT
);
INSERT INTO MyData VALUES
(1,1,30,29), (2,1,19,0), (3,1,11,45), (4,2,0,0), (5,2,100,17);

--**Sample Input**

--| Id  | Grp | Val1 | Val2 |  
--|-----|-----|------|------|  
--|  1  |  1  |   30 |   29 |  
--|  2  |  1  |   19 |    0 |  
--|  3  |  1  |   11 |   45 |  
--|  4  |  2  |    0 |    0 |  
--|  5  |  2  |  100 |   17 |

--**Expected Output**

--| Id | Grp | Val1 | Val2 | Tot  |
--|----|-----|------|------|------|
--| 1  | 1   | 30   | 29   | 134  |
--| 2  | 1   | 19   | 0    | NULL |
--| 3  | 1   | 11   | 45   | NULL |
--| 4  | 2   | 0    | 0    | 117  |
--| 5  | 2   | 100  | 17   | NULL |

select 
	*,
	iif(
		id=min(id) over(partition by grp), 
		SUM(val1) over(partition by grp)+SUM(val2) over(partition by grp),
		null
		) as Tot 
from MyData

--23. **Here you have to sum up the value of the cost column based on the values of Id. 
--For Quantity if values are different then we have to add those values.
--Please go through the sample input and expected output for details.**

CREATE TABLE TheSumPuzzle (
    ID INT, Cost INT, Quantity INT
);
INSERT INTO TheSumPuzzle VALUES
(1234,12,164), (1234,13,164), (1235,100,130), (1235,100,135), (1236,12,136);

--**Sample Input**

--| Id   | Cost | Quantity |  
--|------|------|----------|  
--| 1234 |   12 |      164 |  
--| 1234 |   13 |      164 |  
--| 1235 |  100 |      130 |  
--| 1235 |  100 |      135 |  
--| 1236 |   12 |      136 | 

--**Expected Output**

--| Id   | Cost | Quantity |
--|------|------|----------|
--| 1234 | 25   | 164      |
--| 1235 | 200  | 265      |
--| 1236 | 12   | 136      |

SELECT
    ID,
    SUM(Cost) AS Cost,
    SUM(DISTINCT Quantity) AS Quantity
FROM TheSumPuzzle
GROUP BY ID;

--24. **From following set of integers, write an SQL statement to determine the expected outputs**

CREATE TABLE Seats 
( 
SeatNumber INTEGER 
); 

INSERT INTO Seats VALUES 
(7),(13),(14),(15),(27),(28),(29),(30), 
(31),(32),(33),(34),(35),(52),(53),(54); 

--**Output:**
-----------------------
--|Gap Start	|Gap End|
-----------------------
--|     1     |	6	|
--|     8     |	12	|
--|     16    |	26	|
--|     36    |	51	|
-----------------------

;with cte as(
select a.SeatNumber,LAG(SeatNumber,1,0) over(order by seatnumber) as leadnum from Seats a
)
select b.leadnum+1 as [Gap Start], b.SeatNumber-1 as [Gap End] from cte b
where b.SeatNumber-b.leadnum>1

--25. **In this puzzle you need to generate row numbers for the given data. 
--The condition is that the first row number for every partition should be even number.
--For more details please check the sample input and expected output.**

create table row_numbers (
id int, vals char(1))

insert into row_numbers
values
(101,'a'),
(102,'b'),
(102,'c'),
(103,'f'),
(103,'e'),
(103,'q'),
(104,'r'),
(105,'p')

--**Sample Input**

--| Id  | Vals |
--|-----|------|
--| 101 | a    |
--| 102 | b    |
--| 102 | c    |
--| 103 | f    |
--| 103 | e    |
--| 103 | q    |
--| 104 | r    |
--| 105 | p    |

--**Expected Output**

--| Id  | Vals | Changed |
--|-----|------|---------|
--| 101 | a    | 2       |
--| 102 | b    | 4       |
--| 102 | c    | 5       |
--| 103 | e    | 6       |
--| 103 | f    | 7       |
--| 103 | q    | 8       |
--| 104 | r    | 10      |
--| 105 | p    | 12      |


select 
	*,
	lead(id) over(order by id,vals) lead_row,
	row_number() over(partition by id order by vals)%2 row_num,
	iif(id=lead(id) over(order by id,vals),0,row_number() over(partition by id order by vals)%2) iif_num
from row_numbers


