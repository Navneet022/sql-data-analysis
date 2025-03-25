--PART TO WHOLE ANALYSIS (PROPORTIONAL ANALYSIS)

--Which category contributes the most

With category_sales as (
	SELECT category,
 	sum(sales_amount) as total_sales
 	FROM `first-447405.DataWarehouseAnalytics.Gold_fact_sales` C
	LEFT JOIN  `first-447405.DataWarehouseAnalytics.GOld_dim_products` P
	ON C.product_key=P.product_key
	group by 1)

	select
	category, total_sales,
	sum(total_sales) over () as overall_sales,
	concat(round((cast (total_sales as FLOAT64) / sum(total_sales) over()) *100,2),'%') 	as percentage_of_total
	from category_sales
	order by 2 desc
