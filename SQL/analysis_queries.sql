--1.What are the distinct order statuses, and how many orders fall into each
SELECT DISTINCT order_status, COUNT(*) AS order_count
FROM fact_orders
GROUP BY order_status
ORDER BY order_count DESC

--2.What is the total number of orders placed
SELECT COUNT(*) AS total_order FROM fact_orders

--3.What is the total revenue generated (item price + freight)
SELECT SUM(order_total) AS total_revenue FROM fact_orders

--4.What are the 10 highest-priced individual products sold
SELECT product_id, price 
FROM fact_order_items
ORDER BY price DESC LIMIT 10

--5.How many customers are located in each state
SELECT customer_state, COUNT(*) as total_customers
FROM dim_customers
GROUP BY customer_state
ORDER BY total_customers DESC

--6.What are the different payment types used, and how many transactions use each
SELECT payment_type, COUNT(*) AS transaction_count
FROM fact_payments
GROUP BY payment_type
ORDER BY transaction_count DESC

--7.What is the average freight value per order
SELECT AVG(freight_value) AS average_freightvalue 
FROM fact_orders

--8.How many distinct product categories exist in the catalog
SELECT COUNT(DISTINCT product_category_name_english ) AS category_list
FROM dim_products

--9.How many orders were cancelled or unavailable
SELECT COUNT(*) AS cancelled_orders
FROM fact_orders
WHERE order_status IN ('canceled', 'unavailable')

--10.What is the overall average review score across all orders
SELECT AVG(review_score) AS avg_review_score
FROM fact_reviews

--11.What is the monthly revenue trend across 2016–2018
SELECT DATE_TRUNC('month' , order_purchase_timestamp) AS month,
       COUNT(DISTINCT order_id) AS total_orders,
	   SUM(order_value) AS total_revenue
FROM fact_orders
GROUP BY 1
ORDER BY 1

--12.Which product categories generate the highest total revenue
SELECT p.product_category_name_english,
    SUM(oi.price) AS revenue
FROM fact_order_items as oi
JOIN dim_products AS p ON oi.product_id = p.product_id
GROUP BY p.product_category_name_english
ORDER BY revenue DESC

--13.Which states generate the highest total revenue
SELECT c.customer_state, SUM(o.order_total) AS revenue
FROM fact_orders AS o
JOIN dim_customers AS c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY revenue DESC

--14.What is the average order value by customer state
SELECT c.customer_state, AVG(o.order_value) AS avg_ordervalue
FROM fact_orders AS o
JOIN dim_customers AS c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY avg_ordervalue

--15.Which month had the highest number of orders placed
SELECT DATE_TRUNC('month', order_purchase_timestamp) AS month,
       COUNT(*) AS order_count
FROM fact_orders
GROUP BY 1
ORDER BY order_count DESC
LIMIT 1

--16.What is the revenue contribution of each payment method
SELECT payment_type,
     SUM(payment_value) AS total_revenue,
	 ROUND(100.0 * SUM(payment_value) / SUM(SUM(payment_value)) OVER (), 2) AS pct_of_total
FROM fact_payments
GROUP BY payment_type
ORDER BY total_revenue DESC

--17.What is the average number of installments used per payment type
SELECT payment_type,
       AVG(payment_installments) AS avg_installments
FROM fact_payments
GROUP BY payment_type
ORDER BY avg_installments DESC

--18.Which 10 sellers have processed the highest number of orders
SELECT seller_id, COUNT( DISTINCT order_id) AS order_count
FROM fact_order_items
GROUP BY seller_id
ORDER BY order_count DESC
LIMIT 10

--19.What is the average delivery time (in days) by state
select c.customer_state,
    AVG(EXTRACT(DAY FROM (o.order_delivered_customer_date - o.order_purchase_timestamp))) as avg_delivery_time
FROM fact_orders as o
JOIN dim_customers as c ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delivery_time DESC

--20.Which product categories have the highest average review score (min. 30 orders)
SELECT p.product_category_name_english, 
    AVG(r.review_score) as avg_review_score,
    COUNT(*) AS order_count
FROM fact_order_items as oi
JOIN dim_products as p ON oi.product_id = p.product_id
JOIN fact_reviews as r ON oi.order_id = r.order_id
GROUP BY p.product_category_name_english
HAVING COUNT (*) >= 30
ORDER BY avg_review_score DESC
LIMIT 10

--21.Which product categories have the lowest average review score (min. 30 orders)
SELECT p.product_category_name_english, 
    AVG(r.review_score) as avg_review_score,
    COUNT(*) AS order_count
FROM fact_order_items as oi
JOIN dim_products as p ON oi.product_id = p.product_id
JOIN fact_reviews as r ON oi.order_id = r.order_id
GROUP BY p.product_category_name_english
HAVING COUNT (*) <= 30
ORDER BY avg_review_score ASC

--22.What percentage of orders were delivered after the estimated delivery date
SELECT
  ROUND(100.0 * SUM(CASE WHEN is_late THEN 1 ELSE 0 END )/ COUNT(*),2) as pct_of_orders
FROM fact_orders
WHERE order_delivered_customer_date IS NOT NULL

--23.What is the average freight cost as a percentage of item price, by category
SELECT p.product_category_name_english,
     ROUND(100.0 * AVG(oi.freight_value / NULLIF (oi.price, 0)), 2 ) AS avg_freight_of_item_price
FROM fact_order_items AS oi
JOIN dim_products AS p ON oi.product_id = p.product_id
GROUP BY p.product_category_name_english
ORDER BY avg_freight_of_item_price DESC

--24.How many unique customers made a purchase in each month
SELECT DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
     COUNT(DISTINCT c.customer_unique_id) as unique_customer
FROM dim_customers as c 
JOIN fact_orders as o ON c.customer_id = o.customer_id
GROUP BY 1
ORDER BY 1

--25.What is the distribution of orders by day of the week
SELECT TO_CHAR(order_purchase_timestamp, 'day') as day_of_week,
        COUNT(*) AS order_count
FROM fact_orders
GROUP BY 1
ORDER BY order_count

--26.What is the month-over-month (MoM) revenue growth rate
with monthly_revenue as (
     SELECT EXTRACT(month FROM order_purchase_timestamp) AS month,
	 SUM(order_total) AS revenue
	FROM fact_orders
    GROUP BY 1
	 	 
)
 SELECT
     month,
	 revenue,
	 LAG(revenue) OVER (ORDER BY month) AS prev_revenue,
	 (revenue - LAG(revenue) OVER(ORDER BY MONTH)) / LAG(revenue) OVER (ORDER BY MONTH) * 100 AS mom_growth_pct
 FROM monthly_revenue
 ORDER BY month

 --27.What is the year-over-year (YoY) revenue growth rate, where comparable
  with yearly_revenue as(
       SELECT EXTRACT(year FROM order_purchase_timestamp) as year,
	   SUM(order_total) AS revenue
	  FROM fact_orders
	  GROUP BY 1
 )
  SELECT
     year,
	 revenue,
	 LAG(revenue) OVER (ORDER BY year) as prev_yearly_revenue,
	 ROUND(
           100.0 * (revenue - LAG(revenue) OVER (ORDER BY year)) / LAG(revenue) OVER (ORDER BY year), 2 
	 ) AS yoy_revenue_growth	   
  FROM yearly_revenue
  ORDER BY year

--28.How do sellers rank by revenue within each state (RANK, PARTITION BY state)
 SELECT 
     s.seller_id,
	 s.seller_state,
	 SUM(oi.price) AS revenue,
	 RANK() OVER (PARTITION BY s.seller_state ORDER BY SUM(oi.price) DESC) AS rnk_by_revenue
 FROM fact_order_items AS oi
 JOIN dim_sellers as s ON oi.seller_id = s.seller_id
 GROUP BY s.seller_id, s.seller_state
 ORDER BY revenue DESC 

 --29.What is the running (cumulative) total of revenue over time
 WITH monthly_revenue AS(
         SELECT EXTRACT (month FROM order_purchase_timestamp) as month,
		 SUM(order_total) AS revenue
		 FROM fact_orders
		 GROUP BY 1
		 
 )
   SELECT
       month,
	   revenue,
	   SUM(revenue) OVER (ORDER BY revenue) AS cumulative_total
	FROM monthly_revenue
	ORDER BY revenue DESC

--30.What is each product category's percentage contribution to total revenue
SELECT
    p.product_category_name_english,
    SUM(oi.price) AS category_revenue,
    ROUND(100.0 * SUM(oi.price) / SUM(SUM(oi.price)) OVER (), 2) AS pct_of_total_revenue
FROM fact_order_items oi
JOIN dim_products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name_english
ORDER BY category_revenue DESC

--31.Which customers (by customer_unique_id) placed more than one order across the dataset
SELECT
  c.customer_unique_id,
  COUNT(DISTINCT o.order_id) as order_count
FROM fact_orders as o
JOIN dim_customers as c ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY order_count DESC

--32.For repeat customers, what is the average time gap between their first and second purchase?
WITH customer_orders AS(
      SELECT
	     c.customer_unique_id,
		 o.order_purchase_timestamp,
		 ROW_NUMBER() OVER (PARTITION BY c.customer_unique_id ORDER BY o.order_purchase_timestamp) AS order_rank
	  FROM fact_orders AS o
	  JOIN dim_customers AS c ON c.customer_id = o.customer_id	  
),
  first_two_orders AS (
        SELECT 
		    customer_unique_id,
			MAX(CASE WHEN order_rank = 1 THEN order_purchase_timestamp END ) AS first_purchase,
			MAX(CASE WHEN order_rank = 2 THEN order_purchase_timestamp END ) AS second_purchase
		FROM customer_orders 
		WHERE order_rank <= 2
		GROUP BY customer_unique_id
 )
   SELECT
      AVG(EXTRACT(DAY FROM (first_purchase - second_purchase))) AS avg_days_between_first_second_purchase
   FROM first_two_orders
   WHERE second_purchase IS NOT NULL

--33.Using LAG(), what is the revenue change from the previous month for each category  
WITH monthly_category_revenue AS(
      SELECT
	     EXTRACT(month FROM o.order_purchase_timestamp) AS month,
	     p.product_category_name_english,
		 SUM(o.order_total) AS revenue
	  FROM fact_order_items AS oi
	  JOIN fact_orders as o on oi.order_id = o.order_id
	  JOIN dim_products as p ON oi.product_id = p.product_id
	  GROUP BY 1, 2		 
) 
 SELECT
    month,
	product_category_name_english,
	revenue,
	LAG(revenue) OVER (PARTITION BY product_category_name_english ORDER BY month) AS prev_month_revenue,
	revenue - LAG(revenue) OVER (PARTITION BY product_category_name_english ORDER BY month) AS revenue_change 
 FROM monthly_category_revenue
 ORDER BY product_category_name_english, month 

 --34.What is the 3-month moving average of total revenue
  WITH monthly_revenue AS(
            SELECT
			   EXTRACT(month FROM order_purchase_timestamp) as month,
			   SUM(order_total) AS revenue
			 FROM fact_orders
			 GROUP BY 1			   
)
  SELECT
     month,
	 revenue,
	 ROUND(AVG(revenue) OVER (PARTITION BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_average_3mon
  FROM monthly_revenue
  ORDER BY month

--35.Using ROW_NUMBER() + PARTITION BY state, which sellers rank in the top 5 by revenue per state 
 with seller_state_revenue AS (
       SELECT
	     s.seller_id,
		 s.seller_state,
		 SUM(oi.price) AS revenue,
		 ROW_NUMBER() OVER (PARTITION BY s.seller_state  ORDER BY SUM(oi.price) DESC) AS rnk_in_state
	   FROM fact_order_items as oi
	   JOIN dim_sellers s ON oi.seller_id = s.seller_id
       GROUP BY s.seller_id, s.seller_state
)
SELECT *
FROM seller_state_revenue
WHERE rnk_in_state <= 5
ORDER BY seller_state, rnk_in_state

--36.total revenue and order count: on-time vs. late delivery
SELECT
    is_late,
    COUNT(*) AS order_count,
    SUM(order_total) AS total_revenue
FROM fact_orders
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY is_late

--37.Cohort view: of customers acquired in a given month, how many placed another order within the next 1–3 months?
WITH customer_first_order AS (
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_order_date,
        DATE_TRUNC('month', MIN(o.order_purchase_timestamp)) AS cohort_month
    FROM fact_orders o
    JOIN dim_customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
),
customer_all_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_purchase_timestamp
    FROM fact_orders o
    JOIN dim_customers c ON o.customer_id = c.customer_id
),
cohort_repeat AS (
    SELECT
        f.cohort_month,
        f.customer_unique_id,
        MAX(CASE
            WHEN a.order_purchase_timestamp > f.first_order_date
                 AND a.order_purchase_timestamp <= f.first_order_date + INTERVAL '3 months'
            THEN 1 ELSE 0
        END) AS reordered_within_3mo
    FROM customer_first_order f
    JOIN customer_all_orders a ON f.customer_unique_id = a.customer_unique_id
    GROUP BY f.cohort_month, f.customer_unique_id
)
SELECT
    cohort_month,
    COUNT(*) AS cohort_size,
    SUM(reordered_within_3mo) AS reordered_customers,
    ROUND(100.0 * SUM(reordered_within_3mo) / COUNT(*), 2) AS pct_reordered
FROM cohort_repeat
GROUP BY cohort_month
ORDER BY cohort_month;

--38.Which product categories show declining revenue in the most recent 3 months vs. the prior 3 months
WITH category_monthly AS (
    SELECT
        p.product_category_name_english,
        DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
        SUM(oi.price) AS revenue
    FROM fact_order_items oi
    JOIN fact_orders o ON oi.order_id = o.order_id
    JOIN dim_products p ON oi.product_id = p.product_id
    GROUP BY 1, 2
),
max_month AS (
    SELECT MAX(month) AS latest_month FROM category_monthly
),
recent_vs_prior AS (
    SELECT
        c.product_category_name_english,
        SUM(CASE WHEN c.month > m.latest_month - INTERVAL '3 months' THEN c.revenue ELSE 0 END) AS recent_3mo_revenue,
        SUM(CASE WHEN c.month <= m.latest_month - INTERVAL '3 months'
                  AND c.month > m.latest_month - INTERVAL '6 months' THEN c.revenue ELSE 0 END) AS prior_3mo_revenue
    FROM category_monthly c
    CROSS JOIN max_month m
    GROUP BY c.product_category_name_english
)
SELECT
    product_category_name_english,
    recent_3mo_revenue,
    prior_3mo_revenue,
    recent_3mo_revenue - prior_3mo_revenue AS revenue_change
FROM recent_vs_prior
WHERE recent_3mo_revenue < prior_3mo_revenue
ORDER BY revenue_change ASC;

--39.What is the average review score for orders bucketed by delivery-delay range (on-time, 1–3 days late, 4+ days late)? 
SELECT
    (CASE
        WHEN delivery_delay_days <= 0 THEN 'On-time'
        WHEN delivery_delay_days BETWEEN 1 AND 3 THEN '1-3 days late'
        WHEN delivery_delay_days >= 4 THEN '4+ days late'
    END) AS delay_bucket,
    AVG(r.review_score) AS avg_review_score,
    COUNT(*) AS order_count
FROM fact_orders o
JOIN fact_reviews r ON o.order_id = r.order_id
WHERE o.delivery_delay_days IS NOT NULL
GROUP BY delay_bucket
ORDER BY
    CASE
        WHEN delivery_delay_days <= 0 THEN 'On-time'
        WHEN delivery_delay_days BETWEEN 1 AND 3 THEN '1-3 days late'
        WHEN delivery_delay_days >= 4 THEN '4+ days late'
    END;

--40.States with above-average revenue but below-average review scores
WITH state_metrics AS (
    SELECT
        c.customer_state,
        SUM(o.order_total) AS state_revenue,
        AVG(r.review_score) AS state_avg_review
    FROM fact_orders o
    JOIN dim_customers c ON o.customer_id = c.customer_id
    JOIN fact_reviews r ON o.order_id = r.order_id
    GROUP BY c.customer_state
),
overall_avg AS (
    SELECT
        AVG(state_revenue) AS avg_revenue,
        AVG(state_avg_review) AS avg_review
    FROM state_metrics
)
SELECT
    sm.customer_state,
    sm.state_revenue,
    sm.state_avg_review
FROM state_metrics sm
CROSS JOIN overall_avg oa
WHERE sm.state_revenue > oa.avg_revenue
  AND sm.state_avg_review < oa.avg_review
ORDER BY sm.state_revenue DESC;
 
  

	 