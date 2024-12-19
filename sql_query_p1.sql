CREATE TABLE retail_sales (
    transactions_id	INT PRIMARY KEY,
	sale_date	DATE,
	sale_time	TIME,
	customer_id	INT,
	gender	VARCHAR(15),
	age	     INT,
	category	VARCHAR(15),
	quantiy	INT,
	price_per_unit	FLOAT,
	cogs	FLOAT,
	total_sale FLOAT
	)
-- Data Cleaning--
SELECT * FROM retail_sales
WHERE transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantity IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL
	;
DELETE FROM retail_sales
WHERE transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantity IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL
	;

SELECT COUNT(*) FROM retail_sales;

-- Data Exploration

-- How many sales we have?  
-- Data Analysis & Business Key Problems & Answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT * FROM retail_sales
WHERE category LIKE 'Clothing' AND quantity = 4 AND TO_CHAR(sale_date,'YYYY-MM') = '2022-11' 

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category, SUM(total_sale) AS net_sale FROM retail_sales
GROUP BY category;

SELECT COUNT(*) FROM retail_sales
WHERE category LIKE 'Electronics';

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT ROUND(AVG(age), 2) FROM retail_sales
WHERE category LIKE 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT category, gender, COUNT(transactions_id) AS total_transactions FROM retail_sales
GROUP BY category, gender
	ORDER BY 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

SELECT year, month, avg_sale FROM
(
	SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
	RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
FROM retail_sales
GROUP BY 1, 2
	)
WHERE rank=1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT DISTINCT(customer_id), SUM(total_sale) AS net_sale FROM retail_sales
	GROUP BY customer_id
	ORDER BY net_sale DESC
	LIMIT 5;

--Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category, COUNT(DISTINCT(customer_id)) FROM retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
	AS
	( SELECT *,
  		CASE
   		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
END AS shift
FROM retail_sales)
SELECT shift, COUNT(transactions_id) FROM hourly_sale
	GROUP BY shift;

-- End of project



