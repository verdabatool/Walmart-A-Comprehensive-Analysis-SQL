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