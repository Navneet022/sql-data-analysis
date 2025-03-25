/*
===============================================================================
Customer Report
===============================================================================
Purpose:
  - This report consolidates key customer metrics and behaviors
 
Highlights:
  1. Gathers essential fields such as names, ages, and transaction details.
  2. Segments customers into categories (VIP, Regular, New) and age groups.
  3. Aggregates customer-level metrics:
     - total orders
     - total sales
     - total quantity purchased
     - total products
     - lifespan (in months)
  4. Calculates valuable KPIs:
    - recency (months since last order)
        - average order value
        - average monthly spend
===============================================================================
*/
CREATE OR REPLACE VIEW `first-447405.DataWarehouseAnalytics.REPORT` AS
  WITH BASE_QUERY AS(
-- =============================================================================

--1)Base Query: Retrieves core column from tables


  SELECT S.ORDER_NUMBER,S.PRODUCT_KEY,S.ORDER_DATE,S.SALES_AMOUNT,S.QUANTITY,C.   CUSTOMER_KEY,C.CUSTOMER_NUMBER,C.FIRST_NAME,C.LAST_NAME,
CONCAT(C.FIRST_NAME,' ',C.LAST_NAME) AS CUSTOMER_NAME, c.birthdate,
DATE_DIFF(CURRENT_DATE(),c.birthdate, YEAR) AS AGE
FROM `first-447405.DataWarehouseAnalytics.Gold_fact_sales` S
  LEFT JOIN   `first-447405.DataWarehouseAnalytics.Gold_dim_customers` c
  ON S.CUSTOMER_KEY=C.CUSTOMER_KEY
  WHERE ORDER_DATE IS NOT NULL
),

--3. Aggregates customer-level metrics:

CUSTOMER_AGG AS(
SELECT CUSTOMER_KEY, CUSTOMER_NUMBER,CUSTOMER_NAME, AGE,COUNT(DISTINCT ORDER_NUMBER) AS TOTAL_ORDERS, SUM(SALES_AMOUNT) AS TOTAL_SALES,SUM(QUANTITY) AS TOTAL_QUANTITY, COUNT(DISTINCT PRODUCT_KEY) AS TOTAL_PRODUCTS,
MAX(ORDER_DATE) AS LAST_ORDER_DATE,
DATE_DIFF(MAX(ORDER_DATE), MIN(ORDER_DATE), MONTH) AS LIFESPAN
FROM BASE_QUERY
GROUP BY 1,2,3,4)

--2. Segments customers into categories (VIP, Regular, New) and age groups.

SELECT CUSTOMER_KEY, CUSTOMER_NUMBER,CUSTOMER_NAME, AGE,
        CASE WHEN AGE<20 THEN 'UNDER 20'
              WHEN AGE BETWEEN 20 AND 29 THEN '20-29'
              WHEN AGE BETWEEN 30 AND 39 THEN '30-39'
              WHEN AGE BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 AND ABOVE'
        END AS AGE_GROUP,  
        TOTAL_ORDERS, TOTAL_SALES,TOTAL_QUANTITY,TOTAL_PRODUCTS,
         LIFESPAN,
         CASE  WHEN lifespan>=12 and TOTAL_SALES>5000 THEN 'VIP'
             WHEN lifespan>=12 and TOTAL_SALES<5000 THEN 'REGULAR'
             ELSE 'NEW'
      END AS customer_segment,
      -- RECENCY
      LAST_ORDER_DATE,DATE_DIFF(CURRENT_DATE(),LAST_ORDER_DATE,MONTH) AS RECENCY,
      --COMPUTE AVERAGE ORDER VALUE
      CASE WHEN TOTAL_SALES=0 THEN 0
           ELSE TOTAL_SALES/TOTAL_ORDERS
      END AS AVG_ORDER_VALUE,

      --COMPUTE AVERAGE MONTHLY VALUE
      CASE WHEN LIFESPAN=0 THEN TOTAL_SALES
          ELSE TOTAL_SALES/LIFESPAN
      END AS AVG_MONTHLY_SPENT
FROM CUSTOMER_AGG
ORDER BY 1
