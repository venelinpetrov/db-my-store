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