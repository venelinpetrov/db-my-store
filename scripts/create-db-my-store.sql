DROP DATABASE IF EXISTS my_store;
CREATE DATABASE my_store
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_0900_ai_ci;

USE my_store;

-- Customers model

CREATE TABLE customers (
    customer_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (customer_id),
    UNIQUE KEY idx_customers_email_UNIQUE (email)
) ENGINE=InnoDB;

CREATE TABLE address_types (
    address_type_id INT NOT NULL AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (address_type_id),
    UNIQUE KEY idx_address_types_type_name_UNIQUE (type_name)
) ENGINE=InnoDB;

CREATE TABLE customer_addresses (
    address_id INT NOT NULL AUTO_INCREMENT,
    customer_id INT NOT NULL,
    country VARCHAR(100) NOT NULL,
    state VARCHAR(100) DEFAULT NULL,
    city VARCHAR(100) NOT NULL,
    street VARCHAR(100) NOT NULL,
    floor VARCHAR(10) DEFAULT NULL,
    appartment_no VARCHAR(10) DEFAULT NULL,
    address_type_id INT NOT NULL,
    is_default TINYINT DEFAULT 0,
    PRIMARY KEY (address_id),
    KEY fk_idx_customer_addresses_customer_id (customer_id),
    KEY fk_idx_customer_addresses_address_type_id (address_type_id),
    CONSTRAINT fk_customer_addresses_address_types FOREIGN KEY (address_type_id) REFERENCES address_types (address_type_id),
    CONSTRAINT fk_customers_customer_addresses FOREIGN KEY (customer_id) REFERENCES customers (customer_id) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB;

-- Products model

CREATE TABLE product_categories (
    category_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    parent_category_id INT NULL,
    PRIMARY KEY (category_id),
    UNIQUE KEY idx_product_categories_name_UNIQUE (name),
    KEY fk_idx_product_categories_parent_category_id (parent_category_id),
    FOREIGN KEY (parent_category_id) REFERENCES product_categories (category_id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE products (
    product_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (product_id),
    KEY idx_products_name (name)
) ENGINE=InnoDB;

CREATE TABLE product_to_categories (
    product_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (product_id, category_id),
    KEY fk_idx_product_to_categories_product_id (product_id),
    KEY fk_idx_product_to_categories_category_id (category_id),
    FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES product_categories (category_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE product_variants (
    variant_id INT NOT NULL AUTO_INCREMENT,
    product_id INT NOT NULL,
    sku VARCHAR(20) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity_in_stock INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (variant_id),
    UNIQUE KEY idx_product_variants_sku_UNIQUE (sku),
    KEY fk_idx_product_variants_product_id (product_id)
) ENGINE=InnoDB;

CREATE TABLE variant_options (
    option_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    PRIMARY KEY (option_id),
    UNIQUE KEY idx_variant_options_name_UNIQUE (name)
) ENGINE=InnoDB;

CREATE TABLE variant_option_values (
    value_id INT NOT NULL AUTO_INCREMENT,
    option_id INT NOT NULL,
    value VARCHAR(50) NOT NULL,
    PRIMARY KEY (value_id),
    KEY fk_idx_variant_option_values_option_id (option_id),
    UNIQUE KEY idx_variant_option_values_option_value_UNIQUE (option_id, value)
) ENGINE=InnoDB;

CREATE TABLE variant_option_assignments (
    variant_id INT NOT NULL,
    value_id INT NOT NULL,
    PRIMARY KEY (variant_id, value_id),
    KEY fk_idx_variant_option_assignments_variant_id (variant_id),
    KEY fk_idx_variant_option_assignments_value_id (value_id),
    FOREIGN KEY (variant_id) REFERENCES product_variants (variant_id) ON DELETE CASCADE,
    FOREIGN KEY (value_id) REFERENCES variant_option_values (value_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Orders and Shipment models

CREATE TABLE order_statuses (
  status_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(20) NOT NULL UNIQUE,
  PRIMARY KEY (status_id)
) ENGINE=InnoDB;

CREATE TABLE orders (
  order_id INT NOT NULL AUTO_INCREMENT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  status_id INT NOT NULL,
  customer_id INT NOT NULL,
  address_id INT NOT NULL,
  PRIMARY KEY (order_id),
  KEY fk_idx_orders_status_id (status_id),
  KEY fk_idx_orders_customer_id (customer_id),
  KEY fk_idx_orders_address_id (address_id),
  KEY idx_orders_customer_status (customer_id, status_id),
  FOREIGN KEY (status_id) REFERENCES order_statuses (status_id),
  FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
  FOREIGN KEY (address_id) REFERENCES customer_addresses (address_id)
) ENGINE=InnoDB;

CREATE TABLE order_items (
  order_id INT NOT NULL,
  variant_id INT NOT NULL,
  quantity INT NOT NULL,
  unit_price DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (order_id, variant_id),
  KEY fk_idx_order_items_order_id (order_id),
  KEY fk_idx_order_items_variant_id (variant_id),
  FOREIGN KEY (order_id) REFERENCES orders (order_id),
  FOREIGN KEY (variant_id) REFERENCES product_variants (variant_id)
) ENGINE=InnoDB;


CREATE TABLE shipments (
  shipment_id INT NOT NULL AUTO_INCREMENT,
  carrier VARCHAR(50) NOT NULL,
  tracking_number VARCHAR(50) NOT NULL UNIQUE,
  shipment_date DATETIME NOT NULL,
  delivery_date DATETIME NOT NULL,
  order_id INT NOT NULL,
  address_id INT NOT NULL,
  PRIMARY KEY (shipment_id),
  KEY fk_idx_shipments_order_id (order_id),
  KEY fk_idx_shipments_address_id (address_id),
  FOREIGN KEY (order_id) REFERENCES orders (order_id),
  FOREIGN KEY (address_id) REFERENCES customer_addresses (address_id)
) ENGINE=InnoDB;
