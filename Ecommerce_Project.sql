CREATE DATABASE ecommerce_project;
use ecommerce_project;
Create table orders ( order_id VARCHAR (50), 
product_id varchar(50),
quantity INT,
unit_price decimal (10,2),
discount_percentage decimal (10,8),
dicount_amount decimal (10,2),
gross_sales decimal (10,2),
tax_amount decimal (10,2),
shipping_cost decimal (10,2),
net_sales decimal (10,2),
product_cost decimal (10,2),
profit decimal (10,2)
);

alter table orders rename column dicount_amount to discount_amount;

#load data
use ecommerce_project;
show variables like 'secure_file_priv';
USE ecommerce_project;
TRUNCATE TABLE order_items;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_items.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SELECT COUNT(*) FROM order_items;

#Overall Sale Report
SELECT 
  COUNT(DISTINCT order_id) AS total_orders,
  SUM(quantity) AS total_units_sold,
  ROUND(SUM(gross_sales),2) AS total_gross_sales,
  ROUND(SUM(discount_amount),2) AS total_discount,
  ROUND(SUM(net_sales),2) AS total_net_sales,
  ROUND(SUM(profit),2) AS total_profit,
  ROUND(SUM(profit)/SUM(net_sales)*100,2) AS profit_margin_percent
FROM order_items;

use ecommerce_project;
SELECT COUNT(DISTINCT order_id) AS total_orders FROM order_items;
select count(discount_amount) as dis from order_items;

#Top 10 products by profit
use ecommerce_project;
select product_id,
ROUND(SUM(PROFIT), 2) AS PROFIT
FROM ORDER_ITEMS 
GROUP BY PRODUCT_ID
ORDER BY PROFIT DESC
LIMIT 10;

#Loss making products
select product_id,
ROUND(SUM(profit), 2) as product_loss
from order_items
group by product_id
order by product_loss asc
limit 10;

#overall discount, sales and profit summary
SELECT 
  ROUND(SUM(discount_amount),2) AS total_discount_given,
  ROUND(SUM(net_sales),2) AS total_net_sales,
  ROUND(SUM(profit),2) AS total_profit,
  ROUND(SUM(profit)/SUM(net_sales)*100,2) AS overall_margin_percent
FROM order_items;

#Profit Analysis by Discount Slab
SELECT 
  CASE 
    WHEN discount_percentage = 0 THEN '0% - No Discount'
    WHEN discount_percentage <= 0.10 THEN '1-10% Discount'
    WHEN discount_percentage <= 0.20 THEN '11-20% Discount'
    ELSE 'Above 20% Discount'
  END AS discount_slab,
  COUNT(*) AS total_orders,
  ROUND(SUM(profit),2) AS profit_in_this_slab
FROM order_items
GROUP BY discount_slab
ORDER BY profit_in_this_slab ASC;










