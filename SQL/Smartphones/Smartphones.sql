-- Creating table
CREATE TABLE smartphones (
	brand_name varchar(16),
	model varchar(64),
	price int,
	rating int,
	has_5g boolean,
	has_nfc boolean,
	has_ir_blaster boolean,
	processor_brand varchar(16),
	num_cores int,
	processor_speed numeric,
	battery_capacity int,
	fast_charging_available int,
	fast_charging int,
	ram_capacity int,
	internal_memory int,
	screen_size numeric,
	refresh_rate int,
	resolution varchar(16),
	num_rear_cameras int,
	num_front_cameras int,
	os varchar(8),
	primary_camera_rear int,
	primary_camera_front int,
	extended_memory_available int	
);

-- Copying data from csv file
COPY smartphones FROM 'C:\projects\smartphone_cleaned_v5.csv' DELIMITER ';' CSV HEADER;

-- Select all data
SELECT * FROM smartphones;

-- Number of rows
SELECT count(*) FROM smartphones; 

-- Top 10 most expensive smartphones
SELECT model, price
FROM smartphones
ORDER BY price DESC
LIMIT 10;

-- Top 10 cheapest smartphones
SELECT model, price
FROM smartphones
ORDER BY price
LIMIT 10;

-- Top 10 worst smartphones by rating
SELECT model, rating
FROM smartphones
WHERE rating IS NOT NULL
ORDER BY rating
LIMIT 10;

-- Top 10 best smartphones by rating
SELECT model, rating
FROM smartphones
WHERE rating IS NOT NULL
ORDER BY rating DESC
LIMIT 10;

-- The number of smartphones by brand
SELECT brand_name, count(brand_name) as count_brand
FROM smartphones
GROUP BY brand_name
ORDER BY count_brand DESC;

-- The number of smartphones with or without 5G
SELECT has_5g, count(has_5g) as count_5g
FROM smartphones
GROUP BY has_5g
ORDER BY count_5g DESC;

-- The number of smartphones with or without NFC
SELECT has_nfc, count(has_nfc) as count_nfc
FROM smartphones
GROUP BY has_nfc
ORDER BY count_nfc DESC;

-- The number of smartphones with or without IR blaster
SELECT has_ir_blaster, count(has_ir_blaster) as count_ir
FROM smartphones
GROUP BY has_ir_blaster
ORDER BY count_ir DESC;

-- The number of smartphones by processor brand
SELECT processor_brand, count(processor_brand) as count_processor
FROM smartphones
WHERE processor_brand IS NOT NULL
GROUP BY processor_brand
ORDER BY count_processor DESC;

-- The number of smartphones by num cores
SELECT num_cores, count(num_cores) as count_cores
FROM smartphones
WHERE num_cores IS NOT NULL
GROUP BY num_cores
ORDER BY count_cores DESC;

-- The number of smartphones by resolution
SELECT resolution, count(resolution) as count_resolution
FROM smartphones
GROUP BY resolution
ORDER BY count_resolution DESC;

-- The number of smartphones by operation system
SELECT os, count(os) as count_os
FROM smartphones
WHERE os IS NOT NULL
GROUP BY os
ORDER BY count_os DESC;

-- The best smartphones with big display size
SELECT model, screen_size, rating
FROM smartphones
WHERE rating IS NOT NULL
ORDER BY screen_size DESC, rating DESC
LIMIT 5;

-- The best android smartphones
SELECT model, rating
FROM smartphones
WHERE rating IS NOT NULL AND os = 'android'
ORDER BY rating DESC
LIMIT 5;

-- The best ios smartphones
SELECT model, rating
FROM smartphones
WHERE rating IS NOT NULL AND os = 'ios'
ORDER BY rating DESC
LIMIT 5;

-- Top 5 most expensive smartphones on ios and android systems
SELECT * 
FROM
	(SELECT model, price, os,
		ROW_NUMBER() OVER(PARTITION BY os ORDER BY price DESC) as r_n
	FROM smartphones
	WHERE os = 'ios' OR os = 'android') as subquary
WHERE r_n BETWEEN 1 AND 5;

-- Or another way
SELECT * 
FROM ((SELECT model, price, os
	FROM smartphones
	WHERE os = 'android'
	ORDER BY price DESC 
	LIMIT 5)
	UNION
	(SELECT model, price, os
	FROM smartphones
	WHERE os = 'ios'
	ORDER BY price DESC 
	LIMIT 5)) as subquary
ORDER BY os, price DESC;

-- Smartphone's average price by brand
SELECT brand_name, ROUND(AVG(price)) as avg_price
FROM smartphones
GROUP BY brand_name
ORDER BY avg_price DESC;

-- Smartphone's max price by brand
SELECT brand_name, MAX(price) as max_price
FROM smartphones
GROUP BY brand_name
ORDER BY max_price DESC;

-- Top 10 smartphones by battery capacity
SELECT model, battery_capacity
FROM smartphones
WHERE battery_capacity IS NOT NULL
ORDER BY battery_capacity DESC
LIMIT 10
