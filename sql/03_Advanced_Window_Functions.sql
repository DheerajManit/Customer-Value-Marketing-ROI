USE ecommerce_analytics;

------------------------------------------------------------
-- 1. Rank Customers by Revenue
------------------------------------------------------------

SELECT
    CustomerID,
    ROUND(SUM(TotalAmount),2) AS Revenue,
    RANK() OVER(
        ORDER BY SUM(TotalAmount) DESC
    ) AS CustomerRank
FROM orders
GROUP BY CustomerID;

------------------------------------------------------------
-- 2. Dense Rank Customers
------------------------------------------------------------

SELECT
    CustomerID,
    ROUND(SUM(TotalAmount),2) AS Revenue,
    DENSE_RANK() OVER(
        ORDER BY SUM(TotalAmount) DESC
    ) AS DenseRank
FROM orders
GROUP BY CustomerID;

------------------------------------------------------------
-- 3. Row Number for Orders
------------------------------------------------------------

SELECT
    OrderID,
    CustomerID,
    TotalAmount,
    ROW_NUMBER() OVER(
        ORDER BY TotalAmount DESC
    ) AS RowNum
FROM orders;

------------------------------------------------------------
-- 4. Top Product in Each Category
------------------------------------------------------------

SELECT *
FROM
(
    SELECT
        p.Category,
        p.ProductName,
        SUM(o.Quantity) AS QuantitySold,
        ROW_NUMBER() OVER(
            PARTITION BY p.Category
            ORDER BY SUM(o.Quantity) DESC
        ) AS rn
    FROM products p
    JOIN orders o
        ON p.ProductID=o.ProductID
    GROUP BY p.Category,p.ProductName
) x
WHERE rn=1;

------------------------------------------------------------
-- 5. Running Revenue
------------------------------------------------------------

SELECT
    OrderDate,
    TotalAmount,
    SUM(TotalAmount)
    OVER(
        ORDER BY OrderDate
    ) AS RunningRevenue
FROM orders;

------------------------------------------------------------
-- 6. Running Revenue by Customer
------------------------------------------------------------

SELECT
    CustomerID,
    OrderDate,
    TotalAmount,
    SUM(TotalAmount)
    OVER(
        PARTITION BY CustomerID
        ORDER BY OrderDate
    ) AS CustomerRunningRevenue
FROM orders;

------------------------------------------------------------
-- 7. Previous Order Value
------------------------------------------------------------

SELECT
    CustomerID,
    OrderDate,
    TotalAmount,
    LAG(TotalAmount)
    OVER(
        PARTITION BY CustomerID
        ORDER BY OrderDate
    ) AS PreviousOrder
FROM orders;

------------------------------------------------------------
-- 8. Next Order Value
------------------------------------------------------------

SELECT
    CustomerID,
    OrderDate,
    TotalAmount,
    LEAD(TotalAmount)
    OVER(
        PARTITION BY CustomerID
        ORDER BY OrderDate
    ) AS NextOrder
FROM orders;

------------------------------------------------------------
-- 9. Difference from Previous Order
------------------------------------------------------------

SELECT
    CustomerID,
    OrderDate,
    TotalAmount,
    TotalAmount -
    LAG(TotalAmount)
    OVER(
        PARTITION BY CustomerID
        ORDER BY OrderDate
    ) AS Difference
FROM orders;

------------------------------------------------------------
-- 10. Monthly Revenue Growth
------------------------------------------------------------

WITH MonthlySales AS
(
SELECT
    MONTH(OrderDate) AS MonthNo,
    SUM(TotalAmount) AS Revenue
FROM orders
GROUP BY MONTH(OrderDate)
)

SELECT
    MonthNo,
    Revenue,
    LAG(Revenue)
    OVER(
        ORDER BY MonthNo
    ) AS PreviousMonthRevenue
FROM MonthlySales;

------------------------------------------------------------
-- 11. Revenue Growth Percentage
------------------------------------------------------------

WITH MonthlySales AS
(
SELECT
MONTH(OrderDate) AS MonthNo,
SUM(TotalAmount) AS Revenue
FROM orders
GROUP BY MONTH(OrderDate)
)

SELECT
MonthNo,
Revenue,

ROUND(

(
Revenue-
LAG(Revenue)
OVER(ORDER BY MonthNo)

)

/

LAG(Revenue)
OVER(ORDER BY MonthNo)

*100

,2)

AS GrowthPercentage

FROM MonthlySales;

------------------------------------------------------------
-- 12. Customer Spending Percentile
------------------------------------------------------------

SELECT
CustomerID,
SUM(TotalAmount) Revenue,

PERCENT_RANK()

OVER(

ORDER BY SUM(TotalAmount)

)

AS SpendingPercentile

FROM orders

GROUP BY CustomerID;

------------------------------------------------------------
-- 13. Customer Quartiles
------------------------------------------------------------

SELECT
CustomerID,

SUM(TotalAmount) Revenue,

NTILE(4)

OVER(

ORDER BY SUM(TotalAmount) DESC

)

AS Quartile

FROM orders

GROUP BY CustomerID;

------------------------------------------------------------
-- 14. Highest Order per Customer
------------------------------------------------------------

SELECT *

FROM

(

SELECT

CustomerID,

OrderID,

TotalAmount,

ROW_NUMBER()

OVER(

PARTITION BY CustomerID

ORDER BY TotalAmount DESC

)

AS rn

FROM orders

) x

WHERE rn=1;

------------------------------------------------------------
-- 15. Lowest Order per Customer
------------------------------------------------------------

SELECT *

FROM

(

SELECT

CustomerID,

OrderID,

TotalAmount,

ROW_NUMBER()

OVER(

PARTITION BY CustomerID

ORDER BY TotalAmount

)

AS rn

FROM orders

) x

WHERE rn=1;

------------------------------------------------------------
-- 16. Average Order Value per Customer
------------------------------------------------------------

SELECT

CustomerID,

OrderID,

TotalAmount,

ROUND(

AVG(TotalAmount)

OVER(

PARTITION BY CustomerID

),2)

AS AverageCustomerOrder

FROM orders;

------------------------------------------------------------
-- 17. Customer Contribution %
------------------------------------------------------------

SELECT

CustomerID,

SUM(TotalAmount) Revenue,

ROUND(

SUM(TotalAmount)

/

SUM(SUM(TotalAmount))

OVER()

*100

,2)

AS Contribution

FROM orders

GROUP BY CustomerID;

------------------------------------------------------------
-- 18. Cumulative Orders
------------------------------------------------------------

SELECT

OrderDate,

COUNT(*)

OVER(

ORDER BY OrderDate

)

AS RunningOrders

FROM orders;

------------------------------------------------------------
-- 19. Moving Average of Revenue
------------------------------------------------------------

SELECT

OrderDate,

TotalAmount,

ROUND(

AVG(TotalAmount)

OVER(

ORDER BY OrderDate

ROWS BETWEEN 2 PRECEDING

AND CURRENT ROW

)

,2)

AS MovingAverage

FROM orders;

------------------------------------------------------------
-- 20. Most Recent Purchase of Every Customer
------------------------------------------------------------

SELECT *

FROM

(

SELECT

CustomerID,

OrderDate,

ROW_NUMBER()

OVER(

PARTITION BY CustomerID

ORDER BY OrderDate DESC

)

AS rn

FROM orders

)x

WHERE rn=1;

------------------------------------------------------------
-- 21. First Purchase of Every Customer
------------------------------------------------------------

SELECT *

FROM

(

SELECT

CustomerID,

OrderDate,

ROW_NUMBER()

OVER(

PARTITION BY CustomerID

ORDER BY OrderDate

)

AS rn

FROM orders

)x

WHERE rn=1;

------------------------------------------------------------
-- 22. Revenue Share by Product
------------------------------------------------------------

SELECT

ProductID,

SUM(TotalAmount) Revenue,

ROUND(

SUM(TotalAmount)

/

SUM(SUM(TotalAmount))

OVER()

*100

,2)

AS RevenueShare

FROM orders

GROUP BY ProductID;

------------------------------------------------------------
-- 23. Rank Products by Revenue
------------------------------------------------------------

SELECT

ProductID,

SUM(TotalAmount) Revenue,

RANK()

OVER(

ORDER BY SUM(TotalAmount) DESC

)

AS ProductRank

FROM orders

GROUP BY ProductID;

------------------------------------------------------------
-- 24. Running Quantity Sold
------------------------------------------------------------

SELECT

ProductID,

OrderDate,

Quantity,

SUM(Quantity)

OVER(

PARTITION BY ProductID

ORDER BY OrderDate

)

AS RunningQuantity

FROM orders;

------------------------------------------------------------
-- 25. Top 5 Customers
------------------------------------------------------------

SELECT *

FROM

(

SELECT

CustomerID,

SUM(TotalAmount) Revenue,

DENSE_RANK()

OVER(

ORDER BY SUM(TotalAmount) DESC

)

AS Ranking

FROM orders

GROUP BY CustomerID

)x

WHERE Ranking<=5;

------------------------------------------------------------
-- End of Advanced SQL
------------------------------------------------------------