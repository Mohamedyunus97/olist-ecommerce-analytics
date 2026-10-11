
SELECT 'fact_orders' AS tbl, COUNT(*) FROM fact_orders
UNION ALL SELECT 'fact_order_items', COUNT(*) FROM fact_order_items
UNION ALL SELECT 'dim_customers', COUNT(*) FROM dim_customers
UNION ALL SELECT 'dim_products', COUNT(*) FROM dim_products
UNION ALL SELECT 'dim_sellers', COUNT(*) FROM dim_sellers
UNION ALL SELECT 'fact_payments', COUNT(*) FROM fact_payments
UNION ALL SELECT 'fact_reviews', COUNT(*) FROM fact_reviews;

SELECT COUNT(*) AS ORPHAN_COUNT FROM fact_order_items as oi
LEFT JOIN fact_orders as o on oi.order_id = o.order_id
WHERE oi.order_id IS NULL

SELECT COUNT(*) AS orphan_payments FROM fact_payments p
LEFT JOIN fact_orders o ON p.order_id = o.order_id
WHERE o.order_id IS NULL

SELECT COUNT(*) AS orphan_reviews FROM fact_reviews r
LEFT JOIN fact_orders o ON r.order_id = o.order_id
WHERE o.order_id IS NULL

SELECT COUNT(*) AS total_rows, COUNT(DISTINCT order_id) AS distinct_ids FROM fact_orders

SELECT SUM(order_total) AS sql_total_revenue FROM fact_orders
