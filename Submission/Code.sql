-- Quiz Funnel
-- Get to know survey table
SELECT *
FROM survey
LIMIT 10;

-- List questions
SELECT DISTINCT(question)
FROM survey;

-- Questions and # of answers
SELECT DISTINCT(question),
COUNT(DISTINCT(response))     
FROM survey
GROUP BY 1
ORDER BY 1;

-- Questions and correspondet answers
SELECT DISTINCT(question), response
FROM survey
ORDER BY 1;

-- number of responses for each question
SELECT question, 
	COUNT(DISTINCT user_id)
FROM survey
GROUP BY 1
ORDER BY 1 ASC;

-- Home Try-On Funnel
-- Get to know quiz table
SELECT *
FROM quiz
LIMIT 5;

-- Get to know home_try_on table
SELECT *
FROM home_try_on
LIMIT 5;

-- Get to know purchase table
SELECT *
FROM purchase
LIMIT 5;

-- Create New Table
SELECT DISTINCT q.user_id,
CASE
	WHEN h.user_id IS NOT NULL THEN 'True'
  ELSE 'False'
END AS 'is_home_try_on',
CASE
	WHEN h.number_of_pairs IS NULL THEN 'NULL'
	WHEN h.number_of_pairs = '3 pairs' THEN '3'
	WHEN h.number_of_pairs = '5 pairs' THEN '5'  
  END  AS 'number_of_pairs',
CASE
	WHEN p.user_id IS NOT NULL THEN 'True' 
  ELSE 'False'
  END AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
	ON q.user_id = h.user_id
LEFT JOIN purchase p
	ON p.user_id = q.user_id
LIMIT 10;
               
-- overall conversion rate
WITH new AS (
  WITH funnel AS (
SELECT DISTINCT q.user_id,
CASE
	WHEN h.user_id IS NOT NULL THEN 'True'
  ELSE 'False'
END AS 'is_home_try_on',
CASE
	WHEN h.number_of_pairs IS NULL THEN 'NULL'
	WHEN h.number_of_pairs = '3 pairs' THEN '3'
	WHEN h.number_of_pairs = '5 pairs' THEN '5'  
  END  AS 'number_of_pairs',
CASE
	WHEN p.user_id IS NOT NULL THEN 'True' 
  ELSE 'False'
  END AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
	ON q.user_id = h.user_id
LEFT JOIN purchase p
	ON p.user_id = q.user_id)
SELECT COUNT(*) AS 'num_quiz',
COUNT(DISTINCT CASE
     WHEN is_purchase = 'True' THEN user_id
     END) AS 'num_purchase'              
FROM funnel)
SELECT num_quiz, num_purchase,
1.0 * num_purchase / num_quiz AS 'overall conversion rate'   
FROM new;           
       
-- conversion from quizhome_try_on and home_try_onpurchase.
WITH new AS (
  WITH funnel AS (
SELECT DISTINCT q.user_id,
CASE
	WHEN h.user_id IS NOT NULL THEN 'True'
  ELSE 'False'
END AS 'is_home_try_on',
CASE
	WHEN h.number_of_pairs IS NULL THEN 'NULL'
	WHEN h.number_of_pairs = '3 pairs' THEN '3'
	WHEN h.number_of_pairs = '5 pairs' THEN '5'  
  END  AS 'number_of_pairs',
CASE
	WHEN p.user_id IS NOT NULL THEN 'True' 
  ELSE 'False'
  END AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
	ON q.user_id = h.user_id
LEFT JOIN purchase p
	ON p.user_id = q.user_id)
SELECT COUNT(*) AS 'num_quiz',
COUNT(DISTINCT CASE
     WHEN is_home_try_on = 'True' THEN user_id
     END) AS 'num_try_on',
COUNT(DISTINCT CASE
     WHEN is_purchase = 'True' THEN user_id
     END) AS 'num_purchase'              
FROM funnel)
SELECT num_quiz, num_try_on, num_purchase,
1.0 * num_try_on / num_quiz AS 'Percentage of users from quiz to home try on',
1.0 * num_purchase / num_try_on AS 'Percentage of users from home try on to purchase'               
FROM new;
               
-- A/B Test
WITH new AS (
  WITH funnel AS (
SELECT DISTINCT q.user_id,
CASE
	WHEN h.user_id IS NOT NULL THEN 'True'
  ELSE 'False'
END AS 'is_home_try_on',
CASE
	WHEN h.number_of_pairs IS NULL THEN 'NULL'
	WHEN h.number_of_pairs = '3 pairs' THEN '3'
	WHEN h.number_of_pairs = '5 pairs' THEN '5'  
  END  AS 'number_of_pairs',
CASE
	WHEN p.user_id IS NOT NULL THEN 'True' 
  ELSE 'False'
  END AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
	ON q.user_id = h.user_id
LEFT JOIN purchase p
	ON p.user_id = q.user_id)
SELECT DISTINCT(number_of_pairs) AS 'pairs', COUNT(*) AS 'num_try_on',
  COUNT(DISTINCT CASE
     WHEN is_purchase = 'True' THEN user_id
     END) AS 'num_purchase'            
FROM funnel
GROUP BY 1)
SELECT pairs, num_try_on, num_purchase,
  round(1.0 * num_purchase / num_try_on,2) AS 'conversion rate'
FROM new;              
 
-- The most common results of the style quiz  
SELECT DISTINCT(style), COUNT(*)
FROM quiz
GROUP BY style
ORDER BY style DESC;
               
-- The most common model purchased
SELECT DISTINCT(model_name), COUNT(*)
FROM purchase
GROUP BY 1
ORDER BY 2 DESC;       
               
-- prices from purchase
SELECT DISTINCT(price), COUNT(*) AS '# Purchase'
FROM purchase
GROUP BY 1               
ORDER BY 1;
               
-- Match style and Shape from quiz  
SELECT DISTINCT(shape), COUNT(*) AS '# of Women'
FROM quiz 
WHERE style LIKE 'Women%'               
GROUP BY 1
ORDER BY 2 DESC;


SELECT DISTINCT(shape), COUNT(*) AS '# of Men'
FROM quiz 
WHERE style LIKE 'Men%'               
GROUP BY 1
ORDER BY 2 DESC;                 
               
               