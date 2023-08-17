-- clean [customers] table
SELECT REPLACE(["customer_id"], '"', '') AS ["customer_id"]
	  ,REPLACE(["customer_unique_id"], '"', '') AS ["customer_unique_id"]
      ,CAST(REPLACE(["customer_zip_code_prefix"], '"', '') AS INT) AS ["customer_zip_code_prefix"]
INTO [customers_clean]
FROM [Brazilian e-Commerce].[dbo].[customers];

-- preview [customers_clean] table
SELECT ["customer_id"]
      ,["customer_unique_id"]
      ,["customer_zip_code_prefix"]
FROM [Brazilian e-Commerce].[dbo].[customers_clean];


-- clean [geolocations] table
SELECT CAST(REPLACE(["geolocation_zip_code_prefix"], '"', '') AS INT) AS ["geolocation_zip_code_prefix"]
      ,CAST(REPLACE(["geolocation_lat"], '"', '') AS FLOAT) AS ["geolocation_lat"]
      ,CAST(REPLACE(["geolocation_lng"], '"', '') AS FLOAT) AS ["geolocation_lng"]
      ,["geolocation_city"]
      ,["geolocation_state"]
INTO [geolocations_clean]
FROM [Brazilian e-Commerce].[dbo].[geolocations];

-- peview [geolocations_clean] table
SELECT ["geolocation_zip_code_prefix"]
      ,["geolocation_lat"]
      ,["geolocation_lng"]
      ,["geolocation_city"]
      ,["geolocation_state"]
FROM [Brazilian e-Commerce].[dbo].[geolocations_clean];


-- clean [order_items] table
SELECT REPLACE(["order_id"], '"', '') AS ["order_id"]
      ,CAST(["order_item_id"] AS INT) AS ["order_item_id"]
      ,REPLACE(["product_id"], '"', '') AS ["product_id"]
      ,REPLACE(["seller_id"], '"', '') AS ["seller_id"]
      ,CAST(["shipping_limit_date"] AS DATETIME) AS ["shipping_limit_date"]
      ,CAST(["price"] AS FLOAT) AS ["price"]
      ,CAST(["freight_value"] AS FLOAT) AS ["freight_value"]
INTO [order_items_clean]
FROM [Brazilian e-Commerce].[dbo].[order_items];

-- preview [order_items_clean] table
SELECT ["order_id"]
      ,["order_item_id"]
      ,["product_id"]
      ,["seller_id"]
      ,["shipping_limit_date"]
      ,["price"]
      ,["freight_value"]
FROM [Brazilian e-Commerce].[dbo].[order_items_clean];


-- clean [order_payments] table
SELECT REPLACE(["order_id"], '"', '') AS ["order_id"]
      ,CAST(["payment_sequential"] AS INT) AS ["payment_sequential"]
      ,["payment_type"]
      ,CAST(["payment_installments"] AS INT) AS ["payment_installments"]
      ,CAST(["payment_value"] AS FLOAT) AS ["payment_value"]
INTO [order_payments_clean]
FROM [Brazilian e-Commerce].[dbo].[order_payments];

--preview [order_payments_clean] table
SELECT ["order_id"]
      ,["payment_sequential"]
      ,["payment_type"]
      ,["payment_installments"]
      ,["payment_value"]
FROM [Brazilian e-Commerce].[dbo].[order_payments_clean];

-- clean [orders] table
SELECT REPlACE(["order_id"], '"', '') AS ["order_id"]
      ,REPLACE(["customer_id"], '"', '') AS ["customer_id"]
      ,["order_status"]
      ,CAST(["order_purchase_timestamp"] AS DATETIME) AS ["order_purchase_timestamp"]
      ,CAST(["order_approved_at"] AS DATETIME) AS ["order_approved_at"]
      ,CAST(["order_delivered_carrier_date"] AS DATETIME) AS ["order_delivered_carrier_date"]
      ,CAST(["order_delivered_customer_date"] AS DATETIME) AS ["order_delivered_customer_date"]
      ,CAST(["order_estimated_delivery_date"] AS DATETIME) AS ["order_estimated_delivery_date"]
INTO [orders_clean]
FROM [Brazilian e-Commerce].[dbo].[orders];
-- preview [orders_clean] table
SELECT ["order_id"]
      ,["customer_id"]
      ,["order_status"]
      ,["order_purchase_timestamp"]
      ,["order_approved_at"]
      ,["order_delivered_carrier_date"]
      ,["order_delivered_customer_date"]
      ,["order_estimated_delivery_date"]
FROM [Brazilian e-Commerce].[dbo].[orders_clean];

-- clean [products] table
SELECT REPLACE(["product_id"], '"', '') AS ["product_id"]
      ,b.[product_category_name_english] AS ["product_category_name"]
      ,CAST(["product_name_lenght"] AS INT) AS ["product_name_lenght"]
      ,CAST(["product_description_lenght"] AS INT) AS ["product_description_lenght"]
      ,CAST(["product_photos_qty"] AS INT) AS ["product_photos_qty"] 
      ,CAST(["product_weight_g"] AS INT) AS ["product_weight_g"]
      ,CAST(["product_length_cm"] AS INT) AS ["product_length_cm"]
      ,CAST(["product_height_cm"] AS INT) AS ["product_height_cm"]
      ,CAST(["product_width_cm"] AS INT) AS ["product_width_cm"]
INTO [products_clean]
FROM [Brazilian e-Commerce].[dbo].[products] AS a
	,[product_category_name_translation] AS b
WHERE a.["product_category_name"] = b.[product_category_name];

-- preview [products_clean] table
SELECT ["product_id"]
      ,["product_category_name"]
      ,["product_name_lenght"]
      ,["product_description_lenght"]
      ,["product_photos_qty"] 
      ,["product_weight_g"]
      ,["product_length_cm"]
      ,["product_height_cm"]
      ,["product_width_cm"]
FROM [Brazilian e-Commerce].[dbo].[products_clean];


-- clean [sellers] table
SELECT REPLACE(["seller_id"], '"', '') AS ["seller_id"]
      ,CAST(REPLACE(["seller_zip_code_prefix"], '"', '') AS INT) AS ["seller_zip_code_prefix"]
INTO [sellers_clean]
FROM [Brazilian e-Commerce].[dbo].[sellers]

-- preview [sellers_clean] table
SELECT ["seller_id"]
      ,["seller_zip_code_prefix"]
FROM [Brazilian e-Commerce].[dbo].[sellers_clean];




-- number of Customers per State
SELECT a.["geolocation_state"]
	  ,COUNT(b.["customer_unique_id"]) AS ["customer_count"]
FROM [Brazilian e-Commerce].[dbo].[geolocations_clean] AS a
LEFT JOIN [Brazilian e-Commerce].[dbo].[customers_clean] AS b
  ON a.["geolocation_zip_code_prefix"] = b.["customer_zip_code_prefix"]
GROUP BY a.["geolocation_state"]
ORDER BY ["customer_count"] DESC;

-- found invalid inputs in ["geolocaiton_state"]: " rio de janeiro, brasil, RJ", " bahia, brasil, BA"
-- both abbreaviations are already in the table
-- update the table to clean these inputs
UPDATE [Brazilian e-Commerce].[dbo].[geolocations_clean]
SET ["geolocation_state"] = 'RJ'
WHERE ["geolocation_state"] = ' rio de janeiro, brasil",RJ';

UPDATE [Brazilian e-Commerce].[dbo].[geolocations_clean]
SET ["geolocation_state"] = 'BA'
WHERE ["geolocation_state"] = ' bahia, brasil",BA';




-- number of Customers per City who bought a product

SELECT DISTINCT ["order_status"]
FROM [Brazilian e-Commerce].[dbo].[orders_clean];

SELECT c.["geolocation_city"]
	  ,COUNT(a.["customer_id"]) AS ["customer_count_purchased"]
FROM [Brazilian e-Commerce].[dbo].[customers_clean] AS a
LEFT JOIN [Brazilian e-Commerce].[dbo].[geolocations_clean] AS c
  ON a.["customer_zip_code_prefix"] = c.["geolocation_zip_code_prefix"]
WHERE a.["customer_id"] IN (
	SELECT b.["customer_id"]
	FROM [Brazilian e-Commerce].[dbo].[orders_clean] AS b
	WHERE b.["order_status"] IN ('shipped', 'approved', 'delivered') )
GROUP BY c.["geolocation_city"]
ORDER BY ["customer_count_purchased"] DESC;




-- list of Customers who have made at least two purchases within 7 days (active users)
SELECT DISTINCT(a.["customer_id"])
FROM [Brazilian e-Commerce].[dbo].[orders_clean] AS a
JOIN [Brazilian e-Commerce].[dbo].[orders_clean]  AS b 
ON a.["customer_id"] = b.["customer_id"]
AND a.["order_id"] <> b.["order_id"]
AND b.["order_purchase_timestamp"] BETWEEN a.["order_purchase_timestamp"] AND DATEADD(DAY, 7, a.["order_purchase_timestamp"]);

-- seems like no customer ever made a second purchase
-- double check

SELECT COUNT(["order_id"]) AS ["unique_orders"]
	  ,COUNT(DISTINCT(["customer_id"])) AS ["unique_customers"]
FROM [Brazilian e-Commerce].[dbo].[orders_clean];

-- both values are equal to 99 441




-- list of Sellers who have made 2 or more sales in 7 days (execuiton time - 15 seconds)
SELECT DISTINCT(a.["seller_id"])
FROM [Brazilian e-Commerce].[dbo].[order_items_clean] AS a
JOIN [Brazilian e-Commerce].[dbo].[order_items_clean]  AS b 
ON a.["seller_id"] = b.["seller_id"]
AND a.["order_id"] <> b.["order_id"]
AND b.["shipping_limit_date"] BETWEEN a.["shipping_limit_date"] AND DATEADD(DAY, 7, a.["shipping_limit_date"]);




-- number of Sellers per State
SELECT a.["geolocation_state"]
	  ,COUNT(b.["seller_id"]) AS ["seller_count"]
FROM [Brazilian e-Commerce].[dbo].[geolocations_clean] AS a
INNER JOIN [Brazilian e-Commerce].[dbo].[sellers_clean] AS b
  ON a.["geolocation_zip_code_prefix"] = b.["seller_zip_code_prefix"]
GROUP BY a.["geolocation_state"]
ORDER BY ["seller_count"] DESC;




-- number of cross-State purchases (execution time - 1.5 minutes)
WITH customer_states AS
(
	SELECT DISTINCT(a.["customer_id"])
		  ,b.["geolocation_state"]
	FROM [Brazilian e-Commerce].[dbo].[customers_clean] AS a
	INNER JOIN [Brazilian e-Commerce].[dbo].[geolocations_clean] AS b
	ON a.["customer_zip_code_prefix"] = b.["geolocation_zip_code_prefix"]
),

seller_states AS
(
	SELECT DISTINCT(a.["seller_id"])
		  ,c.["order_id"]
		  ,b.["geolocation_state"]
	FROM [Brazilian e-Commerce].[dbo].[sellers_clean] AS a
	LEFT JOIN [Brazilian e-Commerce].[dbo].[geolocations_clean] AS b
	ON a.["seller_zip_code_prefix"] = b.["geolocation_zip_code_prefix"]
	LEFT JOIN [Brazilian e-Commerce].[dbo].[order_items_clean] AS c
	ON a.["seller_id"] = c.["seller_id"]
)

SELECT COUNT(a.["geolocation_state"]) AS ["cross_state_orders"]
FROM [Brazilian e-Commerce].[dbo].[orders_clean] AS c
JOIN customer_states AS a
ON c.["customer_id"] = a.["customer_id"]
JOIN seller_states AS b
ON c.["order_id"] = b.["order_id"]
WHERE a.["geolocation_state"] <> b.["geolocation_state"];

-- total number of orders
SELECT COUNT(["order_id"]) AS ["order_count"]
FROM [Brazilian e-Commerce].[dbo].[orders_clean];




-- list of highest paid Sellers (running total)
WITH seller_revenues AS
(
	SELECT DISTINCT(["seller_id"])
		,SUM(["price"])
			OVER (PARTITION BY ["seller_id"]) 
			AS ["seller_total_revenue"]
	FROM [Brazilian e-Commerce].[dbo].[order_items_clean]
)

SELECT RANK() OVER(ORDER BY ["seller_total_revenue"] DESC) AS ["rank"]
	  ,["seller_id"]
	  ,["seller_total_revenue"]
FROM seller_revenues;



   
-- list of Cities where delieveries are delayed most frequently
WITH customer_delayed_orders AS
(
	SELECT a.["customer_id"]
		  ,b.["customer_zip_code_prefix"]
	FROM [Brazilian e-Commerce].[dbo].[orders_clean] AS a
	RIGHT JOIN [Brazilian e-Commerce].[dbo].[customers_clean] AS b
	ON a.["customer_id"] = b.["customer_id"]
	WHERE ["order_estimated_delivery_date"] < ["order_delivered_customer_date"]
)

SELECT RANK() OVER(ORDER BY COUNT(b.["geolocation_city"]) DESC) AS ["rank"]
	  ,b.["geolocation_city"]
	  ,COUNT(b.["geolocation_city"]) AS ["n_delayed_orders"]
FROM customer_delayed_orders AS a
INNER JOIN [Brazilian e-Commerce].[dbo].geolocations_clean AS b
ON a.["customer_zip_code_prefix"] = b.["geolocation_zip_code_prefix"]
WHERE b.["geolocation_city"] NOT LIKE '%[^a-z]%'
GROUP BY b.["geolocation_city"];




-- list of average Freight values in each City per State (execution time - 1m)
WITH customer_freight AS 
(
	SELECT DISTINCT a.["customer_id"]
		,b.["freight_value"]
		,c.["customer_zip_code_prefix"]
	FROM [Brazilian e-Commerce].[dbo].[orders_clean] AS a
	INNER JOIN [Brazilian e-Commerce].[dbo].[order_items_clean] AS b
	ON a.["order_id"] = b.["order_id"]
	INNER JOIN [Brazilian e-Commerce].[dbo].[customers_clean] AS c
	ON a.["customer_id"] = c.["customer_id"]
)

SELECT DISTINCT b.["geolocation_state"]
	  ,b.["geolocation_city"]
	  ,AVG(a.["freight_value"]) OVER (PARTITION BY b.["geolocation_city"]) AS ["average_freight_city"]
FROM customer_freight AS a
INNER JOIN [Brazilian e-Commerce].[dbo].[geolocations_clean] AS b
ON a.["customer_zip_code_prefix"] = b.["geolocation_zip_code_prefix"]
ORDER BY b.["geolocation_state"], ["average_freight_city"] DESC;



   
-- list of Product Categories which were bought with Boleto payment
SELECT a.["product_category_name"]
	  ,COUNT(c.["payment_type"]) AS ["n_boleto_payments"]
FROM [Brazilian e-Commerce].[dbo].[products_clean] AS a
INNER JOIN [Brazilian e-Commerce].[dbo].[order_items_clean] AS b
ON a.["product_id"] = b.["product_id"]
INNER JOIN [Brazilian e-Commerce].[dbo].[order_payments_clean] AS c
ON b.["order_id"] = c.["order_id"]
WHERE c.["payment_type"] = 'boleto'
GROUP BY ["product_category_name"]
ORDER BY COUNT(c.["payment_type"]) DESC;




-- list of Product Categories which were bought with Voucher payment
SELECT a.["product_category_name"]
	  ,COUNT(c.["payment_type"]) AS ["n_voucher_payments"]
FROM [Brazilian e-Commerce].[dbo].[products_clean] AS a
INNER JOIN [Brazilian e-Commerce].[dbo].[order_items_clean] AS b
ON a.["product_id"] = b.["product_id"]
INNER JOIN [Brazilian e-Commerce].[dbo].[order_payments_clean] AS c
ON b.["order_id"] = c.["order_id"]
WHERE c.["payment_type"] = 'voucher'
GROUP BY ["product_category_name"]
ORDER BY COUNT(c.["payment_type"]) DESC;