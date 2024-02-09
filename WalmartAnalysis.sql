CREATE DATABASE IF NOT EXISTS walmart_sales;
SELECT * FROM walmartsalesdata;

-- DATA CLEANING --
-- Dropping column
ALTER TABLE walmartsalesdata
DROP COLUMN gross_margin_percentage;

-- Changing Datatype of Date and Time from text to appropriate formats
SET sql_safe_updates = 0;

UPDATE walmartsalesdata
SET `Date` = str_to_date(`Date`, '%Y-%m-%d');
ALTER TABLE walmartsalesdata
MODIFY `Date` DATE;

UPDATE walmartsalesdata
SET `Time` = STR_TO_DATE(`Time`, '%H:%i:%s');
ALTER TABLE walmartsalesdata
MODIFY `Time` TIME;

-- Fixing the column names
ALTER TABLE walmartsalesdata
RENAME COLUMN `Invoice ID` TO `InvoiceID`;
ALTER TABLE walmartsalesdata
RENAME COLUMN `Customer type` TO `customer_type`;
ALTER TABLE walmartsalesdata
RENAME COLUMN `Unit price` TO `unit_price`;
ALTER TABLE walmartsalesdata
RENAME COLUMN `Product line` TO `product_line`;
ALTER TABLE walmartsalesdata
RENAME COLUMN `Tax 5%` TO `tax_5%`;
ALTER TABLE walmartsalesdata
RENAME COLUMN `gross income` TO `gross_income`;

-- Checking datatypes of coulmns
DESCRIBE walmartsalesdata;
-- InvoiceID text 
-- Branch text 
-- City text 
-- customer_type text 
-- Gender text 
-- product_line text 
-- unit_price double 
-- Quantity int 
-- tax_5% double 
-- Total double 
-- Date date 
-- Time time 
-- Payment text 
-- cogs double 
-- gross_income double 
-- Rating double 
-- time_of_day varchar(10) 
-- day_name varchar(10) 
-- month_name varchar(10) 
-- month_number varchar(10) 
-- year year

-- Checking for DUPLICATES
SELECT 
	InvoiceID,
    Branch,
    city,
    customer_type,
    gender,
    product_line,
    unit_price,
    Quantity,
    `tax_5%`,
    Total,
    `Date`,
	`Time`,
    Payment,
    cogs,
    gross_income,
    Rating,
    COUNT(*)
FROM 
	walmartsalesdata
GROUP BY 
	InvoiceID,
    Branch,
    city,
    customer_type,
    gender,
    product_line,
    unit_price,
    Quantity,
    `tax_5%`,
    Total,
    `Date`,
	`Time`,
    Payment,
    cogs,
    gross_income,
    Rating
HAVING COUNT(*) > 1;
## RESULT: There are no duplicate values

-- Checking for NULLS
SELECT 
	InvoiceID,
    Branch,
    city,
    customer_type,
    gender,
    product_line,
    unit_price,
    Quantity,
    `tax_5%`,
    Total,
    `Date`,
	`Time`,
    Payment,
    cogs,
    gross_income,
    Rating,
    COUNT(*)
FROM 
	walmartsalesdata
WHERE invoiceID IS NULL OR Branch IS NULL OR City IS NULL OR customer_type IS NULL OR Gender IS NULL OR product_line IS NULL OR unit_price IS NULL OR Quantity IS NULL OR `tax_5%` IS NULL OR Total IS NULL OR `Date` IS NULL OR `Time` IS NULL OR Payment IS NULL OR cogs IS NULL OR gross_margin_percentage IS NULL OR gross_income IS NULL OR Rating IS NULL
GROUP BY InvoiceID,
    Branch,
    city,
    customer_type,
    gender,
    product_line,
    unit_price,
    Quantity,
    `tax_5%`,
    Total,
    `Date`,
	`Time`,
    Payment,
    cogs,
    gross_income,
    Rating;
## RESULT: There are no duplicate values
   
-- Add time_of_day column
ALTER TABLE walmartsalesdata
ADD COLUMN time_of_day VARCHAR (10);
UPDATE walmartsalesdata
SET time_of_day = (
	CASE
		WHEN `Time` BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
		WHEN `Time` BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
		WHEN `Time` BETWEEN '18:00:00' AND '23:59:59' THEN 'Evening'
	ELSE 
		'Other'
	END
    );
    
-- Add column day_name
ALTER TABLE walmartsalesdata
ADD COLUMN day_name VARCHAR (10);
UPDATE walmartsalesdata
SET day_name = (
	SELECT
	  DATE_FORMAT(`Date`, '%a')
    );
    
-- Add column month_name and month_number
ALTER TABLE walmartsalesdata
ADD COLUMN month_name VARCHAR (10);
UPDATE walmartsalesdata
SET month_name = (
	SELECT
	  DATE_FORMAT(`Date`, '%M')
    );
    
ALTER TABLE walmartsalesdata
ADD COLUMN month_number VARCHAR (10);
UPDATE walmartsalesdata
SET month_number = (
	SELECT
	  DATE_FORMAT(`Date`, '%m')
    );
    
-- Add year column
ALTER TABLE walmartsalesdata
ADD COLUMN `year` YEAR;
UPDATE walmartsalesdata
SET `year` = (
	SELECT
	  DATE_FORMAT(`Date`, '%Y')
    );
    
-- EXPLORATORY DATA ANALYSIS
-- How many unique cities does the data have?
SELECT 
	DISTINCT city
FROM walmartsalesdata;
## There are three unique cities: Yangon, Naypyitaw and Mandalay

-- In which city is each branch?
SELECT 
	DISTINCT city,
    branch
FROM walmartsalesdata;
## Branch A is located in Yangon, Branch C in Naypyitaw and B in Mandalay

-- How many unique product lines does the data have?
SELECT 
	DISTINCT product_line
FROM 
	walmartsalesdata
ORDER BY 
	product_line ASC;
 ## There are 6 distinct product lines: 1- Electronic accessories 2- Fashion accessories 3- Food and Beverages 4- Health and Beauty 5- Home and lifestyle 6- Sports and travel   

-- What is the most selling product line?
SELECT 
    product_line,
    ROUND(SUM(total), 2) AS total_sales,
    ROUND((SUM(total) / (SELECT SUM(total) FROM walmartsalesdata) * 100), 2) AS percent_of_total_sales
FROM 
    walmartsalesdata
GROUP BY 
    product_line
ORDER BY 
    total_sales DESC;
## Top porduct line in terms of sales is Food and beverages followed by Sports and travel, Electronic accessories.
   
-- What is the total revenue by month?
SELECT 
	month_name,
    ROUND(SUM(total), 2) AS total_revenue
FROM 
	walmartsalesdata
GROUP BY 
	month_name, month_number
ORDER BY 
	month_number;
 ## March has the highest revenue
 
-- What month had the largest COGS?
SELECT 
	month_name,
    ROUND(SUM(cogs), 2) AS COGS
FROM
	walmartsalesdata
GROUP BY 
	month_name
ORDER BY 
	COGS DESC;
## January had the highest COGS
    
-- What is the city with the largest revenue?
SELECT 
	city AS largest_revenue_city,
    ROUND(SUM(total), 2) AS total_revenue
FROM 
	walmartsalesdata
GROUP BY 
	city
ORDER BY 
	total_revenue DESC
LIMIT 1;
## Naypyitaw is leading in terms of highest revenue followed by Yangon and Mandalay

-- What product line had the largest VAT?
SELECT 
	product_line AS highest_VAT_product_line,
    ROUND(SUM(`tax_5%`), 2) AS total_VAT
FROM 
	walmartsalesdata
GROUP BY 
	product_line
ORDER BY 
	total_VAT DESC
LIMIT 1;
## Food and beverages has the highets VAT followed by Sports and travel and Electronic accessories

-- What is the most common product line by gender?
SELECT 
	gender,
    product_line,
    COUNT(*) AS number_of_products
FROM
	walmartsalesdata
GROUP BY 
	GENDER,
    product_line
ORDER BY 
	gender, 
    number_of_products DESC;
## Among females, Fashion accessories are popular followed by Food and beverages and Sports and travel while in males health and beauty is the popular porduct line followed by Electronic accessories and Food and beverages

-- What is the average rating of each product line.
SELECT 
	product_line,
    ROUND(AVG(rating), 2) AS average_rating
FROM
	walmartsalesdata
GROUP BY 
	product_line
ORDER BY
	average_rating DESC;
## Food and beverages has the highest average rating followed by fashion accessories and Health and beauty

-- What is the most common customer type?
SELECT 
	customer_type,
    COUNT(*) AS number_of_customers
FROM
	walmartsalesdata
GROUP BY 
	customer_type;
## Memebers dominate the Normal ones

-- Which customer type buys the most?
SELECT 
	customer_type AS most_buying_customer_category,
    ROUND(SUM(Total), 2) AS total_sales
FROM
	walmartsalesdata
GROUP BY 
	customer_type
ORDER BY 
	total_sales DESC
LIMIT 1;
## Members buy the most

-- What is the gender of most of the customers?
SELECT 
	gender AS most_common_gender,
    COUNT(*) AS total_customers
FROM
	walmartsalesdata
GROUP BY 
	gender
ORDER BY 
	total_customers DESC
LIMIT 1;
## There are more females than males (although a very smal difference, almost negligible)

-- What is the gender distribution per branch?
SELECT
	branch,
    gender,
    COUNT(*) AS number_of_customers
FROM
	walmartsalesdata
GROUP BY 
	branch,
    gender
ORDER BY
	branch ASC, gender;
## There is almost equal distribution between males and females among branches 

-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
    COUNT(*) AS number_of_customers
FROM
	walmartsalesdata
GROUP BY 
	time_of_day
ORDER BY
	number_of_customers DESC;
## Customers give most ratings during afternoon

-- Which time of the day do customers give most ratings per branch?
SELECT
	branch,
    time_of_day,
    COUNT(*) AS number_of_ratings
FROM
	walmartsalesdata
GROUP BY
	time_of_day, branch
ORDER BY
	branch ASC, number_of_ratings DESC;
 ## All the branches have maximum ratings during afternoon

-- Which day of the week has the best average ratings per branch?
SELECT
	branch,
    day_name,
    ROUND(AVG(rating),2) AS average_rating
FROM 
	walmartsalesdata
GROUP BY 
	branch, day_name
ORDER BY 
	branch, average_rating DESC;
## Branch A and C has the best ratings on Monday while Branch C has the best ratings on Friday

-- Number of sales made in each time of the day per weekday 
WITH sales_daytime AS (
	SELECT 
		day_name,
		time_of_day,
		COUNT(*) number_of_sales
	FROM
		walmartsalesdata
	GROUP BY
		day_name,
		time_of_day
	ORDER BY 
		day_name,
		time_of_day
        )
SELECT
	*,
	RANK () OVER (PARTITION BY day_name ORDER BY number_of_sales DESC) AS ranked_sales
FROM
	sales_daytime;
## Entire week has predominantly maximum sales during Afternoon

-- Which city has the largest tax/VAT percent?
SELECT 
	city AS city_with_highest_VAT,
    ROUND(SUM(`tax_5%`),2) AS total_VAT
FROM
	walmartsalesdata
GROUP BY
	city
ORDER BY
	total_VAT DESC
LIMIT 1;
## Naypyitaw has the highest VAT followed by Yangon and Mandalay

-- Which customer type pays the most in VAT?
SELECT 
	customer_type AS customer_type_with_highest_VAT,
    ROUND(SUM(`tax_5%`),2) AS total_VAT
FROM
	walmartsalesdata
GROUP BY
	customer_type
ORDER BY
	total_VAT DESC
LIMIT 1;
## Members pay more VAT than Normal ones

-- 1. SALES PERFORMANCE ANALYSIS
-- 1i. What is the monthly sales trend for each product line?
SELECT
    product_line,
    month_name,
    month_number,
    ROUND(SUM(Total), 2) AS total_sales,
    ROUND(SUM(Total) / SUM(SUM(Total)) OVER (PARTITION BY month_name) * 100, 2) AS sales_percent_of_total
FROM 
    walmartsalesdata
GROUP BY
    product_line,
    month_name,
    month_number
ORDER BY
    product_line, total_sales DESC;
     
-- 1ii. Compere the month-over-month sales across all branches
WITH current_month_sales AS(
	SELECT
		branch,
		month_name,
		month_number,
		ROUND(SUM(Total), 2) AS current_month_sales
	FROM 
		walmartsalesdata
	GROUP BY 
		branch,
		month_name,
		month_number
	ORDER BY
		branch, month_number
	),
prev_month_sales AS(
	SELECT 
		branch,
		month_name,
		month_number,
        current_month_sales,
		LAG(current_month_sales, 1, 0) OVER (PARTITION BY branch ORDER BY branch, month_number) AS previous_month_sales
	FROM 
		current_month_sales)
SELECT 
	branch
    month_name,
	month_number,
	current_month_sales,
    previous_month_sales,
    COALESCE(ROUND(((current_month_sales - previous_month_sales)/previous_month_sales) * 100,2), 0)AS MOM_Growth
FROM 
	prev_month_sales;
    
-- 1iii. Which branch has the highest total sales, and how does it compare month-over-month?
WITH branch_having_highest_sale AS (
	SELECT 
		branch AS branch_with_highest_sales,
		ROUND(SUM(total),2) AS total_branch_sales
	FROM walmartsalesdata
	GROUP BY branch
	ORDER BY total_branch_sales DESC
	LIMIT 1
    ),
current_month_sales AS(
	SELECT
		branch,
		month_name,
		month_number,
		ROUND(SUM(Total), 2) AS current_month_sales
	FROM 
		walmartsalesdata
	GROUP BY 
		branch,
		month_name,
		month_number
	ORDER BY
		branch, month_number
	),
prev_month_sales AS(
	SELECT 
		branch,
		month_name,
		month_number,
        current_month_sales,
		LAG(current_month_sales, 1, 0) OVER (PARTITION BY branch ORDER BY branch, month_number) AS previous_month_sales
	FROM 
		current_month_sales)
SELECT 
	branch AS branch_with_highest_sales,
    month_name,
	month_number,
	current_month_sales,
    previous_month_sales,
    COALESCE(ROUND(((current_month_sales - previous_month_sales)/previous_month_sales) * 100, 2), 0)AS MOM_Growth
FROM 
	prev_month_sales
WHERE branch = (SELECT branch_with_highest_sales FROM branch_having_highest_sale);

-- 1iii. Calculate the month-over-month growth in sales for each city.
WITH current_month_sales AS(
	SELECT
		city,
		month_name,
		month_number,
		ROUND(SUM(Total), 2) AS current_month_sales
	FROM 
		walmartsalesdata
	GROUP BY 
		city,
		month_name,
		month_number
	ORDER BY
		city, month_number
	),
prev_month_sales AS(
	SELECT 
		city,
		month_name,
		month_number,
        current_month_sales,
		LAG(current_month_sales, 1, 0) OVER (PARTITION BY city ORDER BY city, month_number) AS previous_month_sales
	FROM 
		current_month_sales)
SELECT 
	city,
    month_name,
	month_number,
	current_month_sales,
    previous_month_sales,
    COALESCE(ROUND(((current_month_sales - previous_month_sales)/previous_month_sales) * 100,2), 0)AS MOM_Growth
FROM 
	prev_month_sales;
    
-- 1iv. Rank product lines by sales within each branch.
WITH sales_across_branches AS (
	SELECT 
    branch,
    product_line,
    ROUND(SUM(total),2) AS total_sales
FROM walmartsalesdata
GROUP BY branch,product_line
)
SELECT 
	*,
    RANK () OVER (PARTITION BY branch ORDER BY total_sales DESC) AS rnk
FROM 
	sales_across_branches;
    
-- 1v. Identify the month with the highest sales 
SELECT 
	month_name AS month_with_highest_sales,
    ROUND(SUM(total), 2) AS total_sales
FROM 
	walmartsalesdata
GROUP BY month_name
ORDER BY total_sales DESC
LIMIT 1;

-- 1vi. Calculate the MOM growth in each product line
WITH current_month_sales AS(
	SELECT
		product_line,
		month_name,
		month_number,
		ROUND(SUM(Total), 2) AS current_month_sales
	FROM 
		walmartsalesdata
	GROUP BY 
		product_line,
		month_name,
		month_number
	ORDER BY
		product_line, month_number
	),
prev_month_sales AS(
	SELECT 
		product_line,
		month_name,
		month_number,
        current_month_sales,
		LAG(current_month_sales, 1, current_month_sales) OVER (PARTITION BY product_line ORDER BY product_line, month_number) AS previous_month_sales
	FROM 
		current_month_sales)
SELECT 
	product_line,
    month_name,
	month_number,
	current_month_sales,
    previous_month_sales,
    COALESCE(ROUND(((current_month_sales - previous_month_sales)/previous_month_sales) * 100, 2), 0)AS MOM_Growth
FROM 
	prev_month_sales;

    
-- 1vii. Determine the top-selling product each month.
WITH sales_by_month AS (
	SELECT 
		product_line,
		month_name,
        month_number,
		ROUND(SUM(total),2) AS total_sales
	FROM walmartsalesdata
	GROUP BY product_line, month_name, month_number
	ORDER BY month_number ASC, total_sales DESC
)
SELECT 
	*
FROM (
	SELECT 
		*,
		RANK() OVER (PARTITION BY month_number ORDER BY month_number ASC, total_sales DESC) AS ranked_sales
	FROM sales_by_month
    ) rnk
WHERE ranked_sales = 1;

-- 1viii. Forecast next month's sales based on the current trend.
WITH monthly_growth AS (
    SELECT 
        month_name,
        AVG(total) AS average_monthly_sales,
        AVG(total) / LAG(AVG(total), 1, AVG(total)) OVER (ORDER BY month_number) AS monthly_growth_rate
    FROM walmartsalesdata
    GROUP BY month_name, month_number
)
SELECT 
    month_name,
    average_monthly_sales,
    ROUND(average_monthly_sales * monthly_growth_rate, 2) AS forecasted_sales
FROM monthly_growth
WHERE month_name = 'March'; -- Replace 'Current Month' with the actual current month

-- 2. CUSTOMER BEHAVIOR ANALYSIS
-- 2i. What is the average transaction value for each customer type (Member vs. Normal)?
SELECT 
	customer_type,
    ROUND(AVG(total),2) AS average_transaction
FROM 
	walmartsalesdata
GROUP BY 
	customer_type;

-- 2ii. How does the gender of customers impact the types of products purchased and the average spend?
SELECT
    gender,
    product_line,
    COUNT(*) AS total_purchases,
    ROUND(AVG(total), 2) AS average_spending
FROM
    walmartsalesdata
GROUP BY
    gender, 
    product_line
ORDER BY
    gender, 
    product_line,
    total_purchases DESC;

-- 2iii. Identify the top 5% of customers by sales volume and analyze their purchasing patterns.
WITH sales AS (
	SELECT 
		invoiceID,
		ROUND(SUM(total),2) AS total_sales
	FROM 
		walmartsalesdata
	GROUP BY 
		invoiceID
	ORDER BY 
		InvoiceID ASC
        ),
dist_cte AS (
	SELECT 
		*,
        ROUND(CUME_DIST() OVER (ORDER BY total_sales DESC) * 100, 2)  AS top_five_percent
	FROM 
		sales
        )
	SELECT 
		invoiceID,
        total_sales AS `top_5%_sales_volume`
	FROM 
		dist_cte
	WHERE top_five_percent <= 5.0;
    
-- 2iv. Analyze the correlation between customer ratings and their purchasing volume.
SELECT 
	rating,
    ROUND(SUM(total), 2) AS total_sales
FROM 
	walmartsalesdata
GROUP BY 
	rating
ORDER BY 
	rating ASC;
    
-- 2v. Examine the impact of customer type on payment method preference.
SELECT
    customer_type,
    payment,
    COUNT(*) AS total_transactions
FROM
    walmartsalesdata
GROUP BY
    customer_type, 
    payment
ORDER BY
    customer_type, 
    total_transactions DESC;

-- 3. PRODUCT LINE INSIGHTS
-- 3i. Calculate the profitability (gross income) for each product line and rank them.
WITH gross AS (
	SELECT 
		product_line,
		ROUND(SUM(gross_income)) AS total_gross_income
	FROM
		walmartsalesdata
	GROUP BY
		product_line
	ORDER BY 
		total_gross_income DESC
)
SELECT 
	*
FROM
	(SELECT 
		*,
        ROW_NUMBER() OVER (ORDER BY total_gross_income DESC) AS ranked
	FROM 
		gross) x
ORDER BY 
	total_gross_income DESC, ranked ASC;
    
-- 3ii. What is the average rating for each product line, and how does it correlate with sales volume?
SELECT 
	product_line,
    ROUND(AVG(rating), 2) AS average_rating,
    ROUND(SUM(total), 2) AS total_sales
FROM
	walmartsalesdata
GROUP BY 
	product_line
ORDER BY 
	average_rating DESC,
    total_sales DESC;

-- 3iii. Identify the product lines with the highest and lowest variability in sales across different branches.
SELECT 
	branch,
    product_line,
    ROUND(SUM(total), 2) AS total_sales
FROM
	walmartsalesdata
GROUP BY 
	branch,
    product_line
ORDER BY
	branch ASC,
    total_sales DESC;
    
-- 3iv. Examine the price sensitivity of different product lines.
SELECT 
	product_line,
    ROUND(AVG(total), 2) AS average_price,
    ROUND(AVG(Quantity), 2) AS average_units_sold,
    ROUND(AVG(Total / quantity), 2) AS price_elasticity
FROM
	walmartsalesdata
GROUP BY 
	product_line
ORDER BY 
	average_price DESC,
    average_units_sold ;
    
-- 3v. Forecast next month's demand for each product line based on the current trend. Identify which product lines have potential to have higher demands
WITH monthly_growth AS (
    SELECT 
        branch,
        product_line,
        month_name,
        AVG(quantity) AS average_quantity_sold,
        AVG(Quantity) / LAG(AVG(quantity), 1, AVG(quantity)) OVER (PARTITION BY branch, product_line ORDER BY month_number) AS monthly_growth_rate
    FROM walmartsalesdata
    GROUP BY product_line, branch, month_name, month_number
),
forecast AS (
	SELECT 
		branch,
		product_line,
		month_name,
		average_quantity_sold,
		ROUND(average_quantity_sold * monthly_growth_rate, 2) AS forecasted_demand
	FROM monthly_growth
    )
SELECT *
FROM forecast
WHERE forecasted_demand > average_quantity_sold;

-- 4. PAYMENT METHOD ANALYSIS
-- 4i. What is the distribution of payment methods across different branches and customer types?
SELECT
    branch,
    customer_type,
    payment,
    COUNT(*) AS total_transactions
FROM
    walmartsalesdata
GROUP BY
    branch, customer_type, payment
ORDER BY 
	branch ASC,
    customer_type ASC,
    total_transactions DESC;

-- 4ii. Compare the average sales value by payment method. Is there a significant difference?
SELECT 
	payment,
    ROUND(AVG(total), 2) AS average_sales
FROM
	walmartsalesdata
GROUP BY 
	payment
ORDER BY
	average_sales DESC;
    
-- 4iii. Analyze the impact of payment methods on product line sales.
SELECT
	payment,
    product_line,
    ROUND(SUM(total), 2) AS total_sales
FROM
	walmartsalesdata
GROUP BY 
	payment,
    product_line
ORDER BY
	payment,
    total_sales DESC;
    
-- 4iv. Determine the correlation between payment method and customer loyalty.
SELECT
    customer_type,
    payment,
    COUNT(*) AS total_transactions
FROM
    walmartsalesdata
GROUP BY
    customer_type, payment
ORDER BY
    customer_type ASC,
    total_transactions DESC;
    
-- 4v. Assess the effect of payment method on the average basket size.
SELECT
	payment,
    ROUND(AVG(quantity), 2) AS average_quantity
FROM
	walmartsalesdata
GROUP BY
	payment
ORDER BY 
	average_quantity DESC;
    
-- 4vi. Identify trends in payment method preferences over time.
SELECT
    payment,
    month_name,
    COUNT(*) AS total_transactions
FROM
    walmartsalesdata
GROUP BY
	payment,
    month_name,
    month_number
ORDER BY 
	month_number ASC,
    total_transactions DESC;

-- 4vii. Examine the relationship between payment methods and customer satisfaction ratings.
SELECT
	payment,
    COUNT(*) AS total_transactions,
    ROUND(SUM(total),2) AS total_sales,
    ROUND(AVG(rating), 2) AS average_rating
FROM
	walmartsalesdata
GROUP BY
	payment
ORDER BY
	total_transactions DESC,
    total_sales DESC,
    average_rating DESC;
    
-- 5. TIME BASED SALES ANALYSIS
-- 5i. What are the peak sales hours throughout the day?
SELECT
	time_of_day,
    COUNT(*) AS number_of_transactions
FROM
	walmartsalesdata
GROUP BY 
	time_of_day
ORDER BY
	number_of_transactions DESC;
    
-- 5ii. Analyze sales performance by day of the week. Are there significant differences?
SELECT
	day_name,
    ROUND(SUM(total),2) AS total_sales
FROM
	walmartsalesdata
GROUP BY 
	day_name
ORDER BY
	total_sales DESC;
-- 5iii. Analyze sales performance by day of the week and time of day. Are there significant differences?
SELECT
	day_name,
    time_of_day,
    ROUND(SUM(total),2) AS total_sales
FROM
	walmartsalesdata
GROUP BY 
	day_name,
    time_of_day
ORDER BY
    day_name,
    total_sales DESC;
    
-- 5iv. Determine the best-performing hours for each product line.
SELECT
	product_line,
    time_of_day,
    ROUND(SUM(total),2) AS total_sales
FROM
	walmartsalesdata
GROUP BY
	product_line,
    time_of_day
ORDER BY
	product_line,
    total_sales DESC;
