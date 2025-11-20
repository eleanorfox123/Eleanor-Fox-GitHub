DROP database `northwind_dw`;
CREATE DATABASE `northwind_dw` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE northwind_dw;

DROP TABLE IF EXISTS `dim_customers`;
CREATE TABLE `dim_customers` (
  `customer_key` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `company` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `job_title` varchar(50) DEFAULT NULL,
  `business_phone` varchar(25) DEFAULT NULL,
  `fax_number` varchar(25) DEFAULT NULL,
  `address` longtext,
  `city` varchar(50) DEFAULT NULL,
  `state_province` varchar(50) DEFAULT NULL,
  `zip_postal_code` varchar(15) DEFAULT NULL,
  `country_region` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`customer_key`),
  KEY `customer_id` (`customer_id`),
  KEY `city` (`city`),
  KEY `company` (`company`),
  KEY `first_name` (`first_name`),
  KEY `last_name` (`last_name`),
  KEY `zip_postal_code` (`zip_postal_code`),
  KEY `state_province` (`state_province`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `dim_employees`;
CREATE TABLE `dim_employees` (
  `employee_key` int NOT NULL AUTO_INCREMENT,
  `employee_id` int NOT NULL,
  `company` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `email_address` varchar(50) DEFAULT NULL,
  `job_title` varchar(50) DEFAULT NULL,
  `business_phone` varchar(25) DEFAULT NULL,
  `home_phone` varchar(25) DEFAULT NULL,
  `fax_number` varchar(25) DEFAULT NULL,
  `address` longtext,
  `city` varchar(50) DEFAULT NULL,
  `state_province` varchar(50) DEFAULT NULL,
  `zip_postal_code` varchar(15) DEFAULT NULL,
  `country_region` varchar(50) DEFAULT NULL,
  `web_page` longtext,
  PRIMARY KEY (`employee_key`),
  KEY `employee_id` (`employee_id`),
  KEY `city` (`city`),
  KEY `company` (`company`),
  KEY `first_name` (`first_name`),
  KEY `last_name` (`last_name`),
  KEY `zip_postal_code` (`zip_postal_code`),
  KEY `state_province` (`state_province`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `dim_products`;
CREATE TABLE `dim_products` (
  `product_key` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `product_code` varchar(25) DEFAULT NULL,
  `product_name` varchar(50) DEFAULT NULL,
  `standard_cost` decimal(19,4) DEFAULT '0.0000',
  `list_price` decimal(19,4) NOT NULL DEFAULT '0.0000',
  `reorder_level` int DEFAULT NULL,
  `target_level` int DEFAULT NULL,
  `quantity_per_unit` varchar(50) DEFAULT NULL,
  `discontinued` tinyint(1) NOT NULL DEFAULT '0',
  `minimum_reorder_quantity` int DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`product_key`),
  KEY `product_id` (`product_id`),
  KEY `product_code` (`product_code`),
  KEY `discontinued` (`discontinued`),
  KEY `category` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4;

# ----------------------------------------------------------
# TODO: CREATE the `dim_shippers` dimension table ----------
# ----------------------------------------------------------
USE northwind_dw;

DROP TABLE IF EXISTS `dim_shippers`;
CREATE TABLE `dim_shippers` ( 
  `shipper_key` INT NOT NULL AUTO_INCREMENT,
  `shipper_id` INT NOT NULL,
  `company` VARCHAR(50) DEFAULT NULL,
  `email_address` VARCHAR(50) DEFAULT NULL,
  `job_title` VARCHAR(50) DEFAULT NULL,
  `business_phone` VARCHAR(25) DEFAULT NULL,
  `home_phone` VARCHAR(25) DEFAULT NULL,
  `mobile_phone` VARCHAR(25) DEFAULT NULL,
  `fax_number` VARCHAR(25) DEFAULT NULL,
  `address` LONGTEXT,
  `city` VARCHAR(50) DEFAULT NULL,
  `state_province` VARCHAR(50) DEFAULT NULL,
  `zip_postal_code` VARCHAR(15) DEFAULT NULL,
  `country_region` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`shipper_key`),
  KEY `shipper_id` (`shipper_id`),
  KEY `company` (`company`),
  KEY `city` (`city`),
  KEY `zip_postal_code` (`zip_postal_code`),
  KEY `state_province` (`state_province`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


# ----------------------------------------------------------------------
# TODO: JOIN the orders, order_details, order_details_status and 
#       orders_status tables to create a new Fact Table in Northwind_DW.
# To keep things simple, don't include purchase order or inventory info
# ----------------------------------------------------------------------
USE northwind_dw;

DROP TABLE IF EXISTS fact_orders;

CREATE TABLE fact_orders AS
SELECT 
    o.id AS order_id,
    o.customer_id,
    o.employee_id,
    o.order_date,
    o.shipped_date,
    o.shipper_id,
    o.shipping_fee,
    o.taxes,
    o.tax_rate,
    o.payment_type,
    o.paid_date,
    o.status_id AS order_status_id,
    os.status_name AS order_status,
    od.id AS order_detail_id,
    od.product_id,
    od.quantity,
    od.unit_price,
    od.discount,
    od.status_id AS order_detail_status_id,
    ods.status_name AS order_detail_status
FROM northwind.orders o
JOIN northwind.order_details od 
    ON o.id = od.order_id
LEFT JOIN northwind.orders_status os 
    ON o.status_id = os.id
LEFT JOIN northwind.order_details_status ods 
    ON od.status_id = ods.id;
    

SHOW TABLES IN northwind_dw;
DESCRIBE fact_orders;
SELECT * FROM fact_orders LIMIT 10;






