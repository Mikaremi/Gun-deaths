CREATE DATABASE guncrime;

-- DATA PREPARATION --
select * from dbo.gun_deaths;

-- check for number of rows
select count(*) AS NO_OF_ROWS from dbo.gun_deaths;

-- check for number of columns
select count(*) AS NO_OF_COLUMNS
from sys.all_columns
where object_id = OBJECT_ID('guncrime.dbo.gun_deaths');

-- adding month column and name
alter table dbo.gun_deaths
add month_name varchar(20);

UPDATE gun_deaths
SET month_name = 
	CASE
		WHEN month = 1 THEN 'January'
		WHEN month = 2 THEN 'February'
		WHEN month = 3 THEN 'March'
		WHEN month = 4 THEN 'April'
		WHEN month = 5 THEN 'May'
		WHEN month = 6 THEN 'June'
		WHEN month = 7 THEN 'July'
		WHEN month = 8 THEN 'August'
		WHEN month = 9 THEN 'September'
		WHEN month = 10 THEN 'October'
		WHEN month = 11 THEN 'November'
		WHEN month = 12 THEN 'December'
	END;

-- DATA ANALYSIS --
-- Between the years presented, which year has the highest number of deaths?
SELECT year, COUNT(intent) as Intent_Count
FROM dbo.gun_deaths
GROUP BY year
ORDER BY Intent_Count DESC;

--what is the rate of gundeaths among genders?
SELECT 
	sex, 
	COUNT(*) as gender_count,
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) from gun_deaths),0) AS percentage
from 
	gun_deaths
GROUP BY 
	sex;

-- Does education level have an impact on intent
SELECT education, intent, COUNT(*) as count
FROM gun_deaths
WHERE education IS NOT NULL
AND intent IS NOT NULL
GROUP BY education, intent
ORDER BY count DESC;

-- update the dataset by filling the null values
-- eduction
UPDATE gun_deaths
SET education = CASE
	WHEN education = '' THEN 'Unknown'
	ELSE education
END;

-- intent
UPDATE gun_deaths
SET intent = CASE
	WHEN intent = '' THEN 'Uknown'
	ELSE intent
END;

-- What is the highest intention among deaths?
SELECT intent, COUNT(intent) AS number_of_deaths
FROM gun_deaths
GROUP BY intent
ORDER BY number_of_deaths DESC;

-- Which age group has the most deaths, and what is the intent?
SELECT
	CASE
		WHEN age BETWEEN 0 AND 12 THEN '0-12'
		WHEN age BETWEEN 13 AND 19 THEN '13-19'
		WHEN age BETWEEN 20 AND 29 THEN '20-29'
		WHEN age BETWEEN 30 AND 39 THEN '30-39'
		WHEN age BETWEEN 40 AND 49 THEN '40-49'
		WHEN age BETWEEN 50 AND 59 THEN '50-59'
		ELSE '60+'
	END AS age_group,
	intent,
	COUNT(*) AS death_count
FROM gun_deaths
WHERE age IS NOT NULL
GROUP BY CASE
		WHEN age BETWEEN 0 AND 12 THEN '0-12'
		WHEN age BETWEEN 13 AND 19 THEN '13-19'
		WHEN age BETWEEN 20 AND 29 THEN '20-29'
		WHEN age BETWEEN 30 AND 39 THEN '30-39'
		WHEN age BETWEEN 40 AND 49 THEN '40-49'
		WHEN age BETWEEN 50 AND 59 THEN '50-59'
		ELSE '60+'
	END,
	intent
ORDER BY death_count DESC;

-- What is the highest place of occurence?
UPDATE gun_deaths
SET place = CASE
	WHEN place = '' THEN 'Unkown'
	ELSE place
END;

SELECT place, COUNT(intent) AS NO_OF_DEATHS
FROM gun_deaths
GROUP BY place
ORDER BY NO_OF_DEATHS DESC;

-- How many police deaths were involved?
SELECT COUNT(*) AS Total_deaths,
SUM(CASE WHEN police >= 1 THEN 1 ELSE 0 END) AS police_deaths
FROM gun_deaths;


SELECT COUNT(intent) AS NO_OF_DEATHS
FROM gun_deaths