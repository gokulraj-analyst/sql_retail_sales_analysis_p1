# Mysql Retail Sales Analysis - Project 1
create database Sales_Analysis;
use Sales_Analysis;

# create table
create table retail_sales(
transactions_id int primary key,
sale_date date,
sale_time time,
customer_id int,
gender varchar(20),
age int,
category varchar(100),
quantity int,
price_per_unit float,
cogs float,
total_sales float
);
# Data Cleaning
select * from retail_sales where sale_date is null;
select * from retail_sales where sale_time is null;
# or Alternative way
select * from retail_sales where transactions_id is null or 
sale_date is null or sale_time is null or customer_id is null or
 gender is null or age is null or category is null 
or quantity is null or price_per_unit is null or 
cogs is null or total_sales is null;

delete from retail_sales where transactions_id is null or 
sale_date is null or sale_time is null or customer_id is null or
 gender is null or age is null or category is null 
or quantity is null or price_per_unit is null or 
cogs is null or total_sales is null;

#Data exploration
-- How many sales we have?
select count(transactions_id) as Total_sales from retail_sales;
 
 -- How many unique customers we have?
select count(distinct(customer_id)) as Total_customers from retail_sales;

 -- How many unique categories we have?
select distinct(category) as categories from retail_sales;
-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select * from retail_sales where sale_date='2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select * from retail_sales where category = 'Clothing' and left(sale_date,7)='2022-11' and quantity >=4 ;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,count(*) as total_orders,sum(total_sales) as total_sales from retail_sales group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select category,round(avg(age),0) as average_age_of_customers from retail_sales group by category having category='Beauty'; 

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales where total_sales > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category,gender,count(*)as total_transactions from retail_sales group by category,gender order by category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select Year,Best_Selling_Month,Average_Sales from (
select year(sale_date) as Year,month(sale_date) as Best_Selling_Month,round(avg(total_sales),2) as Average_Sales,
rank() over(partition by year(sale_date) order by avg(total_sales) desc) as rank_ from retail_sales group by 1,2) as t1
where t1.rank_=1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select customer_id as Top_Five_Customers,sum(total_sales) as Total_Sales from retail_sales group by 1 order by 2 desc limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select category,count(distinct(customer_id)) as Total_Customer from retail_sales group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with Hourly_sales as (
select *,
       case
       when hour(sale_time) < 12 then 'Morning'
       when hour(sale_time) between 12 and 17 then 'Afternoon'
       else 'Evening'
       end as shift from retail_sales)
       select shift as Shift,count(transactions_id) as Total_Orders from Hourly_sales group by shift ; 

-- End of Project


