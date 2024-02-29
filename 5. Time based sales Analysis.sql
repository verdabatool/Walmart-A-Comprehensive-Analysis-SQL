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