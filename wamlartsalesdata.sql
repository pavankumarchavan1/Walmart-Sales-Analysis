SELECT * FROM walmartsalesdata01;

-- ------------------------------------------- Feature Engineering ----------------------------------------------
-- --------------------------------------------------------------------------------------------------------------

-- 1. Add a new column named time_of_day to give insight of sales in the Morning, Afternoon and Evening.

SELECT time01,
	CASE
		WHEN time01 BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN time01 BETWEEN "12:01:00" AND "14:00:00" THEN "Afternoon"
        ELSE "Evening"
	END AS time_of_day
FROM walmartsalesdata01;

ALTER TABLE walmartsalesdata01
ADD COLUMN time_of_day VARCHAR(20);

UPDATE walmartsalesdata01
SET time_of_day = ( 
	CASE
		WHEN time01 BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN time01 BETWEEN "12:01:00" AND "14:00:00" THEN "Afternoon"
        ELSE "Evening"
	END
);


-- 2. Add a new column named day_name that contains the extracted days of the week

SELECT date, dayname(date) AS day_name
FROM walmartsalesdata01;

ALTER TABLE walmartsalesdata01
ADD COLUMN day_name VARCHAR(15);

UPDATE walmartsalesdata01
SET day_name = (dayname(date));


-- 3. Add a new column named month_name that contains the extracted months of the year

SELECT date, monthname(date) AS month_name
FROM walmartsalesdata01;

ALTER TABLE walmartsalesdata01
ADD COLUMN month_name VARCHAR(15);

UPDATE walmartsalesdata01
SET month_name = (monthname(date));



-- ------------------------------------- Generic Questions --------------------------------------------
-- ----------------------------------------------------------------------------------------------------

-- 1. How many unique cities does the data have?


SELECT DISTINCT(City)
FROM walmartsalesdata01;


-- 2. In which city is each branch?

SELECT DISTINCT(City), Branch
FROM walmartsalesdata01;


-- 3. How many branches does each city have?

SELECT City, COUNT(Branch)
FROM walmartsalesdata01
GROUP BY City;


-- ------------------------------------------- Product ------------------------------------------------
-- ----------------------------------------------------------------------------------------------------

-- 1. How many unique product lines does the data have?

SELECT COUNT(DISTINCT(Product_line)) AS unique_product_line
FROM walmartsalesdata01;


-- 2. What is the most common payment method?

SELECT Payment, COUNT(Payment) AS payment_method
FROM walmartsalesdata01
GROUP BY Payment
ORDER BY payment_method DESC;


-- 3. What is the most selling product line?

SELECT Product_line, COUNT(Product_line) most_selling
FROM walmartsalesdata01
GROUP BY Product_line
ORDER BY most_selling DESC;


-- 4. What is the total revenue by month?

SELECT month_name, SUM(Total) AS revenue
FROM walmartsalesdata01
GROUP BY month_name
ORDER BY revenue DESC;


-- 5. What month had the largest COGS?

SELECT month_name, SUM(cogs) AS COGS
FROM walmartsalesdata01
GROUP BY month_name
ORDER BY COGS DESC;


-- 6. What product line had the largest revenue?

SELECT Product_line, SUM(Total) AS PL_revenue
FROM walmartsalesdata01
GROUP BY Product_line
ORDER BY PL_revenue DESC;


-- 7. What is the city with the largest revenue?

SELECT City, Branch, SUM(Total) AS city_revenue
FROM walmartsalesdata01
GROUP BY City
ORDER BY city_revenue DESC;


-- 8. What product line had the largest VAT?

SELECT Product_line, MAX(VAT)
FROM walmartsalesdata01
GROUP BY Product_line;


-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales.

SELECT product_line, AVG(Quantity) AS avg_qty,
	CASE
		WHEN AVG(Quantity) > (SELECT AVG(Quantity) FROM walmartsalesdata01) THEN "Good"
        ELSE "Bad"
	END AS remark
FROM walmartsalesdata01
GROUP BY product_line
ORDER BY avg_qty DESC;


-- 10. Which branch sold more products than average product sold?

SELECT Branch, sub.avg_qty
FROM (
		SELECT Branch, SUM(Quantity) AS avg_qty, AVG(Quantity) AS qty
		FROM walmartsalesdata01
        GROUP BY Branch) AS sub
WHERE sub.avg_qty > sub.qty;


-- 11. What is the most common product line by gender?

SELECT Product_line, Gender, COUNT(Gender) AS gender_count
FROM walmartsalesdata01
GROUP BY Gender, Product_line
ORDER BY Gender, gender_count DESC;


-- 12. What is the average rating of each product line?

SELECT Product_line, ROUND(AVG(Rating), 3) avg_rating
FROM walmartsalesdata01
GROUP BY Product_line
ORDER BY avg_rating DESC;


-- ---------------------------------------------- Sale ---------------------------------------------
-- -------------------------------------------------------------------------------------------------

-- 1. Number of sales made in each time of the day per weekday

SELECT time_of_day, day_name, COUNT(*) AS total_sales
FROM walmartsalesdata01
GROUP BY day_name, time_of_day
ORDER BY total_sales DESC;


-- 2. Which of the customer types brings the most revenue?

SELECT Customer_type, SUM(Total) AS cust_revenue
FROM walmartsalesdata01
GROUP BY Customer_type;


-- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?

SELECT City, AVG(VAT) AS VAT
FROM walmartsalesdata01
GROUP BY City
ORDER BY VAT DESC;


-- 4. Which customer type pays the most in VAT?

SELECT Customer_type, AVG(VAT) AS cust_vat
FROM walmartsalesdata01
GROUP BY Customer_type;


-- -------------------------------------------- Cutomer ------------------------------------------------
-- -----------------------------------------------------------------------------------------------------

-- 1. How many unique customer types does the data have?

SELECT COUNT(DISTINCT(Customer_type)) AS unique_cust_type
FROM walmartsalesdata01;


-- 2. How many unique payment methods does the data have?

SELECT COUNT(DISTINCT(Payment)) AS unique_payment_metods
FROM walmartsalesdata01;


-- 3. What is the most common customer type?

SELECT Customer_type, COUNT(Customer_type)
FROM walmartsalesdata01
GROUP BY Customer_type;


-- 4. Which customer type buys the most?

SELECT Customer_type, SUM(Quantity)
FROM walmartsalesdata01
GROUP BY Customer_type;


-- 5. What is the gender of most of the customers?

SELECT Gender, COUNT(Gender) AS count_of_gender
FROM walmartsalesdata01
GROUP BY Gender;


-- 6. What is the gender of most of the customers accprding to customer type?
SELECT Gender, Customer_type, COUNT(Gender) AS count_of_gender
FROM walmartsalesdata01
GROUP BY Gender, Customer_type;


-- 7. What is the gender distribution per branch?

SELECT Branch, Gender, COUNT(Gender) AS gender_distribution
FROM walmartsalesdata01
GROUP BY Branch, Gender
ORDER BY Branch, gender_distribution DESC;


-- 8. Which time of the day do customers give most ratings?

SELECT time_of_day, ROUND(AVG(Rating), 2) AS most_ratings
FROM walmartsalesdata01
GROUP BY time_of_day
ORDER BY most_ratings DESC;


-- 9. Which time of the day do customers give most ratings per branch?

SELECT Branch, time_of_day, ROUND(AVG(Rating), 2) AS most_ratings_branch
FROM walmartsalesdata01
GROUP BY time_of_day, Branch
ORDER BY Branch, most_ratings_branch DESC;


-- 10. Which day of the week has the best avg ratings?

SELECT day_name, ROUND(AVG(Rating), 2) AS avg_ratings
FROM walmartsalesdata01
GROUP BY day_name
ORDER BY avg_ratings DESC;


-- 11. Which day of the week has the best average ratings per branch?

SELECT Branch, day_name, AVG(Rating) AS avg_rating_per_branch
FROM walmartsalesdata01
GROUP BY Branch, day_name
ORDER BY Branch, avg_rating_per_branch DESC;
