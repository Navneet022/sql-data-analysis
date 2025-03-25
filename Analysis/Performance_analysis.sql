--PERFORMANCE ANALYSIS

--ANALYSE THE YEARLY PERFORMANCE OF PRODUCTS BY COMPARING THEIR SALES TO BOTH THE AVERAGE SALES PERFORMANCE OF THE PRODUCT AND THE PREVIOUS YEAR'S SALES

with yearly_product_sales as (
  	SELECT EXTRACT(YEAR FROM C.ORDER_DATE) AS ORDER_YEAR,
  	P.PRODUCT_NAME,
	SUM(C.sales_amount) AS CURRENT_SALES
	FROM `first-447405.DataWarehouseAnalytics.Gold_fact_sales` C
	LEFT JOIN  `first-447405.DataWarehouseAnalytics.GOld_dim_products` P
	ON C.product_key=P.product_key
	where order_date is not null
	GROUP BY 1,2
)

select order_year,product_name,current_sales,
avg(current_sales) over(partition by product_name) as avg_sales,
current_sales-avg(current_sales) over(partition by product_name) as diff_sales,
case when current_sales-avg(current_sales) over(partition by product_name)>0      
      then 'Above Avg'
      when current_sales-avg(current_sales) over(partition by product_name) <0  
      then 'Below Avg'
      Else 'Avg'
End as avg_change,

--YEAR OVER YEAR ANALYSIS

lag(current_sales) over (partition by product_name order by order_year) as py_sales,
current_sales - lag(current_sales) over (partition by product_name order by order_year) as diff_py,
case
      when current_sales-lag(current_sales) over (partition by product_name order by 	order_year)>0      
      then 'Increase'
      when current_sales-lag(current_sales) over (partition by product_name order by 	order_year) <0  
      then 'Decrease'
      Else 'No change'
	End as py_change

from yearly_product_sales
order by 2,1 

