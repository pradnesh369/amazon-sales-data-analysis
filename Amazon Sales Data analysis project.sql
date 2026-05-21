DROP TABLE amazon_sales_data_analysis;

CREATE TABLE amazon_sales_data_analysis (
    order_id BIGINT,
    order_date VARCHAR(50),
    customer_id BIGINT,
    customer_name VARCHAR(255),
    product_id BIGINT,
    product_name VARCHAR(255),
    category VARCHAR(100),
    brand VARCHAR(100),
    quantity INT,
    unit_price NUMERIC(10,2),
    discount NUMERIC(5,2),
    tax NUMERIC(10,2),
    shipping_cost NUMERIC(10,2),
    total_amount NUMERIC(12,2),
    payment_method VARCHAR(100),
    order_status VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    seller_id BIGINT
);

--IMPORT CSV FILE

COPY amazon_sales_data_analysis (
    order_id,
    order_date,
    customer_id,
    customer_name,
    product_id,
    product_name,
    category,
    brand,
    quantity,
    unit_price,
    discount,
    tax,
    shipping_cost,
    total_amount,
    payment_method,
    order_status,
    city,
    state,
    country,
    seller_id
)
FROM 'D:/Project/Amazon sales data analysis.csv'
DELIMITER ','
CSV HEADER;

Select * from Amazon_sales_data_analysis

Select * from Amazon_sales_data_analysis

-- CHECK TOTAL ROWS

SELECT COUNT(*) AS total_rows FROM amazon_sales_data;

--CHECK NULL VALUES
SELECT *
FROM amazon_sales_data_analysis
WHERE order_id IS NULL
   OR order_date IS NULL
   OR customer_id IS NULL
   OR customer_name IS NULL
   OR product_id IS NULL
   OR product_name IS NULL
   OR category IS NULL
   OR brand IS NULL
   OR quantity IS NULL
   OR unit_price IS NULL
   OR discount IS NULL
   OR tax IS NULL
   OR shipping_cost IS NULL
   OR total_amount IS NULL
   OR payment_method IS NULL
   OR order_status IS NULL
   OR city IS NULL
   OR state IS NULL
   OR country IS NULL
   OR seller_id IS NULL;


-- REMOVE DUPLICATES 
DELETE FROM amazon_sales_data_analysis
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM amazon_sales_data_analysis
    GROUP BY order_id
);

Select * from Amazon_sales_data_analysis

--CONVERT DATE FORMAT

ALTER TABLE amazon_sales_data_analysis
ADD COLUMN new_order_date DATE;

UPDATE amazon_sales_data_analysis
SET new_order_date = TO_DATE(order_date, 'DD-MM-YYYY');

--CHECK DISTINCT CATEGORIES
SELECT DISTINCT category
FROM amazon_sales_data_analysis

-- TOTAL SALES

SELECT category,
       ROUND(SUM(total_amount),2) AS total_sales
FROM amazon_sales_data_analysis
GROUP BY category
ORDER BY category;

-- Total Customers
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM amazon_sales_data_analysis;

-- Total Products
SELECT COUNT(DISTINCT product_id) AS total_products
FROM amazon_sales_data_analysis;

--TOP 10 BEST SELLING PRODUCTS
SELECT product_name,
       SUM(quantity) AS total_quantity_sold
FROM amazon_sales_data_analysis
GROUP BY product_name
ORDER BY total_quantity_sold DESC
LIMIT 10;

--TOP 10 HIGHEST REVENUE PRODUCTS
SELECT product_name,
       ROUND(SUM(total_amount),2) AS total_revenue
FROM amazon_sales_data_analysis
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 10;

--TOP CUSTOMERS BY SPENDING

SELECT customer_name,
       ROUND(SUM(total_amount),2) AS total_spent
FROM amazon_sales_data_analysis
GROUP BY customer_name
ORDER BY total_spent DESC
LIMIT 10;

--SALES BY COUNTRY
SELECT country,
       ROUND(SUM(total_amount),2) AS total_sales
FROM amazon_sales_data_analysis
GROUP BY country
ORDER BY total_sales DESC;

--MOST USED PAYMENT METHOD
SELECT payment_method,
       COUNT(*) AS total_usage
FROM amazon_sales_data_analysis
GROUP BY payment_method

--HIGHEST TAX PRODUCTS
SELECT product_name,
       ROUND(AVG(tax),2) AS avg_tax
FROM amazon_sales_data_analysis
GROUP BY product_name
ORDER BY avg_tax DESC
LIMIT 10;

--HIGHEST SHIPPING COST PRODUCTS
SELECT product_name,
       ROUND(AVG(shipping_cost),2) AS avg_shipping_cost
FROM amazon_sales_data_analysis
GROUP BY product_name
ORDER BY avg_shipping_cost DESC
LIMIT 10;

--TOP PRODUCTS WITH HIGHEST DISCOUNT
SELECT product_name,
       ROUND(AVG(discount),2) AS avg_discount
FROM amazon_sales_data_analysis
GROUP BY product_name
ORDER BY avg_discount DESC

--RUNNING TOTAL SALES
SELECT new_order_date,
       SUM(total_amount) AS daily_sales,
       SUM(SUM(total_amount)) OVER (ORDER BY new_order_date) AS running_total_sales
FROM amazon_sales_data_analysis
GROUP BY new_order_date
ORDER BY new_order_date;

--CREATE INDEXES
CREATE INDEX idx_order_date
ON amazon_sales_data_analysis(new_order_date);

CREATE INDEX idx_category
ON amazon_sales_data_analysis(category);

CREATE INDEX idx_customer_id
ON amazon_sales_data_analysis(customer_id);

Select * from Amazon_sales_data_analysis


--CREATE VIEW FOR DASHBOARD
CREATE VIEW sales_dashboard AS
SELECT
    category,
    brand,
    country,
    payment_method,
    ROUND(SUM(total_amount),2) AS total_sales,
    SUM(quantity) AS total_quantity
FROM amazon_sales_data_analysis
GROUP BY category, brand, country, payment_method;

--EXPORT CLEAN DATA
COPY amazon_sales_data_analysis
TO 'D:/Project/amazon_sales_cleaned.csv'
DELIMITER ','
CSV HEADER;
