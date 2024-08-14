SQL Retail Analysis

For a retail e-commerce website, I performed a series of SQL tasks to clean and analyze the sales data. I utilized functions such as ROW_NUMBER() and DELETE to remove duplicate records, JOIN and UPDATE to correct pricing discrepancies, and IS NULL with UPDATE to handle null values. Additionally, I employed STR_TO_DATE() to clean date formats, SUM() and GROUP BY to summarize total sales, and COUNT() to analyze purchase frequency. These tasks provided valuable insights into product performance, customer behavior, and sales trends, enhancing the overall data quality and business decision-making.
## Key Tasks, Discoveries, and SQL Functions Used

 # 1.  Removing Duplicates 
-  Task:  Identified and removed duplicate records in the `sales_transaction` table.
-  SQL Functions Used: 
  - `ROW_NUMBER()`: To assign a unique number to each row within a partition of duplicates.
  - `DELETE`: To remove the identified duplicate rows from the original table.
  - `CREATE TABLE AS SELECT DISTINCT`: To create a new table with unique records.

 # 2.  Fixing Incorrect Pricing 
-  Task:  Identified discrepancies in pricing between `sales_transaction` and `product_inventory`, and updated prices to ensure consistency.
-  SQL Functions Used: 
  - `JOIN`: To compare pricing information between tables.
  - `UPDATE`: To correct discrepancies in the prices.
  - `SELECT DISTINCT`: To list unique discrepancies for verification.


The following query identifies products where the price in the `sales_transaction` table differs from the price in the `Product_inventory` table:

sql
SELECT DISTINCT pi.ProductID, pi.Price, st.Price 
FROM sales_transaction AS st 
JOIN Product_inventory AS pi 
ON st.ProductID = pi.ProductID
WHERE pi.Price <> st.Price;


![Description of the Image](./Users/tkarora/Desktop/1.png)



UPDATE sales_transaction AS st
SET price = (SELECT pi.price 
             FROM Product_inventory pi 
             WHERE pi.ProductID = st.ProductID)
WHERE st.ProductID IN 
    (SELECT pi.ProductID 
     FROM Product_inventory pi 
     WHERE st.price <> pi.price);

![Description of the Image](./Users/tkarora/Desktop/2.png)




 # 3.  Handling Null Values 
-  Task:  Replaced null values in the `customer_profiles` table with “Unknown”.
-  SQL Functions Used: 
  - `IS NULL`: To identify columns with null values.
  - `UPDATE`: To replace null values with “Unknown”.
  - `COUNT()`: To count the number of null values before and after replacement.

 # 4.  Cleaning Date Column 
-  Task:  Standardized the `TransactionDate` column by converting it from text to date format.
-  SQL Functions Used: 
  - `STR_TO_DATE()`: To convert text to date format.
  - `CREATE TABLE AS SELECT`: To create a new table with the cleaned date column.
  - `DROP TABLE`: To remove the original table.
  - `RENAME TABLE`: To rename the new table to the original table’s name.

 # 5.  Total Sales Summary 
-  Task:  Summarized total sales and quantities sold per product.
-  SQL Functions Used: 
  - `SUM()`: To calculate total sales and quantities.
  - `GROUP BY`: To group results by product.
  - `ORDER BY`: To sort results by total sales in descending order.

 # 6.  Customer Purchase Frequency 
-  Task:  Counted the number of transactions per customer.
-  SQL Functions Used: 
  - `COUNT()`: To count transactions per customer.
  - `GROUP BY`: To group results by customer.
  - `ORDER BY`: To sort results by number of transactions in descending order.

 # 7.  Product Category Performance 
-  Task:  Evaluated performance of product categories based on total sales.
-  SQL Functions Used: 
  - `SUM()`: To calculate total sales and units sold by category.
  - `GROUP BY`: To group results by product category.
  - `ORDER BY`: To sort results by total sales in descending order.

 # 8.  High and Low Sales Products 
-  Task:  Identified top 10 products with highest total sales and bottom 10 products with least units sold.
-  SQL Functions Used: 
  - `SUM()`: To calculate total revenue and units sold.
  - `ORDER BY`: To sort products by total revenue or units sold.
  - `LIMIT`: To restrict results to top 10 or bottom 10 products.

 # 9.  Sales Trends 
-  Task:  Analyzed sales trends by tracking daily transactions, units sold, and total sales.
-  SQL Functions Used: 
  - `COUNT()`: To count transactions per date.
  - `SUM()`: To calculate total units sold and sales per date.
  - `GROUP BY`: To group results by date.
  - `ORDER BY`: To sort results by date in descending order.

 # 10.  Growth Rate of Sales 
-  Task:  Calculated month-on-month growth rate of sales.
-  SQL Functions Used: 
  - `EXTRACT(MONTH FROM date_column)`: To extract month from transaction date.
  - `SUM()`: To calculate total sales per month.
  - `LAG()`: To access data from the previous month for growth rate calculation.
  - `ROUND()`: To format growth rate percentages.

 # 11.  Customer Segmentation 
-  Task:  Segmented customers based on the total quantity of products purchased.
-  SQL Functions Used: 
  - `SUM()`: To calculate total quantity purchased by each customer.
  - `CASE`: To create customer segments based on quantity purchased.
  - `GROUP BY`: To group customers by segment.
  - `COUNT()`: To count the number of customers in each segment.

Through these tasks and SQL functions, I effectively cleaned and analyzed the sales dataset, uncovering valuable insights that support informed business decisions.
