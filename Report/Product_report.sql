/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/

CREATE OR REPLACE VIEW `first-447405.DataWarehouseAnalytics.PRODUCT_REPORT` AS

WITH BASE_QUERY AS (
  SELECT f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
from `first-447405.DataWarehouseAnalytics.Gold_fact_sales` F
 LEFT JOIN `first-447405.DataWarehouseAnalytics.GOld_dim_products` P
 ON F.PRODUCT_KEY=P.PRODUCT_KEY
  WHERE order_date IS NOT NULL
),

PRODUCT_AGGREGATIONS AS(
  SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    DATE_DIFF(Max(order_date), Min(order_date),month) AS lifespan,
    MAX(order_date) AS last_sale_date,
    COUNT(DISTINCT order_number) AS total_orders,
  COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
  ROUND(AVG(CAST(sales_amount AS FLOAT64) / NULLIF(quantity, 0)),1) AS avg_selling_price
FROM base_query

GROUP BY
    product_key,
    product_name,
    category,
    subcategory,
    cost
)
SELECT
  product_key,
  product_name,
  category,
  subcategory,
  cost,
  last_sale_date,
  DATE_DIFF(CURRENT_DATE(),last_sale_date,MONTH) AS recency_in_months,
  CASE
    WHEN total_sales > 50000 THEN 'High-Performer'
    WHEN total_sales >= 10000 THEN 'Mid-Range'
    ELSE 'Low-Performer'
  END AS product_segment,
  lifespan,
  total_orders,
  total_sales,
  total_quantity,
  total_customers,
  avg_selling_price,
  -- Average Order Revenue (AOR)
  CASE
    WHEN total_orders = 0 THEN 0
    ELSE total_sales / total_orders
  END AS avg_order_revenue,

  -- Average Monthly Revenue
  CASE
    WHEN lifespan = 0 THEN total_sales
    ELSE total_sales / lifespan
  END AS avg_monthly_revenue

FROM product_aggregations




