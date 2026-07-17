/*=========================================================
OLIST E-COMMERCE SQL ANALYSIS
Author: Asha Kumari
=========================================================*/

-- CREATE DATABASE olist;
USE olist;

-- ===========================
-- Customers
-- ===========================
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);

-- ===========================
-- Products
-- ===========================
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

-- ===========================
-- Sellers
-- ===========================
CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);

-- ===========================
Orders
-- ===========================
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

-- ===========================
-- Order Items
-- ===========================
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),

    PRIMARY KEY (order_id, order_item_id)
);

-- ===========================
-- Order Payments
-- ===========================
CREATE TABLE order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value DECIMAL(10,2),

    PRIMARY KEY (order_id, payment_sequential)
);

-- ===========================
-- Order Reviews
-- ===========================
CREATE TABLE order_reviews (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);

-- ===========================
-- Geolocation
-- ===========================
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat DOUBLE,
    geolocation_lng DOUBLE,
    geolocation_city VARCHAR(100),
    geolocation_state CHAR(2)
);

-- ===========================
-- Product Category Translation
-- ===========================
CREATE TABLE product_category_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);

select count(*) from geolocation;
truncate table geolocation;

SET GLOBAL local_infile = 1;

/*=========================================================
BASIC KPI QUERIES
=========================================================*/
/*=========================================================
1. Total Orders
=========================================================*/

SELECT
    COUNT(order_id) AS total_orders
FROM orders;

/*=========================================================
2. Total Customers
=========================================================*/

SELECT
    COUNT(customer_id) AS total_customers
FROM customers;

/*=========================================================
3. Total Sellers
=========================================================*/

SELECT
    COUNT(seller_id) AS total_sellers
FROM sellers;

/*=========================================================
4. Total Revenue
=========================================================*/

SELECT
    SUM(payment_value) AS total_revenue
FROM order_payments;

/*=========================================================
5. Average Payment Value
=========================================================*/

SELECT
    ROUND(AVG(payment_value),2) AS average_payment
FROM order_payments;

/*=========================================================
6. Order Status Distribution
=========================================================*/

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

/*=========================================================
7. Orders by Year
=========================================================*/

SELECT
    YEAR(order_purchase_timestamp) AS order_year,
    COUNT(*) AS total_orders
FROM orders
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY order_year;

/*=========================================================
8. Orders by Month
=========================================================*/

SELECT
    MONTH(order_purchase_timestamp) AS month_no,
    MONTHNAME(order_purchase_timestamp) AS month_name,
    COUNT(*) AS total_orders
FROM orders
GROUP BY
    MONTH(order_purchase_timestamp),
    MONTHNAME(order_purchase_timestamp)
ORDER BY month_no;

/*=========================================================
9. Total Products
=========================================================*/

SELECT
    COUNT(*) AS total_products
FROM products;

/*=========================================================
10. Average Review Score
=========================================================*/

SELECT
    ROUND(AVG(review_score), 2) AS average_review_score
FROM order_reviews;

/*=========================================================
SALES & REVENUE ANALYSIS
=========================================================*/
/*=========================================================
11. Highest Revenue Product Category
=========================================================*/

SELECT
    p.product_category_name AS product_category,
    SUM(oi.price) AS total_revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 1;

/*=========================================================
12. State with the Highest Number of Customers
=========================================================*/

SELECT
    customer_state,
    COUNT(customer_id) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC
LIMIT 1;

/*=========================================================
13. Payment Method Analysis
=========================================================*/

SELECT
    payment_type,
    COUNT(*) AS total_payments,
    SUM(payment_value) AS total_revenue
FROM order_payments
GROUP BY payment_type
ORDER BY total_payments DESC;

/*=========================================================
14. Top 10 Sellers by Revenue
=========================================================*/

SELECT
    s.seller_id,
    COUNT(oi.order_id) AS total_orders,
    SUM(oi.price) AS total_revenue
FROM sellers s
JOIN order_items oi
    ON s.seller_id = oi.seller_id
GROUP BY s.seller_id
ORDER BY total_revenue DESC
LIMIT 10;

/*=========================================================
15. Top 10 Customer Cities by Revenue
=========================================================*/

SELECT
    c.customer_city,
    COUNT(oi.order_id) AS total_orders,
    SUM(oi.price) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_city
ORDER BY total_revenue DESC
LIMIT 10;

/*=========================================================
11. Highest Revenue Product Category
=========================================================*/

SELECT
    p.product_category_name AS product_category,
    SUM(oi.price) AS total_revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 1;

/*=========================================================
12. State with the Highest Number of Customers
=========================================================*/

SELECT
    customer_state,
    COUNT(customer_id) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC
LIMIT 1;

/*=========================================================
13. Payment Method Analysis
=========================================================*/

SELECT
    payment_type,
    COUNT(*) AS total_payments,
    SUM(payment_value) AS total_revenue
FROM order_payments
GROUP BY payment_type
ORDER BY total_payments DESC;

/*=========================================================
14. Top 10 Sellers by Revenue
=========================================================*/

SELECT
    s.seller_id,
    COUNT(oi.order_id) AS total_orders,
    SUM(oi.price) AS total_revenue
FROM sellers s
JOIN order_items oi
    ON s.seller_id = oi.seller_id
GROUP BY s.seller_id
ORDER BY total_revenue DESC
LIMIT 10;

/*=========================================================
15. Top 10 Customer Cities by Revenue
=========================================================*/

SELECT
    c.customer_city,
    COUNT(oi.order_id) AS total_orders,
    SUM(oi.price) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_city
ORDER BY total_revenue DESC
LIMIT 10;

/*=========================================================
ADVANCED SQL (CTEs, Window Functions)
=========================================================*/
/*=========================================================
21. Product Category Revenue Ranking
=========================================================*/

WITH category_revenue AS (
    SELECT
        p.product_category_name AS product_category,
        SUM(oi.price) AS total_revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY p.product_category_name
)

SELECT
    product_category,
    total_revenue,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS category_rank
FROM category_revenue;

/*=========================================================
22. Seller Revenue Ranking
=========================================================*/

WITH seller_revenue AS (
    SELECT
        s.seller_id,
        SUM(oi.price) AS total_revenue
    FROM sellers s
    JOIN order_items oi
        ON s.seller_id = oi.seller_id
    GROUP BY s.seller_id
)

SELECT
    seller_id,
    total_revenue,
    DENSE_RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS seller_rank
FROM seller_revenue;

/*=========================================================
23. Top 3 Products in Each Category by Revenue
=========================================================*/

WITH product_revenue AS (
    SELECT
        p.product_category_name AS product_category,
        p.product_id,
        SUM(oi.price) AS total_revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_category_name,
        p.product_id
),

ranked_products AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY product_category
            ORDER BY total_revenue DESC
        ) AS product_rank
    FROM product_revenue
)
SELECT
    *
FROM ranked_products
WHERE product_rank <= 3;

/*=========================================================
24. Highest Spending Customer in Each State
=========================================================*/

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_state,
        SUM(oi.price) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_id,
        c.customer_state
),

ranked_customers AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY customer_state
            ORDER BY total_revenue DESC
        ) AS customer_rank
    FROM customer_revenue
)
SELECT
    *
FROM ranked_customers
WHERE customer_rank = 1;

/*=========================================================
25. Revenue Contribution by Product Category
=========================================================*/

WITH category_revenue AS (
    SELECT
        p.product_category_name AS product_category,
        SUM(oi.price) AS total_revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY p.product_category_name
)

SELECT
    product_category,
    total_revenue,
    ROUND(
        total_revenue * 100.0 / SUM(total_revenue) OVER (),
        2
    ) AS contribution_percentage,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS category_rank
FROM category_revenue;

/*=========================================================
26. Customer Spending Segmentation
=========================================================*/

WITH customer_spending AS (
    SELECT
        c.customer_id,
        SUM(oi.price) AS total_spending
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id
)

SELECT
    customer_id,
    total_spending,
    CASE
        WHEN total_spending > 5000 THEN 'Platinum'
        WHEN total_spending > 3000 THEN 'Gold'
        WHEN total_spending > 1000 THEN 'Silver'
        ELSE 'Bronze'
    END AS spending_category
FROM customer_spending
ORDER BY total_spending DESC;

/*=========================================================
27. Delivery Status Classification
=========================================================*/

SELECT
    order_id,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    CASE
        WHEN order_delivered_customer_date < order_estimated_delivery_date
            THEN 'Delivered Early'
        WHEN order_delivered_customer_date > order_estimated_delivery_date
            THEN 'Delivered Late'
        ELSE 'Delivered On Time'
    END AS delivery_status
FROM orders;

/*=========================================================
28. Customer Review Classification
=========================================================*/

SELECT
    c.customer_id,
    ov.review_id,
    ov.review_score,
    CASE
        WHEN ov.review_score = 5 THEN 'Excellent'
        WHEN ov.review_score = 4 THEN 'Good'
        WHEN ov.review_score = 3 THEN 'Average'
        ELSE 'Poor'
    END AS review_category
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_reviews ov
    ON o.order_id = ov.order_id;

/*=========================================================
29. Average Delivery Time (Days)
=========================================================*/

SELECT
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_purchase_timestamp
            )
        ),
        2
    ) AS average_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

/*=========================================================
30. Average Order Approval Time (Hours)
=========================================================*/

SELECT
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                HOUR,
                order_purchase_timestamp,
                order_approved_at
            )
        ),
        2
    ) AS average_approval_time_hours
FROM orders
WHERE order_approved_at IS NOT NULL;

/*=========================================================
31. Average Shipping Time (Carrier to Customer)
=========================================================*/

SELECT
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_delivered_carrier_date
            )
        ),
        2
    ) AS average_shipping_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
    AND order_delivered_carrier_date IS NOT NULL;

/*=========================================================
32. Customers Without Reviews
=========================================================*/

SELECT
    c.customer_id
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
LEFT JOIN order_reviews ov
    ON o.order_id = ov.order_id
WHERE ov.review_id IS NULL;

/*=========================================================
33. Product Categories Without Sales
=========================================================*/

SELECT DISTINCT
    pt.product_category_name_english
FROM product_category_translation pt
LEFT JOIN products p
    ON pt.product_category_name = p.product_category_name
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;

/*=========================================================
34. Sellers Without Orders
=========================================================*/

SELECT
    s.seller_id
FROM sellers s
LEFT JOIN order_items oi
    ON s.seller_id = oi.seller_id
WHERE oi.order_id IS NULL;

/*=========================================================
35. Average Review Score by Product Category
=========================================================*/

SELECT
    p.product_category_name AS product_category,
    ROUND(AVG(ov.review_score), 2) AS average_review_score
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN order_reviews ov
    ON oi.order_id = ov.order_id
GROUP BY p.product_category_name
ORDER BY average_review_score DESC;

