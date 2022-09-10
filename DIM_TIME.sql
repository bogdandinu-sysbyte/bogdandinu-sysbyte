
CREATE  TABLE DIM_TIME AS
SELECT
-- DAY LEVEL
time_id AS day_id,
INITCAP(TO_CHAR(time_id,'fmMonth DD, YYYY')) AS day_desc,
INITCAP(TO_CHAR(time_id, 'fmDAY')) AS day_name,
TO_NUMBER(TO_CHAR(time_id - 1, 'D')) AS day_of_week,
TO_NUMBER(TO_CHAR(time_id, 'DD')) AS day_of_month,
TO_NUMBER(TO_CHAR(time_id, 'DDD')) AS day_of_year,
1 AS days_in_day,

-- MONTH LEVEL
TO_CHAR(time_id, 'YYYY"-M"MM') AS month_id,
TO_CHAR(time_id, 'fmMonth YYYY') AS month_desc,
DECODE(MOD(TO_NUMBER(TO_CHAR(time_id, 'MM')), 4), 0, 4, MOD(TO_NUMBER(TO_CHAR(time_id, 'MM')), 4)) AS month_of_quarter,
TO_NUMBER(TO_CHAR(time_id, 'MM')) AS month_of_year,
TO_CHAR(time_id, 'fmMonth') AS month_name,
LAST_DAY(time_id) AS end_of_month,
TO_CHAR(LAST_DAY(time_id),'DD') AS days_in_month,

-- QUARTER LEVEL
TO_CHAR(time_id, 'YYYY"-Q"Q') AS quarter_id,
INITCAP(TO_CHAR(time_id, 'fmQth "quarter," YYYY')) AS quarter_desc,
TO_NUMBER(TO_CHAR(time_id, 'Q')) AS quarter_of_year,
TRUNC(ADD_MONTHS(time_id,3), 'Q') - 1 AS end_of_quarter,
(TRUNC(ADD_MONTHS(time_id,3), 'Q') - 1) - (TRUNC(time_id, 'Q') - 1) AS days_in_quarter,

-- YEAR LEVEL
TO_NUMBER(TO_CHAR(time_id, 'YYYY')) AS year_id,
(TRUNC(ADD_MONTHS(time_id,12), 'YYYY') - 1) - (TRUNC(time_id, 'YYYY') - 1) AS days_in_year,
TRUNC(ADD_MONTHS(time_id,12), 'YYYY') - 1 AS end_of_year,

-- THIS IS THE SAME FOR ALL WEEKS
7 AS days_in_week,

-- CALENDAR WEEK LEVEL
TO_CHAR(time_id, 'IYYY') || '-CW' || TO_CHAR(time_id, 'IW') AS cal_week_id,
INITCAP(TO_CHAR(time_id, 'fmIWth "week of" IYYY')) || ', ending ' || TO_CHAR(TRUNC(time_id + 7, 'IW') - 1, 'fmMonth DD, YYYY') AS cal_week_desc,
TO_NUMBER(TO_CHAR(time_id, 'IW')) AS cal_week_of_year,
TRUNC(time_id + 7, 'IW') - 1 AS end_of_cal_week

FROM (SELECT to_date('01/01/2000','MM/DD/YYYY') + rownum - 1 AS time_id
FROM all_objects
WHERE rownum <= 12000)
ORDER BY time_id DESC
