--CHANGE OVER TIME (TRENDS)


-- SALES PERFORMANCE OVER A YEAR

SELECT EXTRACT(YEAR FROM order_date) AS order_year
,sum(sales_amount) as total_sales, count(distinct customer_key) as total_customer,
sum(quantity) as total_quantity
FROM `first-447405.DataWarehouseAnalytics.Gold_fact_sales`
where order_date is not null
group by 1
order by 1

-- SALES PERFORMANCE OVER A YEAR AND ACROSS EACH MONTH OF THAT YEAR

SELECT EXTRACT(YEAR FROM order_date) AS order_year,
 EXTRACT(month FROM order_date) AS order_month
,sum(sales_amount) as total_sales, count(distinct customer_key) as total_customer,
sum(quantity) as total_quantity
FROM `first-447405.DataWarehouseAnalytics.Gold_fact_sales`
where order_date is not null
group by 1,2
order by 1,2

--TO GET BOTH YEAR AND MONTH IN THE SAME COLUMN

SELECT DATE_TRUNC(order_date, MONTH) AS order_month,
sum(sales_amount) as total_sales, count(distinct customer_key) as total_customer,
sum(quantity) as total_quantity
FROM `first-447405.DataWarehouseAnalytics.Gold_fact_sales`
where order_date is not null
group by 1
order by 1

--TO GET BOTH YEAR AND MONTH IN THE SAME COLUMN

SELECT FORMAT_DATE('%Y-%b', DATE(order_date)) AS order_month  ,
sum(sales_amount) as total_sales, count(distinct customer_key) as total_customer,
sum(quantity) as total_quantity
FROM `first-447405.DataWarehouseAnalytics.Gold_fact_sales`
where order_date is not null
group by 1
order by 1
