SELECT
	CustomerID,
	MIN(InvoiceDate) AS first_purchase_date
FROM customer_data
GROUP BY CustomerID;
SELECT
	CustomerID,
	DATEFROMPARTS(YEAR(MIN(InvoiceDate)), MONTH(MIN(InvoiceDate)), 1) AS cohort_month
FROM customer_data
GROUP BY CustomerID;
WITH cohort_data AS (
	SELECT
		c.CustomerID,
		DATEFROMPARTS(YEAR(MIN(c.InvoiceDate)), MONTH(MIN(c.InvoiceDate)), 1) AS cohort_month
	FROM customer_data c
	GROUP BY c.CustomerID
),
transactions AS (
	SELECT
		cd.CustomerID,
		cd.cohort_month,
		DATEFROMPARTS(YEAR(t.InvoiceDate), MONTH(t.InvoiceDate), 1) AS transaction_month
	FROM customer_data t
	JOIN cohort_data cd
		ON t.CustomerID = cd.CustomerID
)
SELECT *
FROM transactions;
WITH cohort_data AS (
	SELECT
		CustomerID,
		DATEFROMPARTS(YEAR(MIN(InvoiceDate)), MONTH(MIN(InvoiceDate)), 1)  AS cohort_month
	FROM customer_data
	GROUP BY CustomerID
),
transactions AS (
	SELECT
		t.CustomerID,
		cd.cohort_month,
		DATEFROMPARTS(YEAR(t.InvoiceDate), MONTH(t.InvoiceDate), 1) AS transaction_month
	FROM customer_data t
	JOIN cohort_data cd
		ON t.CustomerID = cd.CustomerID
),
cohort_counts AS (
	SELECT
		cohort_month,
		DATEDIFF(MONTH, cohort_month, transaction_month) AS cohort_index,
		COUNT(DISTINCT CustomerID) AS active_customers
	FROM transactions
	GROUP BY
		cohort_month,
		DATEDIFF(MONTH, cohort_month, transaction_month)
),
cohort_size AS (
	SELECT
		cohort_month,
		COUNT(DISTINCT CustomerID) AS cohort_customers
	FROM cohort_data
	GROUP BY cohort_month
)
SELECT
	cc.cohort_month,
	cc.cohort_index,
	cc.active_customers,
	cs.cohort_customers,
	CAST(100.0 * cc.active_customers / cs.cohort_customers AS DECIMAL(5,2)) AS retention_rate
FROM cohort_counts cc
JOIN cohort_size cs
	ON cc.cohort_month = cs.cohort_month
ORDER BY cc.cohort_month, cc.cohort_index;
WITH cohort_data AS (
	SELECT
		CustomerID,
		DATEFROMPARTS(YEAR(MIN(InvoiceDate)), MONTH(MIN(InvoiceDate)),1 ) AS cohort_month
	FROM customer_data
	GROUP BY CustomerID
),
transactions AS (
	SELECT
		t.CustomerID,
		cd.cohort_month,
		DATEFROMPARTS(YEAR(t.InvoiceDate), MONTH(t.InvoiceDate), 1) AS transaction_month
	FROM customer_data t
	JOIN cohort_data cd
		ON t.CustomerID = cd.CustomerID
),
cohort_counts AS (
	SELECT
		cohort_month,
		DATEDIFF(MONTH, cohort_month, transaction_month) AS cohort_index,
		COUNT(DISTINCT CustomerID) AS active_customers
	FROM transactions
	GROUP BY
		cohort_month,
		DATEDIFF(MONTH, cohort_month, transaction_month)
),
cohort_size AS (
	SELECT
		cohort_month,
		COUNT(DISTINCT CustomerID) AS cohort_customers
	FROM cohort_data
	GROUP BY cohort_month
),
retention AS (
	SELECT
		cc.cohort_month,
		cc.cohort_index,
		CAST(100.0 * cc.active_customers / cs.cohort_customers AS DECIMAL(5,2)) AS retention_rate
	FROM cohort_counts cc
	JOIN cohort_size cs
		ON cc.cohort_month = cs.cohort_month
)
SELECT *
FROM retention;
WITH cohort_data AS (
SELECT
CustomerID,
DATEFROMPARTS(YEAR(MIN(InvoiceDate)), MONTH(MIN(InvoiceDate)), 1) AS cohort_month
FROM customer_data
GROUP BY CustomerID
),
transactions AS (
SELECT
t.CustomerID,
cd.cohort_month,
DATEFROMPARTS(YEAR(t.InvoiceDate), MONTH(t.InvoiceDate), 1) AS transaction_month
FROM customer_data t
JOIN cohort_data cd
ON t.CustomerID = cd.CustomerID
),
cohort_counts AS (
SELECT
cohort_month,
DATEDIFF(MONTH, cohort_month, transaction_month) AS cohort_index,
COUNT(DISTINCT CustomerID) AS active_customers
FROM transactions
GROUP BY
cohort_month,
DATEDIFF(MONTH, cohort_month, transaction_month)
),
cohort_size AS (
SELECT
cohort_month,
COUNT(DISTINCT CustomerID) AS cohort_customers
FROM cohort_data
GROUP BY cohort_month
),
retention AS (
SELECT
cc.cohort_month,
cc.cohort_index,
CAST(100.0 * cc.active_customers / cs.cohort_customers AS DECIMAL(5,2)) AS retention_rate
FROM cohort_counts cc
JOIN cohort_size cs
ON cc.cohort_month = cs.cohort_month
)
SELECT
cohort_month,
MAX(CASE WHEN cohort_index = 0 THEN retention_rate END) AS Month_0,
MAX(CASE WHEN cohort_index = 1 THEN retention_rate END) AS Month_1,
MAX(CASE WHEN cohort_index = 2 THEN retention_rate END) AS Month_2,
MAX(CASE WHEN cohort_index = 3 THEN retention_rate END) AS Month_3,
MAX(CASE WHEN cohort_index = 4 THEN retention_rate END) AS Month_4,
MAX(CASE WHEN cohort_index = 5 THEN retention_rate END) AS Month_5,
MAX(CASE WHEN cohort_index = 6 THEN retention_rate END) AS Month_6
FROM retention
GROUP BY cohort_month
ORDER BY cohort_month;