--CUSTOMER SEGMENTATION

--1.Segment products into cost and count how many products fall into each segment
-------------------------------------------------------------------------------------------
with product_segment as(
      SELECT product_key,product_name,cost,
        case  when cost<100 then 'Below 100'
              when cost>100 and cost<500 then '100-500'
              when cost>500 and cost<1000 then '500-1000'
              else 'Above 1000'
        End cost_range      
      FROM `first-447405.DataWarehouseAnalytics.GOld_dim_products` )

 	select cost_range,
        count(product_key) as total_products
	from product_segment
	group by 1    
	order by 2


-------------------------------------------------------------------------------------------

 /* 2. Group customers into three segments based on their spending behaviour:
      1.VIP :Customers with atleast 12 months of history and spending more than
            $5,000.
      2. Regular: Customers with atleast 12 months of history but spending
            $5,000 or less.
      3. New: Customers with a lifespan less than 12 months
  And find the total number of customers by each group */  
-------------------------------------------------------------------------------------------

SELECT customer_segment, count(customer_key) as total_customer
FROM(select customer_key, total_spending,lifespan,
       CASE  WHEN lifespan>=12 and total_spending>5000 THEN 'VIP'
             WHEN lifespan>=12 and total_spending<5000 THEN 'REGULAR'
             ELSE 'NEW'
      END AS customer_segment
      	from (SELECT 
	      c.customer_key,sum(s.sales_amount) as total_spending, min(s.order_date) as 	      first_order , max(order_date) as last_order, DATETIME_DIFF(max(order_date), 	      min(order_date), month) as lifespan
	      FROM `first-447405.DataWarehouseAnalytics.Gold_fact_sales` s
	      Left Join   `first-447405.DataWarehouseAnalytics.Gold_dim_customers` c
	      on s.customer_key=c.customer_key
	      group by 1)
	      ) t
	group by 1
	order by 2 desc

