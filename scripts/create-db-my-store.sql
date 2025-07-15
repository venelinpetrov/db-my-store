DROP DATABASE IS EXISTS `my-store`;
CREATE DATABASE `my-store`;
USE `my-store`;


-- `my-store`.customers definition

CREATE TABLE `customers` (
	`customer_id` int NOT NULL AUTO_INCREMENT,
	`name` varchar(100) NOT NULL,
	`email` varchar(50) NOT NULL,
	`phone` varchar(20) NOT NULL,
	`created_at` datetime DEFAULT CURRENT_TIMESTAMP,
	`updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`customer_id`),
	UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- `my-store`.customer_addresses definition

CREATE TABLE `customer_addresses` (
	`address_id` int NOT NULL AUTO_INCREMENT,
	`customer_id` int NOT NULL,
	`country` varchar(100) NOT NULL,
	`state` varchar(100) DEFAULT NULL,
	`city` varchar(100) NOT NULL,
	`street` varchar(100) NOT NULL,
	`floor` varchar(10) DEFAULT NULL,
	`appartment_no` varchar(10) DEFAULT NULL,
	`address_type_id` int NOT NULL,
	`is_default` tinyint(1) DEFAULT '0',
	PRIMARY KEY (`address_id`),
	KEY `fk_customers_customer_addresses_1_idx` (`customer_id`),
	KEY `fk_customer_addresses_address_types_idx` (`address_type_id`),
	CONSTRAINT `fk_customer_addresses_address_types` FOREIGN KEY (`address_type_id`) REFERENCES `address_types` (`address_type_id`),
	CONSTRAINT `fk_customers_customer_addresses` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- `my-store`.address_types definition

CREATE TABLE `address_types` (
	`address_type_id` int NOT NULL AUTO_INCREMENT,
	`type_name` varchar(50) NOT NULL,
	PRIMARY KEY (`address_type_id`),
	UNIQUE KEY `type_name_UNIQUE` (`type_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--- `my-store`.`product_categories` definition

CREATE TABLE `my-store`.`product_categories` (
	`category_id` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(100) NOT NULL,
	`parent_category_id` INT NULL,
	PRIMARY KEY (`category_id`),
	FOREIGN KEY (`parent_category_id`) REFERENCES `my-store`.`product_categories` (`category_id`) ON DELETE SET NULL
);

CREATE TABLE `my-store`.`product_to_categories` (
	`product_id` INT NOT NULL,
	`category_id` INT NOT NULL,
	PRIMARY KEY (`product_id`, `category_id`),
	FOREIGN KEY (`product_id`) REFERENCES `my-store`.`products` (`product_id`) ON DELETE CASCADE,
	FOREIGN KEY (`category_id`) REFERENCES `my-store`.`product_categories` (`category_id`) ON DELETE CASCADE
);

