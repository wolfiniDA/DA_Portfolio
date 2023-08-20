-- Creating a table
CREATE TABLE superstore_sales 
(
	id SERIAL PRIMARY KEY UNIQUE,
	order_id VARCHAR(16),
	order_date DATE,
	ship_date DATE,
	ship_mode VARCHAR(16),
	customer_id VARCHAR(16),
	customer_name VARCHAR(64),
	segment VARCHAR(16),
	country VARCHAR(16),
	city VARCHAR(32),
	state VARCHAR(32),
	postal_code INT,
	region VARCHAR(16),
	product_id VARCHAR(16),
	category VARCHAR(32),
	sub_category VARCHAR(32),
	product_name TEXT,
	sales FLOAT,
	quantity INT,
	discount FLOAT,
	profit NUMERIC(8, 4)
);

-- Copying data from csv file
COPY superstore_sales FROM 'C:\projects\Superstore.csv' DELIMITER ';' CSV HEADER;

-- Selecting all data
SELECT * 
FROM superstore_sales;

-- Checking NULL values
SELECT *
FROM superstore_sales
WHERE order_id IS NULL OR order_date IS NULL OR ship_date IS NULL OR ship_mode IS NULL OR customer_id IS NULL OR 
	customer_name IS NULL OR segment IS NULL OR country IS NULL OR city IS NULL OR state IS NULL OR 
	postal_code IS NULL OR region IS NULL OR product_id IS NULL OR category IS NULL OR sub_category IS NULL OR
	product_name IS NULL OR sales IS NULL OR quantity IS NULL OR discount IS NULL OR profit IS NULL; --0

-- Count fo all sales per customer_name
SELECT customer_name, COUNT(*) as count
FROM superstore_sales
GROUP BY customer_name
ORDER BY count DESC;

-- All sales per customer_id
SELECT *,
	row_number() OVER(PARTITION BY customer_id ORDER BY order_date) as sale_number
FROM superstore_sales

-- All first sales by customer_id
SELECT * FROM (
	SELECT *,
		row_number() OVER(PARTITION BY customer_id ORDER BY order_date) as sale_number
	FROM superstore_sales) as subquery
WHERE sale_number = 1;

-- Cumulative sum of orders by customer_id
SELECT customer_id, order_date, profit,
	SUM(profit) OVER(PARTITION BY customer_id ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as cumul_sum
FROM superstore_sales
ORDER BY customer_id, order_date;

-- Sum of profit by customer
SELECT customer_id, customer_sum FROM
	(SELECT customer_id, profit, SUM(profit) OVER(PARTITION BY customer_id) as customer_sum
	FROM superstore_sales) as subquery
GROUP BY customer_id, customer_sum
ORDER BY customer_id;

-- Cumulative sum of profit by day
SELECT order_date, profit,
	SUM(profit) OVER(PARTITION BY order_date ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as cumul_sum
FROM superstore_sales
ORDER BY order_date;

-- Sum of profit by day
SELECT order_date, day_sum FROM
	(SELECT order_date, profit, SUM(profit) OVER(PARTITION BY order_date) as day_sum 
	FROM superstore_sales) as subquery
GROUP BY order_date, day_sum
ORDER BY order_date;

-- Profit for all time
SELECT round(SUM(profit),2) as all_profit
FROM superstore_sales;

-- Orders count by segment
SELECT segment, COUNT(*) as count
FROM superstore_sales
GROUP BY segment
ORDER BY count DESC;

-- Orders count by category
SELECT category, COUNT(*) as count
FROM superstore_sales
GROUP BY category
ORDER BY count DESC;

-- Orders count by sub-category
SELECT sub_category, COUNT(*) as count
FROM superstore_sales
GROUP BY sub_category
ORDER BY count DESC;

-- Orders count by country
SELECT country, COUNT(*) as count
FROM superstore_sales
GROUP BY country
ORDER BY count DESC;

-- Orders count by region
SELECT region, COUNT(*) as count
FROM superstore_sales
GROUP BY region
ORDER BY count DESC;

-- Top 10 cities by orders
SELECT city, COUNT(*) as count
FROM superstore_sales
GROUP BY city
ORDER BY count DESC
LIMIT 10;

-- Order count by states
SELECT state, COUNT(*) as count
FROM superstore_sales
GROUP BY state
ORDER BY count DESC;

-- Top 5 products by sales
SELECT product_name, COUNT(*) as count
FROM superstore_sales
GROUP BY product_name
ORDER BY COUNT DESC
LIMIT 5;

-- Number of unique customers
SELECT COUNT (DISTINCT customer_id)
FROM superstore_sales;

-- Number of products sold
SELECT SUM(quantity) as quantity_sum
FROM superstore_sales

-- Top 1 profit data
SELECT *
FROM superstore_sales
WHERE profit = (SELECT MAX(profit) FROM superstore_sales);

-- Calculation of the selling price of each product and its change by date
SELECT *, price - LAG(price, 1, 0) OVER(PARTITION BY product_name ORDER BY order_date) as price_change FROM
	(SELECT order_date, product_name, CAST(sales/quantity AS NUMERIC(10,2)) as price
	FROM superstore_sales) as subquery;
	
-- Days with most disount
SELECT order_date, product_name, discount
FROM superstore_sales
ORDER BY discount DESC
LIMIT 20;

-- Average days from sale to shipping
SELECT ROUND(AVG(ship_date - order_date)) as avg
FROM superstore_sales;

-- Longest shipping time
SELECT order_date, ship_date, product_name, sales, quantity, ship_date-order_date as shipping_days
FROM superstore_sales
ORDER BY shipping_days DESC
LIMIT 1;

-- All orders made in September 2012 
SELECT *
FROM superstore_sales
WHERE order_date BETWEEN '2012-09-01' AND '2012-09-30'
ORDER BY order_date;

-- Mark of the day by the amount of profit
CREATE VIEW day_marks AS
	(SELECT order_date, profit, CASE
		WHEN profit > 1000 THEN 'Excellent day'
		WHEN profit > 100 THEN 'Good day'
		WHEN profit > 0 THEN 'Typical day'
		ELSE 'Bad day' 
		END as day_on_profit
	FROM superstore_sales);
	 
-- Number of days by profit marks
SELECT day_on_profit, count(*) as count
FROM day_marks
GROUP BY day_on_profit 
ORDER BY count DESC;

-- Top 20 products by all-time profit
SELECT product_name, SUM(profit) as sum_pr
FROM superstore_sales
GROUP BY product_name
ORDER BY sum_pr DESC
LIMIT 20;

-- All-time profit by category
SELECT category, SUM(profit) as sum_pr
FROM superstore_sales
GROUP BY category
ORDER BY sum_pr DESC;

-- All-time profit by sub_category
SELECT sub_category, SUM(profit) as sum_pr
FROM superstore_sales
GROUP BY sub_category
ORDER BY sum_pr DESC;

