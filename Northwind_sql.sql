use Northwind;

-- 1. Which shippers do we have? 
select *
from [dbo].[Shippers];

-- 2. Certain fields from Categories 
select  *
from [dbo].[Categories];

-- 3. Sales Representatives
select FirstName, LastName, HireDate 
from [dbo].[Employees] where Title='Sales Representative';

-- 4. Sales Representatives in the United States 
select FirstName, LastName, HireDate
from[dbo].[Employees] where Title= 'Sales Representative' and Country='USA';

-- 5. Orders placed by specific EmployeeID
select OrderID, OrderDate
from[dbo].[Orders] where EmployeeID=7;

-- 6. Suppliers and ContactTitles
select SupplierID,ContactName,ContactTitle
from[dbo].[Suppliers] where not ContactTitle='Marketing Manager';

-- 7. Products with “queso” in ProductName
select ProductID,ProductName
from[dbo].[Products] where ProductName like '%queso%';

-- 8. Orders shipping to France or Belgium
select OrderID,CustomerID, ShipCountry
from[dbo].[Orders] where ShipCountry='France' or ShipCountry='Belgium';

-- alternate method for qn8.
select OrderID,CustomerID, ShipCountry
from[dbo].[Orders] where ShipCountry in ('France' ,'Belgium');

-- 9. Orders shipping to any country in Latin America
select OrderId, CustomerID, ShipCountry
from[dbo].[Orders] where ShipCountry in ('Brazil','Mexico','Argentina','Venezuela');

-- 10. Employees, in order of age
select FirstName,LastName, Title, BirthDate
from[dbo].[Employees] order by BirthDate asc;

-- 11. Showing only the Date with a DateTime field
select FirstName,LastName,Title, CAST(BirthDate AS DATE) AS BirthDate
from[dbo].[Employees];

-- 12. Employees full name 
select FirstName, LastName, FirstName + ' ' + LastName as FullName
from [dbo].[Employees];

-- 13. OrderDetails amount per line item  
select OrderId, ProductID, UnitPrice, Quantity, TotalPrice=(UnitPrice*Quantity)
from[dbo].[OrderDetails] order by OrderID, ProductID;

-- 14. How many customers?  
select count(distinct(CustomerID)) as NoOfCustomers
from[dbo].[Customers];

--15. When was the first order?  
select CAST(min(OrderDate) as DATE) as EarliestOrder
from[dbo].[Orders]; 

--16. Countries where there are customers 
select Country
from [dbo].[Customers] group by Country having count(CustomerID)>1;

--17. Contact titles for customers
select ContactTitle, count(ContactTitle) as TotalContactTitle
from[dbo].[Customers] group by ContactTitle order by TotalContactTitle desc;

--18. Profucts with associated supplier names
select p.ProductID, p.ProductName, s.CompanyName as Suppliers
from[dbo].[Products] p inner join [dbo].[Suppliers] s on p.SupplierID=s.SupplierID order by p.ProductID;

--19. Orders and the Shipper that was used
select o.OrderID, o.OrderDate, s.CompanyName
from[dbo].[Orders] o inner join [dbo].[Shippers] s on o.ShipVia=s.ShipperID
where OrderID<10300;

--20. Categories, and the total products in each category
select c.CategoryName, count(p.ProductID) as TotalProducts
from[dbo].[Categories] c join [dbo].[Products] p on c.CategoryID=p.CategoryID 
group by c.CategoryName 
order by TotalProducts desc


--21. Total customers per country/city 
select Country, City, count(*) as Total_Customers
from [dbo].[Customers] group by City, Country order by Total_Customers desc

--22. Products that need reordering
select ProductId, ProductName, UnitsInStock, ReorderLevel
from[dbo].[Products] where UnitsInStock<ReorderLevel

--23. Products that need reordering, continued 
select ProductID, ProductName, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued
from[dbo].[Products] where (UnitsInStock+UnitsOnOrder) <= ReorderLevel and Discontinued=0

--24. Customer list by region
WITH CTE
AS
(
select CustomerID, CompanyName, Region, 
case 
when Region is null then 1
else 0 
end  
as Region_Indi
from[dbo].[Customers]
)
SELECT * FROM CTE
WHERE Region_Indi != 1

--25. High freight charges
select top 3 ShipCountry, avg(Freight) as Average_Freight
from[dbo].[Orders] group by ShipCountry order by Average_Freight desc 

--26. High Freight charges
select top 3 ShipCountry, avg(Freight) as Average_Freight
from[dbo].[Orders] where OrderDate like '%2015%'  group by ShipCountry order by Average_Freight desc

