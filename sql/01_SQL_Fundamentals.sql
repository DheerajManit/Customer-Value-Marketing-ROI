USE ecommerce_analytics;
------------------------------------------------------------
-- View data from each table
------------------------------------------------------------

SELECT * FROM customers;

SELECT * FROM products;

SELECT * FROM orders;

SELECT * FROM campaigns;

SELECT * FROM payments;

SELECT * FROM returns;

SELECT * FROM reviews;

------------------------------------------------------------
-- Count number of records
------------------------------------------------------------

SELECT COUNT(*) AS TotalCustomers
FROM customers;

SELECT COUNT(*) AS TotalOrders
FROM orders;

SELECT COUNT(*) AS TotalProducts
FROM products;

SELECT COUNT(*) AS TotalCampaigns
FROM campaigns;

------------------------------------------------------------
-- Customer Information
------------------------------------------------------------

SELECT CustomerID,
       CustomerName,
       City,
       Region
FROM customers;

SELECT DISTINCT City
FROM customers;

SELECT DISTINCT Region
FROM customers;

------------------------------------------------------------
-- Product Information
------------------------------------------------------------

SELECT ProductName,
       Category,
       SellingPrice
FROM products;

SELECT DISTINCT Category
FROM products;

SELECT DISTINCT Brand
FROM products;

------------------------------------------------------------
-- Basic Filtering
------------------------------------------------------------

SELECT *
FROM customers
WHERE Gender='Female';

SELECT *
FROM customers
WHERE Age > 40;

SELECT *
FROM orders
WHERE OrderStatus='Delivered';

SELECT *
FROM payments
WHERE PaymentStatus='Completed';

------------------------------------------------------------
-- Sorting
------------------------------------------------------------

SELECT *
FROM products
ORDER BY SellingPrice DESC;

SELECT *
FROM customers
ORDER BY JoinDate;

SELECT *
FROM orders
ORDER BY TotalAmount DESC;

------------------------------------------------------------
-- Aggregate Functions
------------------------------------------------------------

SELECT
SUM(TotalAmount) AS TotalRevenue
FROM orders;

SELECT
AVG(TotalAmount) AS AverageOrderValue
FROM orders;

SELECT
MAX(TotalAmount) AS HighestOrder
FROM orders;

SELECT
MIN(TotalAmount) AS LowestOrder
FROM orders;

------------------------------------------------------------
-- GROUP BY
------------------------------------------------------------

SELECT
OrderStatus,
COUNT(*) AS TotalOrders
FROM orders
GROUP BY OrderStatus;

SELECT
PaymentMethod,
COUNT(*) AS TotalPayments
FROM payments
GROUP BY PaymentMethod;

SELECT
Category,
COUNT(*) AS TotalProducts
FROM products
GROUP BY Category;

------------------------------------------------------------
-- HAVING
------------------------------------------------------------

SELECT
Category,
COUNT(*) AS ProductCount
FROM products
GROUP BY Category
HAVING COUNT(*) > 5;

------------------------------------------------------------
-- INNER JOIN
------------------------------------------------------------

SELECT
o.OrderID,
c.CustomerName,
o.TotalAmount
FROM orders o
INNER JOIN customers c
ON o.CustomerID = c.CustomerID;

------------------------------------------------------------
-- Join Orders with Products
------------------------------------------------------------

SELECT
o.OrderID,
p.ProductName,
o.Quantity,
o.TotalAmount
FROM orders o
INNER JOIN products p
ON o.ProductID = p.ProductID;

------------------------------------------------------------
-- Join Orders with Campaigns
------------------------------------------------------------

SELECT
o.OrderID,
c.CampaignName,
o.TotalAmount
FROM orders o
INNER JOIN campaigns c
ON o.CampaignID = c.CampaignID;

------------------------------------------------------------
-- Join Orders with Payments
------------------------------------------------------------

SELECT
o.OrderID,
p.PaymentMethod,
p.PaymentStatus,
o.TotalAmount
FROM orders o
INNER JOIN payments p
ON o.OrderID = p.OrderID;

------------------------------------------------------------
-- Multiple Table Join
------------------------------------------------------------

SELECT
o.OrderID,
cu.CustomerName,
pr.ProductName,
ca.CampaignName,
o.TotalAmount
FROM orders o
JOIN customers cu
ON o.CustomerID = cu.CustomerID
JOIN products pr
ON o.ProductID = pr.ProductID
JOIN campaigns ca
ON o.CampaignID = ca.CampaignID;

------------------------------------------------------------
-- Revenue by City
------------------------------------------------------------

SELECT
c.City,
SUM(o.TotalAmount) AS Revenue
FROM customers c
JOIN orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.City
ORDER BY Revenue DESC;

------------------------------------------------------------
-- Revenue by Region
------------------------------------------------------------

SELECT
c.Region,
SUM(o.TotalAmount) AS Revenue
FROM customers c
JOIN orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.Region
ORDER BY Revenue DESC;

------------------------------------------------------------
-- Orders per Customer
------------------------------------------------------------

SELECT
CustomerID,
COUNT(OrderID) AS TotalOrders
FROM orders
GROUP BY CustomerID
ORDER BY TotalOrders DESC;

------------------------------------------------------------
-- Average Selling Price by Category
------------------------------------------------------------

SELECT
Category,
ROUND(AVG(SellingPrice),2) AS AvgSellingPrice
FROM products
GROUP BY Category;

------------------------------------------------------------
-- Delivered Orders
------------------------------------------------------------

SELECT *
FROM orders
WHERE OrderStatus='Delivered';

------------------------------------------------------------
-- Pending Orders
------------------------------------------------------------

SELECT *
FROM orders
WHERE OrderStatus='Pending';

------------------------------------------------------------
-- Cancelled Orders
------------------------------------------------------------

SELECT *
FROM orders
WHERE OrderStatus='Cancelled';

------------------------------------------------------------
-- Total Sales by Product
------------------------------------------------------------

SELECT
p.ProductName,
SUM(o.TotalAmount) AS Revenue
FROM products p
JOIN orders o
ON p.ProductID = o.ProductID
GROUP BY p.ProductName
ORDER BY Revenue DESC;

------------------------------------------------------------
-- Total Quantity Sold
------------------------------------------------------------

SELECT
ProductID,
SUM(Quantity) AS QuantitySold
FROM orders
GROUP BY ProductID
ORDER BY QuantitySold DESC;

------------------------------------------------------------
-- Revenue by Payment Method
------------------------------------------------------------

SELECT
PaymentMethod,
SUM(TotalAmount) AS Revenue
FROM orders
GROUP BY PaymentMethod
ORDER BY Revenue DESC;

------------------------------------------------------------
-- Customer Registration Trend
------------------------------------------------------------

SELECT
YEAR(JoinDate) AS YearJoined,
COUNT(*) AS Customers
FROM customers
GROUP BY YEAR(JoinDate);

------------------------------------------------------------
-- Campaign Budget
------------------------------------------------------------

SELECT
CampaignName,
Budget
FROM campaigns
ORDER BY Budget DESC;

------------------------------------------------------------
-- Basic Review Analysis
------------------------------------------------------------

SELECT
Rating,
COUNT(*) AS TotalReviews
FROM reviews
GROUP BY Rating
ORDER BY Rating DESC;

------------------------------------------------------------
-- Return Status
------------------------------------------------------------

SELECT
RefundStatus,
COUNT(*) AS TotalReturns
FROM returns
GROUP BY RefundStatus;

------------------------------------------------------------
-- End of Fundamentals
------------------------------------------------------------