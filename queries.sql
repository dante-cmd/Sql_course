CREATE DATABASE IF NOT EXISTS FLIGHT;
USE FLIGHT;

-- THE SAFE IS DISATIVATED
-- THIS ALLOW US THAT WE CAN MAKE SOME CHANGES
SET SQL_SAFE_UPDATES = 0;

-- CREATE A TABLE
CREATE TABLE NY_FLIGHTS(
flightid int,
col_year int,
col_month int,
col_day int,
dep_time int,
sched_dep_time int,
dep_delay int,
arr_time int,
sched_arr_time int,
arr_delay int,
carrier char(2),
flight char(4),
tailnum char(6),
origin char(3),
dest char(3),
air_time int,
distance int,
col_hour int, 
col_minute int, 
time_hour timestamp);


-- INSERT ROW A DEFAULT ORDER
INSERT INTO ny_flights VALUES(1, 2013, 1, 1, 517, 515, 2, 830, 
819, 11, "UA", 1545, "N14228", "EWR", "IAH", 227, 1400, 5, 15,
'2013-01-01 05:00:00');

SELECT * FROM NY_FLIGHTS;

-- INSERT A SPECIFIC ORDER
INSERT INTO ny_flights(col_day ,col_year) VALUES
(3, 2010);

-- INSERT ROW A DEFAULT ORDER BY INCOMPLETE
INSERT INTO ny_flights VALUES(2, 2013, 1, 1, null, null, 4,
850, 830, 20, "UA", 1714, null, "LGA", "IAH", 227, null, 5,
29, '2013-01-01 05:00:00');

-- DROP A TABLE
DROP TABLE ny_flights;

-- TO SHOW INFORMATION OF SOME ATTRIBUTES
SHOW TABLES FROM FLIGHT;
USE FLIGHT;
SHOW COLUMNS FROM NY_FLIGHTS;

-- CREATE A TABLE WITH PRIMARY KEYS
CREATE TABLE NY_FLIGHTS(
flightid int primary key,
col_year int,
col_month int,
col_day int,
dep_time int,
sched_dep_time int,
dep_delay int,
arr_time int,
sched_arr_time int,
arr_delay int,
carrier char(2),
flight char(4),
tailnum char(6),
origin char(3),
dest char(3),
air_time int,
distance int,
col_hour int, 
col_minute int, 
time_hour timestamp);


CREATE DATABASE BOOK;
USE BOOK;

-- TABLE CREATED WITHOUT PRYMARY KEY
CREATE TABLE BOOKS(
book_id INT,
title VARCHAR(100) NOT NULL,
author VARCHAR(100),
publisher VARCHAR(100),
num_pages INT);

-- WE CAN MODIFY A TABLE AND USING AN ATTRIBUTE LIKE KEY
ALTER TABLE BOOKS ADD PRIMARY KEY AUTO_INCREMENT (book_id);

-- OR WE CAN CREATE KEY WHEN WE CREATE THE TABLE
DROP TABLE BOOKS; -- FIRST DROP THE TABLE CREATED ALREADY
-- NOW WE CREATE AGAIN
CREATE TABLE BOOKS (
book_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, -- <
title VARCHAR(100) NOT NULL,
author VARCHAR(100),
publisher VARCHAR(100),
num_pages INT);


--------------------------------------------------------
-------------------- ONE-TO-ONE -----------------------
--------------------------------------------------------

CREATE DATABASE COMPLEX;
USE COMPLEX;

-- Create a table  PEOPLE 
CREATE TABLE IF NOT EXISTS PEOPLE (
PRIMARY KEY(Name_people),
Name_people VARCHAR(64),
first_name VARCHAR(32),
last_name VARCHAR(32)
);

-- Create a table named ADDRESS
-- with primary key (street_number, street_name, city).
-- That mean we can't insert two address for a person

CREATE TABLE IF NOT EXISTS ADDRESS (
street_number INT,
street_name VARCHAR(128),
city VARCHAR(64),
Name_people VARCHAR(64),
FOREIGN KEY(Name_people) REFERENCES PEOPLE(Name_people), 
PRIMARY KEY(street_number, street_name, city)
);

-- Insert data in tables
INSERT INTO PEOPLE VALUES 
('Dante Toribio', 'Dante', 'Toribio'),
('Sofía Mendez', 'Sofía', 'Mendez'),
('Valeria Rojas', 'Valeria', 'Rojas'),
('Gregorio Zull', 'Gregorio', 'ZUll');

INSERT INTO ADDRESS VALUES
(1001,'UNION', 'LIMA' ,'Dante Toribio'),
(1005, 'UNION','LIMA' ,'Sofía Mendez'),
(5004, 'SAN MARCOS',	'CHICLAYO' ,'Valeria Rojas'),
(2001,'PATRON' , 'HUACHO' ,'Gregorio Zull');


-- ------------------------------------
-- -------- ONE-TO-MANY----------------
-- ------------------------------------

CREATE TABLE IF NOT EXISTS CUSTOMER(
PRIMARY KEY(CustomerID),
CustomerID INT,
NameCustomer VARCHAR(64),
YearCustomer INT
);

CREATE TABLE IF NOT EXISTS ORDERS(
PRIMARY KEY(OrderID),
FOREIGN KEY(CustomerID) REFERENCES CUSTOMER(CustomerID) ON UPDATE cascade,
OrderID INT,
CustomerID INT, 
DateCustomer VARCHAR(32)
);

INSERT INTO CUSTOMER VALUES
(1012, 'Fabiola', 20),
(1013, 'Keyla', 30),
(1014, 'Lucía', 50);


INSERT INTO ORDERS VALUES
(123, 1012, '15/10/2021'),
(124, 1012, '15/10/2021'),
(125, 1013, '15/10/2021'),
(126, 1013, '15/10/2021'),
(127, 1014, '15/10/2021');  


-- TO SEE THE EFFECTS OF THE CASCADE
USE COMPLEX;
UPDATE CUSTOMER SET CustomerID=2020 WHERE CustomerID =1012;

SELECT * FROM CUSTOMER;
SELECT * FROM ORDERS;

-- --------------------------------------------------------------
-- ---------------MANY-MANY-RELATIONSHIP-------------------------
-- --------------------------------------------------------------
USE COMPLEX;

CREATE TABLE IF NOT EXISTS SUPPLIER (
    PRIMARY KEY(IdSupName),
    IdSupName INT,
    SupName  character(100)
    );

CREATE TABLE IF NOT EXISTS LABORATORY ( 
    PRIMARY KEY(IdLabName),
    IdLabName INT, 
    LabName character(100)
    );

CREATE TABLE IF NOT EXISTS COMPOUND ( 
    PRIMARY KEY(IdCompName),
    IdCompName INT, 
    CompName character(100)
    );

CREATE TABLE IF NOT EXISTS BUYS (
    PRIMARY KEY (IdSupName, IdLabName, IdCompName),
    FOREIGN KEY(IdLabName) REFERENCES LABORATORY(IdLabName) on update cascade,
    FOREIGN KEY(IdSupName) REFERENCES SUPPLIER(IdSupName) on update cascade,
    FOREIGN KEY(IdCompName) REFERENCES COMPOUND(IdCompName) on update cascade,
    IdSupName INT,
    IdLabName INT,
    IdCompName INT,
    Amount INT,
    BuyDate char(32)
    );

INSERT INTO SUPPLIER VALUES 
(1010, 'Silva Medic S.A.C.'),
(1011, 'Feros Medic S.R.L.');

INSERT INTO LABORATORY VALUES
(2020, 'Suiza Lab S.A.'),
(2021, 'New Lab S.A.');

INSERT INTO COMPOUND VALUES
(3030, 'PANADOL 300ML'),
(3031, 'PARACETAMOL 500ML'),
(3032, 'ALTANGINA 800ML');

INSERT INTO BUYS VALUES
(1010, 2020, 3030, 20, '28/01/2021'),
(1010, 2020, 3031, 80,'28/01/2021'),
(1010, 2021, 3030, 5,'28/01/2021'),
(1010, 2021, 3031, 10,'28/01/2021'),
(1011, 2020, 3032, 40,'28/01/2021'),
(1011, 2021, 3032, 60,'28/01/2021');


-- -------------------------------------------------
-- ------------------Don't work---------------------
-- -------------------------------------------------
-- We create a new table only to see how work the function LOAD
create table ORDERS1(
primary key(OrderID),
OrderID INT,
CustomerID int, 
DateCustomer char(32)
);

select * from employees.orders1;

LOAD DATA infile "load_data_1.csv"
into table employees.orders1
fields terminated by ','
enclosed by "'"
escaped by '\n'
ignore 1 lines;

show variables like "secure_file_priv";

LOAD DATA infile "load_data_2.csv"
into table employees.orders1
fields terminated by ','
enclosed by "'"
escaped by '\n'
ignore 1 lines
(OrderID,CustomerID,@dummy ,DateCustomer );

-- C:\ProgramData\MySQL\MySQL Server 8.0\Data\employees -- Here is where the file is saved
use employees;
LOAD DATA infile "data_load_9.csv"
into table orders2
fields terminated by ','
enclosed by "'"
escaped by '\n'
ignore 1 lines;

-- --------------------------------------------------

-- To delete values
USE COMPLEX;

DELETE FROM BUYS
WHERE IdCompName = 3032;

DELETE FROM COMPOUND
WHERE IdCompName = 3032;

-- TO UPDATE VALUES
UPDATE COMPOUND 
SET IdCompName = 3036
WHERE IdCompName = 3031;

-- To save a table in file csv
-- THE DIRECTORY WHERE IS SAVED IS 
-- C:\ProgramData\MySQL\MySQL Server 8.0\Data\complex
-- COMPLEX POINT OUT THE NAME OF THE DATABASE, IN OURE CASE, COMPLEX
USE COMPLEX;
SELECT * INTO OUTFILE "COMPLEX.csv"
FIELDS TERMINATED BY ','
ENCLOSED BY "'"
ESCAPED BY '\n'
FROM BUYS;

-- -----------------------------------------
-- -----------------QUERIES-----------------
-- -----------------------------------------

CREATE DATABASE IF NOT EXISTS LINIO_SAMPLE;
-- IMPORT DATA BY WIZARD FROM 
-- C:\Users\LENOVO\Desktop\python_course\PySpark\Learning\assets\files
-- PRODUCTS
-- SALES_NORMALIZE
-- USERS

USE LINIO_SAMPLE; 

-- IF WE WANT TO RENAME A TABLE 
-- RENAME TABLE  tableName TO newTableName;

SELECT PRODUCT_ID, (OLD_PRICES - CURRENT_PRICES)/OLD_PRICES AS DISCOUNT
FROM PRODUCTS
WHERE CURRENT_PRICES > 50;

-- SORTED
SELECT PRODUCT_ID, (OLD_PRICES - CURRENT_PRICES)/OLD_PRICES AS DISCOUNT
FROM PRODUCTS
WHERE CURRENT_PRICES > 50
GROUP BY PRODUCT_ID
ORDER BY DISCOUNT;


-- QUERIES OF QUERIES,
-- data_gt_100 is a subquery (inner query), this first is evaluated

SELECT * FROM USERS;

SELECT *
FROM (SELECT * FROM USERS
WHERE AGES>40) AS AGES_40
WHERE DEPARTMENT = 'Lima' ;

SELECT *
FROM (SELECT * FROM USERS
WHERE AGES>40) AS AGES_40
WHERE DEPARTMENT REGEXP '^[Ll]ima$';

-- IN
SELECT COUNT(*)
FROM  USERS
WHERE DEPARTMENT IN ('Ica', 'Puno');

-- BETWEEN
SELECT COUNT(*)
FROM PRODUCTS
WHERE CURRENT_PRICES BETWEEN 35 AND 50;

-- ---------
-- DISTINCT
-- ---------

-- RETURN THE TABLE THAT CONTAIN UNIqUE PRODUCT_ID
SELECT DISTINCT(PRODUCT_ID) AS ONLYS
FROM SALES_NORMALIZE;

-- COUNT UNIqUE PRODUCT_ID
WITH ONLYS_TABLE AS (SELECT DISTINCT(PRODUCT_ID) AS ONLYS
					  FROM SALES_NORMALIZE)
SELECT COUNT(ONLYS) AS UNIQUE_ID_PRODUCTS
FROM ONLYS_TABLE;

-- -----------------
-- CARTESIAN PRODUCT
-- -----------------

WITH T AS (SELECT MAX(CURRENT_PRICES) AS CURRENT_PRICES_MAX
		   FROM PRODUCTS)
SELECT CURRENT_PRICES/CURRENT_PRICES_MAX AS RATIO_CURRENT_PRICES
FROM PRODUCTS, T;

-- ------
-- JOIN
-- ------
USE WORLD;

SELECT * 
-- FROM CITY;
FROM COUNTRY JOIN CITY ON (COUNTRY.CODE= CITY.COUNTRYCODE);

-- -----------------------------------------------
-- JOIN MORE ELEGANT = CARTESIAN PRODUCT + FIRTER
-- -----------------------------------------------
SELECT * 
FROM country  AS CountryTab , city as CityTab
WHERE (CountryTab.Code = CityTab.CountryCode);

-- ----------
-- FUNTIONS
-- ----------
-- 1. STRING FUNCTIONS

USE WORLD;
SHOW TABLES from WORLD;

-- LOWER
SELECT LOWER(COUNTRYCODE)
FROM CITY;

-- CONCAT
SELECT  CONCAT(CITY.NAME , '-', CITY.DISTRICT) AS NAME_DISTRICT
FROM CITY;

-- TRIM => TO  REMOVE THE WHITE SPACES AT LEFT AND RIGHT
-- LTRIM => TO  REMOVE THE WHITE SPACES AT LEFT
-- RTRIM => TO  REMOVE THE WHITE SPACES AT RIGHT

-- --------------
-- CONDITIONALS
-- --------------
-- THE DEMOGRAPHY OF A COUNTRY RESPECT TO CONTINENT (IN %)
-- COUNT THE COUNTRIES THAT OVER 1%
WITH TY AS	(WITH T AS (SELECT CONTINENT AS CONTINENT_T, SUM(POPULATION) AS POPULATION_BY_CONTINENT
			            FROM COUNTRY
			            GROUP BY CONTINENT)
			SELECT CONTINENT, COUNTRY.NAME, (CASE WHEN POPULATION/POPULATION_BY_CONTINENT>0.01 THEN 1 ELSE 0 END) AS POPULATION_GT_1_BY_CONTINENT
			FROM COUNTRY JOIN T ON COUNTRY.CONTINENT = T.CONTINENT_T)
SELECT CONTINENT, SUM(POPULATION_GT_1_BY_CONTINENT) AS COUNT_1
FROM TY
GROUP BY CONTINENT
ORDER BY COUNT_1 DESC
LIMIT 5;

-- ---------------------------------
-- ------------GROUPING-------------
-- ---------------------------------

SELECT REGION, COUNT(*) as HIST
FROM COUNTRY
WHERE CONTINENT= 'Asia'
GROUP BY REGION; 

-- CONTINENT REGION
SELECT REGION, POPULATION, COUNT(*) as HIST
FROM COUNTRY
WHERE CONTINENT= 'Asia'
GROUP BY REGION; 


WITH T AS (SELECT COUNT(*) AS COUNT_REGION_ASIA
			FROM COUNTRY
            WHERE CONTINENT = 'Asia')
SELECT REGION, COUNT(*)/COUNT_REGION_ASIA AS DIST
FROM COUNTRY, T
WHERE CONTINENT = 'Asia'
GROUP BY REGION;

-- ----------------------------
-- ---- GROUP BY and CASE ----
-- ----------------------------

WITH T AS (select Continent, LifeExpectancy, (case when LifeExpectancy > 80 then "High" 
													when LifeExpectancy > 70 then "Medium"
													when LifeExpectancy > 50 then "Low" 
													else "Bad" end) as Classification
			from country)
SELECT Continent, Classification, COUNT(Classification)
FROM T
GROUP BY Continent, Classification
ORDER BY Continent, Classification;

-- 
SELECT CONTINENT, SUM(CASE WHEN LifeExpectancy < 50 THEN 1 ELSE 0 end ) as  "Bad",
				  SUM(CASE WHEN LifeExpectancy BETWEEN 50 and 70 THEN 1 ELSE 0 end) as  "Low",
				  SUM(CASE WHEN LifeExpectancy BETWEEN 70 and 80 THEN 1 ELSE 0 end) as  "Medium",
				  SUM(CASE WHEN LifeExpectancy > 80 THEN 1 ELSE 0 end ) as  "High"
FROM COUNTRY
GROUP BY CONTINENT;

-- STEPS OF THE COMPUTATIONS
-- 1. GROUP BY CONTINENT
-- 2. COMPUTE THE CASE WHEN
-- 3. COMPUTE THE AGGREGATION FUNCTION SUM
-- 4. THIS IS ASSIGNED LIKE BAD, LOW, ...


-- HAVING 
USE WORLD;
WITH T AS (SELECT COUNT(*) AS TOTAL_ASIA FROM COUNTRY
            WHERE CONTINENT='Asia')
SELECT REGION, COUNT(*)/TOTAL_ASIA AS DISTRIBUTIONS
FROM COUNTRY, T
WHERE CONTINENT='Asia'
GROUP BY REGION
HAVING DISTRIBUTIONS>0.10;

-- ORDER BY 
SELECT NAME, COUNT(LANGUAGE) AS SPOKEN_LANGUAGE
FROM COUNTRYLANGUAGE, COUNTRY
WHERE `Code` = CountryCode
GROUP BY NAME
HAVING SPOKEN_LANGUAGE>10
ORDER BY SPOKEN_LANGUAGE DESC;

-- TOP 5 REGIONS AREA
SELECT REGION, SUM(SurfaceArea) as AREA
FROM COUNTRY
GROUP BY REGION
ORDER BY AREA DESC
LIMIT 5;

-- SKIPPING
SELECT REGION, SUM(SurfaceArea) as AREA
FROM COUNTRY
GROUP BY REGION
ORDER BY AREA DESC
limit 5 OFFSET 20 ;

-- WITH FOR COMPLEX QUERIES
with T as (select Continent ,sum(SurfaceArea) as TotalArea, sum(Population) as TotalPopulation
from world.country
group by Continent)
select Continent, TotalPopulation/TotalArea as Densitity
from T
order by Densitity desc;

-- DROP A COLUMN IN A TABLE 
alter table data_products
drop column YearInit;

-- ADD A COLUMN IN A TABLE 
alter table data_products
add YearInit char(30);

-- UPDATE VALUES
SET SQL_SAFE_UPDATES = 0;
update data_products 
set YearInit = 'SOL'
where YearInit is null; 


update data_products 
set YearInit = '2010'
where title = 'Labial Colorfix Duo Tattoo';

select *
from data_products
where title regexp '^L.*' ;


-- concat('%', 'S', '%');

-- Create data base companyCakes

create database companyCake;
use companyCake;

SELECT *
FROM companyCake;

select ssn, nameEmp, sum(amount) as total

from emp left outer join sales on (emp.ssn = sales.essn )
group by ssn, nameEmp
order by total asc
limit 5;

-- Subqueries
select essn, total
from (
	select essn, sum(amount) as total
	from sales 
	group by essn) as Tab1
where total > 100;

-- IN NOT IN

select *
from emp
where ssn not in (
	select essn
	from sales
	group by essn);
    
