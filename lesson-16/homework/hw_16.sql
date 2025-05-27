--# Easy Tasks

--1. Create a numbers table using a recursive query from 1 to 1000.
;with cte as(
select 1 as a
union all
select a+1 from cte
where a<1000
)select a from cte
OPTION (MAXRECURSION 1000)

--2. Write a query to find the total sales per employee using a derived table.(Sales, Employees)

select a.FirstName,a.LastName,b.total_sales from employees a
join 
(select EmployeeID, SUM(SalesAmount) as total_sales from Sales group by EmployeeID) b 
on a.EmployeeID=b.EmployeeID

--3. Create a CTE to find the average salary of employees.(Employees

;with ste as (select AVG(Salary) as avg_salary from Employees) select * from cte

--4. Write a query using a derived table to find the highest sales for each product.(Sales, Products)

select a.ProductName,maxprice_proid.max_sale from Products a 
join (select ProductID,max(SalesAmount) as max_sale from sales
group by ProductID)as maxprice_proid   on a.ProductID=maxprice_proid.ProductID 

select * from Products
select * from Sales
--5. Beginning at 1, write a statement to double the number for each record, the max value you get should be less than 1000000.

;with double_value as(
select 1 as num
union all
select num*2 from double_value
where num*2<1000000
)select num from double_value
option(maxrecursion 1000)

--6. Use a CTE to get the names of employees who have made more than 5 sales.(Sales, Employees)

select a.FirstName,a.LastName,a.Salary,b.total_sales from Employees a
join (select EmployeeID,COUNT(SalesAmount) total_sales from Sales
group by EmployeeID) b on b.EmployeeID=a.EmployeeID and total_sales>5

;with counted_sales as (select EmployeeID,COUNT(SalesAmount)as total_sales from Sales
group by EmployeeID) select a.FirstName,a.LastName,b.total_sales from Employees a 
join counted_sales b on a.EmployeeID=b.EmployeeID where total_sales>5 

--7. Write a query using a CTE to find all products with sales greater than $500.(Sales, Products)

select * from Sales
select * from Products
;with saled_amount as(
	select ProductID,sum(SalesAmount) total_sale 
	from Sales
	group by ProductID) 
select a.ProductName,b.total_sale from Products a 
join saled_amount b on a.ProductID=b.ProductID 
where b.total_sale>500

--8. Create a CTE to find employees with salaries above the average salary.(Employees)
 
select FirstName,LastName,Salary from Employees 
where Salary>(select AVG(Salary) avg_salary from Employees )

--# Medium Tasks
--1. Write a query using a derived table to find the top 5 employees by the number of orders made.(Employees, Sales)

select top 5 a.DepartmentID,a.FirstName,a.LastName,b.total_order from Employees a
join
(select EmployeeID,COUNT(*) total_order from Sales
group by EmployeeID) as  b on b.EmployeeID=a.EmployeeID
order by total_order desc

--2. Write a query using a derived table to find the sales per product category.(Sales, Products)

select a.ProductID,a.ProductName,sales.total_sale from Products a join
(select ProductID,sum(SalesAmount) total_sale from Sales
group by ProductID) sales on a.ProductID=sales.ProductID 

--3. Write a script to return the factorial of each value next to it.(Numbers1)

;with factorial_nums as(
select Number as num, 1 as qadam, 1 as faktorial from Numbers1
union all
select num, qadam+1,faktorial*(qadam+1) from factorial_nums
where qadam<=num
)select num,max(faktorial) faktorials from factorial_nums
group by num
order by num

--4. This script uses recursion to split a string into rows of substrings for each character in the string.(Example)

;with splitter_cte as (
select id,string as st, 1 as position, SUBSTRING(string,1,1) as letters from Example
union all
select a.Id,a.String,b.position + 1, SUBSTRING(a.String, b.position + 1, 1) from Example a
join splitter_cte b on a.Id=b.Id
where b.position+1<=LEN(a.String)
) select f.Id,f.st,f.letters from splitter_cte f
order by f.Id

--5. Use a CTE to calculate the sales difference between the current month and the previous month.(Sales)

;with sale_now as (
select sum(SalesAmount) total_sales_now from Sales
where YEAR(SaleDate)=YEAR(GETDATE()) and MONTH(SaleDate)=MONTH(GETDATE())),
sale_previous as(
select sum(SalesAmount) total_sales_previous from Sales
where 
 SaleDate >= DATEADD(MONTH, -1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))
 AND SaleDate < DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
) select b.total_sales_previous,a.total_sales_now,b.total_sales_previous-a.total_sales_now as [difference] from sale_now a 
cross join sale_previous  b 

--6. Create a derived table to find employees with sales over $45000 in each quarter.(Sales, Employees)

select a.FirstName,a.LastName,b.quarter,b.total_sales_by_quarter from Employees a
join
(select EmployeeID,DATEPART(QUARTER,SaleDate) as [quarter],sum(SalesAmount) as total_sales_by_quarter from Sales
group by EmployeeID,DATEPART(QUARTER,SaleDate)
 ) as b  on b.EmployeeID=a.EmployeeID  where total_sales_by_quarter>45000

--# Difficult Tasks
--1. This script uses recursion to calculate Fibonacci numbers

;with fibonacci(n,a,b) as(
select 1 n,0 a,1 b
union all
select n+1 as n,b,a+b from fibonacci
where n<20
)select n,a from fibonacci

--2. Find a string where all characters are the same and the length is greater than 1.(FindSameCharacters)a.Id,a.Vals

select *  from FindSameCharacters a
where len(vals)>1 and len(REPLACE(Vals,LEFT(vals,1),''))=0

--3. Create a numbers table that shows all numbers 1 through n and their order gradually increasing by the next number in the sequence.
--(Example:n=5 | 1, 12, 123, 1234, 12345)
;with num as(
select 1 as n, cast('1' as varchar(100))as b 
union all
select n+1 , cast(b+ cast(n+1 as varchar(100)) as varchar(100)) from num
where n+1<=5
) select b from num

--4. Write a query using a derived table to find the employees who have made the most sales in the last 6 months.(Employees,Sales)

select a.EmployeeID,a.FirstName,a.LastName,b.total_sale from Employees a 
join
(select EmployeeID, sum(SalesAmount)as total_sale from Sales a
where SaleDate>=dateadd(month,-6, getdate()	)
group by EmployeeID) b 
on a.EmployeeID=b.EmployeeID
where b.total_sale=(select max(total_sale) from (select EmployeeID, sum(SalesAmount)as total_sale from Sales a
where SaleDate>=dateadd(month,-6, getdate()	)
group by EmployeeID ) sub )

;with sales_info as( select EmployeeID,sum(SalesAmount) total_sale from Sales
where SaleDate>=DATEADD(MONTH,-6,GETDATE())
group by EmployeeID)
 select a.EmployeeID,a.FirstName,a.LastName,b.total_sale from Employees a join
 sales_info b on a.EmployeeID=b.EmployeeID
 where b.total_sale=(select MAX(total_sale) from sales_info)

 --5. Write a T-SQL query to remove the duplicate integer values present in the string column. 
 --Additionally, remove the single integer character that appears in the string.
--(RemoveDuplicateIntsFromNames)
with cte as(
select PawanName,Pawan_slug_name,CHARINDEX('-',Pawan_slug_name)+1 chr from RemoveDuplicateIntsFromNames
union all
select PawanName,Pawan_slug_name,chr+1 from cte 
where chr<LEN(Pawan_slug_name)),
cte2 as(
select distinct PawanName, LEFT(Pawan_slug_name,CHARINDEX('-',Pawan_slug_name)) lf,
SUBSTRING(Pawan_slug_name,chr,1) sb from cte
)
select PawanName,lf+string_agg(sb,'') from cte2
group by PawanName,lf
