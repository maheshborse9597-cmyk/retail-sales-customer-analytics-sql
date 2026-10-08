/*
===========================================================
Project: Retail Sales & Customer Analytics
Tool: PostgreSQL 18
Database: RetailAnalytics

Objective:
Analyze retail sales performance, customer behavior,
product performance, payment methods, and revenue trends.

Skills Demonstrated:
- SQL Aggregations
- GROUP BY
- CTEs
- CASE WHEN
- Window Functions
- LAG()
- RANK()
- Data Quality Checks
- Customer Segmentation
- Business KPI Analysis
===========================================================
*/


-- =========================================================
-- 1. TABLE CREATION
-- =========================================================
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    sale_date DATE NOT NULL,
    customer_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    category VARCHAR(50),
    product VARCHAR(100),
    quantity INT NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    payment_method VARCHAR(30)
);



-- =========================================================
-- 2. INSERT SAMPLE SALES DATA
-- =========================================================

INSERT INTO sales
(sale_date, customer_id, customer_name, city, category, product, quantity, unit_price, payment_method)
VALUES
('2026-01-05', 101, 'Amit Sharma', 'Pune', 'Electronics', 'Wireless Mouse', 2, 799.00, 'UPI'),
('2026-01-08', 102, 'Priya Patil', 'Mumbai', 'Home & Kitchen', 'Mixer Grinder', 1, 3499.00, 'Credit Card'),
('2026-01-12', 103, 'Rahul Verma', 'Pune', 'Sports', 'Cricket Bat', 1, 2999.00, 'UPI'),
('2026-01-18', 104, 'Sneha Joshi', 'Nashik', 'Beauty', 'Face Serum', 3, 599.00, 'Debit Card'),
('2026-01-22', 105, 'Rohit Singh', 'Mumbai', 'Electronics', 'Smart Watch', 1, 3999.00, 'Credit Card'),
('2026-01-25', 106, 'Neha Kulkarni', 'Pune', 'Home & Kitchen', 'Air Fryer', 1, 4999.00, 'UPI'),
('2026-01-28', 107, 'Vikas More', 'Thane', 'Sports', 'Dumbbells', 2, 1599.00, 'Cash'),
('2026-02-03', 108, 'Pooja Deshmukh', 'Jalgaon', 'Beauty', 'Shampoo', 4, 399.00, 'UPI'),
('2026-02-07', 109, 'Karan Shah', 'Pune', 'Electronics', 'Bluetooth Speaker', 2, 1599.00, 'Credit Card'),
('2026-02-10', 110, 'Anjali Mehta', 'Mumbai', 'Home & Kitchen', 'Non Stick Pan', 1, 1299.00, 'UPI'),
('2026-02-14', 111, 'Sahil Pawar', 'Thane', 'Sports', 'Sports Bag', 1, 2398.00, 'Debit Card'),
('2026-02-18', 112, 'Riya Gupta', 'Nashik', 'Beauty', 'Face Wash', 2, 499.00, 'UPI'),
('2026-02-22', 113, 'Akash Patil', 'Pune', 'Electronics', 'Mechanical Keyboard', 1, 2499.00, 'Credit Card'),
('2026-02-25', 114, 'Nikita Jadhav', 'Mumbai', 'Home & Kitchen', 'Coffee Maker', 1, 2999.00, 'UPI'),
('2026-02-28', 115, 'Manish Yadav', 'Thane', 'Sports', 'Cricket Bat', 1, 3998.00, 'Cash'),
('2026-03-03', 116, 'Kavita More', 'Jalgaon', 'Beauty', 'Face Wash', 1, 549.00, 'UPI'),
('2026-03-07', 117, 'Deepak Shinde', 'Nashik', 'Home & Kitchen', 'Mixer Grinder', 1, 2199.00, 'Debit Card'),
('2026-03-11', 118, 'Meena Pawar', 'Pune', 'Electronics', 'USB Cable', 2, 499.00, 'UPI'),
('2026-03-15', 119, 'Suresh Kale', 'Mumbai', 'Sports', 'Sports Bag', 1, 999.00, 'Cash'),
('2026-03-18', 120, 'Aarti Joshi', 'Thane', 'Home & Kitchen', 'Non Stick Pan', 2, 1299.00, 'UPI'),
('2026-03-22', 121, 'Nilesh Patil', 'Pune', 'Sports', 'Dumbbells', 1, 1799.00, 'Debit Card'),
('2026-03-25', 122, 'Shweta Shah', 'Nashik', 'Beauty', 'Shampoo', 2, 699.00, 'UPI'),
('2026-03-28', 123, 'Ganesh More', 'Jalgaon', 'Electronics', 'Wireless Mouse', 1, 2499.00, 'Credit Card'),
('2026-03-30', 124, 'Komal Desai', 'Mumbai', 'Beauty', 'Face Serum', 1, 1899.00, 'UPI'),
('2026-04-02', 101, 'Amit Sharma', 'Pune', 'Electronics', 'USB Cable', 3, 299.00, 'UPI'),
('2026-04-06', 102, 'Priya Patil', 'Mumbai', 'Home & Kitchen', 'Coffee Maker', 1, 3198.00, 'Credit Card'),
('2026-04-10', 103, 'Rahul Verma', 'Pune', 'Sports', 'Sports Bag', 1, 1999.00, 'UPI'),
('2026-04-15', 105, 'Rohit Singh', 'Mumbai', 'Electronics', 'Earbuds', 1, 898.00, 'Debit Card'),
('2026-04-20', 107, 'Vikas More', 'Thane', 'Sports', 'Dumbbells', 1, 799.00, 'Cash'),
('2026-04-25', 109, 'Karan Shah', 'Pune', 'Electronics', 'Bluetooth Speaker', 1, 1799.00, 'UPI');



-- =========================================================
-- 3. DATA VALIDATION
-- =========================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT sale_id) AS unique_sale_ids,
    COUNT(DISTINCT customer_id) AS unique_customers,
    MIN(sale_date) AS first_sale_date,
    MAX(sale_date) AS last_sale_date
FROM sales;




-- =========================================================
-- 4. KEY BUSINESS KPIs
-- =========================================================

-- 4.1 Total Revenue
SELECT
    SUM(quantity * unit_price) AS total_revenue
FROM sales;


-- 4.2 Total Units Sold
SELECT
    SUM(quantity) AS total_units_sold
FROM sales;


-- 4.3 Unique Customers
SELECT
    COUNT(DISTINCT customer_id) AS unique_customers
FROM sales;


-- 4.4 Average Order Value
SELECT
    ROUND(
        SUM(quantity * unit_price) / COUNT(*),
        2
    ) AS average_order_value
FROM sales;





-- =========================================================
-- 5. CATEGORY PERFORMANCE
-- =========================================================

-- 5.1 Revenue by Category
SELECT
    category,
    SUM(quantity * unit_price) AS revenue
FROM sales
GROUP BY category
ORDER BY revenue DESC;


-- 5.2 Units Sold by Category
SELECT
    category,
    SUM(quantity) AS units_sold
FROM sales
GROUP BY category
ORDER BY units_sold DESC;


-- 5.3 Revenue Contribution by Category
SELECT
    category,
    SUM(quantity * unit_price) AS revenue,
    ROUND(
        SUM(quantity * unit_price) * 100.0
        / SUM(SUM(quantity * unit_price)) OVER (),
        2
    ) AS revenue_percentage
FROM sales
GROUP BY category
ORDER BY revenue DESC;





-- =========================================================
-- 6. PRODUCT PERFORMANCE
-- =========================================================

-- 6.1 Top 10 Products by Revenue
SELECT
    product,
    SUM(quantity * unit_price) AS revenue
FROM sales
GROUP BY product
ORDER BY revenue DESC
LIMIT 10;


-- 6.2 Best-Selling Products by Units
SELECT
    product,
    SUM(quantity) AS units_sold,
    SUM(quantity * unit_price) AS revenue
FROM sales
GROUP BY product
ORDER BY units_sold DESC, revenue DESC
LIMIT 10;


-- 6.3 Revenue by City and Category
SELECT
    city,
    category,
    SUM(quantity * unit_price) AS revenue
FROM sales
GROUP BY city, category
ORDER BY city, revenue DESC;




-- =========================================================
-- 7. TIME-BASED REVENUE ANALYSIS
-- =========================================================

-- 7.1 Monthly Revenue
SELECT
    DATE_TRUNC('month', sale_date)::date AS month,
    SUM(quantity * unit_price) AS revenue
FROM sales
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY month;


-- 7.2 Month-over-Month Revenue Growth
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', sale_date)::date AS month,
        SUM(quantity * unit_price) AS revenue
    FROM sales
    GROUP BY DATE_TRUNC('month', sale_date)
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month)) * 100.0
        / LAG(revenue) OVER (ORDER BY month),
        2
    ) AS mom_growth_percentage
FROM monthly_revenue
ORDER BY month;





-- =========================================================
-- 8. CUSTOMER ANALYSIS
-- =========================================================

-- 8.1 Top 10 Customers by Revenue
SELECT
    customer_id,
    customer_name,
    COUNT(*) AS transactions,
    SUM(quantity * unit_price) AS total_spent
FROM sales
GROUP BY customer_id, customer_name
ORDER BY total_spent DESC
LIMIT 10;


-- 8.2 Repeat Customers
SELECT
    customer_id,
    customer_name,
    COUNT(*) AS purchase_count,
    SUM(quantity * unit_price) AS total_spent
FROM sales
GROUP BY customer_id, customer_name
HAVING COUNT(*) > 1
ORDER BY purchase_count DESC, total_spent DESC;


-- 8.3 Repeat Customer Rate
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(*) AS purchase_count
    FROM sales
    GROUP BY customer_id
)
SELECT
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE purchase_count > 1) AS repeat_customers,
    ROUND(
        COUNT(*) FILTER (WHERE purchase_count > 1) * 100.0
        / COUNT(*),
        2
    ) AS repeat_customer_rate
FROM customer_orders;


-- 8.4 Customer Segmentation
WITH customer_spending AS (
    SELECT
        customer_id,
        customer_name,
        SUM(quantity * unit_price) AS total_spent
    FROM sales
    GROUP BY customer_id, customer_name
)
SELECT
    customer_id,
    customer_name,
    total_spent,
    CASE
        WHEN total_spent >= 4000 THEN 'High Value'
        WHEN total_spent >= 2500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_spending
ORDER BY total_spent DESC;





-- =========================================================
-- 9. CUSTOMER RANKING & PAYMENT ANALYSIS
-- =========================================================


-- 9.1 Customer Revenue Ranking
WITH customer_spending AS (
    SELECT
        customer_id,
        customer_name,
        SUM(quantity * unit_price) AS total_spent
    FROM sales
    GROUP BY customer_id, customer_name
)
SELECT
    RANK() OVER (ORDER BY total_spent DESC) AS customer_rank,
    customer_id,
    customer_name,
    total_spent
FROM customer_spending
ORDER BY customer_rank;


-- 9.2 Revenue by Payment Method
SELECT
    payment_method,
    COUNT(*) AS transactions,
    SUM(quantity * unit_price) AS revenue
FROM sales
GROUP BY payment_method
ORDER BY revenue DESC;


-- 9.3 Average Order Value by Category
SELECT
    category,
    COUNT(*) AS transactions,
    SUM(quantity * unit_price) AS revenue,
    ROUND(
        SUM(quantity * unit_price) / COUNT(*),
        2
    ) AS average_order_value
FROM sales
GROUP BY category
ORDER BY average_order_value DESC;





-- =========================================================
-- 10. ADVANCED CUSTOMER ANALYSIS
-- =========================================================


-- 10.1 Customer Performance Dashboard Query
WITH customer_analysis AS (
    SELECT
        customer_id,
        customer_name,
        COUNT(*) AS total_orders,
        SUM(quantity) AS total_units,
        SUM(quantity * unit_price) AS total_spent,
        ROUND(
            SUM(quantity * unit_price) / COUNT(*),
            2
        ) AS average_order_value
    FROM sales
    GROUP BY customer_id, customer_name
)
SELECT
    RANK() OVER (ORDER BY total_spent DESC) AS customer_rank,
    customer_id,
    customer_name,
    total_orders,
    total_units,
    total_spent,
    average_order_value,
    CASE
        WHEN total_spent >= 4000 THEN 'High Value'
        WHEN total_spent >= 2500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_analysis
ORDER BY customer_rank;





-- =========================================================
-- 11. DATA QUALITY AUDIT
-- =========================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE sale_date IS NULL) AS missing_dates,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS missing_customer_ids,
    COUNT(*) FILTER (WHERE customer_name IS NULL) AS missing_customer_names,
    COUNT(*) FILTER (
        WHERE quantity IS NULL OR quantity <= 0
    ) AS invalid_quantities,
    COUNT(*) FILTER (
        WHERE unit_price IS NULL OR unit_price <= 0
    ) AS invalid_prices,
    COUNT(*) - COUNT(DISTINCT sale_id) AS duplicate_sale_ids
FROM sales;









