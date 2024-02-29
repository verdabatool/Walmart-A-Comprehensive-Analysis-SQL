``` sql
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
```
