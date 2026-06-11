-- Retail Sales Analysis -- 
Create database retail_sales;

-- data cleaning --
select count(*)
from retail_sales.retail_sales_eda;

select *
from retail_sales.retail_sales_eda
where transactions_id = 0
or
sale_date = 0
or
sale_time = 0
or
gender = '0'
or 
age = 0
or
category = '0'
or
quantity = 0
or
price_per_unit = 0
or
cogs = 0
or 
total_sale = 0;

delete from retail_sales.retail_sales_eda
where transactions_id = 0
or
sale_date = 0
or
sale_time = 0
or
gender = '0'
or 
age = 0
or
category = '0'
or
quantity = 0
or
price_per_unit = 0
or
cogs = 0
or 
total_sale = 0;

-- data exploration --

-- no. of sales -- 
select count(*) as total_sale
from retail_sales.retail_sales_eda;

-- how many customers in total and unique customers the business has
select count(customer_id), count(distinct customer_id)
from retail_sales.retail_sales_eda;

-- Unique categories --
select count(distinct category)
from retail_sales.retail_sales_eda;

select distinct category
from retail_sales.retail_sales_eda;

-- data analysis & solutions to key business problems --
select *
from retail_sales.retail_sales_eda
where sale_date = '2022-11-05';

select *
from retail_sales.retail_sales_eda
where category = 'clothing' and date_format(sale_date, "%Y-%m") = '2022-11' and quantity >= 4;

select category, sum( total_sale) as net_sale
from retail_sales.retail_sales_eda
group by 1;

select round(avg(age), 2) as avg_age
from retail_sales.retail_sales_eda
where category = 'beauty';

select *
from retail_sales.retail_sales_eda
where total_sale > 1000;

select category, gender, count(*)
from retail_sales.retail_sales_eda
group by category, gender
order by category;

select year(sale_date) as year, month(sale_date) as month, round(avg(total_sale), 2) as avg_sale
from retail_sales.retail_sales_eda
group by year, month
order by year, avg_sale desc;

select year, month, avg_sale
from (
	select year(sale_date) as year, 
		month(sale_date) as month, 
		round(avg(total_sale), 2) as avg_sale,
		rank() over ( partition by year(sale_date) order by avg(total_sale) desc ) as ranking
	from retail_sales.retail_sales_eda
	group by year, month
) as temp_table
where ranking = 1;

select customer_id, sum(total_sale) as total_sales
from retail_sales.retail_sales_eda
group by 1
order by 2 desc
limit 5;

select category, count(distinct customer_id) as unique_customers
from retail_sales.retail_sales_eda
group by 1;

select *
from retail_sales.retail_sales_eda;

with hourly_sale as 
(
	select *  ,
		case
			when extract(hour from sale_time) < 12 then 'Morning'
			when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
			else 'evening'
		end as shift
	from retail_sales.retail_sales_eda
)
select count(transactions_id) as total_orders, shift
from hourly_sale
group by shift;

select hour(current_time());