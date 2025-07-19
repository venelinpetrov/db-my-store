-- Scripts for BI

USE my_store;

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