DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
    date          DATE,
    warehouse     TEXT,
    client_type   TEXT,
    product_line  TEXT,
    quantity      INT,
    unit_price    NUMERIC(10,2),
    total         NUMERIC(12,2),
    payment       TEXT,
    payment_fee   NUMERIC(10,2)
);

-- analysis

SELECT 
    warehouse,
    product_line,
    SUM(quantity) as total_qty,
    ROUND(SUM(total), 2) as total_revenue
FROM sales
GROUP BY warehouse, product_line
ORDER BY total_revenue DESC;

-- 1. Which parts bring in the most money?
SELECT product_line,
       SUM(quantity) AS units_sold,
       ROUND(SUM(total - payment_fee), 2) AS net_revenue
FROM sales
GROUP BY product_line
ORDER BY net_revenue DESC;

-- 2. Warehouse Performance 
SELECT warehouse,
       COUNT(*) AS total_orders,
       ROUND(SUM(total - payment_fee), 2) AS net_revenue,
       ROUND(AVG(total), 2) AS avg_order_value
FROM sales
GROUP BY warehouse
ORDER BY net_revenue DESC;

-- 3. Are processing fees hurting margins?
SELECT payment,
       COUNT(*) AS transactions,
       ROUND(SUM(total), 2) AS gross_revenue,
       ROUND(SUM(payment_fee), 2) AS fees_paid
FROM sales
GROUP BY payment
ORDER BY fees_paid DESC;
