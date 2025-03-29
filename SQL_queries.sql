-- sql Retail sales analysis -- P1
CREATE DATABASE sql_project_p2;

-- CREATE TABLE 
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
  transactions_id INT , 
  sale_date	DATE, 
  sale_time TIME,
  customer_id FLOAT,
  gender VARCHAR(15),
  age FLOAT,
  category VARCHAR(15),
  quantiy  INT,
  price_per_unit FLOAT,
  cogs   FLOAT,
  total_sale FLOAT

);
SELECT * FROM retail_sales
LIMIT 10

SELECT 
COUNT(*) 
FROM retail_sales
-- Data Cleaning -- 
DELETE FROM retail_sales
WHERE transactions_id IS NULL 
   OR sale_time IS NULL 
   OR sale_date IS NULL 
   OR gender IS NULL 
   OR category IS NULL 
   OR quantiy IS NULL 
   OR price_per_unit IS NULL 
   OR cogs IS NULL 
   OR total_sale IS NULL;

 -- Data Exploration -- 
 -- How many sales we have? -- 
 SELECT COUNT(*) as total_sale FROM retail_sales
 -- How many Customers we have ? --
  SELECT DISTINCT customer_id as total_sale FROM retail_sales
  -- How many categories we have ? -- 
    SELECT DISTINCT category as total_sale FROM retail_sales
--- DATA ANALYSIS / BUSSINES KEY PROBLEMS & ANSWERS  -- 
-- MY ANALYSIS AND FINDINGS -- 
-- 1)Write a SQL query to retrieve all columns for sales made on '2022-11-05'.

--2)Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022.

--3)Write a SQL query to calculate the total sales (total_sale) for each category.

--4)Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

--5)Write a SQL query to find all transactions where the total_sale is greater than 1000.

--6)Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

--7)Write a SQL query to calculate the average sale for each month. Find out the best-selling month in each year.

--8)Write a SQL query to find the top 5 customers based on the highest total sales.

--9)Write a SQL query to find the number of unique customers who purchased items from each category.

--10)Write a SQL query to create each shift and the number of orders (Example: Morning <=12, Afternoon Between 12 & 17, Evening >17).

-------------------------------------------------------------------------------------------------------------
----  1)Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

--2)Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022.
SELECT 
*
FROM retail_sales
WHERE category = 'clothing'
AND 
TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
AND
quantiy >= 4

--3)Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
category ,
SUM(total_sale) as net_sale,
COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

--4)Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
  ROUND(CAST(AVG(age) AS NUMERIC), 2) AS average_age
FROM retail_sales
WHERE category = 'Beauty';

--5)Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale >= 1000

--6)Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
  category,
  gender,
  COUNT(*) AS total_trans
FROM retail_sales  -- Fixed the table name
GROUP BY 
  category, 
  gender
ORDER BY 1;

--7)Write a SQL query to calculate the average sale for each month. Find out the best-selling month in each year.

SELECT 
    year,
    month,
    avg_sale
FROM
(
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales
    GROUP BY 1, 2
) AS t1 
WHERE rank = 1;


--8)Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

--9)Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT
category,
COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category

--10)Write a SQL query to create each shift and the number of orders (Example: Morning <=12, Afternoon Between 12 & 17, Evening >17).
WITH hourly_sale AS (
    SELECT 
        sale_time, -- Select only necessary columns
        CASE 
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'MORNING'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
            ELSE 'EVENING'  
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders  -- Ensure alias is used for clarity
FROM hourly_sale
GROUP BY shift;

SELECT EXTRACT (HOUR FROM CURRENT_TIME)








 