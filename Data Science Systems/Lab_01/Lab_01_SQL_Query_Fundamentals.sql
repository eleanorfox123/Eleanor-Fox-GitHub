-- --------------------------------------------------------------------------------------
-- Course: DS2-2002 - Data Science Systems | Author: Jon Tupitza
-- Lab 1: SQL Query Fundamentals | 5 Points
-- --------------------------------------------------------------------------------------
# use northwind; not sure if this is correct 
# Create database northwind; 
# use northwind;
-- --------------------------------------------------------------------------------------
-- 1). First, How Many Rows (Products) are in the Products Table?			| 0.2 pt
-- --------------------------------------------------------------------------------------
SELECT count(*) as product_count
 FROM northwind.products; 
#45 
-- --------------------------------------------------------------------------------------
-- 2). Fetch Each Product Name and its Quantity per Unit					| 0.2.pt
-- --------------------------------------------------------------------------------------
SELECT product_name
	, quantity_per_unit
FROM northwind.products;

-- --------------------------------------------------------------------------------------
-- 3). Fetch the Product ID and Name of Currently Available Products		| 0.2 pt
-- --------------------------------------------------------------------------------------
SELECT id AS product_id
	, product_name AS product
--    , discontinued AS available
FROM northwind.products
WHERE discontinued = 0;
# WHERE discontinued <= 1;

-- --------------------------------------------------------------------------------------
-- 4). Fetch the Product ID, Name & List Price Costing Less Than $20
--     Sort the results with the most expensive Products first.				| 0.2 pt
-- --------------------------------------------------------------------------------------
SELECT id AS product_id
	, product_name AS product
    , list_price
FROM northwind.products
WHERE list_price < 20
ORDER BY list_price DESC;
-- --------------------------------------------------------------------------------------
-- 5). Fetch the Product ID, Name & List Price Costing Between $15 and $20
--     Sort the results with the most expensive Products first.				| 0.2 pt
-- --------------------------------------------------------------------------------------
SELECT id AS product_id
	, product_name AS product
    , list_price
FROM northwind.products
WHERE list_price BETWEEN 15 AND 20
ORDER by list_price DESC;

-- Older (Equivalent) Syntax -----
SELECT id AS product_id 
	, product_name 
    , list_price 
FROM northwind.products
WHERE list_price >= 15.00 
AND list_price <= 20.00 
ORDER BY list_price DESC; 

-- --------------------------------------------------------------------------------------
-- 6). Fetch the Product Name & List Price of the 10 Most Expensive Products 
--     Sort the results with the most expensive Products first.				| 0.33 pt
-- --------------------------------------------------------------------------------------
SELECT product_name 
	, list_price 
FROM northwind.products
ORDER BY list_price DESC
LIMIT 10;

-- --------------------------------------------------------------------------------------
-- 7). Fetch the Name & List Price of the Most & Least Expensive Products	| 0.33 pt.
-- --------------------------------------------------------------------------------------
SELECT product_name 
	, list_price
from northwind.products 
where list_price = (select min(list_price) from northwind.products) 
or list_price = (select max(list_price) from northwind.products); 

-- --------------------------------------------------------------------------------------
-- 8). Fetch the Product Name & List Price Costing Above Average List Price
--     Sort the results with the most expensive Products first.				| 0.33 pt.
-- --------------------------------------------------------------------------------------
select product_name 
	, list_price 
  from northwind.products 
  where list_price > (select AVG (list_price) from northwind.products) 
  order by list_price DESC; 

-- --------------------------------------------------------------------------------------
-- 9). Fetch & Label the Count of Current and Discontinued Products using
-- 	   the "CASE... WHEN" syntax to create a column named "availablity"
--     that contains the values "discontinued" and "current". 				| 0.33 pt
-- --------------------------------------------------------------------------------------
UPDATE northwind.products SET discontinued = 1 WHERE id IN (95, 96, 97);

select case discontinued 
			when 1 then 'discontinued'
			else 'current'
		end as availability 
	, count(*) as product_count 
from northwind.products 
group by availability; 


-- TODO: Insert query here.


UPDATE northwind.products SET discontinued = 0 WHERE id in (95, 96, 97);

-- --------------------------------------------------------------------------------------
-- 10). Fetch Product Name, Reorder Level, Target Level and "Reorder Threshold"
-- 	    Where Reorder Level is Less Than or Equal to 20% of Target Level	| 0.33 pt.
-- --------------------------------------------------------------------------------------
select product_name 
	, reorder_level 
    , target_level 
    , round(target_level/5) as reorder_threshold #not sure how to fix this yet. maybe going to learn soon? 
from northwind.products 
where reorder_level <= round(target_level/5); 

-- --------------------------------------------------------------------------------------
-- 11). Fetch the Number of Products per Category Priced Less Than $20.00	| 0.33 pt
-- --------------------------------------------------------------------------------------
select category 
	, count(*) as product_count 
from northwind.products 
where list_price < 20.00 
group by category 
order by category; 
# when you want to do grouping, need to list anything in selected list 
# that is not in an aggregate. stick to 1,2,3 columns. 

-- --------------------------------------------------------------------------------------
-- 12). Fetch the Number of Products per Category With Less Than 5 Units In Stock	| 0.5 pt
-- --------------------------------------------------------------------------------------
select category 
	, count(*) as units_in_stock 
from northwind.products 
group by category 
having units_in_stock < 5
order by units_in_stock desc; 

-- --------------------------------------------------------------------------------------
-- 13). Fetch Products along with their Supplier Company & Address Info		| 0.5 pt
-- --------------------------------------------------------------------------------------
select p.product_name 
	, p.category as product_category 
    , p.list_price as product_list_price 
    , s.company as supplier_company 
    , s.address as supplier_address 
    , s.city as supplier_city 
    , s.state_province as supplier_state_province 
    , s.zip_postal_code as supplier_zip_postal_code
from northwind.products p 
inner join northwind.suppliers s 
on s.id = p.supplier_ids; 
# 3 primary joins 
# join - inner join. everything in that table that matches other table 
# cab you have a column with multiple values in it? no. what morron would do this.
	# violates first normal form. 
-- --------------------------------------------------------------------------------------
-- 14). Fetch the Customer ID and Full Name for All Customers along with
-- 		the Order ID and Order Date for Any Orders they may have			| 0.5 pt
-- --------------------------------------------------------------------------------------
select c.id as customer_id 
	, contact(c.first_name, " ", c.last_name) as customer_name 
    , o.id as order_id
    , o.order_date 
from northwind.customers as c
left outer join northwind.orders as o 
ON c.id = o.customer_id 
order by customer_id;
    
    


-- --------------------------------------------------------------------------------------
-- 15). Fetch the Order ID and Order Date for All Orders along with
--   	the Customr ID and Full Name for Any Associated Customers			| 0.5 pt
-- --------------------------------------------------------------------------------------
select o.id as order_id 
	, o.order_date 
    , c.id as customer_id 
    , contact(c.first_name, " ", c.last_name) as customer_name 
from northwind.customers as c
right outer join northwind.orders as o 
on c.id = o.customer_id 
order by customer_id


