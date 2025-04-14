CREATE DATABASE pro;

USE pro;

SELECT *
FROM retail
LIMIT 10;

ALTER TABLE retail RENAME COLUMN quantiy TO quantity;
ALTER TABLE retail RENAME COLUMN ï»¿transactions_id TO transactions_id ;

-- COUNT

SELECT count(*)
FROM retail;

-- NULL

SELECT *
FROM retail
WHERE transaction_id IS NULL
  OR gender IS NULL
  OR age IS NULL
  OR category IS NULL
  OR price_per_unit IS NULL
  OR total_sale IS NULL ;

-- BASIC OVERVIEW
-- 1.how many sales do we have

SELECT count(*) AS tot_sale
FROM retail;

-- 2.what is overall sales amount

SELECT sum(total_sale) AS total_sale
FROM retail;

-- 3.what is the average quantity sold per transaction

SELECT avg(quantity) AS avg_qunatity_per_transaction
FROM retail;

--  4.total no of unique customer we have

SELECT count(DISTINCT customer_id) AS unique_id
FROM retail;

-- 5.what is the most common transaction size in term of quantity?

SELECT quantity,
       count(*) AS freq
FROM retail
GROUP BY quantity
ORDER BY freq DESC
LIMIT 1;

-- CUSTOMERS ANALYSIS
 -- 1.top 5 customer based on highest total sale

SELECT customer_id,
       sum(total_sale) AS total_sale
FROM retail
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;

-- 2. which customer has highest avg spend per transaction

SELECT customer_id,
       avg(total_sale) AS avg_spend_per_transaction
FROM retail
GROUP BY customer_id
ORDER BY avg_spend_per_transaction DESC
LIMIT 1;

-- 3.no of unique customer who purchase item in each category

SELECT category,
       count(DISTINCT customer_id) AS unique_customer
FROM retail
GROUP BY category;

-- 4.average age of customers who purchase beauty products

SELECT round(avg(age), 2)AS age
FROM retail
WHERE category ="Beauty";

-- 5.avg age of customer in each product

SELECT category,
       avg(age) AS average_age
FROM retail
GROUP BY category;

-- 6. top 3 age group contributes most to total sales

SELECT age,
       sum(total_sale) AS total_sale
FROM retail
GROUP BY age
ORDER BY total_sale DESC
LIMIT 3;

-- 3. CATEGORY AND PRODUCT INSIGHTS
 -- 1.Unique category

SELECT DISTINCT category
FROM retail;

-- 2.which category has most sale or total sale form each category

SELECT category,
       sum(total_sale) AS total_sale
FROM retail
GROUP BY category
ORDER BY category DESC;

-- 3.which product category generates highest total sales

SELECT category
FROM retail
WHERE max(sum(total_sale));

-- 4.Are there any categories where the cost is more than the price (negative profit)

ALTER TABLE retail ADD COLUMN profit float;


UPDATE retail
SET profit=total_sale-cogs ;

-- here i notice that cogs is per unit

ALTER TABLE retail RENAME COLUMN cogs TO cogs_per_unit;


ALTER TABLE retail ADD COLUMN total_cogs float;


UPDATE retail
SET total_cogs=cogs_per_unit * quantity;


UPDATE retail
SET profit=total_sale-total_cogs;

-- NOW WE SOLVE THIS
-- Are there any categories where the cost is more than the price (negative profit)

SELECT category,
       sum(total_sale) AS total_sale_sum ,
       sum(total_cogs) AS total_cogs_sum
FROM retail
GROUP BY category
HAVING sum(total_sale)<sum(total_cogs) ;

-- 5 .average profit per catgory

SELECT category,
       avg(profit) AS avg_profit
FROM retail
GROUP BY category;

-- 6.Overall Profit

SELECT sum(profit) AS overall_profit
FROM retail;

--  6.How much markup is applied per unit on average in each category?

SELECT category,
       avg(profit) AS avg_profit
FROM retail GROUP  BY category;

-- GENDER BASED INSIGHTS
 -- 1.Which gender purchase more?

SELECT gender,
       sum(quantity) AS total_product_purchased
FROM retail
GROUP BY gender;

-- 2.total transaction by each gender in each category

SELECT gender,
       category,
       sum(transaction_id) AS total_transaction
FROM retail
GROUP BY gender,
         category
ORDER BY gender,
         category DESC;

-- 3.which product category is most preffred by male and female

SELECT category,
       gender,
       sum(quantity) AS product
FROM retail
GROUP BY gender,
         category
ORDER BY product DESC ;

-- TRANSACTION
-- 1.all transaction where toal sale is greater than 1000

SELECT transaction_id
FROM retail
WHERE total_sale >1000;
