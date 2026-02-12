#1. Overall Sales Performance

-- Monthly Revenue
SELECT
	YEAR(InvoiceDate) AS Year,
	MONTH(InvoiceDate) AS Month,
    SUM(Quantity * UnitPrice) AS TotalSales
FROM OnlineRetailDB
WHERE 
	Transaction_type = 'Sale'
    AND InvoiceDate IS NOT NULL
GROUP BY Year, Month
ORDER BY Year, Month
;

-- Quarterly Revenue
SELECT
	YEAR(InvoiceDate) AS Year,
    QUARTER(InvoiceDate) AS Quarter,
    SUM(Quantity * UnitPrice) AS TotalSales
FROM OnlineRetailDB
WHERE
	Transaction_type = 'Sale'
    AND InvoiceDate IS NOT NULL
GROUP BY Year, Quarter
ORDER BY Year, Quarter
;

#2. Growth & Momentum

-- MoM(Month-over-Month) Growth
WITH MonthlySales AS (
	SELECT
		DATE_FORMAT(InvoiceDate, '%Y-%m') AS YearMonth,
		SUM(Quantity * UnitPrice) AS TotalSales
    FROM OnlineRetailDB
    WHERE Transaction_type = 'Sale'
		AND InvoiceDate IS NOT NULL
    GROUP BY YearMonth
)
SELECT
	YearMonth,
    TotalSales,
    LAG(TotalSales) OVER (ORDER BY YearMonth) AS PrevMonthSales,
    ROUND(((TotalSales - LAG(TotalSales) OVER (ORDER BY YearMonth)) / LAG(TotalSales) OVER (ORDER BY YearMonth)*100), 2) AS MoMGrowthRate
FROM MonthlySales
ORDER BY YearMonth
;

-- QoQ(Quarter-over-Quarter) Growth
WITH QuarterlySales AS (
	SELECT
		YEAR(InvoiceDate) AS Year,
		QUARTER(InvoiceDate) AS Quarter,
		SUM(Quantity * UnitPrice) AS TotalSales
	FROM OnlineRetailDB
	WHERE 
		Transaction_type = 'Sale'
		AND InvoiceDate IS NOT NULL
	GROUP BY Year, Quarter
),
PrevQS AS (
	SELECT
		Year,
        Quarter,
        TotalSales,
        LAG(TotalSales, 1) OVER (ORDER BY Year, Quarter) AS PrevQuarterSales
	FROM QuarterlySales
)
SELECT
	Year,
    Quarter,
    TotalSales,
    PrevQuarterSales,
    ROUND(((TotalSales - PrevQuarterSales)/PrevQuarterSales)*100, 2) AS GrowthRate
FROM PrevQS
;


#3. Customer Value & Engagement

-- Top 10 High-value Customers
SELECT
	CustomerID,
	SUM(Quantity * UnitPrice) AS TotalSales
FROM OnlineRetailDB
WHERE CustomerID IS NOT NULL
	AND Transaction_type = 'Sale'
    AND InvoiceDate IS NOT NULL
GROUP BY CustomerID
ORDER BY TotalSales DESC
LIMIT 10
;
	
-- Top 10 Frequent Customers
SELECT
	CustomerID,
    COUNT(DISTINCT InvoiceNo) AS PurchaseCount
FROM OnlineRetailDB
WHERE
	CustomerID IS NOT NULL
    AND Transaction_type = 'Sale'
    AND InvoiceDate IS NOT NULL
GROUP BY CustomerID
ORDER BY PurchaseCount DESC
LIMIT 10
;

-- Top 10 High-Risk Customers (Cancellations)
SELECT
    CustomerID,
    COUNT(*) AS CancelledCount
FROM OnlineRetailDB
WHERE Transaction_type = 'Cancellation'
    AND CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY CancelledCount DESC
LIMIT 10
;


#4. Product Performance & Operational Risk

-- Top 10 Best Sellers
SELECT
    StockCode,
    Description,
    SUM(Quantity * UnitPrice) AS TotalSales
FROM OnlineRetailDB
WHERE InvoiceDate IS NOT NULL
	AND Transaction_type = 'Sale'
GROUP BY StockCode, Description
ORDER BY TotalSales DESC
LIMIT 10
;

-- Sales Volume vs Revenue by Product
SELECT
	StockCode,
    Description,
    SUM(Quantity) AS SalesVolume,
    SUM(Quantity * UnitPrice) AS TotalSales
FROM OnlineRetailDB
WHERE InvoiceDate IS NOT NULL
	AND Transaction_type = 'Sale'
GROUP BY StockCode, Description
ORDER BY TotalSales DESC
;

-- Cancellations by Product
SELECT
	StockCode,
    Description,
    COUNT(*) AS CancelledVolume
FROM OnlineRetailDB
WHERE Transaction_type = 'Cancellation'
GROUP BY StockCode, Description
ORDER BY CancelledVolume DESC
;

-- Monthly Cancellations
SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS YearMonth,
	COUNT(DISTINCT InvoiceNo) AS TotalOrders,
    COUNT(DISTINCT CASE WHEN Transaction_type = 'Cancellation' THEN InvoiceNo END) AS CancelledOrders,
    ROUND(
        COUNT(DISTINCT CASE WHEN Transaction_type = 'Cancellation' THEN InvoiceNo END) 
        / COUNT(DISTINCT InvoiceNo) * 100, 2
    ) AS CancellationRate
FROM OnlineRetailDB
WHERE InvoiceDate IS NOT NULL
GROUP BY YearMonth
ORDER BY YearMonth
;


#5. Geographical Sales Distribution

-- Sales Volume and Revenue by Country
SELECT
	Country,
    SUM(Quantity) AS SalesVolume,
    SUM(Quantity * UnitPrice) AS TotalSales
FROM OnlineRetailDB
WHERE InvoiceDate IS NOT NULL
	AND Transaction_type = 'Sale'
GROUP BY Country
ORDER BY TotalSales DESC
;

-- Cancellations by Country
WITH CountryOrders AS (
    SELECT
        Country,
        COUNT(DISTINCT InvoiceNo) AS TotalOrders
    FROM OnlineRetailDB
    WHERE
        Transaction_type = 'Sale'
        AND InvoiceDate IS NOT NULL
    GROUP BY Country
),
CountryCancelled AS (
    SELECT
        Country,
        COUNT(DISTINCT InvoiceNo) AS CancelledOrders
    FROM OnlineRetailDB
    WHERE
        Transaction_type = 'Cancellation'
        AND InvoiceDate IS NOT NULL
    GROUP BY Country
)
SELECT
    co.Country,
    co.TotalOrders,
    IFNULL(cc.CancelledOrders, 0) AS CancelledOrders,
    ROUND(IFNULL(cc.CancelledOrders, 0) / co.TotalOrders * 100,2) AS CancellationRate
FROM CountryOrders co
LEFT JOIN CountryCancelled cc
    ON co.Country = cc.Country
ORDER BY CancellationRate DESC
;

