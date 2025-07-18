USE my_store;

-- Insert data into address_types
INSERT INTO address_types (type_name) VALUES
('Shipping'),
('Billing'),
('Home'),
('Work');

-- Insert data into customers
INSERT INTO customers (name, email, phone, created_at) VALUES
('Alice Smith', 'alice.smith@example.com', '111-222-3333', '2023-01-15 10:00:00'),
('Bob Johnson', 'bob.johnson@example.com', '444-555-6666', '2023-03-20 11:30:00'),
('Charlie Brown', 'charlie.brown@example.com', '777-888-9999', '2024-02-10 14:00:00'),
('Diana Prince', 'diana.prince@example.com', '000-111-2222', '2024-06-01 09:00:00'),
('Eve Adams', 'eve.adams@example.com', '333-444-5555', '2025-01-05 16:00:00');

-- Insert data into customer_addresses
INSERT INTO customer_addresses (customer_id, country, state, city, street, floor, appartment_no, address_type_id, is_default) VALUES
(1, 'USA', 'California', 'Los Angeles', '123 Main St', NULL, '10A', 1, 1),
(1, 'USA', 'California', 'Los Angeles', '123 Main St', NULL, '10A', 2, 0),
(2, 'Canada', 'Ontario', 'Toronto', '456 Oak Ave', '2', '201', 1, 1),
(2, 'Canada', 'Ontario', 'Toronto', '456 Oak Ave', '2', '201', 2, 0),
(3, 'UK', 'England', 'London', '789 Elm Rd', NULL, NULL, 1, 1),
(4, 'Germany', 'Bavaria', 'Munich', '101 Pine Ln', '3', '3B', 1, 1),
(5, 'France', 'Ile-de-France', 'Paris', '202 Birch Blvd', NULL, 'G05', 1, 1);

-- Insert data into product_categories
INSERT INTO product_categories (name, parent_category_id) VALUES
('Electronics', NULL),
('Computers', 1),
('Smartphones', 1),
('Accessories', 1),
('Laptops', 2),
('Desktops', 2),
('Audio', 1),
('Headphones', 7),
('Speakers', 7),
('Home & Kitchen', NULL),
('Cookware', 10),
('Appliances', 10);

-- Insert data into brands
INSERT INTO brands (name, logo_url) VALUES
('TechCorp', 'http://example.com/techcorp_logo.png'),
('AudioBlast', 'http://example.com/audioblast_logo.png'),
('HomeComfort', 'http://example.com/homecomfort_logo.png'),
('InnovateGadgets', 'http://example.com/innovategadgets_logo.png');

-- Insert data into products
INSERT INTO products (name, description, brand_id, created_at) VALUES
('Laptop Pro X', 'Powerful laptop for professionals.', 1, '2023-01-20 09:00:00'),
('Smartphone Z1', 'Latest model with advanced camera.', 1, '2023-02-01 10:30:00'),
('Wireless Headphones', 'Noise-cancelling over-ear headphones.', 2, '2023-03-10 11:00:00'),
('Smart Speaker Echo', 'Voice-controlled smart speaker.', 2, '2023-04-05 14:00:00'),
('Coffee Maker Deluxe', 'Automatic coffee maker with grinder.', 3, '2024-01-15 15:00:00'),
('Ergonomic Mouse', 'Comfortable mouse for long use.', 4, '2024-03-22 13:00:00'),
('Gaming PC Ultra', 'High-performance gaming desktop.', 1, '2024-05-01 10:00:00');

-- Insert data into tags
INSERT INTO tags (name) VALUES
('New Arrival'),
('Best Seller'),
('Eco-Friendly'),
('Gaming'),
('Work From Home');

-- Insert data into product_tags
INSERT INTO product_tags (product_id, tag_id) VALUES
(1, 2), -- Laptop Pro X - Best Seller
(1, 5), -- Laptop Pro X - Work From Home
(2, 1), -- Smartphone Z1 - New Arrival
(2, 2), -- Smartphone Z1 - Best Seller
(3, 2), -- Wireless Headphones - Best Seller
(4, 3), -- Smart Speaker Echo - Eco-Friendly
(6, 5), -- Ergonomic Mouse - Work From Home
(7, 4); -- Gaming PC Ultra - Gaming

-- Insert data into product_to_categories
INSERT INTO product_to_categories (product_id, category_id) VALUES
(1, 2), -- Laptop Pro X - Computers
(1, 5), -- Laptop Pro X - Laptops
(2, 3), -- Smartphone Z1 - Smartphones
(3, 7), -- Wireless Headphones - Audio
(3, 8), -- Wireless Headphones - Headphones
(4, 7), -- Smart Speaker Echo - Audio
(4, 9), -- Smart Speaker Echo - Speakers
(5, 10), -- Coffee Maker Deluxe - Home & Kitchen
(5, 12), -- Coffee Maker Deluxe - Appliances
(6, 1), -- Ergonomic Mouse - Electronics
(6, 4), -- Ergonomic Mouse - Accessories
(7, 2), -- Gaming PC Ultra - Computers
(7, 6); -- Gaming PC Ultra - Desktops

-- Insert data into product_variants
INSERT INTO product_variants (product_id, sku, unit_price, quantity_in_stock, created_at) VALUES
(1, 'LAP-PX-256GB', 1200.00, 50, '2023-01-20 09:10:00'),
(1, 'LAP-PX-512GB', 1450.00, 30, '2023-01-20 09:10:00'),
(2, 'SMART-Z1-BLK', 800.00, 100, '2023-02-01 10:40:00'),
(2, 'SMART-Z1-WHT', 820.00, 80, '2023-02-01 10:40:00'),
(3, 'HP-WIRE-BLK', 150.00, 200, '2023-03-10 11:10:00'),
(3, 'HP-WIRE-WHT', 155.00, 180, '2023-03-10 11:10:00'),
(4, 'SPK-ECHO-GRY', 99.99, 150, '2023-04-05 14:10:00'),
(5, 'COF-DELUXE', 250.00, 70, '2024-01-15 15:10:00'),
(6, 'MOUSE-ERG-BLK', 45.00, 300, '2024-03-22 13:10:00'),
(7, 'GAM-PC-ULTRA', 2500.00, 20, '2024-05-01 10:10:00');

-- Insert data into variant_options
INSERT INTO variant_options (name) VALUES
('Storage'),
('Color'),
('Size');

-- Insert data into variant_option_values
INSERT INTO variant_option_values (option_id, value) VALUES
(1, '256GB'),
(1, '512GB'),
(2, 'Black'),
(2, 'White'),
(2, 'Grey'),
(3, 'Small'),
(3, 'Medium'),
(3, 'Large');

-- Insert data into variant_option_assignments
INSERT INTO variant_option_assignments (variant_id, value_id) VALUES
(1, 1), -- LAP-PX-256GB -> 256GB
(2, 2), -- LAP-PX-512GB -> 512GB
(3, 3), -- SMART-Z1-BLK -> Black
(4, 4), -- SMART-Z1-WHT -> White
(5, 3), -- HP-WIRE-BLK -> Black
(6, 4), -- HP-WIRE-WHT -> White
(7, 5), -- SPK-ECHO-GRY -> Grey
(9, 3); -- MOUSE-ERG-BLK -> Black

-- Insert data into order_statuses
INSERT INTO order_statuses (name) VALUES
('Pending'),
('Processing'),
('Shipped'),
('Delivered'),
('Cancelled'),
('Refunded');

-- Insert data into orders (multi-year, multi-month data)
INSERT INTO orders (created_at, status_id, customer_id, address_id) VALUES
('2023-02-01 10:00:00', 4, 1, 1), -- Alice, Delivered, Feb 2023
('2023-04-10 11:00:00', 4, 2, 3), -- Bob, Delivered, Apr 2023
('2023-08-20 14:00:00', 3, 1, 1), -- Alice, Shipped, Aug 2023
('2023-11-05 09:00:00', 5, 2, 3), -- Bob, Cancelled, Nov 2023
('2024-01-10 16:00:00', 4, 3, 5), -- Charlie, Delivered, Jan 2024
('2024-03-15 10:30:00', 2, 4, 6), -- Diana, Processing, Mar 2024
('2024-05-25 12:00:00', 4, 1, 1), -- Alice, Delivered, May 2024
('2024-07-01 11:00:00', 1, 5, 7), -- Eve, Pending, Jul 2024
('2024-09-12 15:00:00', 4, 3, 5), -- Charlie, Delivered, Sep 2024
('2025-01-20 09:30:00', 1, 2, 3), -- Bob, Pending, Jan 2025
('2025-03-01 14:00:00', 2, 4, 6); -- Diana, Processing, Mar 2025

-- Insert data into order_items
INSERT INTO order_items (order_id, variant_id, quantity, unit_price) VALUES
(1, 1, 1, 1200.00), -- Alice's Feb 2023 order: Laptop Pro X 256GB
(1, 3, 1, 800.00),  -- Alice's Feb 2023 order: Smartphone Z1 Black
(2, 5, 2, 150.00),  -- Bob's Apr 2023 order: Wireless Headphones Black (x2)
(3, 2, 1, 1450.00), -- Alice's Aug 2023 order: Laptop Pro X 512GB
(4, 7, 1, 99.99),   -- Bob's Nov 2023 order: Smart Speaker Echo Grey (cancelled)
(5, 8, 1, 250.00),  -- Charlie's Jan 2024 order: Coffee Maker Deluxe
(6, 9, 3, 45.00),   -- Diana's Mar 2024 order: Ergonomic Mouse Black (x3)
(7, 1, 1, 1200.00), -- Alice's May 2024 order: Laptop Pro X 256GB
(7, 6, 1, 155.00),  -- Alice's May 2024 order: Wireless Headphones White
(8, 10, 1, 2500.00),-- Eve's Jul 2024 order: Gaming PC Ultra
(9, 3, 1, 800.00),  -- Charlie's Sep 2024 order: Smartphone Z1 Black
(10, 5, 1, 150.00), -- Bob's Jan 2025 order: Wireless Headphones Black
(11, 8, 1, 250.00); -- Diana's Mar 2025 order: Coffee Maker Deluxe

-- Insert data into shipments
INSERT INTO shipments (carrier, tracking_number, shipment_date, delivery_date, order_id, address_id) VALUES
('FedEx', 'FEDEX123456789', '2023-02-02 12:00:00', '2023-02-05 10:00:00', 1, 1),
('UPS', 'UPS987654321', '2023-04-11 13:00:00', '2023-04-14 11:00:00', 2, 3),
('DHL', 'DHL555444333', '2023-08-21 16:00:00', '2023-08-25 09:00:00', 3, 1),
('Royal Mail', 'RM1122334455', '2024-01-11 17:00:00', '2024-01-16 13:00:00', 5, 5),
('DPD', 'DPD9988776655', '2024-05-26 10:00:00', '2024-05-29 14:00:00', 7, 1),
('UPS', 'UPS0011223344', '2024-09-13 11:00:00', '2024-09-17 10:00:00', 9, 5);

-- Insert data into payment_methods
INSERT INTO payment_methods (type, name) VALUES
('Credit Card', 'Visa'),
('Credit Card', 'MasterCard'),
('Bank Transfer', 'Bank Transfer'),
('PayPal', 'PayPal'),
('Cash', 'Cash on Delivery');

-- Insert data into payment_statuses
INSERT INTO payment_statuses (name) VALUES
('Pending'),
('Completed'),
('Failed'),
('Refunded');

-- Insert data into invoices
INSERT INTO invoices (order_id, customer_id, invoice_total, tax, discount, payment_total, invoice_date, due_date, payment_date) VALUES
(1, 1, 2000.00, 100.00, 0.00, 2000.00, '2023-02-01 10:00:00', '2023-02-15 00:00:00', '2023-02-01 10:05:00'), -- Order 1: Alice, Paid
(2, 2, 300.00, 15.00, 0.00, 300.00, '2023-04-10 11:00:00', '2023-04-24 00:00:00', '2023-04-10 11:05:00'), -- Order 2: Bob, Paid
(3, 1, 1450.00, 72.50, 0.00, 0.00, '2023-08-20 14:00:00', '2023-09-03 00:00:00', NULL), -- Order 3: Alice, Not yet paid
(4, 2, 99.99, 5.00, 0.00, 0.00, '2023-11-05 09:00:00', '2023-11-19 00:00:00', NULL), -- Order 4: Bob, Cancelled, no payment
(5, 3, 250.00, 12.50, 0.00, 250.00, '2024-01-10 16:00:00', '2024-01-24 00:00:00', '2024-01-10 16:05:00'), -- Order 5: Charlie, Paid
(6, 4, 135.00, 6.75, 0.00, 0.00, '2024-03-15 10:30:00', '2024-03-29 00:00:00', NULL), -- Order 6: Diana, Not yet paid
(7, 1, 1355.00, 67.75, 0.00, 1355.00, '2024-05-25 12:00:00', '2024-06-08 00:00:00', '2024-05-25 12:05:00'), -- Order 7: Alice, Paid
(8, 5, 2500.00, 125.00, 0.00, 0.00, '2024-07-01 11:00:00', '2024-07-15 00:00:00', NULL), -- Order 8: Eve, Not yet paid
(9, 3, 800.00, 40.00, 0.00, 800.00, '2024-09-12 15:00:00', '2024-09-26 00:00:00', '2024-09-12 15:05:00'), -- Order 9: Charlie, Paid
(10, 2, 150.00, 7.50, 0.00, 0.00, '2025-01-20 09:30:00', '2025-02-03 00:00:00', NULL), -- Order 10: Bob, Not yet paid
(11, 4, 250.00, 12.50, 0.00, 0.00, '2025-03-01 14:00:00', '2025-03-15 00:00:00', NULL); -- Order 11: Diana, Not yet paid

-- Insert data into payments
INSERT INTO payments (invoice_id, amount, payment_date, method_id, status_id) VALUES
(1, 2000.00, '2023-02-01 10:05:00', 1, 2), -- Invoice 1: Completed via Visa
(2, 300.00, '2023-04-10 11:05:00', 2, 2), -- Invoice 2: Completed via MasterCard
(5, 250.00, '2024-01-10 16:05:00', 3, 2), -- Invoice 5: Completed via Bank Transfer
(7, 1355.00, '2024-05-25 12:05:00', 4, 2), -- Invoice 7: Completed via PayPal
(9, 800.00, '2024-09-12 15:05:00', 1, 2); -- Invoice 9: Completed via Visa
