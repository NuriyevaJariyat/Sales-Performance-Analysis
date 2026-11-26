USE sales_analysis;
SHOW TABLES;

-- Total Customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- Total Orders
SELECT COUNT(*) AS total_orders
FROM orders;
-- Total Products
SELECT COUNT(*) AS total_products
FROM products;

-- Orders Without Customer
SELECT COUNT(*) AS orders_without_customer
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Orders Without Product
SELECT COUNT(*) AS orders_without_product
FROM orders o
LEFT JOIN products p
    ON o.sku = p.sku
WHERE p.sku IS NULL;

-- ORDER STATUS ANALYSIS
SELECT
    status,
    COUNT(*) AS order_count
FROM orders
GROUP BY status
ORDER BY order_count DESC;

-- REVENUE BY ORDER STATUS
SELECT
    status,
    ROUND(SUM(total), 2) AS revenue
FROM orders
GROUP BY status
ORDER BY revenue DESC;

-- ORDER STATUS DISTRIBUTION (%)
SELECT
    status,
    COUNT(*) AS order_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM orders), 2
    ) AS percentage
FROM orders
GROUP BY status
ORDER BY order_count DESC;

-- MONTHLY REVENUE TREND
SELECT
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    ROUND(SUM(total), 2) AS revenue
FROM orders
WHERE status NOT IN ('cancelled', 'returned')
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY year,month;

-- ANNUAL REVENUE TREND
SELECT
    YEAR(order_date) AS year,
    ROUND(SUM(total), 2) AS annual_revenue
FROM orders
WHERE status NOT IN ('cancelled', 'returned')
GROUP BY YEAR(order_date)
ORDER BY year;

-- REVENUE BY COUNTRY
SELECT
    c.country,
    ROUND(SUM(o.total), 2) AS revenue
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE o.status NOT IN ('cancelled', 'returned')
GROUP BY c.country
ORDER BY revenue DESC;

-- ORDERS BY COUNTRY
SELECT 
   c.country,
   COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE o.status NOT IN ('cancelled', 'returned')
GROUP BY c.country
ORDER BY total_orders DESC;

-- AVERAGE ORDER VALUE BY COUNTRY
SELECT
   c.country,
   COUNT(o.order_id) AS total_orders,
   ROUND(SUM(o.total),2) AS revenue,
   ROUND(AVG(o.total),2) AS average_order_value
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE o.status NOT IN ('cancelled', 'returned')
GROUP BY c.country
ORDER BY average_order_value DESC;

-- REVENUE BY PRODUCT CATEGORY
SELECT
    p.category,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total), 2) AS revenue
FROM orders o
JOIN products p
    ON o.sku = p.sku
WHERE o.status NOT IN ('cancelled', 'returned')
GROUP BY p.category
ORDER BY revenue DESC;


-- TOP 10 PRODUCTS BY REVENUE
SELECT
    p.product_name,
    p.category,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.total), 2) AS revenue
FROM orders o
JOIN products p
    ON o.sku = p.sku
WHERE o.status NOT IN ('cancelled', 'returned')
GROUP BY
    p.product_name,
    p.category
ORDER BY revenue DESC
LIMIT 10;

-- PROFIT BY PRODUCT CATEGORY
SELECT
    p.category,
    ROUND(
        SUM(o.quantity * (o.unit_price - p.unit_cost)), 2
    ) AS total_profit
FROM orders o
JOIN products p
    ON o.sku = p.sku
WHERE o.status NOT IN ('cancelled', 'returned')
GROUP BY p.category
ORDER BY total_profit DESC;




