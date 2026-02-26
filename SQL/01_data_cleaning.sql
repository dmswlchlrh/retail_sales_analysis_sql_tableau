# 1. Database Setup 
USE OnlineRetailSales;

# 2. Table Creation
CREATE TABLE IF NOT EXISTS OnlineRetailDB (
	InvoiceNo VARCHAR(20) NOT NULL, 
    StockCode VARCHAR(20) NOT NULL,
    Description	TEXT,
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice DECIMAL(10,2),
    CustomerID INT,
    Country VARCHAR(50),
    PRIMARY KEY (InvoiceNo, StockCode)
);

-- Verify Table Structure
SHOW TABLES;
SELECT * FROM OnlineRetailDB;

# 3. CSV Data Loading
SET GLOBAL local_infile = 1;

-- Note: Update the file path as per your local environment
LOAD DATA LOCAL INFILE 'OnlineRetail.csv'
INTO TABLE OnlineRetailDB
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Verify Data Loading
SELECT COUNT(*) AS total_records 
FROM OnlineRetailDB;

# 4. Handling Missing Values
-- Cleanse InvoiceDate: Set to NULL if dates are outside the analysis period (2010-12-01 to 2011-12-09)
UPDATE OnlineRetailDB
SET InvoiceDate = NULL
WHERE InvoiceDate NOT BETWEEN '2010-12-01' AND '2011-12-09';

-- Handle CustomerID: Set to NULL where ID is 0
UPDATE OnlineRetailDB
SET CustomerID = NULL
WHERE CustomerID = 0;

-- Handle Description: Set to NULL for empty strings
UPDATE OnlineRetailDB
SET Description = NULL
WHERE TRIM(Description) = '';

-- Handle Country: Set to NULL for empty strings or numeric patterns
UPDATE OnlineRetailDB
SET Country = NULL
WHERE
    TRIM(Country) = ''
    OR TRIM(Country) REGEXP '^[0-9]+(\\.[0-9]+)?$';

-- Verify Country cleansing results
SELECT DISTINCT Country
FROM OnlineRetailDB
ORDER BY Country;

# 5. Feature Engineering: Transaction Classification
-- Classify transaction types (Sale/Cancellation/Adjustment) based on InvoiceNo pattern and Quantity
ALTER TABLE OnlineRetailDB
ADD COLUMN Transaction_type VARCHAR(20);

UPDATE OnlineRetailDB
SET Transaction_type =
    CASE
        WHEN LOWER(InvoiceNo) LIKE 'c%' THEN 'Cancellation'
		WHEN Quantity < 0 THEN 'Adjustment'
		ELSE 'Sale'
END;

-- Check counts by Transaction Type
SELECT Transaction_type, COUNT(*) AS Num_Transactions
FROM OnlineRetailDB
GROUP BY Transaction_type;

# 6. Remove Duplicates
-- Identify duplicates using ROW_NUMBER()
SELECT *,
	ROW_NUMBER() OVER(
		PARTITION BY InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country
		ORDER BY InvoiceNo
	) AS row_num
 FROM onlineRetailDB;
 
-- Result: No duplicates found -> Skipping delete logic

/* (Optional: Delete logic for duplicates using CTE)
WITH cte AS (
    SELECT *,
		ROW_NUMBER() OVER(
			PARTITION BY InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country
			ORDER BY InvoiceNo
        ) AS row_num
    FROM OnlineRetailDB
)
DELETE FROM OnlineRetailDB
WHERE (InvoiceNo, StockCode, CustomerID) In (
	SELECT InvoiceNo, StockCode, CustomerID
    FROM cte
    WHERE row_num > 1
);
*/
