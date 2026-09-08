CREATE DATABASE ecommerce_project;
SHOW DATABASES;
USE ecommerce_project;

# First Real SQL Query — Monthly Revenue Trend
SELECT 
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
    ROUND(SUM(order_payment.total_payment), 2) AS total_revenue
FROM orders o
JOIN (
    SELECT order_id, SUM(payment_value) AS total_payment
    FROM payments
    GROUP BY order_id
) order_payment ON o.order_id = order_payment.order_id
GROUP BY order_month
ORDER BY order_month;

#Top Categories by Revenue
SELECT 
    c.product_category_name_english,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN category_translation c ON p.product_category_name = c.product_category_name
GROUP BY c.product_category_name_english
ORDER BY total_revenue DESC
LIMIT 10;

#Revenue by Region (State)
SELECT 
    cust.customer_state,
    ROUND(SUM(order_payment.total_payment), 2) AS total_revenue
FROM orders o
JOIN customers cust ON o.customer_id = cust.customer_id
JOIN (
    SELECT order_id, SUM(payment_value) AS total_payment
    FROM payments
    GROUP BY order_id
) order_payment ON o.order_id = order_payment.order_id
GROUP BY cust.customer_state
ORDER BY total_revenue DESC
LIMIT 10;

#Delivery Time vs Review Score
SELECT 
    CASE 
        WHEN DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) <= 7 THEN '0-7 days'
        WHEN DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) <= 14 THEN '8-14 days'
        WHEN DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) <= 21 THEN '15-21 days'
        ELSE '22+ days'
    END AS delivery_bucket,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    COUNT(*) AS num_orders
FROM orders o
JOIN reviews r ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY delivery_bucket
ORDER BY 
    CASE delivery_bucket
        WHEN '0-7 days' THEN 1
        WHEN '8-14 days' THEN 2
        WHEN '15-21 days' THEN 3
        ELSE 4
    END;
    
#RFM Analysis (Customer Segmentation)
WITH rfm_base AS (
    SELECT 
        c.customer_unique_id,
        DATEDIFF((SELECT MAX(order_purchase_timestamp) FROM orders), MAX(o.order_purchase_timestamp)) AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(op.total_payment) AS monetary
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN (
        SELECT order_id, SUM(payment_value) AS total_payment
        FROM payments
        GROUP BY order_id
    ) op ON o.order_id = op.order_id
    GROUP BY c.customer_unique_id
)
SELECT 
    customer_unique_id,
    recency,
    frequency,
    ROUND(monetary, 2) AS monetary,
    NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
    CASE WHEN frequency = 1 THEN 1 WHEN frequency = 2 THEN 3 ELSE 5 END AS f_score,
    NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
FROM rfm_base
LIMIT 20;

#Add Segment Classification
WITH rfm_base AS (
    SELECT 
        c.customer_unique_id,
        DATEDIFF((SELECT MAX(order_purchase_timestamp) FROM orders), MAX(o.order_purchase_timestamp)) AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(op.total_payment) AS monetary
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN (
        SELECT order_id, SUM(payment_value) AS total_payment
        FROM payments
        GROUP BY order_id
    ) op ON o.order_id = op.order_id
    GROUP BY c.customer_unique_id
),
rfm_scores AS (
    SELECT 
        customer_unique_id,
        recency,
        frequency,
        monetary,
        NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
        CASE WHEN frequency = 1 THEN 1 WHEN frequency = 2 THEN 3 ELSE 5 END AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM rfm_base
)
SELECT 
    CASE 
        WHEN (r_score + f_score + m_score) >= 12 THEN 'Champions'
        WHEN (r_score + f_score + m_score) >= 9 THEN 'Loyal Customers'
        WHEN (r_score + f_score + m_score) >= 6 THEN 'Potential Loyalists'
        WHEN (r_score + f_score + m_score) >= 4 THEN 'At Risk'
        ELSE 'Lost'
    END AS segment,
    COUNT(*) AS num_customers
FROM rfm_scores
GROUP BY segment
ORDER BY num_customers DESC;