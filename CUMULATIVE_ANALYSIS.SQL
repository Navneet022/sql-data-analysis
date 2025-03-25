-- CUMULATIVE ANALYSIS.

--CALCULATE TOTAL SALES PER MONTH AND RUNNING TOTAL SALES OVER TIME
select order_date,total_sales,
sum(total_sales) over ( order by order_date) as running_total_sales,
round(avg(avg_price) over (order by order_date),2) as moving_average_price
from
(
 select DATE_TRUNC(DATE(order_date), year) AS order_date,
        sum(sales_amount) as total_sales,
        round(avg(price),2) as avg_price
 FROM `first-447405.DataWarehouseAnalytics.Gold_fact_sales`
 where order_date is not null
 group by 1
)

