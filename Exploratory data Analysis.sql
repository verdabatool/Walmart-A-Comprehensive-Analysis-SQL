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