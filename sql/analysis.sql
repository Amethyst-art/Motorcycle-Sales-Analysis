-- name: net_revenue_by_line_month_warehouse
SELECT product_line,
       STRFTIME('%Y-%m', date) AS month,
       warehouse,
       ROUND(SUM(total - payment_fee), 2) AS net_revenue
FROM sales
WHERE client_type = 'Wholesale'
GROUP BY product_line, STRFTIME('%Y-%m', date), warehouse
ORDER BY product_line, month, net_revenue DESC;

-- name: revenue_by_product_line
SELECT product_line,
       SUM(quantity) AS units_sold,
       ROUND(SUM(total - payment_fee), 2) AS net_revenue,
       ROUND(100.0 * SUM(total - payment_fee) / SUM(SUM(total - payment_fee)) OVER (), 1) AS pct_of_total
FROM sales
WHERE client_type = 'Wholesale'
GROUP BY product_line
ORDER BY net_revenue DESC;

-- name: revenue_by_warehouse
SELECT warehouse,
       COUNT(*) AS orders,
       ROUND(SUM(total - payment_fee), 2) AS net_revenue,
       ROUND(AVG(total), 2) AS avg_order_value
FROM sales
WHERE client_type = 'Wholesale'
GROUP BY warehouse
ORDER BY net_revenue DESC;

-- name: monthly_trend
WITH monthly AS (
    SELECT STRFTIME('%Y-%m', date) AS month,
           SUM(total - payment_fee) AS net_revenue
    FROM sales
    WHERE client_type = 'Wholesale'
    GROUP BY 1
)
SELECT month,
       ROUND(net_revenue, 2) AS net_revenue,
       ROUND(100.0 * (net_revenue - LAG(net_revenue) OVER (ORDER BY month))
             / LAG(net_revenue) OVER (ORDER BY month), 1) AS mom_growth_pct
FROM monthly
ORDER BY month;

-- name: top_combinations
SELECT product_line, warehouse,
       ROUND(SUM(total - payment_fee), 2) AS net_revenue,
       RANK() OVER (ORDER BY SUM(total - payment_fee) DESC) AS rank
FROM sales
WHERE client_type = 'Wholesale'
GROUP BY product_line, warehouse
ORDER BY rank
LIMIT 10;

-- name: payment_fee_impact
SELECT payment,
       COUNT(*) AS transactions,
       ROUND(SUM(total), 2) AS gross_revenue,
       ROUND(SUM(payment_fee), 2) AS fees_paid,
       ROUND(100.0 * SUM(payment_fee) / SUM(total), 2) AS fee_pct_of_gross
FROM sales
WHERE client_type = 'Wholesale'
GROUP BY payment
ORDER BY fees_paid DESC;

-- name: wholesale_vs_retail
SELECT client_type,
       COUNT(*) AS orders,
       ROUND(SUM(total - payment_fee), 2) AS net_revenue,
       ROUND(AVG(total), 2) AS avg_order_value
FROM sales
GROUP BY client_type;