create database hw_21
use hw_21

--Write a query to assign a row number to each sale based on the SaleDate.
select *,ROW_NUMBER() over(order by saleamount) as row_num from ProductSales
--Write a query to rank products based on the total quantity sold. give the same rank for the same amounts without skipping numbers.
select 
ProductName,
SUM(quantity) as total_qty,
DENSE_RANK() over(order by SUM(quantity) desc) as rank 
from ProductSales
group by ProductName
--Write a query to identify the top sale for each customer based on the SaleAmount.
select *,ROW_NUMBER() over(partition by customerid order by saleamount desc) from ProductSales
--Write a query to display each sale's amount along with the next sale amount in the order of SaleDate.
select *,LEAD(SaleAmount) over(order by saledate) as lead_row from ProductSales
--Write a query to display each sale's amount along with the previous sale amount in the order of SaleDate.
select *, LAG(SaleAmount) over(order by saledate) from ProductSales
--Write a query to identify sales amounts that are greater than the previous sale's amount
;with cte as(
	select *,LAG(SaleAmount) over(order by saledate) as prew_sale 
	from ProductSales)
select * from cte
where prew_sale<SaleAmount
--Write a query to calculate the difference in sale amount from the previous sale for every product
select *,-saleamount+lead(saleamount) over(partition by productname order by saledate) as difference from ProductSales
--Write a query to compare the current sale amount with the next sale amount in terms of percentage change.
select *,concat_ws('',cast(lead(SaleAmount) over(order by saledate)*100/SaleAmount-100 as decimal(10,2)),'%') as SaleAmount_2nd_day from ProductSales
--Write a query to calculate the ratio of the current sale amount to the previous sale amount within the same product.
select *,cast(SaleAmount/LAG(SaleAmount) over(partition by productname order by saledate) as decimal(10,2))as sale_ratio from ProductSales
--Write a query to calculate the difference in sale amount from the very first sale of that product.
select 
a.CustomerID,
a.ProductName,
a.SaleDate,
a.SaleAmount,
a.SaleAmount-
FIRST_VALUE(SaleAmount) over(
partition by productname 
order by saledate 
rows between unbounded preceding and unbounded following) as diff_from_first_value
from ProductSales a
--Write a query to find sales that have been increasing continuously for a product (i.e., each sale amount is greater than the previous sale amount for that product).
;with cte as(
select *, LAG(SaleAmount) over(partition by productname order by saledate) as prew_amount 
from ProductSales
) 
select * from cte
where saleamount>prew_Amount
--Write a query to calculate a "closing balance"(running total) for sales amounts which adds the current sale amount to a running total of previous sales.
select *, sum(SaleAmount) over(order by saleamount) as [closing balance] from ProductSales
--Write a query to calculate the moving average of sales amounts over the last 3 sales.
select *,AVG(SaleAmount) over(partition by productname order by saledate rows between 2 preceding and current row ) as [last 3 sales] from ProductSales
--Write a query to show the difference between each sale amount and the average sale amount.
;with cte as(
select *,avg(SaleAmount) over(partition  by productname) as avg_amount from ProductSales
)
select *,cast(SaleAmount-avg_amount as decimal(10,2)) as diff_sale_avg from cte

--Find Employees Who Have the Same Salary Rank
;with cte as(
select EmployeeID,Name,Salary,RANK() over(order by salary) as rn,DENSE_RANK() over(order by salary) as dr 
from Employees1 )
select * from cte
where rn<>dr
--Identify the Top 2 Highest Salaries in Each Department
;with cte as(
select 
	*,
	rank() over(partition by department  order by salary desc) as rk 
from Employees1
)
select * from cte
where rk<3
--Find the Lowest-Paid Employee in Each Department
;with cte as(
select 
	*,
	rank() over(partition by department order by salary) as rk 
from Employees1)
select * from cte
where rk=1
--Calculate the Running Total of Salaries in Each Department
select 
	*, 
	SUM(salary) over(partition by department order by salary) as running_total 
from Employees1
--Find the Total Salary of Each Department Without GROUP BY
select *,sum(salary) over(partition by department) as total_salary from Employees1
--Calculate the Average Salary in Each Department Without GROUP BY
select *,AVG(salary) over(partition by department) as avg_salary from Employees1
--Find the Difference Between an Employee’s Salary and Their Department’s Average
select 
	*,
	cast(Salary-AVG(salary) over(partition by department) as decimal(10,2)) as diff_salary_avgsalary
from Employees1
--Calculate the Moving Average Salary Over 3 Employees (Including Current, Previous, and Next)
select 
	*,
	avg(salary) over(order by employeeid 
		rows between 1 preceding and 1 following ) as moving_avg_salary
from Employees1
--Find the Sum of Salaries for the Last 3 Hired Employees
select 
	*,
	SUM(Salary) over(order by hiredate rows between 2 preceding and current row ) 
from Employees1
