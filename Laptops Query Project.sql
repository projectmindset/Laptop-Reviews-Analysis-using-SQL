-- Flipkart Laptop Reviews Analysis using SQL
 -- This project analyzes 24,000 laptop product reviews scraped from Flipkart, covering around 600 different laptop models. The goal is to gain business insights by examining product ratings, review trends, and customer sentiments.

--By leveraging SQL queries, I aim to answer key business questions such as:
--Which laptop brands are the most trusted?
--What factors impact customer ratings?
--Are highly reviewed laptops always highly rated?
--What are common issues in negative reviews?
--How do premium and budget laptops compare?

--The insights generated from this project can help businesses, retailers, and manufacturers improve their products and customer satisfaction.

--Q1 Which laptop brands have the highest and lowest average ratings?
SELECT TOP 10 
    LEFT(product_name, CHARINDEX(' ', product_name + ' ') - 1) AS brand, 
    ROUND(AVG(overall_rating), 2) AS avg_rating
FROM dbo.Laptops
GROUP BY LEFT(product_name, CHARINDEX(' ', product_name + ' ') - 1)
ORDER BY avg_rating DESC;

-- The above query shows that the laptop brand GIGABYTE has the ighest average rating of 4.7 out of 5 starts
------------------------------------------------------------------------------------------------------------

--Q2 What are the top 10 most reviewed laptops?
SELECT TOP 10 
    product_name, no_reviews 
FROM dbo.Laptops
ORDER BY no_reviews DESC;

-- The above query has shown that the most reviewed Laptops are HP 14S Intel Core i3 with a total of 954
----------------------------------------------------------------------------------------------------------

--Q3 Which laptops have the most extreme (1-star and 5-star) ratings?
SELECT TOP 10 
    product_name, 
    COUNT(CASE WHEN rating = 1 THEN 1 END) AS one_star_count, 
    COUNT(CASE WHEN rating = 5 THEN 1 END) AS five_star_count
FROM dbo.Laptops
GROUP BY product_name
ORDER BY five_star_count DESC, one_star_count ASC;

-- The above query displays the amount of needed press

-- Q4 What is the correlation between the number of reviews and average rating?
--SELECT 
--    (SUM(no_reviews * overall_rating) - SUM(no_reviews) * SUM(overall_rating) / COUNT(*)) /
--    (SQRT((SUM(no_reviews * no_reviews) - SUM(no_reviews) * SUM(no_reviews) / COUNT(*)) * 
--          (SUM(overall_rating * overall_rating) - SUM(overall_rating) * SUM(overall_rating) / COUNT(*)))) 
--    AS correlation
--FROM dbo.Laptops;

-- Q5 Which laptops are highly rated but have very few reviews (hidden gems)?
SELECT
    product_name, overall_rating, no_reviews
FROM dbo.Laptops
WHERE overall_rating >= 4.5 AND no_reviews < 50
ORDER BY overall_rating DESC;

-- Q6 What are the most common words in positive reviews?
SELECT TOP 20 word, COUNT(*) AS frequency
FROM (
    SELECT value AS word 
    FROM dbo.Laptops
    CROSS APPLY STRING_SPLIT(review, ' ') 
    WHERE rating >= 4
) AS words
GROUP BY word
ORDER BY frequency DESC;

-- Q7 How do ratings differ between premium and budget laptops?
SELECT 
    CASE 
        WHEN product_name LIKE '%MacBook%' OR product_name LIKE '%XPS%' THEN 'Premium'
        ELSE 'Budget'
    END AS category, 
    ROUND(AVG(overall_rating), 2) AS avg_rating
FROM dbo.Laptops
GROUP BY CASE 
        WHEN product_name LIKE '%MacBook%' OR product_name LIKE '%XPS%' THEN 'Premium'
        ELSE 'Budget'
    END;

-- Q8 How many reviews mention performance issues (e.g., slow, bad battery, heating)?
SELECT COUNT(*) AS count_of_negative_reviews 
FROM dbo.Laptops
WHERE review LIKE '%slow%' 
   OR review LIKE '%bad battery%' 
   OR review LIKE '%heating issue%';

--Q9 Which brands have the highest number of verified purchases?
SELECT 
    LEFT(product_name, CHARINDEX(' ', product_name + ' ') - 1) AS brand, 
    COUNT(*) AS verified_purchases
FROM dbo.Laptops
WHERE title LIKE '%Verified%'
GROUP BY LEFT(product_name, CHARINDEX(' ', product_name + ' ') - 1)
ORDER BY verified_purchases DESC;






