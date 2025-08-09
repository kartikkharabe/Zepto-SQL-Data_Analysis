drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingprice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

SELECT * FROM zepto

--data exploration

--count of rows
SELECT COUNT (*) FROM zepto

--sample data 
SELECT * FROM zepto
LIMIT 10

--null value
SELECT * FROM zepto
WHERE name IS NULL 
OR 
category IS NULL
OR 
mrp IS NULL
OR
discountpercent IS NULL
OR
discountedsellingprice IS NULL
OR
weightingms IS NULL
OR
availablequantity IS NULL
OR
outofstock IS NULL
OR
quantity IS NULL


--DIFFERENT PRODUCT CATEGORIES
SELECT DISTINCT category
FROM zepto
ORDER BY category


--PRODUCT IN STOCK VS OUT OF STOCK
SELECT outofstock, COUNT(sku_id)
FROM zepto
GROUP BY outofstock


--product name persent multiple times 
SELECT name, 
	COUNT(sku_id) as "Number  of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC


--DATA CLEANING


--PRODUCT WITH PRICE = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedsellingprice = 0;

DELETE FROM zepto
WHERE mrp = 0 


--convert paisa to rupess
UPDATE zepto 
SET mrp = mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0;
SELECT mrp, discountedsellingprice FROM zepto


--Questions
--Q1.Find the top 10 best-value products based on the discount percentage.
SELECT * FROM zepto
SELECT DISTINCT name,mrp,discountpercent
FROM zepto
ORDER BY discountpercent DESC 
LIMIT 10

--Q2.What are the products with high MRP but out of stock
SELECT DISTINCT name,mrp 
FROM zepto
WHERE outofstock = True and mrp > 300
ORDER BY mrp DESC

--Q3.Calculate estimated Revenue for each category
SELECT category,
SUM(discountedsellingprice * availablequantity) as total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue

--Q4.Find all products where MRP is greater than 500 and discount is less than 10%
SELECT category,mrp,discountpercent
FROM zepto
WHERE mrp > 500 and discountpercent < 10

--Q5.Identify the top 5 categories offering the highest average discount percentage
SELECT category,
	ROUND(AVG(discountpercent),2) as avgdiscountpercent
FROM zepto
GROUP BY category
ORDER BY avgdiscountpercent DESC 
LIMIT 5

--Q6.Find the price per gram for products above 100g and sort by best value
SELECT DISTINCT name,weightingms,discountedsellingprice,
ROUND(discountedsellingprice/weightingms,2) as pricepergms
FROM zepto
WHERE weightingms >= 100
ORDER BY pricepergms

--Q7.Group the products into categories like low, Medium, Bulk.
SELECT DISTINCT name,weightingms,
CASE WHEN weightingms < 1000 THEN 'Low'
	WHEN weightingms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weightcategory
FROM zepto

--Q8.What is the Total Inventory weight per category
SELECT category,
SUM(weightingms * availablequantity) as totalweight
FROM zepto
GROUP BY category
ORDER BY totalweight
