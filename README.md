# Walmart-ComprehensiveAnalysis
## Project Objective

The objective of this project was to conduct an extensive Exploratory Data Analysis (EDA) on a Walmart Sales Data dataset to uncover insights into sales performance, customer behavior, product line profitability, payment method preferences, and temporal sales trends. By answering a comprehensive set of analytical questions, the project aimed to:

- Identify patterns in sales across different cities and branches.
- Understand customer demographics and their purchasing habits.
- Evaluate the performance of various product lines.
- Assess the impact of different payment methods on sales.
- Determine peak sales periods and understand how these vary by time of day and day of the week.
- Explore key business terms such as revenue, cost of goods sold (COGS), gross income, VAT, and customer loyalty.

The purpose of this project was not only to derive actionable insights for improving sales strategies, inventory management, and customer engagement but also to facilitate data-driven decision-making within the retail environment. Through meticulous analysis, the project provides valuable recommendations that could help in optimizing product offerings, enhancing customer satisfaction, and ultimately driving sales growth.

## About the Dataset

The dataset was obtained from the [Kaggle Walmart Sales Forecasting Competition](https://www.kaggle.com/datasets/yasserh/walmart-dataset). This dataset contains sales transactions from three different branches of Walmart, respectively located in Mandalay, Yangon, and Naypyitaw. The data contains 21 columns and 1000 rows. After cleaning, the dataset contains the following columns:

| Column name | Description | Datatype |
|----------|----------|----------|
| InvoiceID | Invoice of the sales made | VARCHAR (30)
| Branch | Branch at which sales were made | VARCHAR (30)
| City | The location of the branch | VARCHAR (30)
| Customer_type | The type of the customer | VARCHAR (10)
| Gender | The gender of customer | VARCHAR (10)
| Product_line | Product line of the product sold | VARCHAR (30)
| Unit_price | The porce of the unit sold | DOUBLE
| Quantity | The number of units sold | INT
| Tax_5% | The amount of tax on the purchase | DOUBLE
| Total | The total cost of the purchase (COGS + TAX) | DOUBLE 
| Date | The date on which the purchase was made | DATE
| Time | The time on which the purchase was made | TIME
| Payment | The method of payment used at the time of purchase | TEXT
| COGS | Cost Of Goods Sold (unit price * quantity) | DOUBLE
| Gross_income | Gross Income (total - cogs) | DOUBLE
| Rating | Rating of the purchase order | DOUBLE
| Time_of_day | The time of the day on which the purchase was made | TIME
| Day_name | The day on which the purchase was made | VARCHAR(10)
| Month_name | The month on which the purchase was made | VARCHAR(10)
| Month_number | The month number on which the purchase was made | VARCHAR(10)
| Year | The year on which the purchase was made | YEAR

## Approach

**1. Data Wrangling:** The dataset was cleaned and transformed to protect its integrity and make it suitable for analysis. It was checked for missing values and duplicates, datatypes were fixed.  
**2. Featured engineering:** was used to generate sone new columns such as `time_of_day` , `day_name` , `month_name` , `month_number` and `year` from the existing ones.
**3. Analysis:** SQL was used to analyze the data and answer the business questions.

# Analysis List

## EDA Questions

### General Insights
1. How many unique cities does the data have?
2. In which city is each branch?
3. How many unique product lines does the data have?
4. What is the most selling product line?
5. What is the total revenue by month?
6. What month had the largest COGS?
7. What product line had the largest revenue?
8. What is the city with the largest revenue?
9. What product line had the largest VAT?
10. Which branch sold more products than the average product sold?
11. What is the most common product line by gender?
12. What is the most common customer type?
13. Which customer type buys the most?
14. What is the gender of most of the customers?
15. What is the gender distribution per branch?
16. Which time of the day do customers give most ratings?
17. Which time of the day do customers give most ratings per branch?
18. Which day of the week has the best average ratings?
19. Which day of the week has the best average ratings per branch?
20. Number of sales made in each time of the day per weekday.
21. Which city has the largest tax/VAT percent?
22. Which customer type pays the most in VAT?

### Sales Performance Analysis
23. What is the monthly sales trend for each product line?
24. Compare the month-over-month sales across all branches.
25. Which branch has the highest total sales, and how does it compare month-over-month?
26. Calculate the month-over-month growth in sales for each city.
27. Rank product lines by sales within each branch.
28. Identify the month with the highest sales.
29. Calculate the MOM growth in each product line.
30. Determine the top-selling product each month.
31. Forecast next month's sales based on the current trend.

### Customer Behavior Analysis
32. What is the average transaction value for each customer type (Member vs. Normal)?
33. How does the gender of customers impact the types of products purchased and the average spend?
34. Identify the top 5% of customers by sales volume and analyze their purchasing patterns.
35. Analyze the correlation between customer ratings and their purchasing volume.
36. Examine the impact of customer type on payment method preference.

### Product Line Insights
37. Calculate the profitability (gross income) for each product line and rank them.
38. What is the average rating for each product line, and how does it correlate with sales volume?
39. Identify the product lines with the highest and lowest variability in sales across different branches.
40. Examine the price sensitivity of different product lines.
41. Forecast next month's demand for each product line based on the current trend. Identify which product lines have the potential for higher demands.

### Payment Method Analysis
42. What is the distribution of payment methods across different branches and customer types?
43. Compare the average sales value by payment method. Is there a significant difference?
44. Analyze the impact of payment methods on product line sales.
45. Determine the correlation between payment method and customer loyalty.
46. Assess the effect of payment method on the average basket size.
47. Identify trends in payment method preferences over time.
48. Examine the relationship between payment methods and customer satisfaction ratings.

### Time-Based Sales Analysis
49. What are the peak sales hours throughout the day?
50. Analyze sales performance by day of the week. Are there significant differences?
51. Analyze sales performance by day of the week and time of day. Are there significant differences?
52. Determine the best-performing hours for each product line.
