
USE SupplyChain

-- Let's get an overview of the dataset 

-- Customers table
SELECT * FROM dim_customers;       

-- Date table
SELECT * FROM dim_date;

-- Products table
SELECT * FROM dim_products;

-- Target_orders table 
SELECT * FROM dim_targets_orders;

-- Order_lines table 
SELECT * FROM fact_order_lines;

-- Ordes Aggregated table 
SELECT * FROM fact_orders_aggregate;

-- To get total customers present 
SELECT COUNT(distinct customer_id) AS Total_Cusotmers 
FROM dim_customers;	-- Total Customers are 35.


-- To get total products with their categories available 
SELECT COUNT(DISTINCT product_id) AS Total_products 
FROM dim_products;  -- Total products are 18.


-- To get total cities they are currently operating in
SELECT COUNT(DISTINCT city) AS Total_cities 
FROM dim_customers; -- Atliq currently operating in 3 cities.


-- What are total number of products and total number of customers?
SELECT 
	COUNT(DISTINCT customer_id) AS Total_Customers, 
	COUNT(DISTINCT product_id) AS Total_Products 
FROM fact_order_lines;


-- What is the average order quantity by customers?
SELECT 
	customer_id, 
	AVG(order_qty) AS Avg_order_qty 
FROM fact_order_lines 
GROUP BY customer_id;


-- What is the average delivery time for orders by city?
SELECT 
    dc.city, 
    AVG(DATEDIFF(DAY, fo.actual_delivery_date, fo.agreed_delivery_date)) AS Avg_delivery_date
FROM fact_order_lines AS fo
	INNER JOIN dim_customers AS dc
		ON fo.customer_id = dc.customer_id
GROUP BY dc.city;


-- What is the average delivery time for on-time(OT) orders by city?
SELECT 
	city, 
	AVG(DATEDIFF(DAY, actual_delivery_date, agreed_delivery_date)) AS Avg_delivery_date
FROM fact_order_lines 
	INNER JOIN dim_customers 
		ON fact_order_lines.customer_id = dim_customers.customer_id
	INNER JOIN fact_orders_aggregate 
		ON fact_order_lines.order_id = fact_orders_aggregate.order_id
WHERE fact_orders_aggregate.on_time = 1
GROUP BY city;


--What are total orders, total orders on-time(OT), total order infull(IF), and total orders(ONIF) by city?    
WITH city_order_data AS (
    SELECT 
        dim_customers.city,
        fact_orders_aggregate.order_id,
        fact_orders_aggregate.on_time,
        fact_orders_aggregate.in_full,
        fact_orders_aggregate.otif
    FROM fact_orders_aggregate 
		INNER JOIN dim_customers 
			ON fact_orders_aggregate.customer_id = dim_customers.customer_id
),
all_order_data AS (
    SELECT 	
        city,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(CASE WHEN on_time = 1 THEN 1 ELSE 0 END) AS total_on_time,
        SUM(CASE WHEN in_full = 1 THEN 1 ELSE 0 END) AS total_in_full,
        SUM(CASE WHEN otif = 1 THEN 1 ELSE 0 END) AS total_otif
    FROM city_order_data
    GROUP BY city
)

SELECT 
    all_order_data.city,
    all_order_data.total_orders,
    all_order_data.total_on_time,
    all_order_data.total_in_full,
    all_order_data.total_otif,
    (SELECT COUNT(DISTINCT order_id) FROM fact_orders_aggregate) AS overall_total_order
FROM all_order_data;

              

--Provide insight regarding the share distribution of previous question metrics by customers. 
WITH customer_metrics AS (
	SELECT 
		c.customer_name,
        SUM(ol.order_qty) AS total_orders,
        SUM(CASE WHEN o.on_time = 1 THEN ol.order_qty ELSE 0 END) AS total_orders_on_time,
        SUM(CASE WHEN o.in_full = 1 THEN ol.order_qty ELSE 0 END) AS total_orders_in_full,
        SUM(CASE WHEN o.otif = 1 THEN ol.order_qty ELSE 0 END) AS total_orders_otif
     FROM fact_order_lines AS ol
	 INNER JOIN dim_customers AS c  ON ol.customer_id = c.customer_id 
     INNER JOIN fact_orders_aggregate AS o ON ol.order_id = o.order_id 
     GROUP BY c.customer_name
) 
 
SELECT 
	customer_name,
    total_orders,
    total_orders_on_time,
    total_orders_in_full,
    total_orders_otif,
    ROUND((total_orders_on_time*100.0)/total_orders, 2) AS 'on_time_%',
    ROUND((total_orders_in_full*100.0)/total_orders, 2) AS 'in_full_%',
    ROUND((total_orders_otif*100.0)/total_orders, 2) AS 'otif_%'
FROM customer_metrics 
ORDER BY total_orders DESC;
   
   

--Calcualte % variance between actual and target from 'on-time(OT)', 'infull(IF)' and 'ON_Time and In Full(OTIF)' metrics by City.  
 WITH actual AS (
	SELECT 
		dim_customers.city,
        SUM(CASE WHEN fact_orders_aggregate.on_time = 1 THEN 1 ELSE 0 END)* 100.0 / COUNT(DISTINCT fact_orders_aggregate.order_id)  AS actual_ot,
        SUM(CASE WHEN fact_orders_aggregate.in_full = 1 THEN 1 ELSE 0 END)* 100.0 / COUNT(DISTINCT fact_orders_aggregate.order_id)  AS actual_if,
        SUM(CASE WHEN fact_orders_aggregate.otif = 1 THEN 1 ELSE 0 END) * 100.0/ COUNT(DISTINCT fact_orders_aggregate.order_id) AS actual_otif
      FROM fact_orders_aggregate
      JOIN dim_customers ON fact_orders_aggregate.customer_id = dim_customers.customer_id 
      GROUP BY dim_customers.city
),
 target AS (
	SELECT 
		dim_customers.city,
        SUM(dim_targets_orders.ontime_target_pct) / COUNT(DISTINCT dim_targets_orders.customer_id) AS target_ot,
        SUM(dim_targets_orders.infull_target_pct)/ COUNT(DISTINCT dim_targets_orders.customer_id) AS target_if,
        SUM(dim_targets_orders.otif_target_pct) / COUNT(DISTINCT dim_targets_orders.customer_id) AS target_otif
	FROM dim_targets_orders
	JOIN dim_customers ON dim_targets_orders.customer_id = dim_customers.customer_id
	GROUP BY dim_customers.city
)
SELECT 
	actual.city,
	ROUND((actual.actual_ot - target.target_ot) * 100.0 / target.target_ot, 3) AS ot_varience,
	ROUND((actual.actual_if - target.target_if) * 100.0 / target.target_if, 3) AS if_varience,
	ROUND((actual.actual_otif - target.target_otif) * 100.0 / target.target_otif, 3) AS otif_varience
FROM actual
JOIN target ON actual.city = target.city; 

	  
--Top/bottom 5 customers by total_quantity_orderd, "in full" quantity  ordered and "on time and infull" quantity ordered.
            
  -- Top 5 Cusotmers by Total_quantity_ordered: 
  SELECT Top 5
	dim_customers.customer_name,
    SUM(fact_order_lines.order_qty) AS Total_order_qty
 FROM dim_customers 
 INNER JOIN fact_order_lines ON dim_customers.customer_id = fact_order_lines.customer_id 
 GROUP BY dim_customers.customer_name
 ORDER BY Total_order_qty DESC;
 


 -- Top 5 Cusotmers by in_full_qty_ordered
 SELECT Top 5
	dim_customers.customer_name,
    SUM(fact_order_lines.delivery_qty) AS Full_qty_ordered
FROM dim_customers
INNER JOIN fact_order_lines ON dim_customers.customer_id = fact_order_lines.customer_id
GROUP BY dim_customers.customer_name
ORDER BY Full_qty_ordered DESC;        



-- Top 5 Customers by "OTIF" ordered Quantity.
WITH otif_ordered_qty AS (
	SELECT 
		fact_order_lines.customer_id,
        SUM(CASE WHEN fact_orders_aggregate.otif = 1 THEN fact_order_lines.delivery_qty ELSE 0 END) AS OTIF_Qty
    FROM fact_order_lines 
    INNER JOIN fact_orders_aggregate ON fact_order_lines.order_id = fact_orders_aggregate.order_id 
    GROUP BY fact_order_lines.customer_id
)
SELECT Top 5
	dim_customers.customer_name,
    otif_ordered_qty.OTIF_Qty
FROM otif_ordered_qty 
INNER JOIN dim_customers ON otif_ordered_qty.customer_id = dim_customers.customer_id
ORDER BY OTIF_Qty DESC;
    
 

--Provide actual OT%, IF%, AND OTIF% by Cusotmers
WITH actual AS (
	SELECT 
		dim_customers.customer_name,
        SUM(CASE WHEN fact_orders_aggregate.on_time = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT fact_orders_aggregate.order_id) AS  actual_ot,
        SUM(CASE WHEN fact_orders_aggregate.in_full = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT fact_orders_aggregate.order_id) AS actual_if,
        SUM(CASE WHEN fact_orders_aggregate.otif = 1 THEN 1 ELSE 0 END) * 100.0/ COUNT(DISTINCT fact_orders_aggregate.order_id) AS actual_otif
	FROM fact_orders_aggregate
    JOIN dim_customers ON fact_orders_aggregate.customer_id = dim_customers.customer_id
    GROUP BY dim_customers.customer_name 
)
SELECT 
	actual.customer_name,
    ROUND(actual.actual_ot, 2) AS ot_pct,
    ROUND(actual.actual_if, 2) AS if_pct,
    ROUND(actual.actual_otif,2) AS otif_pct
FROM actual
ORDER BY actual.customer_name;    
 
 

--Categorize the orders by Product category for each customer in descending Order   
 WITH customer_orders AS (
	SELECT 
		dim_customers.customer_name,
        dim_products.category,
        COUNT(DISTINCT fact_order_lines.order_id) AS Total_Orders
    FROM fact_order_lines
    JOIN dim_customers ON fact_order_lines.customer_id = dim_customers.customer_id
    JOIN dim_products ON fact_order_lines.product_id = dim_products.product_id
    GROUP BY dim_customers.customer_name, dim_products.category
)
SELECT 
	customer_orders.customer_name,
	SUM(CASE WHEN customer_orders.category = 'dairy' THEN customer_orders.Total_Orders ELSE 0 END) AS 'Dairy',
	SUM(CASE WHEN customer_orders.category = 'food' THEN customer_orders.Total_Orders ELSE 0 END) AS 'Food',
	SUM(CASE WHEN customer_orders.category = 'beverages' THEN customer_orders.Total_Orders ELSE 0 END) AS 'Beverages',
	SUM(customer_orders.Total_Orders) AS "Total_Orders"
FROM customer_orders
GROUP BY customer_orders.customer_name
ORDER BY "Total_Orders" DESC;
            
 

--Categorize the orders by Product category for each city in descending order       
WITH customer_orders AS (
	SELECT 
		dim_customers.city,
		dim_products.category,
		COUNT(DISTINCT fact_order_lines.order_id) AS total_orders
   FROM fact_order_lines 
   JOIN dim_customers ON fact_order_lines.customer_id = dim_customers.customer_id
   JOIN dim_products ON fact_order_lines.product_id = dim_products.product_id
   GROUP BY dim_customers.city, dim_products.category
)
SELECT 
	customer_orders.city,
	SUM(CASE WHEN customer_orders.category = 'dairy' THEN customer_orders.total_orders ELSE 0 END) AS 'Dairy',
    SUM(CASE WHEN customer_orders.category = 'food' THEN customer_orders.total_orders ELSE 0 END) AS 'Food',
    SUM(CASE WHEN customer_orders.category = 'beverages' THEN customer_orders.total_orders ELSE 0 END) AS 'Beverages',
    SUM(customer_orders.total_orders) AS "Total_Orders"
FROM customer_orders
GROUP BY customer_orders.city 
ORDER BY "Total_Orders" DESC;
       

       
--Find the top 3 Customers from each city based on thier total orders and what is their OTIF%.           
WITH customer_orders AS (
	SELECT 
	dim_customers.city,
	dim_customers.customer_name,
    COUNT(fact_orders_aggregate.order_id) AS Total_orders,
    CONCAT((ROUND((COUNT(CASE WHEN otif = 1 THEN (otif) END) * 100.0 / COUNT(otif)),2)), '%') AS "OTIF%",
    ROW_NUMBER() OVER(PARTITION BY dim_customers.city ORDER BY COUNT(fact_orders_aggregate.order_id) DESC) AS Ranking
FROM fact_orders_aggregate
JOIN dim_customers ON fact_orders_aggregate.customer_id = dim_customers.customer_id
GROUP BY dim_customers.city, dim_customers.customer_name

)

SELECT * FROM customer_orders WHERE Ranking IN (1,2,3);
            


--Which product was most and least ordered bt each customer?
WITH customer_products AS (
    SELECT 
        dim_customers.customer_name,
        dim_products.product_name,
        COUNT(fact_order_lines.product_id) AS Product_count
    FROM fact_order_lines 
    JOIN dim_customers ON fact_order_lines.customer_id = dim_customers.customer_id
    JOIN dim_products ON fact_order_lines.product_id = dim_products.product_id
    GROUP BY dim_customers.customer_name, dim_products.product_name
),
customer_max_min_counts AS (
    SELECT
        cp.customer_name,
        MAX(cp.Product_count) AS max_product_count,
        MIN(cp.Product_count) AS min_product_count
    FROM customer_products cp
    GROUP BY cp.customer_name
)
SELECT
    cp.customer_name,
    MAX(CASE WHEN cp.Product_count = cmc.max_product_count THEN cp.product_name END) AS most_ordered_product,
    MAX(CASE WHEN cp.Product_count = cmc.min_product_count THEN cp.product_name END) AS least_ordered_product
FROM customer_products cp
JOIN customer_max_min_counts cmc ON cp.customer_name = cmc.customer_name
GROUP BY cp.customer_name, cmc.max_product_count, cmc.min_product_count
ORDER BY cp.customer_name;
             
 


--Try to distribute the total product orders by their categories and their % share, also show each city's top and worst selling products.
WITH city_categories AS 
(
    SELECT 
        dim_customers.city,
        dim_products.product_name,
        dim_products.category,
        COUNT(fact_order_lines.order_id) AS total_orders
    FROM fact_order_lines 
    JOIN dim_customers ON fact_order_lines.customer_id = dim_customers.customer_id
    JOIN dim_products ON fact_order_lines.product_id = dim_products.product_id
    GROUP BY dim_customers.city, dim_products.product_name, dim_products.category 
),
categories_totals AS 
(
    SELECT 
        city,
        SUM(CASE WHEN category = 'dairy' THEN total_orders ELSE 0 END) AS dairy_total,
        SUM(CASE WHEN category = 'food' THEN total_orders ELSE 0 END) AS food_total,
        SUM(CASE WHEN category = 'beverages' THEN total_orders ELSE 0 END) AS beverages_total,
        SUM(total_orders) AS total_orders 
    FROM city_categories
    GROUP BY city
)
SELECT 
    cc.city,
    cc.category,
    SUM(cc.total_orders) AS total_orders,
    CONCAT(ROUND((SUM(cc.total_orders) * 100.0 / ct.total_orders), 2), '%') AS percent_share,
    (SELECT TOP 1 cc2.product_name FROM city_categories cc2 WHERE cc2.city = cc.city ORDER BY cc2.total_orders DESC) AS top_selling_products,
    (SELECT TOP 1 cc2.product_name FROM city_categories cc2 WHERE cc2.city = cc.city ORDER BY cc2.total_orders ASC) AS least_selling_products
FROM city_categories cc
JOIN categories_totals ct ON cc.city = ct.city
GROUP BY cc.city, cc.category, ct.total_orders
ORDER BY cc.city, percent_share DESC;



--Investigate how the trend of on-time delivery varies over different months.
SELECT 
    MONTH(order_placement_date) AS month,
    COUNT(order_id) AS Total_orders,
    SUM(CASE WHEN fact_order_lines.On_Time = 1 THEN 1 ELSE 0 END) AS on_time_orders,
    (SUM(CASE WHEN fact_order_lines.On_Time = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(fact_order_lines.order_id)) AS on_time_pct 
FROM fact_order_lines
GROUP BY MONTH(order_placement_date)
ORDER BY MONTH(order_placement_date);
         


--Analyze the pattern of in-full deliveries across the course of months.
SELECT 
	MONTH(order_placement_date) AS Month,
	COUNT(order_id) AS Total_orders,
	SUM(CASE WHEN fact_order_lines.In_Full = 1 THEN 1 ELSE 0 END ) AS in_full_orders,
	(SUM(CASE WHEN fact_order_lines.In_Full = 1 THEN 1 ELSE 0 END)  * 100.0/ COUNT(fact_order_lines.order_id)) AS in_full_pct
FROM fact_order_lines
GROUP BY MONTH(order_placement_date)
ORDER BY MONTH(order_placement_date);	
       


--Explore the trend of deliveries that are both on-time and in-full across different months. 
SELECT 
	MONTH(order_placement_date) AS Month,
	COUNT(order_id) AS Total_Orders,
	SUM(CASE WHEN fact_order_lines.On_Time_In_Full= 1 THEN 1 ELSE 0 END) AS otif_orders,
	SUM(CASE WHEN fact_order_lines.On_Time_In_Full = 1 THEN 1 ELSE 0 END)* 100.0/ COUNT(fact_order_lines.order_id)  AS otif_orders_pct
FROM fact_order_lines
GROUP BY MONTH(order_placement_date)
ORDER BY MONTH(order_placement_date);
        
 

--Investigate the distribution of customer orders based on the days of the week. 
SELECT 
    DATEPART(WEEKDAY, order_placement_date) AS Day_no,
    CASE DATEPART(WEEKDAY, order_placement_date)
		WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
     END AS Day_Name,
	COUNT(order_id) AS Total_orders
FROM fact_order_lines
GROUP BY DATEPART(WEEKDAY, order_placement_date)
ORDER BY Total_orders DESC;

   
--Determine the average duration in days from order placement to delivery for all orders, categorized by city.
SELECT 
	c.city,
    AVG(DATEDIFF(DAY, ol.actual_delivery_date, ol.order_placement_date)) AS Average_days
FROM fact_order_lines ol
INNER JOIN dim_customers c ON ol.customer_id = c.customer_id
GROUP BY c.city
ORDER BY Average_days DESC;


--Calculate the average lead time (time between order placement and delivery) for each individual customer.
SELECT 
	c.customer_name,
    AVG(DATEDIFF(HOUR, ol.actual_delivery_date, ol.order_placement_date)) AS Average_Time
FROM fact_order_lines ol
JOIN dim_customers c ON ol.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY Average_Time;
