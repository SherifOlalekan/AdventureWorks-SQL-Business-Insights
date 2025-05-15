-- Question 1: Top 10 Customers by revenue
SELECT TOP 10 --selecting the top 10
	C.FirstName + ' ' + C.LastName AS FullName, --concatenating first and last name for full name
	A.CountryRegion AS Shipping_country, 
	A.City , 
	SUM(SOD.OrderQty * SOD.UnitPrice) AS Revenue --performing summation aggregate for revenue

FROM SalesLT.SalesOrderHeader AS SOH

--Join all Necessary tables
	INNER JOIN SalesLT.SalesOrderDetail AS SOD
		ON SOH.SalesOrderID = SOD.SalesOrderID
	INNER JOIN SalesLT.Customer AS C 
		ON SOH.CustomerID = C.CustomerID
	INNER JOIN SalesLT.Address AS A ON SOH.ShipToAddressID = A.AddressID

--Group by FirstName, Lastname, CountryRegion and City
GROUP BY 
	C.FirstName, C.LastName, A.CountryRegion, A.City

--order by Revenue in descneding order
ORDER BY Revenue DESC;


-- Question 2: Customers segmentation by revenue (Platinum, Gold, Silver and Bronze)
--create a CTE called CustomerRevenue
WITH CustomerRevenue AS (
SELECT 
	C.CustomerID, 
	C.FirstName + ' ' + C.LastName AS FullName, --concatenating the first and last name
	C.CompanyName, 
	SUM(SOD.OrderQty * SOD.UnitPrice) AS Revenue	--performing summation aggregate for revenue

FROM SalesLT.SalesOrderHeader AS SOH

--joining all neccessary tables
	INNER JOIN SalesLT.SalesOrderDetail AS SOD
		ON SOH.SalesOrderID = SOD.SalesOrderID
	INNER JOIN SalesLT.Customer AS C 
		ON SOH.CustomerID = C.CustomerID

	GROUP BY 
		C.CustomerID, C.FirstName, C.LastName, C.CompanyName
),
RankedRevenue AS (
    SELECT *,
           NTILE(4) OVER (ORDER BY Revenue DESC) AS RevenueQuartile --Splitting the data into 4 equal parts ordering from the highest to the lowest
    FROM CustomerRevenue
)

SELECT
    CustomerID,
    FullName,
    Revenue,
    CASE --Create the segment using CASE statement for the splitted data
        WHEN RevenueQuartile = 1 THEN 'Platinum' --first quater
        WHEN RevenueQuartile = 2 THEN 'Gold'	--second quater
        WHEN RevenueQuartile = 3 THEN 'Silver'	--third quater
        ELSE 'Bronze'							-- fourth quater/the remainig data
    END AS CustomerSegment
FROM RankedRevenue


-- Question 3: What product with their respective categories did the customer order on the last day of business
SELECT 
	CustomerID, 
	p.ProductID, 
	p.Name AS product_name, 
	pc.Name AS Category_name, 
	OrderDate -- since we only have one date throughout
FROM 
	SalesLT.SalesOrderHeader AS SOH
	--perform joins on all neccessary tables
INNER JOIN 
	SalesLT.SalesOrderDetail AS SOD ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN 
	SalesLT.Product AS p ON SOD.ProductID = p.ProductID
INNER JOIN 
	SalesLT.ProductCategory AS PC ON p.ProductCategoryID = PC.ProductCategoryID

WHERE --filtering by the last order date
SOH.OrderDate = (SELECT MAX(OrderDate) FROM SalesLT.SalesOrderHeader)

	--order the result by customerID and product name
ORDER BY CustomerID, product_name;


-- Question 4: Create a View with question 2 as CustomerSegments
--create a view called CustomerSegments
CREATE VIEW CustomerSegments AS
WITH CustomerRevenue AS (
SELECT 
	C.CustomerID, 
	C.FirstName + ' ' + C.LastName AS FullName, --concatenating the first and last name
	C.CompanyName, 
	SUM(SOD.OrderQty * SOD.UnitPrice) AS Revenue	--performing summation aggregate for revenue

FROM SalesLT.SalesOrderHeader AS SOH

--joining all neccessary tables
	INNER JOIN SalesLT.SalesOrderDetail AS SOD
		ON SOH.SalesOrderID = SOD.SalesOrderID
	INNER JOIN SalesLT.Customer AS C 
		ON SOH.CustomerID = C.CustomerID

	GROUP BY 
		C.CustomerID, C.FirstName, C.LastName, C.CompanyName
),
RankedRevenue AS (
    SELECT *,
           NTILE(4) OVER (ORDER BY Revenue DESC) AS RevenueQuartile --Splitting the data into 4 equal parts ordering from the highest to the lowest
    FROM CustomerRevenue
)

SELECT
    CustomerID,
    FullName,
    Revenue,
    CASE --Create the segment using CASE statement for the splitted data
        WHEN RevenueQuartile = 1 THEN 'Platinum' --first quater
        WHEN RevenueQuartile = 2 THEN 'Gold'	--second quater
        WHEN RevenueQuartile = 3 THEN 'Silver'	--third quater
        ELSE 'Bronze'							-- fourth quater/the remainig data
    END AS CustomerSegment
FROM RankedRevenue


-- Question 5: Top 3 selling product (by revenue) in each product category
--create a CTE for rank
WITH revenue_rank AS (
SELECT p.ProductCategoryID AS CategoryID, 
		p.Name AS product_name, 
	SUM(LineTotal) AS product_revenue, 
	DENSE_RANK() OVER (PARTITION BY ProductCategoryID --creating a dense rank and partitioning by categoryID
		ORDER BY SUM(LineTotal) DESC) AS rank_num
FROM SalesLT.SalesOrderDetail AS SOD 

-- Join the SalesOrderDetails and product tables
INNER JOIN 
	SalesLT.Product AS p ON SOD.ProductID = p.ProductID

--group by CategoryID and ProductName
GROUP BY p.ProductCategoryID, p.Name)

SELECT 
	Name AS category_name, 
		product_name, 
		product_revenue, 
		rank_num
FROM revenue_rank AS RR

--join the CTE with the productCategory table
INNER JOIN 
	SalesLT.ProductCategory AS PC ON RR.CategoryID = PC.ProductCategoryID

WHERE rank_num <=3 --filter the table to only show the top 3 products

--order by category name
ORDER BY category_name
