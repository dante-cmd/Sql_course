-- WINDOW

-- 1. MOVING AVERAGE OVER A WINDOW OF 3 ROWS, THE CURRENT AND THE 2 PRECEDING
/*WITH T AS (SELECT YEARS, MONTHS, DAYS, SUM(quantity*sale_price) AS amount
				FROM metro_sample.sales
				GROUP BY YEARS, MONTHS, DAYS)

SELECT YEARS, MONTHS, DAYS, AVG(amount) OVER W AS MA_OVER_AMOUNT
FROM T
WINDOW W AS (PARTITION BY YEARS, MONTHS ORDER BY DAYS ROWS 2 PRECEDING);

-- 2. CUMMULATIVE SUM
WITH T AS (SELECT YEARS, MONTHS, DAYS, SUM(quantity*sale_price) AS amount
				FROM metro_sample.sales
				GROUP BY YEARS, MONTHS, DAYS)

SELECT YEARS, MONTHS, DAYS, SUM(amount) OVER W AS MA_OVER_AMOUNT
FROM T
WINDOW W AS (PARTITION BY YEARS, MONTHS ORDER BY DAYS  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW);*/

/* WITH T AS (SELECT YEARS, MONTHS, DAYS, SUM(quantity*sale_price) AS amount
				FROM metro_sample.sales
				GROUP BY YEARS, MONTHS, DAYS)*/

/*WITH T AS (SELECT product_id, quantity, AVG(quantity) over W AS mean_by_product
				FROM metro_sample.sales
				WINDOW W AS (PARTITION BY product_id))
SELECT product_id , SUM(POW(mean_by_product - quantity, 2))/COUNT(*)
FROM T
GROUP by product_id*/

-- MULTIPLE WINDOWS

/* SELECT product_id, quantity, 
	AVG(quantity) over W AS mean_overall,
	AVG(quantity) over W1 AS mean_by_product_id,
 	AVG(quantity) over W2 AS mean_by_year_month_day
FROM metro_sample.sales
WINDOW 
		W AS (),
		W1 AS (PARTITION BY product_id),
		W2 AS (PARTITION BY YEARS, MONTHS, DAYS)*/
		

-- REUSABLE WINDOW
/* SELECT YEARS, MONTHS, DAYS, HOURS, quantity,
AVG(quantity) over W,
SUM(quantity) over W1 AS CUMSUM
FROM metro_sample.sales
WINDOW W AS (PARTITION BY YEARS, MONTHS, DAYS, HOURS ORDER BY YEARS, MONTHS, DAYS, HOURS),
W1 AS (W ROWS BETWEEN UNBOUNDED PRECEDING AND  CURRENT ROW);*/


-- RANK

/*WITH T2 AS (WITH T AS (SELECT years, user_id, SUM(quantity) AS total
								FROM metro_sample.sales
								GROUP BY years, user_id)
	
				SELECT YEARS, user_id,total, RANK() over W AS ranking
				FROM T
				WINDOW W AS (partition by YEARS ORDER BY total DESC ))
SELECT *
FROM T2
WHERE ranking <= 5*/


-- OTHERS FUNCTIONS

WITH T2 AS (WITH T AS (SELECT YEARS, MONTHS, DAYS, SUM(quantity) AS total
				FROM metro_sample.sales
				GROUP BY YEARS, MONTHS, DAYS)
	
				SELECT YEARS, MONTHS, DAYS, total,
					lag(total) OVER W AS total_lag_1,
					ROW_NUMBER() over W AS `row_number`
				FROM T
				WINDOW W AS (PARTITION BY YEARS, MONTHS ORDER BY YEARS, MONTHS, DAYS))
SELECT YEARS, MONTHS, DAYS, total - total_lag_1 AS diff
FROM T2



-- --------------------
-- --- PERCENT RANK ---
-- --------------------


WITH T AS (SELECT YEARS, MONTHS, DAYS, SUM(quantity) AS total
				FROM metro_sample.sales
				GROUP BY YEARS, MONTHS, DAYS)
				
SELECT YEARS, MONTHS, DAYS, total,
PERCENT_RANK() OVER W AS PERCENT_RANKING
FROM T
WINDOW W AS (PARTITION BY YEARS, MONTHS ORDER BY total);
