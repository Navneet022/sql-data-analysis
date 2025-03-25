--MEASURES EXPLORATION

 --GENERATE REPORT THAT SHOWS ALL KEY METRICS OF THE BUSINESS
___________________________________________________________________________________________

SELECT 'TOTAL SALES' AS measure_name, SUM(sales_amount) AS measure_value
FROM `first-447405.DataWarehouseAnalytics.Gold_fact_sales`

UNION ALL

SELECT 'TOTAL QUANTITY' AS measure_name, SUM(quantity) AS measure_value
FROM `first-447405.DataWarehouseAnalytics.Gold_fact_sales`

UNION ALL

SELECT 'AVERAGE PRICE' AS measure_name, AVG(price) AS measure_value
FROM `first-447405.DataWarehouseAnalytics.Gold_fact_sales`

UNION ALL

SELECT 'TOTAL ORDERS' AS measure_name, COUNT(price) AS measure_value
FROM `first-447405.DataWarehouseAnalytics.Gold_fact_sales`

UNION ALL

SELECT 'TOTAL PRODUCTS (Sales Fact)' AS measure_name, COUNT(product_key) AS measure_value
FROM `first-447405.DataWarehouseAnalytics.Gold_fact_sales`

UNION ALL

SELECT 'DISTINCT ORDERS' AS measure_name, COUNT(DISTINCT order_number) AS measure_value
FROM `first-447405.DataWarehouseAnalytics.Gold_fact_sales`

UNION ALL

SELECT 'TOTAL PRODUCTS (Dim Product)' AS measure_name, COUNT(product_key) AS measure_value
FROM `first-447405.DataWarehouseAnalytics.GOld_dim_products`

UNION ALL

SELECT 'TOTAL CUSTOMERS (Dim Customer)' AS measure_name, COUNT(customer_key) AS measure_value
FROM `first-447405.DataWarehouseAnalytics.Gold_dim_customers`

UNION ALL

SELECT 'CUSTOMERS WITH ORDERS' AS measure_name, COUNT(DISTINCT customer_key) AS measure_value
FROM `first-447405.DataWarehouseAnalytics.Gold_fact_sales`;
