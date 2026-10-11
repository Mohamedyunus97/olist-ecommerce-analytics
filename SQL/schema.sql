CREATE TABLE dim_customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_state CHAR(2),
    customer_city VARCHAR(100)
);

CREATE TABLE dim_products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name_english VARCHAR(100),
    product_weight_g NUMERIC,
    product_length_cm NUMERIC,
    product_height_cm NUMERIC,
    product_width_cm NUMERIC
); 

CREATE TABLE dim_date (
    date_key DATE PRIMARY KEY,
    year INT,
    quarter INT,
    month INT,
    month_name VARCHAR(20),
    day_of_week VARCHAR(20),
    is_weekend BOOLEAN
);

CREATE TABLE fact_orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50) REFERENCES dim_customers(customer_id),
    order_status VARCHAR(30),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,
    is_delivered BOOLEAN,
    delivery_delay_days INT,
    is_late BOOLEAN,
    order_value NUMERIC(10,2),
    freight_value NUMERIC(10,2),
    customer_state CHAR(2),
    customer_city VARCHAR(100),
    order_total NUMERIC(10,2)
);

ALTER TABLE fact_orders ALTER COLUMN delivery_delay_days TYPE NUMERIC;

CREATE TABLE fact_order_items (
    order_id VARCHAR(50) REFERENCES fact_orders(order_id),
    order_item_id INT,
    product_id VARCHAR(50) REFERENCES dim_products(product_id),
    seller_id VARCHAR(50) REFERENCES dim_sellers(seller_id),
    price NUMERIC(10,2),
    freight_value NUMERIC(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

TRUNCATE fact_order_items;
SELECT * FROM fact_order_items
SELECT COUNT(*) FROM fact_order_items

SELECT COUNT(*) FROM fact_order_items oi
LEFT JOIN fact_orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

CREATE TABLE fact_payments (
    order_id VARCHAR(50) REFERENCES fact_orders(order_id),
    payment_sequential INT,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value NUMERIC(10,2),
    PRIMARY KEY (order_id, payment_sequential)
);


TRUNCATE fact_payments
SELECT * FROM fact_payments
SELECT COUNT(*) FROM fact_payments

SELECT COUNT(*) FROM fact_payments oi
LEFT JOIN fact_orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

CREATE TABLE fact_reviews (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50) REFERENCES fact_orders(order_id),
    review_score SMALLINT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

