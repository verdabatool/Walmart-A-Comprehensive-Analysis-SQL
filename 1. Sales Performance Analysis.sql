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