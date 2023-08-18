-- Creating a table 'Automobile'
CREATE TABLE Automobile (
	name varchar(64),
	mpg float,
	cylinders int,
	displacement float,
	horsepower int,
	weight int,
	acceleration float,
	model_year int,
	origin varchar(16)	
);

-- Copying data from a csv table
COPY Automobile FROM 'C:\projects\Automobile.csv' DELIMITER ',' CSV HEADER;

-- Checking and viewing all data from the table
SELECT * FROM Automobile;

-- Selecting max model year to make sure that only the 20th century is listed in the values
SELECT MAX(model_year) 
FROM Automobile;

-- Cheking min model_year
SELECT MIN(model_year) 
FROM Automobile;

-- Replacement the values of model_year column
UPDATE Automobile
SET model_year = 1900 + model_year;

-- Checking
SELECT * FROM Automobile;

-- Convert first letters to uppercase in a name column
UPDATE Automobile
SET name = INITCAP(name);

-- Checking
SELECT * FROM Automobile;

-- Number of car models from different regions
SELECT count(name) as count, origin
FROM Automobile
GROUP BY origin

-- Changing case in a origin column
UPDATE Automobile
SET origin = 
	CASE
		WHEN origin = 'usa' THEN UPPER(origin)
		ELSE INITCAP(origin)
	END;

-- Checking
SELECT * FROM Automobile;

-- Number of null values by columns
SELECT COUNT(*) AS NullCount
FROM Automobile
WHERE name IS NULL; -- 0

SELECT COUNT(*) AS NullCount
FROM Automobile
WHERE mpg IS NULL; -- 0

SELECT COUNT(*) AS NullCount
FROM Automobile
WHERE cylinders IS NULL; -- 0

SELECT COUNT(*) AS NullCount
FROM Automobile
WHERE displacement IS NULL; -- 0

SELECT COUNT(*) AS NullCount
FROM Automobile
WHERE horsepower IS NULL; -- 6

SELECT COUNT(*) AS NullCount
FROM Automobile
WHERE weight IS NULL; -- 0

SELECT COUNT(*) AS NullCount
FROM Automobile
WHERE acceleration IS NULL; -- 0

SELECT COUNT(*) AS NullCount
FROM Automobile
WHERE model_year IS NULL; -- 0

SELECT COUNT(*) AS NullCount
FROM Automobile
WHERE origin IS NULL; -- 0

-- Update null values to zero values
UPDATE Automobile
SET horsepower = COALESCE(horsepower, 0);

-- Cheking
SELECT *
FROM Automobile
WHERE horsepower = 0;


-- The average value (average indicator) for various characteristics of cars by year of production
SELECT model_year, AVG(mpg) AS AvgMPG, AVG(horsepower) AS AvgHorsepower
FROM Automobile
GROUP BY model_year
ORDER BY model_year;

-- The most powerful cars
SELECT name, horsepower
FROM Automobile
ORDER BY horsepower DESC
LIMIT 10;

-- The lightest and heaviest cars
SELECT *
FROM Automobile
ORDER BY weight
LIMIT 5;

SELECT *
FROM Automobile
ORDER BY weight DESC
LIMIT 5;

-- Analysis of correlations between different values
SELECT
    CORR(weight, mpg) AS weight_mpg_corr,
    CORR(acceleration, cylinders) AS acceleration_cylinders_corr,
	CORR(displacement, horsepower) AS displacement_horsepower_corr
FROM Automobile;

-- Number of models by year
SELECT
    model_year,
    COUNT(*) AS count
FROM Automobile
GROUP BY model_year
ORDER BY model_year;

-- Сomparison of the most powerful cars by country
SELECT *
FROM
	(SELECT *,
		RANK() OVER(PARTITION BY origin ORDER by horsepower DESC) as rank
	FROM Automobile) as subquery
WHERE rank = 1
ORDER BY horsepower DESC;

-- Automobiles by fuel efficiency
SELECT *
FROM Automobile
ORDER BY mpg
LIMIT 5;

SELECT *
FROM Automobile
ORDER BY mpg DESC
LIMIT 5;

-- Average weight of cars by year
SELECT model_year, weight_avg
FROM
	(SELECT *, 
		ROUND(AVG(weight) OVER(PARTITION BY model_year)) as weight_avg
	FROM Automobile) as subquery
GROUP BY model_year, weight_avg
ORDER BY model_year;

-- Car models produced between 1975 and 1980
SELECT * 
FROM Automobile
WHERE model_year BETWEEN 1975 AND 1980
ORDER BY model_year;

-- Car models produced between in 1970, 1975 and 1980
SELECT * 
FROM Automobile
WHERE model_year IN (1970, 1975, 1980)
ORDER BY model_year;

-- All car models starting with D letter
SELECT * 
FROM Automobile
WHERE name LIKE 'D%'

-- All car models starting with A or B or C or D letters
SELECT * 
FROM Automobile
WHERE name LIKE 'A%' OR name LIKE 'B%' OR name LIKE 'C%' OR name LIKE 'D%';

-- All car models starting with C and ending with S letters
SELECT * 
FROM Automobile
WHERE name LIKE 'C%S'