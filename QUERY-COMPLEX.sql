CREATE DATABASE IF NOT EXISTS SOUL;
USE SOUL;

SELECT IDX, SUM(SALES) AS SALES_EMP
FROM EMPLOYEES LEFT OUTER JOIN SALES ON (SALES.IDX_EMP = EMPLOYEES.IDX)
GROUP BY IDX ; 

-- -------------------------
-- Aggregated subqueries
-- -------------------------

CREATE DATABASE IF NOT EXISTS LINIO_SAMPLE;
USE LINIO_SAMPLE;

WITH T3  AS (SELECT YEARS AS YEARS_T3, MONTHS AS MONTHS_T3, DAYS AS DAYS_T3, AVG(TOTAL) AS AVERAGE
			 FROM T
             GROUP BY YEARS, MONTHS, DAYS)
SELECT YEARS, MONTHS, DAYS, HOURS, TOTAL,AVERAGE, TOTAL > AVERAGE AS GT
FROM T JOIN T3 ON (T.YEARS = T3.YEARS_T3 && T.MONTHS = T3.MONTHS_T3 && T.DAYS = T3.DAYS_T3);

-- -----------
-- --- IN ---
-- -----------
SELECT *
FROM  SALES_NORMALIZE
WHERE PRODUCT_ID IN (SELECT PRODUCT_ID
					 FROM PRODUCTS
					 WHERE CURRENT_PRICES>50);
-- -------------
-- -- EXISTS ---
-- -------------

SELECT COUNT(*)
FROM  SALES_NORMALIZE
WHERE PRODUCT_ID AND EXISTS(SELECT PRODUCT_ID
							 FROM PRODUCTS
							 WHERE CURRENT_PRICES>60);

SELECT COUNT(*)
FROM  SALES_NORMALIZE
WHERE SALE_PRICE >= (SELECT MAX(CURRENT_PRICES) FROM PRODUCTS);

-- -----------------
-- ---- WINDOWS ----
-- -----------------

SELECT YEARS, MONTHS, DAYS,HOURS, AVG(TOTAL) OVER W
FROM T 
WINDOW W AS (PARTITION BY YEARS, MONTHS, DAYS ORDER BY HOURS ROWS 2 PRECEDING);


-- CUMULATIVE SUM
SELECT YEARS, MONTHS, DAYS,HOURS, SUM(TOTAL) OVER W
FROM T 
WINDOW W AS (PARTITION BY YEARS, MONTHS, DAYS ORDER BY HOURS ROWS BETWEEN UNBOUNDED PRECEDING AND  CURRENT ROW);

-- MULTIPLE WINDOWS
SELECT * FROM SALES_NORMALIZE;

SELECT YEARS, MONTHS, DAYS, SELLER_ID, PRODUCT_ID, 
AVG(quantity) OVER W,
AVG(quantity) OVER W1,
AVG(quantity) OVER W2
FROM SALES_NORMALIZE
WINDOW W AS (),
W1 AS (PARTITION BY SELLER_ID),
W2 AS (PARTITION BY YEARS, MONTHS, DAYS);

-- RESUSE A WINDOW

SELECT YEARS, MONTHS, DAYS, HOURS, quantity,
AVG(quantity) over W,
SUM(quantity) over W1
FROM SALES_NORMALIZE
WINDOW W AS (PARTITION BY YEARS, MONTHS, DAYS, HOURS ORDER BY HOURS), -- ;-- ,
W1 AS (W ROWS BETWEEN UNBOUNDED PRECEDING AND  CURRENT ROW);

-- RANK

SELECT *  
FROM T;

WITH T3 AS (SELECT YEARS, MONTHS, DAYS, HOURS, TOTAL,
			RANK() OVER W AS RANKING
			FROM T
			WINDOW W AS (PARTITION BY YEARS, MONTHS, DAYS ORDER BY TOTAL))
SELECT HOURS, COUNT(*) AS TOP
FROM T3
WHERE RANKING < 4
GROUP BY HOURS
ORDER BY TOP DESC;

-- ------------------
-- PERCENT PARNK
-- ------------------
SELECT YEARS, MONTHS, DAYS, HOURS, TOTAL,
PERCENT_RANK() OVER W AS RANKING
FROM T
WINDOW W AS (PARTITION BY YEARS, MONTHS, DAYS ORDER BY TOTAL);


-- --------------------------
-- ---- SETS OPERATION -----
-- --------------------------

-- DROP VIEW T2019;

CREATE VIEW T2017 AS 
(SELECT * FROM T WHERE YEARS = 2017);
CREATE VIEW T2018 AS 
(SELECT * FROM T WHERE YEARS = 2018);
CREATE VIEW T2019 AS 
(SELECT * FROM T WHERE YEARS = 2019);

-- SELECT * FROM T2017;
SELECT * FROM T2017
UNION 
SELECT * FROM T2018
UNION 
SELECT * FROM T2019;


