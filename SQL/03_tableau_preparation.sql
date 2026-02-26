#1. Performance Metrics

-- Monthly Sales & MoM (Month-over-Month) Growth
WITH MoM AS (
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
    ROUND(
	    IFNULL(
			((TotalSales - LAG(TotalSales) OVER (ORDER BY YearMonth))
			/ LAG(TotalSales) OVER (ORDER BY YearMonth)*100),
		0)
    , 2) AS MoMGrowthRate
FROM MoM
ORDER BY YearMonth
;

-- Quarterly Sales & QoQ(Quarter-over-Quarter) Growth
WITH QuarterlySales AS (
    SELECT
        CONCAT(DATE_FORMAT(InvoiceDate, '%Y'), '-Q', QUARTER(InvoiceDate)) AS YearQuarter,
        SUM(Quantity * UnitPrice) AS TotalSales
    FROM OnlineRetailDB
    WHERE Transaction_type = 'Sale'
        AND InvoiceDate IS NOT NULL
    GROUP BY YearQuarter
),
PrevQS AS (
    SELECT
        YearQuarter,
        TotalSales,
        LAG(TotalSales) OVER (ORDER BY YearQuarter) AS PrevQuarterSales
    FROM QuarterlySales
)
SELECT
    YearQuarter,
    TotalSales,
    PrevQuarterSales,
    ROUND(
        ((TotalSales - PrevQuarterSales) / PrevQuarterSales * 100), 2
    ) AS QoQGrowthRate
FROM PrevQS
ORDER BY YearQuarter;


#2. Customer Insights

-- Monthly Sales by Customer
SELECT
	DATE_FORMAT(InvoiceDate, '%Y-%m') AS YearMonth,
	CustomerID,
	SUM(Quantity * UnitPrice) AS TotalSales
FROM OnlineRetailDB
WHERE CustomerID IS NOT NULL
	AND Transaction_type = 'Sale'
    AND InvoiceDate IS NOT NULL
GROUP BY YearMonth, CustomerID
;

-- Monthly Customer Purchase Frequency
SELECT
	DATE_FORMAT(InvoiceDate, '%Y-%m') AS YearMonth,
	CustomerID,
    COUNT(DISTINCT InvoiceNo) AS PurchaseCount
FROM OnlineRetailDB
WHERE
	CustomerID IS NOT NULL
    AND Transaction_type = 'Sale'
    AND InvoiceDate IS NOT NULL
GROUP BY YearMonth, CustomerID
;

-- Monthly Cancellations by Customer
SELECT
	DATE_FORMAT(InvoiceDate, '%Y-%m') AS YearMonth,
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS CancelledOrders
FROM OnlineRetailDB
WHERE Transaction_type = 'Cancellation'
    AND CustomerID IS NOT NULL
    AND InvoiceDate IS NOT NULL
GROUP BY YearMonth, CustomerID
;


#3. Product Performance

-- Monthly Product Sales Volume & Revenue
SELECT
	DATE_FORMAT(InvoiceDate, '%Y-%m') AS YearMonth,
	StockCode,
    Description,
    SUM(Quantity) AS SalesVolume,
    SUM(Quantity * UnitPrice) AS TotalSales
FROM OnlineRetailDB
WHERE InvoiceDate IS NOT NULL
	AND Transaction_type = 'Sale'
GROUP BY YearMonth, StockCode, Description
;

-- Monthly Product Cancellations
SELECT
	DATE_FORMAT(InvoiceDate, '%Y-%m') AS YearMonth,
	StockCode,
    Description,
    COUNT(DISTINCT InvoiceNo) AS CancelledVolume
FROM OnlineRetailDB
WHERE Transaction_type = 'Cancellation'
	AND InvoiceDate IS NOT NULL
GROUP BY YearMonth, StockCode, Description
;


#4. Operational & Geographic Metrics

-- Monthly Orders & Cancellation Rate
SELECT
	DATE_FORMAT(InvoiceDate, '%Y-%m') AS YearMonth,
    COUNT(DISTINCT InvoiceNo) AS TotalOrders,
    COUNT(DISTINCT CASE WHEN Transaction_type = 'Cancellation' THEN InvoiceNo END) AS CancelledOrders,
    ROUND(
		COUNT(DISTINCT CASE WHEN Transaction_type = 'Cancellation' THEN InvoiceNo END) 
        / COUNT(DISTINCT InvoiceNo) * 100,2
	) AS CancellationRate
FROM OnlineRetailDB
WHERE InvoiceDate IS NOT NULL
GROUP BY YearMonth
ORDER BY YearMonth
;

-- Monthly Sales by Country
SELECT
	DATE_FORMAT(InvoiceDate, '%Y-%m') AS YearMonth,
	Country,
    SUM(Quantity) AS SalesVolume,
    SUM(Quantity * UnitPrice) AS TotalSales
FROM OnlineRetailDB
WHERE InvoiceDate IS NOT NULL
	AND Transaction_type = 'Sale'
GROUP BY YearMonth, Country
;

-- Cancellations by Country
WITH CountryOrders AS (
    SELECT
		DATE_FORMAT(InvoiceDate, '%Y-%m') AS YearMonth,
        Country,
        COUNT(DISTINCT InvoiceNo) AS TotalOrders
    FROM OnlineRetailDB
    WHERE Transaction_type = 'Sale'
        AND InvoiceDate IS NOT NULL
    GROUP BY YearMonth, Country
),
CountryCancelled AS (
    SELECT
		DATE_FORMAT(InvoiceDate, '%Y-%m') AS YearMonth,
        Country,
        COUNT(DISTINCT InvoiceNo) AS CancelledOrders
    FROM OnlineRetailDB
    WHERE Transaction_type = 'Cancellation'
        AND InvoiceDate IS NOT NULL
    GROUP BY YearMonth, Country
)
SELECT
	co.YearMonth,
    co.Country,
    co.TotalOrders,
    IFNULL(cc.CancelledOrders, 0) AS CancelledOrders,
    ROUND(IFNULL(cc.CancelledOrders, 0) / co.TotalOrders * 100,2) AS CancellationRate
FROM CountryOrders co
LEFT JOIN CountryCancelled cc
	ON co.YearMonth = cc.YearMonth
    AND co.Country = cc.Country
;


#5. Master Fact Table: Monthly Customer View
-- A consolidated table explaining customer behaviour on a monthly basis for Tableau visualisation
SELECT
    Date_format(InvoiceDate, '%Y-%m') AS YearMonth,
    CustomerID,
    Country,

    SUM(CASE WHEN Transaction_type='Sale'
        THEN Quantity * UnitPrice END) AS TotalSales,

    COUNT(DISTINCT CASE WHEN Transaction_type='Sale'
        THEN InvoiceNo END) AS PurchaseCount,

    COUNT(DISTINCT CASE WHEN Transaction_type='Cancellation'
        THEN InvoiceNo END) AS CancelledOrders
FROM OnlineRetailDB
WHERE InvoiceDate IS NOT NULL
  AND CustomerID IS NOT NULL
GROUP BY YearMonth, CustomerID, Country
;
