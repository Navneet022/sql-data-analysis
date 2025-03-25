--RANKING ANALYSIS


 --WHICH 5 PRODUCTS GENERATE THE HIGHEST REVENUE
  
 SELECT P.product_name , SUM(S.SALES_AMOUNT)
  FROM `first-447405.DataWarehouseAnalytics.Gold_fact_sales` AS S
  LEFT JOIN `first-447405.DataWarehouseAnalytics.GOld_dim_products` P
  ON P.PRODUCT_KEY=S.PRODUCT_KEY
  GROUP BY 1
  ORDER BY 2 DESC LIMIT 5

  --USING WINDOW FUNCTION

  SELECT *
  FROM (
    SELECT P.product_name , SUM(S.SALES_AMOUNT),
    ROW_NUMBER() OVER (ORDER BY 2 DESC) AS RANK_PRODUCTS
  FROM `first-447405.DataWarehouseAnalytics.Gold_fact_sales` AS S
  LEFT JOIN `first-447405.DataWarehouseAnalytics.GOld_dim_products` P
  ON P.PRODUCT_KEY=S.PRODUCT_KEY
  GROUP BY 1)
  WHERE RANK_PRODUCTS<=5;
 
 
--WHAT ARE THE 5 WORST-PERFORMING PRODUCTS IN TERMS OF SALES?

 SELECT P.product_name , SUM(S.SALES_AMOUNT)
  FROM `first-447405.DataWarehouseAnalytics.Gold_fact_sales` AS S
  LEFT JOIN `first-447405.DataWarehouseAnalytics.GOld_dim_products` P
  ON P.PRODUCT_KEY=S.PRODUCT_KEY
  GROUP BY 1
  ORDER BY 2 ASC LIMIT 5

--WHICH 5 SUBCATEGORIES GENERATE THE HIGHEST REVENUE

  SELECT P.subcategory , SUM(S.SALES_AMOUNT)
  FROM `first-447405.DataWarehouseAnalytics.Gold_fact_sales` AS S
  LEFT JOIN `first-447405.DataWarehouseAnalytics.GOld_dim_products` P
  ON P.PRODUCT_KEY=S.PRODUCT_KEY
  GROUP BY 1
  ORDER BY 2 DESC LIMIT 5
 
-- FIND THE TOP 10 CUSTOMERS WHO HAVE GENERATED THE HIGHEST REVENUE

  SELECT C.customer_key,C.first_name,C.last_name,SUM(S.SALES_AMOUNT)AS TOTAL_REVENUE
  FROM `first-447405.DataWarehouseAnalytics.Gold_dim_customers` C
  LEFT JOIN `first-447405.DataWarehouseAnalytics.Gold_fact_sales` AS S
  ON C.CUSTOMER_KEY=S.CUSTOMER_KEY
  GROUP BY 1,2,3
  ORDER BY 4 DESC LIMIT 10

-- THE 3 CUSTOMERS WITH THE FEWEST ORDERS PLACED
  
   SELECT C.customer_key,C.first_name,C.last_name,COUNT(DISTINCT ORDER_NUMBER)AS 	TOTAL_ORDERS
  FROM `first-447405.DataWarehouseAnalytics.Gold_dim_customers` C
  LEFT JOIN `first-447405.DataWarehouseAnalytics.Gold_fact_sales` AS S
  ON C.CUSTOMER_KEY=S.CUSTOMER_KEY
  GROUP BY 1,2,3
  ORDER BY 4 ASC LIMIT 3
