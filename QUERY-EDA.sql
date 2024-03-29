-- CLEAN DATA
USE LINIO_SAMPLE;
SELECT * FROM SALES_NORMALIZE;

-- CREATE A VIEW T
CREATE VIEW T AS (SELECT YEARS, MONTHS, DAYS, HOURS, SUM(quantity) AS TOTAL 
					FROM SALES_NORMALIZE
					GROUP BY YEARS, MONTHS, DAYS, HOURS);
-- DROP VIEW T;
-- SHOW COLUMNS FROM T;
-- SELECT * FROM T;

-- CREATE VIEW T2
CREATE VIEW T2 AS (SELECT YEARS AS YEARS_T2, MONTHS AS MONTHS_T2, DAYS AS DAYS_T2, AVG(TOTAL) AS AVERAGE, 
					MAX(TOTAL) AS MAXIMUN, MIN(TOTAL) AS MINIMUN, STD(TOTAL) AS STANDAR
					FROM T
					GROUP BY YEARS, MONTHS, DAYS);
   
-- NORMALIZATION
WITH TABLE_TOTAL AS (SELECT * 
					 FROM T, T2
					 WHERE T.YEARS = T2.YEARS_T2 AND T.MONTHS = T2.MONTHS_T2 AND T.DAYS = T2.DAYS_T2)
SELECT YEARS, MONTHS, DAYS, HOURS, TOTAL, (TOTAL - AVERAGE)/(STANDAR) AS Z
FROM TABLE_TOTAL;

-- CREATE A TABLE NORMALIZE
CREATE VIEW NORMAL AS 
WITH TABLE_TOTAL AS (SELECT * 
					 FROM T, T2
					 WHERE T.YEARS = T2.YEARS_T2 AND T.MONTHS = T2.MONTHS_T2 AND T.DAYS = T2.DAYS_T2)
SELECT YEARS, MONTHS, DAYS, HOURS, TOTAL, (TOTAL - AVERAGE)/(STANDAR) AS Z
FROM TABLE_TOTAL;

-- SELECT * FROM T2;
-- DROP VIEW T2;

-- ---------------
-- LINEAR SCALING
-- --------------- 

WITH TABLE_TOTAL AS (SELECT * 
					 FROM T, T2
					 WHERE T.YEARS = T2.YEARS_T2 AND T.MONTHS = T2.MONTHS_T2 AND T.DAYS = T2.DAYS_T2)
SELECT YEARS, MONTHS, DAYS, HOURS, TOTAL, (TOTAL - AVERAGE)/(MAXIMUN - MINIMUN) AS MAXMIN
FROM TABLE_TOTAL;

-- NON LINEAR TRANFORMATION
-- GIVEN A TABLE NORMLAIZE 
SELECT 1/(1 + EXP(-Z))
FROM NORMAL;


-- ------------------------
-- WORKING WITH STRING
-- ------------------------

CREATE TABLE STUDENT(
    StudentId INT,
    Department CHAR(45)
);

INSERT INTO STUDENT VALUES
(1,"Dept of Economics"),
(2,"Econ"),
(3, "Department of Econ");

UPDATE STUDENT
SET Department = "Economics"
WHERE Department REGEXP '.*Econ.*';

-- LENGHT
SET @VARIABLE = "MACROECONOMICS";
SELECT LENGTH(@VARIABLE);
-- LPAD
SELECT LPAD(@VARIABLE, 20, "*");

-- POSITION
SET @VARIABLE = "1 FORM";
SELECT POSITION("FORM" IN @VARIABLE);
-- UPPER AND LOWER
SET @MYNAME = "Jeff";
SELECT UPPER(@MYNAME );
SET @MYNAME = "Jeff";
SELECT LOWER(@MYNAME );

-- SUBSTRING
SET @VARIABLE = "Avenger - Ultron Age";
SELECT SUBSTR(@VARIABLE, POSITION("A" IN @VARIABLE), 7);

-- SUBSTRING_INDEX
SET @VARIABLE_1 = "http://www.google.com";
SET @VARIABLE_2 = "www.outlook.com";
SELECT SUBSTRING_INDEX(@VARIABLE_2, 'www', -1);

SELECT SUBSTRING_INDEX("www.google.com", '.', -1);

SELECT CONCAT('10' ,'-05-', '2020');

-- 1 POINT OUT THE TIMES IN WHICH MUST APPEAR THE "."
-- THE SIGN MINUS (-) START THE COUNTING FROM RIGHT
-- THE MEANING IS: 
-- >EXTRACT ALL STRING FROM THE LEFT UNTIL 1 TIME THE '.' APPEAR. HER THE OUTPUE IS `com`
SELECT SUBSTRING_INDEX("www.google.com", '.', -1);

-- CONCAT STRING `CONCAT(STRING1, STRING2 , ...)`
SELECT CONCAT('10' ,'-05-', '2020');

-- EXTRACT 5 CHARS STARTING AT RIGHT. THE YEAR
SELECT RIGHT("10-05-2020", 4);

-- EXTRACT 5 CHARS STARTING AT LEFT. THE DAY
SELECT LEFT("10-05-2020", 2);

-- GROUP_CONCAT
ALTER TABLE SALES_NORMALIZE
ADD COLUMN PRODUCT_ID_STR  CHAR(10) AS (CAST(PRODUCT_ID AS CHAR(10)));

SELECT YEARS, MONTHS, DAYS, HOURS, GROUP_CONCAT(PRODUCT_ID_STR)
FROM SALES_NORMALIZE
GROUP BY YEARS, MONTHS, DAYS, HOURS;


-- ---------------------
-- WORKING WITH DATES
-- ---------------------
-- SELECT THE date
SELECT DATE('2020-12-20 22:12:32');

-- SELECT THE time
SELECT TIME('2020-12-20 22:12:32');

-- add 4 days. Can be other itervals like months, year
SELECT adddate('2020-12-20 22:12:32', interval 4 day);

-- diff between dates
SELECT datediff('2021-12-20', '2020-12-20');

-- get a format of date
SELECT date_format('2021-12-20', '%a-%d-%b-%Y') ;

-- more about date -> `https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html#function_date-format`

-- `MAKEDATE(year,dayofyear)`
SELECT MAKEDATE(2015, 90);

-- `str_to_date`
set @mydate = "15-04-2015";
SELECT str_to_date(@mydate, '%d-%m-%Y');

-- ----------------------
-- ---- MISSING DATA ----
-- ----------------------
USE LINIO_SAMPLE;

SELECT COUNT(*)  AS CURRENT_NULL FROM PRODUCTS
WHERE CURRENT_PRICES IS NULL;

SELECT COUNT(*)  AS CURRENT_NOT_NULL FROM PRODUCTS
WHERE CURRENT_PRICES IS NOT NULL;


-- ---------------------------
-- --------------------

SET SQL_SAFE_UPDATES = 0;
ALTER TABLE PRODUCTS ADD COLUMN  CLASSIFICATION CHAR(12);
-- ALTER TABLE PRODUCTS DROP COLUMN  CLASSIFICATION;

UPDATE PRODUCTS
SET CLASSIFICATION = (CASE 
			WHEN CURRENT_PRICES < 30 THEN "Low" 
			WHEN CURRENT_PRICES < 50 THEN "Medium"
            ELSE "High" END);

-- ADD WRONG COLUMN
ALTER TABLE PRODUCTS ADD COLUMN  WRONG FLOAT;
UPDATE PRODUCTS
SET WRONG = (CASE 
			WHEN CURRENT_PRICES BETWEEN 45 AND 55 THEN NULL
            ELSE CURRENT_PRICES END);

SELECT 
CLASSIFICATION, 
COUNT(*) AS COUNT_TOTAL, 
SUM(CASE WHEN WRONG IS NULL THEN 1 ELSE 0 END) AS COUNT_NULL,
SUM(CASE WHEN WRONG IS NOT NULL THEN 1 ELSE 0 END) AS COUNT_NOT_NULL
FROM PRODUCTS
GROUP BY CLASSIFICATION;

-- DELETE THE OBSERVATION FROM tableName IF columnName IS NULL
DELETE FROM tableName
WHERE columnName IS NULL;

-- FILL THE SPACES NULL WITH ZERO
SELECT COALESCE(WRONG, 0)
FROM PRODUCTS;

-- THE NULLS IN STRING ARE ""
-- ONE MAY THAT WE CAN FIND THEM IS WITH LENGHT

SELECT COUNT(columnString) FROM tableName WHERE LENGTH(columnString) = 0;

-- ---------------------
-- ----- OUTLIER ------
-- ---------------------

WITH T3  AS (SELECT STD(TOTAL) AS STD_TOTAL, 
				AVG(TOTAL) AS AVG_TOTAL FROM T
				WHERE HOURS = 9)
SELECT *
FROM T,T3
WHERE HOURS = 9 AND (TOTAL > AVG_TOTAL + 2*STD_TOTAL  OR TOTAL < AVG_TOTAL - 2*STD_TOTAL);


-- OUTLIER DETECTTION

CREATE DATABASE STUDENTS;

-- DROP TABLE table_student;
-- DROP DATABASE STUDENT;

CREATE TABLE STUDENT(
    first_name char(32),
    last_name char(32),
    address_student char(100));

INSERT INTO STUDENT VALUES
('Badfinger', 'British', 'Av. San Martin de Porres 906'),
('Badfinger', 'British', 'Av. San Martin de Porres 906'),
('Dante', 'Toribio', 'Av. Tacna 784'),
('Maria', 'Mauricia', 'Jr. La Union');

-- To identify duplicates values

SELECT COUNT(*) as count_duplicates, first_name, last_name, address_student
FROM STUDENT
GROUP BY first_name, last_name, address_student
HAVING count_duplicates>1;

-- To identify duplicates values string or how far apart they are
SELECT *
FROM STUDENT
WHERE first_name REGEXP '^[Bb]ad.*';


-- SAMPLING. THE SIZE OF THE SAMPLE IS 50. 
SELECT * FROM PRODUCTS ORDER BY RAND() LIMIT 50;

-- a----------------------ALTER

CREATE DATABASE Earthquakes;
-- DROP TABLE Earthquake;
USE Earthquakes;

CREATE TABLE Earthquake(
    Magnitude FLOAT, 
    Y2000 INT,
    Y2001 INT,
    Y2002 INT,
    Y2003 INT
);

INSERT INTO Earthquake VALUES 
(4.8, 1, 2, 3,6),
(3.1, 3, 0, 5, 1),
(2.9, 2, 0, 0, 4),
(5, 1, 1, 2, 1);

SELECT * FROM Earthquake;

CREATE TEMPORARY table tmp(year_n INT);

INSERT INTO tmp VALUES (2000), (2001), (2002), (2003);

CREATE TABLE earthquateTidy AS
(SELECT Magnitude, year_n, sum(
    CASE WHEN year_n = 2000 THEN Y2000
    WHEN year_n = 2001 THEN Y2001
    WHEN year_n = 2002 THEN Y2002
    WHEN year_n = 2003 THEN Y2003
    ELSE 0 END) as numberquake
FROM Earthquake, tmp
GROUP BY Magnitude, year_n);

SELECT * FROM earthquateTidy;

-- CREATE A NEW TABLE BASED ONE ORIGINAL
CREATE TABLE new_tbl LIKE orig_tbl;


-- To recover what we had above
SELECT 
Magnitude,
sum(CASE WHEN year_n = 2000 THEN numberquake ELSE 0 END) as Y2000,
sum(CASE WHEN year_n = 2001 THEN numberquake ELSE 0 END) as Y2001,
sum(CASE WHEN year_n = 2002 THEN numberquake ELSE 0 END) as Y2002,
sum(CASE WHEN year_n = 2003 THEN numberquake ELSE 0 END) as Y2003
FROM earthquateTidy
GROUP BY magnitude;

CREATE TABLE SIMPLE_TAB (
    NAME_TAB CHAR(50),
    CATEGORY CHAR(10)
);

INSERT INTO SIMPLE_TAB VALUES
('Jones', 'A'),
('Jones', 'C'),
('Smith', 'B'),
('Lewis', 'B'),
('Lewis', 'C');

SELECT NAME_TAB,
sum(CASE WHEN CATEGORY = "A" then 1 ELSE 0 END) AS A,
sum(CASE WHEN CATEGORY = "B" then 1 ELSE 0 END) AS B,
sum(CASE WHEN CATEGORY = "C" then 1 ELSE 0 END) AS C
FROM SIMPLE_TAB
GROUP BY NAME_TAB;

-- --------------------------------
-- Creating Dummy Variables
-- --------------------------------

USE STUDENTS;

CREATE TABLE SIMPLE_TAB (
    NAME_TAB CHAR(50),
    CATEGORY CHAR(10)
);

INSERT INTO SIMPLE_TAB VALUES
('Jones', 'A'),
('Jones', 'C'),
('Smith', 'B'),
('Lewis', 'B'),
('Lewis', 'C');


SELECT NAME_TAB,
sum(CASE WHEN CATEGORY = "A" then 1 ELSE 0 END) AS A,
sum(CASE WHEN CATEGORY = "B" then 1 ELSE 0 END) AS B,
sum(CASE WHEN CATEGORY = "C" then 1 ELSE 0 END) AS C
FROM SIMPLE_TAB
GROUP BY NAME_TAB;



CREATE TEMPORARY table tmp(
IND INT,
BOOK TEXT,
AUTHOR TEXT,
PUBLISHING TEXT,
PAG INT);
-- DROP TEMPORARY table  TMP;	
SELECT * FROM TMP;

INSERT INTO TMP VALUES
(1, "Harry Potter", "J.K.Rowing", "Bloomsbury Publishing", 500),
(2, "La tentacion del fracaso", "Juio Ramón Ribeyro","Planeta", 704),
(3 , "Cien años de soledad", "Gabriel Garcia Marquez", "Sudamericana", 496);

-- DESTRUCTIVE ACTION
UPDATE TMP SET PUBLISHING = UPPER(PUBLISHING);


-- NON DESTRUCTIVE ACTION
-- ADD NEW COLUMN
ALTER TABLE TMP ADD column BOOK_AUTHOR CHAR(60);

UPDATE TMP
SET BOOK_AUTHOR = CONCAT(BOOK,"-" , AUTHOR);

-- CREATE A NEW TABLE THAT INCLUDE OUR NEW COLUMN
CREATE TEMPORARY TABLE TMP1 AS
SELECT IND, BOOK, AUTHOR, PUBLISHING, PAG, CONCAT(BOOK,"-" , AUTHOR) as BOOK_AUTHOR
FROM TMP;

USE LINIO_SAMPLE;
CREATE VIEW VIEW1 AS
(SELECT *
FROM PRODUCTS);
