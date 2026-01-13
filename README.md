# Customer-Retention-Churn-Analysis-SQL-Server-
Business-Focused Analytics using real-world SQL techniques.
Project Overview
  This project analyze customer purchasing behavior to measure retention trends and monthly churn using SQL Server. Customers are grouped by into cohorts based onn their first purchase month, and their engagement is tracked over time to identify churn patterns and retention opportunties. The goal is to demonstrate business-focused analytics using real-world SQL techniques.

 DATASET
  Transaction-level customer purchase data
 Key Fields include:
 - InvoiceNo
 - StockCode
 - Description
 - Quantity
 - InvoiceDate
 - UnitPrice
 - CustomerID
 - Country
  Dataset was cleaned to remove missing values and strandardize date formats.

Tools & Technologies:
 - SQL Server (SSMS 21)
 - T-SQL
 - Common Table Expressions (CTEs)
 - Date normalizations & aggregation

 Methodology 
  1. Data Preparation
- Removed records with missing values
- Standardized InvoiceDate to monthly granularitty
- Ensured all customer had valid CustomerID values
  2. Cohort Analysis
- Identified each customer's first purchase month
- Group customer into cohorts
- Calculated month-over-month retention rates
  3. Churn Analysis
- Identified each customer's last active month
- Defined churn as no activity in the following month
- Calculated monthly churn rates

Key Findings
- Significant drop in customer activity after the first month, indicatiing early churn.
- Later cohorts show modest retention improvement, suggesting better engagement over time.
- A small group of customers demonstrates long-term retention, representing high-value segments.
- 
Business Implications
- Improve onbroading and post-purchase engagement in the first month
- Introduce loyalty incentives for repest customers
- Track cohort trends to evaluate retention intiatives
Project Structure
customer-retention-analysis/

│

├── data/

│   └── cleaned_customer_data.csv

│

├── sql/

│   ├── cohort_analysis.sql

│   └── churn_analysis.sql

│

├── README.md
