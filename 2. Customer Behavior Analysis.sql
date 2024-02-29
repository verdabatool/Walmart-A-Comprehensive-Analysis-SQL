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
