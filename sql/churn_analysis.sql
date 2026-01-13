/*
Project: Customer Retention & Churn Analysis
File: churn_analysis.sql
Purpose: Calculate monthly customer churn rates
Tool: SQL Server (SSMS)
*/

WITH customer_activity AS (
SELECT
CustomerID,
DATEFROMPARTS(YEAR(InvoiceDate), MONTH(InvoiceDate), 1) AS activity_month
FROM customer_data
GROUP BY
CustomerID,
DATEFROMPARTS(YEAR(InvoiceDate), MONTH(InvoiceDate), 1)
)
SELECT *
FROM customer_activity;
WITH customer_activity AS (
SELECT
CustomerID,
DATEFROMPARTS(YEAR(InvoiceDate), MONTH(InvoiceDate), 1) AS activity_month
FROM customer_data
GROUP BY
CustomerID,
DATEFROMPARTS(YEAR(InvoiceDate), MONTH(InvoiceDate), 1)
),
last_activity AS (
SELECT
CustomerID,
MAX(activity_month) AS last_active_month
FROM customer_activity
GROUP BY CustomerID
)
SELECT *
FROM last_activity;
WITH customer_activity AS (
SELECT
CustomerID,
DATEFROMPARTS(YEAR(InvoiceDate), MONTH(InvoiceDate), 1) AS activity_month
FROM customer_data
GROUP BY
CustomerID,
DATEFROMPARTS(YEAR(InvoiceDate), MONTH(InvoiceDate), 1)
),
last_activity AS (
SELECT
CustomerID,
MAX(activity_month) AS last_active_month
FROM customer_activity
GROUP BY CustomerID
),
churned_customers AS (
SELECT
DATEADD(MONTH, 1, last_active_month) AS churn_month,
COUNT(CustomerID) AS churned_customers
FROM last_activity
GROUP BY DATEADD(MONTH, 1, last_active_month)
)
SELECT *
FROM churned_customers
ORDER BY churn_month;
WITH customer_activity AS (
SELECT
CustomerID,
DATEFROMPARTS(YEAR(InvoiceDate), MONTH(InvoiceDate), 1) AS activity_month
FROM customer_data
GROUP BY
CustomerID,
DATEFROMPARTS(YEAR(InvoiceDate), MONTH(InvoiceDate), 1)
),
active_customers AS (
SELECT
activity_month,
COUNT(DISTINCT CustomerID) AS active_customers
FROM customer_activity
GROUP BY activity_month
),
last_activity AS (
SELECT
CustomerID,
MAX(activity_month) AS last_active_month
FROM customer_activity
GROUP BY CustomerID
),
churned_customers AS (
SELECT
DATEADD(MONTH, 1, last_active_month) AS churn_month,
COUNT(CustomerID) AS churned_customers
FROM last_activity
GROUP BY DATEADD(MONTH, 1, last_active_month)
)
SELECT
a.activity_month,
a.active_customers,
ISNULL(c.churned_customers, 0) AS churned_customers,
CAST(
100.0 * ISNULL(c.churned_customers, 0) / a.active_customers
AS DECIMAL(5,2)
) AS churn_rate
FROM active_customers a
LEFT JOIN churned_customers c
ON a.activity_month = c.churn_month

ORDER BY a.activity_month;

