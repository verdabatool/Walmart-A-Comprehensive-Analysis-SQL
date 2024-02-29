## EXPLORATORY DATA ANALYSIS

**How many unique cities does the data have?**
```sql
SELECT 
	DISTINCT city
FROM walmartsalesdata;
``` 
**Output:** There are three unique cities: Yangon, Naypyitaw and Mandalay

| city      |
|-----------|
| Yangon    |
| Naypyitaw |
| Mandalay  |

**In which city is each branch?**
``` sql
SELECT 
	DISTINCT city,
    branch
FROM walmartsalesdata;
```
**Output:** Branch A is located in Yangon, Branch C in Naypyitaw and B in Mandalay

| city      | branch |
|-----------|--------|
| Yangon    | A      |
| Naypyitaw | C      |
| Mandalay  | B      |


**How many unique product lines does the data have?**
``` sql
SELECT 
	DISTINCT product_line
FROM 
	walmartsalesdata
ORDER BY 
	product_line ASC;
```
**Output:** There are 6 distinct product lines: 1- Electronic accessories 2- Fashion accessories 3- Food and Beverages 4- Health and Beauty 5- Home and lifestyle 6- Sports and travel   

| product_line           |
|------------------------|
| Electronic accessories |
| Fashion accessories    |
| Food and beverages     |
| Health and beauty      |
| Home and lifestyle     |
| Sports and travel      |


**What is the most selling product line?**
``` sql
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
```

**Output:** Top product line in terms of sales is Food and beverages followed by Sports and travel, Electronic accessories.

| product_line           | total_sales | percent_of_total_sales |
|------------------------|-------------|------------------------|
| Food and beverages     | 56144.84    | 17.38                  |
| Sports and travel      | 55122.83    | 17.07                  |
| Electronic accessories | 54337.53    | 16.82                  |
| Fashion accessories    | 54305.9     | 16.81                  |
| Home and lifestyle     | 53861.91    | 16.68                  |
| Health and beauty      | 49193.74    | 15.23                 

**What is the total revenue by month?**
``` sql
SELECT 
	month_name,
    ROUND(SUM(total), 2) AS total_revenue
FROM 
	walmartsalesdata
GROUP BY 
	month_name, month_number
ORDER BY 
	month_number;
```
**Output:** March has the highest revenue

| month_name | total_revenue |
|------------|---------------|
| January    | 116291.87     |
| February   | 97219.37      |
| March      | 109455.51     |



**Which month had the largest COGS?**
``` sql
SELECT 
	month_name,
    ROUND(SUM(cogs), 2) AS COGS
FROM
	walmartsalesdata
GROUP BY 
	month_name
ORDER BY 
	COGS DESC;
```
**Output:** January had the highest COGS

| month_name | COGS       |
|------------|------------|
| January    | 110754.16  |
| March      | 104243.34  |
| February   | 92589.88   |


**What is the city with the largest revenue?**
``` sql
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
```

**Output:** Naypyitaw is leading in terms of highest revenue followed by Yangon and Mandalay

| largest_revenue_city | total_revenue |
|----------------------|---------------|
| Naypyitaw            | 110568.71     |


**What product line had the largest VAT?**
``` sql
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
```
**Output:** Food and beverages has the highets VAT followed by Sports and travel and Electronic accessories


| highest_VAT_product_line | total_VAT |
|--------------------------|-----------|
| Food and beverages       | 2673.56   |


**What is the most common product line by gender?**
``` sql
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
```
**Output:** Among females, Fashion accessories are popular followed by Food and beverages and Sports and travel while in males health and beauty is the popular product line followed by Electronic accessories and Food and beverages

| gender | product_line           | number_of_products |
|--------|------------------------|--------------------|
| Female | Fashion accessories    | 96                 |
| Female | Food and beverages     | 90                 |
| Female | Sports and travel      | 88                 |
| Female | Electronic accessories | 84                 |
| Female | Home and lifestyle     | 79                 |
| Female | Health and beauty      | 64                 |
| Male   | Health and beauty      | 88                 |
| Male   | Electronic accessories | 86                 |
| Male   | Food and beverages     | 84                 |
| Male   | Fashion accessories    | 82                 |
| Male   | Home and lifestyle     | 81                 |
| Male   | Sports and travel      | 78                 |


**What is the average rating of each product line.**
``` sql
SELECT 
	product_line,
    ROUND(AVG(rating), 2) AS average_rating
FROM
	walmartsalesdata
GROUP BY 
	product_line
ORDER BY
	average_rating DESC;
```
**Output:** Food and beverages has the highest average rating followed by fashion accessories and Health and beauty.

| product_line           | average_rating |
|------------------------|----------------|
| Food and beverages     | 7.11           |
| Fashion accessories    | 7.03           |
| Health and beauty      | 7              |
| Electronic accessories | 6.92           |
| Sports and travel      | 6.92           |
| Home and lifestyle     | 6.84           |



**What is the most common customer type?**
``` sql
SELECT 
	customer_type,
    COUNT(*) AS number_of_customers
FROM
	walmartsalesdata
GROUP BY 
	customer_type;
```
**Output:** Memebers dominate the Normal ones

| customer_type | number_of_customers |
|---------------|---------------------|
| Member        | 501                 |
| Normal        | 499                 |


**Which customer type buys the most?**
``` sql
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
```
**Output:** Members buy the most

| most_buying_customer_category | total_sales |
|-------------------------------|-------------|
| Member                        | 164223.44   |


**What is the gender of most of the customers?**

``` sql
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
```
**Output:** There are more females than males (although a very smal difference, almost negligible)

| most_common_gender | total_customers |
|--------------------|-----------------|
| Female             | 501             |


**What is the gender distribution per branch?**
``` sql
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
```
**Output:** There is almost equal distribution between males and females among branches 

| branch | gender | number_of_customers |
|--------|--------|---------------------|
| A      | Female | 161                 |
| A      | Male   | 179                 |
| B      | Female | 162                 |
| B      | Male   | 170                 |
| C      | Female | 178                 |
| C      | Male   | 150                 |


**Which time of the day do customers give most ratings?**

``` sql
SELECT
	time_of_day,
    COUNT(*) AS number_of_customers
FROM
	walmartsalesdata
GROUP BY 
	time_of_day
ORDER BY
	number_of_customers DESC;
```
**Output:** Customers give most ratings during afternoon

| time_of_day | number_of_customers |
|-------------|---------------------|
| Afternoon   | 528                 |
| Evening     | 281                 |
| Morning     | 191                 |


**Which time of the day do customers give most ratings per branch?**

```sql
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
```
 **Output:** All the branches have maximum ratings during afternoon

| branch | time_of_day | number_of_ratings |
|--------|-------------|-------------------|
| A      | Afternoon   | 185               |
| A      | Evening     | 82                |
| A      | Morning     | 73                |
| B      | Afternoon   | 162               |
| B      | Evening     | 111               |
| B      | Morning     | 59                |
| C      | Afternoon   | 181               |
| C      | Evening     | 88                |
| C      | Morning     | 59                |


**Which day of the week has the best average ratings per branch?**
``` sql
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
``` 
**Output:** Branch A and C has the best ratings on Monday while Branch C has the best ratings on Friday

| branch | day_name | average_rating |
|--------|----------|----------------|
| A      | Fri      | 7.31           |
| A      | Mon      | 7.1            |
| A      | Sun      | 7.08           |
| A      | Tue      | 7.06           |
| A      | Thu      | 6.96           |
| A      | Wed      | 6.92           |
| A      | Sat      | 6.75           |
| B      | Mon      | 7.34           |
| B      | Tue      | 7              |
| B      | Sun      | 6.89           |
| B      | Thu      | 6.75           |
| B      | Sat      | 6.74           |
| B      | Fri      | 6.69           |
| B      | Wed      | 6.45           |
| C      | Fri      | 7.28           |
| C      | Sat      | 7.23           |
| C      | Wed      | 7.06           |
| C      | Mon      | 7.04           |
| C      | Sun      | 7.03           |
| C      | Tue      | 6.95           |
| C      | Thu      | 6.95           |


**Number of sales made in each time of the day per weekday**

``` sql
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
```

**Output:** Entire week has predominantly maximum sales during Afternoon

| day_name | time_of_day | number_of_sales | ranked_sales |
|----------|-------------|-----------------|--------------|
| Fri      | Morning     | 29              | 3            |
| Mon      | Afternoon   | 75              | 1            |
| Mon      | Evening     | 2               | 3            |
| Mon      | Morning     | 21              | 3            |
| Sat      | Afternoon   | 81              | 1            |
| Sat      | Evening     | 55              | 2            |
| Sat      | Morning     | 28              | 3            |
| Sun      | Afternoon   | 70              | 1            |
| Sun      | Evening     | 41              | 2            |
| Sun      | Morning     | 22              | 3            |
| Thu      | Afternoon   | 76              | 1            |
| Thu      | Morning     | 33              | 2            |
| Thu      | Evening     | 29              | 3            |
| Tue      | Afternoon   | 71              | 1            |
| Tue      | Evening     | 51              | 2            |
| Tue      | Morning     | 36              | 3            |
| Wed      | Afternoon   | 81              | 1            |
| Wed      | Evening     | 40              | 2            |
| Wed      | Morning     | 22              | 3            |

Please note that this output is limited to save up on space.

**Which city has the largest tax/VAT percent?**

``` sql
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
```
**Output:** Naypyitaw has the highest VAT followed by Yangon and Mandalay

| city_with_highest_VAT | total_VAT |
|-----------------------|-----------|
| Naypyitaw             | 5265.18   |


**Which customer type pays the most in VAT?**

``` sql
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
```
**Output:** Members pay more VAT than Normal ones

| customer_type_with_highest_VAT | total_VAT |
|--------------------------------|-----------|
| Member                         | 7820.16   |

