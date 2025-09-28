CREATE TABLE ecom (
    order_date TEXT,
    time TEXT,
    aging INT,
    customer_id INT,
    gender TEXT,
    device_type TEXT,
    customer_login_type TEXT,
    product_category TEXT,
    product TEXT,
    sales INT,
    quantity INT,
    discount DOUBLE,
    profit DOUBLE,
    shipping_cost DOUBLE,
    order_priority TEXT,
    payment_method TEXT
);
 # adding table to schema
USE elevatelabs;
LOAD DATA LOCAL INFILE 'C:/Users/talre/Downloads/datasets/E-commerce csv.csv'
    INTO TABLE ecom
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS; -- Use if your CSV has a header row;
    SELECT*
    FROM ecom
    LIMIT 10;

   # looking for outliers
    SELECT aging
    FROM ecom
    ORDER BY aging DESC;
        SELECT sales
    FROM ecom
    ORDER BY sales DESC;
        SELECT quantity
    FROM ecom
    ORDER BY quantity DESC;
        SELECT discount
    FROM ecom
    ORDER BY discount DESC; #discount ranges from 10% to 50%
        SELECT profit
    FROM ecom
    ORDER BY profit DESC;
        SELECT shipping_cost
    FROM ecom
    ORDER BY shipping_cost DESC;

# CHECKING FOR NULL VALUES
        SELECT DISTINCT *
    FROM ecom
WHERE aging = 0 OR sales = 0 OR quantity = 0 OR DISCOUNT = 0 OR PROFIT = 0 OR SHIPPING_COST = 0;
SELECT DISTINCT *
    FROM ecom
WHERE order_date = "" OR time = "" OR customer_id = "" OR gender = "" OR device_type = "" OR customer_login_type = "" OR product_category = "" OR product = "" OR order_priority = "" OR payment_method = "";
# AGING, QUANTITY, SALES, DISCOUNT AND SHIPPING COST HAVE NULL VALUES
# ORDER_PRIORITY HAS NULL VALUES

# DEALING WITH NULL VALUES
SET SQL_SAFE_UPDATES = 0;
UPDATE ecom
SET order_priority = 'Other'
WHERE order_priority = "";

#FINDING THE ACTUAL VALUES OF NULL VALUES
SELECT * FROM ecom WHERE quantity=1 AND product='Car Speakers' AND discount=0.1 AND profit= 124.7; #FOR 0 SALES
SELECT * FROM ecom WHERE sales=72 AND product='Bike tyres' AND discount=0.1 AND profit= 36; #FOR 0 quantity
SELECT * FROM ecom WHERE sales=54 AND product='Car Mat' AND discount=0.2 AND profit= 54; #FOR 0 quantity
SELECT * FROM ecom WHERE sales=250 AND quantity=5 AND product='Tyre' AND profit= 132.5; #FOR 0 discount
SELECT * FROM ecom WHERE sales=250 AND product='Tyre' AND discount=0.2 AND profit= 150; #FOR 0 shipping cost

# UPDATING NULL VALUES
UPDATE ecom SET sales=211 WHERE sales=0;
DELETE FROM ecom WHERE quantity=0 AND sales=72 AND product='Bike tyres' AND discount=0.1 AND profit= 36;
UPDATE ecom SET quantity=1 WHERE sales=54 AND product='Car Mat' AND discount=0.2 AND profit= 54;
UPDATE ecom SET discount=0.3 WHERE discount=0;
UPDATE ecom SET shipping_cost=15 WHERE shipping_cost=0;

#checking if null values have been replaced
SELECT DISTINCT *
    FROM ecom
WHERE aging = 0 OR sales = 0 OR quantity = 0 OR DISCOUNT = 0 OR PROFIT = 0 OR SHIPPING_COST = 0;
SELECT DISTINCT *
    FROM ecom
WHERE order_date = "" OR time = "" OR customer_id = "" OR gender = "" OR device_type = "" OR customer_login_type = "" OR product_category = "" OR product = "" OR order_priority = "" OR payment_method = "";
select COUNT(*) FROM ecom;
    COMMIT;
    
SELECT COUNT(DISTINCT customer_id) FROM ecom;

#ANALYSIS 
#gender
SELECT 
    gender,
    COUNT(*) AS total_customers,
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM distinct_customers)) AS percentage
FROM distinct_customers
GROUP BY gender
ORDER BY percentage DESC;

#device type
SELECT 
    ( (SELECT COUNT(*) FROM ecom WHERE device_type = 'web') * 100.0 / COUNT(*)) AS percentage_web
FROM ecom;
SELECT 
    ( (SELECT COUNT(*) FROM ecom WHERE device_type = 'mobile') * 100.0 / COUNT(*)) AS percentage_mobile
FROM ecom;

#payment method
SELECT 
   payment_method,
    COUNT(*) AS total_orders,
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ecom)) AS percentage
FROM ecom
GROUP BY payment_method
ORDER BY percentage DESC;

#customer type
WITH distinct_customers AS (
    SELECT *
    FROM (
        SELECT ecom.*,
               ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS rn
        FROM ecom
    ) t
    WHERE rn = 1
    )
SELECT 
    customer_login_type,
    COUNT(*) AS total_customers,
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM distinct_customers)) AS percentage
FROM distinct_customers
GROUP BY customer_login_type
ORDER BY percentage DESC;

#most selling product category
SELECT 
    product_category,
    COUNT(*) AS total_orders,
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ecom)) AS percentage
FROM ecom
GROUP BY product_category
ORDER BY percentage DESC;

# most sold product
SELECT 
    product,
    COUNT(*) AS total_orders,
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ecom)) AS percentage
FROM ecom
GROUP BY product
ORDER BY percentage DESC;

#profit by category
SELECT 
    product_category,
    SUM(profit) AS total_profit
FROM ecom
GROUP BY product_category
ORDER BY product_category DESC;

#total profit
SELECT SUM(PROFIT) FROM ecom












    


