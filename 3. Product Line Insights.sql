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