-- Scripts for BI

USE my_store;

-- Daily revenue

DROP VIEW IF EXISTS view_daily_revenue;
CREATE VIEW view_daily_revenue AS
SELECT
    DATE(payment_date) as day,
    SUM(payment_total) as total_revenue
FROM invoices
WHERE payment_date IS NOT NULL
GROUP BY day
ORDER BY day;

-- Weekly revenue

DROP VIEW IF EXISTS view_weekly_revenue;
CREATE VIEW view_weekly_revenue AS
SELECT
    YEAR(payment_date) as year,
    WEEK(payment_date) as week,
    SUM(payment_total) as total_revenue
FROM invoices
WHERE payment_date IS NOT NULL
GROUP BY year, week
ORDER BY year, week;

-- Monthly revenue

DROP VIEW IF EXISTS view_monthly_revenue;
CREATE VIEW view_monthly_revenue AS
SELECT
    DATE_FORMAT(payment_date, '%Y-%m') as month,
    SUM(payment_total) as total_revenue
FROM invoices
WHERE payment_date IS NOT NULL
GROUP BY month
ORDER BY month;

-- Revenue per product

DROP VIEW IF EXISTS view_revenue_per_product;
CREATE VIEW view_revenue_per_product AS
SELECT
    pv.variant_id,
    pv.product_id,
    p.name,
    b.name AS brand,
    pv.sku,
    SUM(oi.quantity) AS quantity,
    pv.unit_price,
    SUM(quantity * pv.unit_price) AS total
FROM my_store.order_items oi
LEFT JOIN product_variants pv
    USING (variant_id)
JOIN products p
    USING (product_id)
JOIN variant_option_assignments voa
    USING (variant_id)
LEFT JOIN brands b
    USING (brand_id)
GROUP BY pv.variant_id, pv.sku
ORDER BY pv.variant_id;

-- Revenue per category

DROP VIEW IF EXISTS view_revenue_per_category;
CREATE VIEW view_revenue_per_category AS
SELECT
    pc.category_id,
    pc.name AS category_name,
    SUM(pv.unit_price) AS revenue
FROM order_items oi
LEFT JOIN product_variants pv
    USING (variant_id)
LEFT JOIN products p
    USING (product_id)
LEFT JOIN product_categories pc
    USING (category_id)
GROUP BY category_id;

-- Revenue per brand

DROP VIEW IF EXISTS view_revenue_per_brand;
CREATE VIEW view_revenue_per_brand AS
SELECT
    b.name AS brand,
    SUM(pv.unit_price) AS revenue
FROM order_items oi
LEFT JOIN product_variants pv
    USING (variant_id)
LEFT JOIN products p
    USING (product_id)
LEFT JOIN brands b
    USING (brand_id)
GROUP BY brand
ORDER BY revenue DESC;

-- Top-selling products by quantity and revenue


DROP VIEW IF EXISTS view_top_selling_products;
CREATE VIEW view_top_selling_products AS
SELECT
    p.name,
    SUM(oi.quantity) AS quantity,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items oi
JOIN product_variants pv
    USING (variant_id)
JOIN products p
    USING (product_id)
GROUP BY product_id;

-- Sales by region

-- Country
DROP VIEW IF EXISTS view_sales_by_country;
CREATE VIEW view_sales_by_country AS
SELECT
    ca.country,
    SUM(i.payment_total) AS revenue
FROM invoices i
JOIN customer_addresses ca
    USING(customer_id)
WHERE i.payment_date IS NOT NULL
GROUP BY ca.country
ORDER BY revenue DESC;

-- City
DROP VIEW IF EXISTS view_sales_by_city;
CREATE VIEW view_sales_by_city AS
SELECT
    ca.city,
    SUM(i.payment_total) AS revenue
FROM invoices i
JOIN customer_addresses ca
    USING(customer_id)
WHERE i.payment_date IS NOT NULL
GROUP BY ca.city
ORDER BY revenue DESC;

-- Most active customers

-- by number of orders
DROP VIEW IF EXISTS view_most_active_customers_by_number_of_orders;
CREATE VIEW view_most_active_customers_by_number_of_orders AS
SELECT
    c.name,
    COUNT(i.invoice_id) AS number_of_orders
FROM invoices i
JOIN customers c
    USING (customer_id)
GROUP BY i.customer_id
ORDER BY number_of_orders DESC
LIMIT 20;

-- by total spent
DROP VIEW IF EXISTS view_most_active_customers_by_spend;
CREATE VIEW view_most_active_customers_by_spend AS
SELECT
    c.customer_id,
    c.name,
    SUM(i.payment_total) AS total_spent
FROM invoices i
JOIN customers c
    USING (customer_id)
WHERE i.payment_date IS NOT NULL
GROUP BY i.customer_id
ORDER BY total_spent DESC
LIMIT 20;

-- Inventory & supply chain

-- Variants below threshold
SELECT variant_id, quantity_in_stock
FROM inventory_levels
WHERE quantity_in_stock < 20;

-- Order & Fulfillment Performance

-- Time from order to shipment
SELECT
    s.shipment_date,
    o.created_at,
    DATE(s.shipment_date) - DATE(o.created_at) as fulfillment_time
FROM shipments s
JOIN orders o
USING (order_id);

-- Shipping delays: Late deliveries vs. shipment date
-- Not very clear requirement, so let's assume that a late delivery is more than 7 days
SELECT
    shipment_date,
    delivery_date,
    DATE(delivery_date) - DATE(shipment_date) AS delay
FROM shipments
WHERE DATE(delivery_date) - DATE(shipment_date) >= 7
ORDER BY delay DESC;

-- Cancellation / Return / Success rate
SELECT
    ROUND(COUNT(CASE WHEN status_id = 5 THEN 1 END) * 100.0 / COUNT(*), 2) AS cancellation_rate,
    ROUND(COUNT(CASE WHEN status_id = 6 THEN 1 END) * 100.0 / COUNT(*), 2) AS return_rate,
    ROUND(COUNT(CASE WHEN status_id = 4 THEN 1 END) * 100.0 / COUNT(*), 2) AS success_rate
FROM orders;

-- Payments & Financial Health

-- Average payment delay: Invoice due date vs. payment date
SELECT
    AVG(DATEDIFF(payment_date, due_date)) AS avg_payment_delay
FROM invoices
WHERE payment_date IS NOT NULL AND payment_date > due_date;

-- Payment method breakdown: % paid via card, PayPal, etc.
SELECT
	p.method_id,
    pm.name AS payment_method,
    ROUND(COUNT(*) * 100.0 / total.total_count, 2) AS percentage
FROM payments p
JOIN payment_methods pm USING(method_id)
JOIN (
    SELECT COUNT(*) AS total_count FROM payments
) AS total
GROUP BY p.method_id, pm.name, total.total_count
ORDER BY percentage DESC;

-- Failed payments or retries (if tracked)
SELECT
    ROUND(COUNT(CASE WHEN status_id = 3 THEN 1 END) * 100 / COUNT(*), 2) AS failed_payments_ratio
FROM payments;