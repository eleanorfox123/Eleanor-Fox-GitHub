-- --------------------------------------------------------------------------------------------------------------
-- TODO: Extract the appropriate data from the northwind database, 
-- and INSERT it into the Northwind_DW database.
-- --------------------------------------------------------------------------------------------------------------

-- ----------------------------------------------
-- Populate dim_customers
-- ----------------------------------------------
TRUNCATE TABLE northwind_dw.dim_customers;

SELECT * FROM northwind_dw.dim_customers;

INSERT INTO `northwind_dw`.`dim_customers`
(`customer_id`,
`company`,
`last_name`,
`first_name`,
`job_title`,
`business_phone`,
`fax_number`,
`address`,
`city`,
`state_province`,
`zip_postal_code`,
`country_region`)
SELECT `id`,
	`company`,
	`last_name`,
	`first_name`,
	`job_title`,
	`business_phone`,
	`fax_number`,
	`address`,
	`city`,
	`state_province`,
	`zip_postal_code`,
	`country_region`
FROM northwind.customers;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM northwind_dw.dim_customers;


-- ----------------------------------------------
-- Populate dim_employees
-- ----------------------------------------------
TRUNCATE TABLE `northwind_dw`.`dim_employees`;

INSERT INTO `northwind_dw`.`dim_employees`
(`employee_id`,
`company`,
`last_name`,
`first_name`,
`email_address`,
`job_title`,
`business_phone`,
`home_phone`,
`fax_number`,
`address`,
`city`,
`state_province`,
`zip_postal_code`,
`country_region`,
`web_page`)
SELECT `id`,
    `company`,
    `last_name`,
    `first_name`,
    `email_address`,
    `job_title`,
    `business_phone`,
    `home_phone`,
    `fax_number`,
    `address`,
    `city`,
    `state_province`,
    `zip_postal_code`,
    `country_region`,
    `web_page`
FROM `northwind`.`employees`;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM northwind_dw.dim_employees;


-- ----------------------------------------------
-- Populate dim_products
-- ----------------------------------------------
TRUNCATE TABLE `northwind_dw`.`dim_products`;

INSERT INTO `northwind_dw`.`dim_products`
(`supplier_ids`,
`product_code`,
`product_name`,
`standard_cost`,
`list_price`,
`reorder_level`,
`target_level`,
`quantity_per_unit`,
`discontinued`,
`minimum_reorder_quantity`,
`category`)
# TODO: Write a SELECT Statement to Populate the table;
SELECT `supplier_ids`,
       `product_code`,
       `product_name`,
       `standard_cost`,
       `list_price`,
       `reorder_level`,
       `target_level`,
       `quantity_per_unit`,
       `discontinued`,
       `minimum_reorder_quantity`,
       `category`
FROM `northwind`.`products`;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM northwind_dw.dim_products;


-- ----------------------------------------------
-- Populate dim_shippers
-- ----------------------------------------------
TRUNCATE TABLE `northwind_dw`.`dim_shippers`;

INSERT INTO `northwind_dw`.`dim_shippers`
(`shipper_id`,
 `company`,
 `email_address`,
 `job_title`,
 `business_phone`,
 `home_phone`,
 `mobile_phone`,
 `fax_number`,
 `address`,
 `city`,
 `state_province`,
 `zip_postal_code`,
 `country_region`)
# TODO: Write a SELECT Statement to Populate the table;
SELECT `id`,
       `company`,
       `email_address`,
       `job_title`,
       `business_phone`,
       `home_phone`,
       `mobile_phone`,
       `fax_number`,
       `address`,
       `city`,
       `state_province`,
       `zip_postal_code`,
       `country_region`
FROM `northwind`.`shippers`;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM northwind_dw.dim_shippers;



-- ----------------------------------------------
#Populate fact_orders
-- ----------------------------------------------
TRUNCATE TABLE `northwind_dw`.`fact_orders`;

INSERT INTO northwind_dw.fact_orders
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

-- Validate
SELECT * FROM northwind_dw.fact_orders LIMIT 10;

/* 
--------------------------------------------------------------------------------------------------
TODO: Write a SELECT Statement that:
- JOINS the northwind.orders table with the northwind.orders_status table
- JOINS the northwind.orders with the northwind.order_details table.
--  (TIP: Remember that there is a one-to-many relationship between orders and order_details).
- JOINS the northwind.order_details table with the northwind.order_details_status table.
--------------------------------------------------------------------------------------------------
- The column list I've included in the INSERT INTO clause above should be your guide to which 
- columns you're required to extract from each of the four tables. Pay close attention!
--------------------------------------------------------------------------------------------------
*/
-- Join orders, orders_status, order_details, and order_details_status
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
-- inner join because every order must have a status
INNER JOIN northwind.orders_status os 
    ON o.status_id = os.id
-- left outer join because orders may or may not have details
LEFT OUTER JOIN northwind.order_details od 
    ON o.id = od.order_id
-- left outer join because detail may or may not have a status
INNER JOIN northwind.order_details_status ods 
    ON od.status_id = ods.id;




-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM northwind_dw.fact_orders;



-- ----------------------------------------------
-- ----------------------------------------------
-- Next, create the date dimension and then -----
-- integrate the date, customer, employee -------
-- product and shipper dimension tables ---------
-- ----------------------------------------------
-- ----------------------------------------------
-- ----------------------------------------------
-- Create dim_date
-- ----------------------------------------------
DROP TABLE IF EXISTS northwind_dw.dim_date;

CREATE TABLE northwind_dw.dim_date (
    date_key INT NOT NULL AUTO_INCREMENT,
    full_date DATE NOT NULL,
    year INT,
    month INT,
    day INT,
    PRIMARY KEY (date_key),
    UNIQUE KEY (full_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------
-- Populate dim_date from orders
-- ----------------------------------------------
TRUNCATE TABLE northwind_dw.dim_date;

INSERT IGNORE INTO northwind_dw.dim_date (full_date, year, month, day)
SELECT DISTINCT 
    o.order_date,
    YEAR(o.order_date),
    MONTH(o.order_date),
    DAY(o.order_date)
FROM northwind.orders o
WHERE o.order_date IS NOT NULL
UNION
SELECT DISTINCT 
    o.shipped_date,
    YEAR(o.shipped_date),
    MONTH(o.shipped_date),
    DAY(o.shipped_date)
FROM northwind.orders o
WHERE o.shipped_date IS NOT NULL
UNION
SELECT DISTINCT 
    o.paid_date,
    YEAR(o.paid_date),
    MONTH(o.paid_date),
    DAY(o.paid_date)
FROM northwind.orders o
WHERE o.paid_date IS NOT NULL;

SHOW CREATE TABLE northwind_dw.dim_date;

ALTER TABLE northwind_dw.dim_date 
MODIFY COLUMN full_date DATE NOT NULL;


-- Validate
SELECT * FROM northwind_dw.dim_date LIMIT 10;

-- ----------------------------------------------
-- Integrate fact_orders with dimensions
-- ----------------------------------------------
SELECT 
    fo.order_id,
    dc.customer_key,
    de.employee_key,
    dp.id AS product_id,
    ds.shipper_key,
    dd1.date_key AS order_date_key,
    dd2.date_key AS shipped_date_key,
    dd3.date_key AS paid_date_key,
    fo.quantity,
    fo.unit_price,
    fo.discount,
    fo.shipping_fee,
    fo.taxes,
    fo.tax_rate,
    fo.order_status,
    fo.order_detail_status
FROM northwind_dw.fact_orders fo
JOIN northwind_dw.dim_customers dc 
    ON fo.customer_id = dc.customer_id
JOIN northwind_dw.dim_employees de 
    ON fo.employee_id = de.employee_id
JOIN northwind_dw.dim_products dp 
    ON fo.product_id = dp.id
JOIN northwind_dw.dim_shippers ds 
    ON fo.shipper_id = ds.shipper_id
LEFT JOIN northwind_dw.dim_date dd1 
    ON fo.order_date = dd1.full_date
LEFT JOIN northwind_dw.dim_date dd2 
    ON fo.shipped_date = dd2.full_date
LEFT JOIN northwind_dw.dim_date dd3 
    ON fo.paid_date = dd3.full_date;



-- --------------------------------------------------------------------------------------------------
-- LAB QUESTION: Author a SQL query that returns the total (sum) of the quantity and unit price
-- for each customer (last name), sorted by the total unit price in descending order.
-- --------------------------------------------------------------------------------------------------

-- Total quantity and unit price by customer (last name)
SELECT 
    dc.last_name,
    SUM(fo.quantity) AS total_quantity,
    SUM(fo.unit_price) AS total_unit_price
FROM northwind_dw.fact_orders fo
JOIN northwind_dw.dim_customers dc
    ON fo.customer_id = dc.customer_id
GROUP BY dc.last_name
ORDER BY total_unit_price DESC;
