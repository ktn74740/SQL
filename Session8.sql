USE sakila;

-- ===============================
-- 1) COMMON TABLE EXPRESSIONS
-- ===============================

-- CTE creates a temporary named result set usable inside one query

WITH payment_totals AS (
    SELECT customer_id,
           SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
)
SELECT customer_id, total_spent
FROM payment_totals
ORDER BY total_spent DESC;


-- joining a CTE with another table
WITH payment_totals AS (
    SELECT customer_id,
           SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
)
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       pt.total_spent
FROM customer c
JOIN payment_totals pt
    ON c.customer_id = pt.customer_id
ORDER BY pt.total_spent DESC;


-- multiple CTEs in one query
WITH
payment_totals AS (
    SELECT customer_id,
           SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
),
top_spenders AS (
    SELECT customer_id, total_spent
    FROM payment_totals
    ORDER BY total_spent DESC
    LIMIT 5
)
SELECT ts.customer_id,
       c.first_name,
       c.last_name,
       ts.total_spent
FROM top_spenders ts
JOIN customer c
    ON ts.customer_id = c.customer_id;


-- validation query idea (checking logic quickly)
WITH payment_counts AS (
    SELECT customer_id,
           COUNT(*) AS total_payments
    FROM payment
    GROUP BY customer_id
)
SELECT *
FROM payment_counts
WHERE total_payments > 5;


-- ===============================
-- 2) RECURSIVE CTE
-- ===============================

-- recursive CTE calls itself until a condition stops

WITH RECURSIVE number_series AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM number_series
    WHERE n < 10
)
SELECT *
FROM number_series;


-- generate last 10 rental days and count rentals
WITH RECURSIVE rental_days AS (
    SELECT DATE(MAX(rental_date)) - INTERVAL 9 DAY AS rental_day
    FROM rental

    UNION ALL

    SELECT rental_day + INTERVAL 1 DAY
    FROM rental_days
    WHERE rental_day + INTERVAL 1 DAY <= (
        SELECT DATE(MAX(rental_date))
        FROM rental
    )
)
SELECT rd.rental_day,
       COUNT(r.rental_id) AS rental_count
FROM rental_days rd
LEFT JOIN rental r
    ON DATE(r.rental_date) = rd.rental_day
GROUP BY rd.rental_day;


-- ===============================
-- 3) TEMPORARY TABLES
-- ===============================

-- temporary tables exist only during the current session

DROP TEMPORARY TABLE IF EXISTS top_categories;

CREATE TEMPORARY TABLE top_categories AS
SELECT c.name AS category_name,
       c.category_id,
       COUNT(*) AS rental_count
FROM rental r
JOIN inventory i
    ON r.inventory_id = i.inventory_id
JOIN film f
    ON i.film_id = f.film_id
JOIN film_category fc
    ON f.film_id = fc.film_id
JOIN category c
    ON fc.category_id = c.category_id
GROUP BY c.name, c.category_id
ORDER BY rental_count DESC
LIMIT 5;


SELECT *
FROM top_categories;


-- reuse the temporary table for another query
SELECT tc.category_name,
       f.title
FROM top_categories tc
JOIN film_category fc
    ON tc.category_id = fc.category_id
JOIN film f
    ON fc.film_id = f.film_id
ORDER BY tc.category_name, f.title;


-- ===============================
-- 4) VIEWS
-- ===============================

-- a view stores a query, not the data itself

DROP VIEW IF EXISTS recent_rentals;

CREATE OR REPLACE VIEW recent_rentals AS
SELECT r.customer_id,
       MAX(r.rental_date) AS last_rental_date
FROM rental r
GROUP BY r.customer_id;


SELECT *
FROM recent_rentals;


-- joining a view with another table
SELECT c.first_name,
       c.last_name,
       rr.last_rental_date
FROM customer c
JOIN recent_rentals rr
    ON c.customer_id = rr.customer_id;


-- extra practice: customers who rented something in the last 30 days
SELECT c.first_name,
       c.last_name,
       rr.last_rental_date
FROM customer c
JOIN recent_rentals rr
    ON c.customer_id = rr.customer_id
WHERE rr.last_rental_date >= NOW() - INTERVAL 30 DAY;


-- ======================================
-- NOTES
-- ======================================

-- CTE: temporary result used inside one query
-- Recursive CTE: repeatedly calls itself to generate sequences

-- Temporary table:
-- stored during the session
-- good when you want to reuse intermediate results

-- View:
-- virtual table
-- stores query logic
-- runs the query each time it is used

-- performance note:
-- views recompute results each time
-- temporary tables are often faster for repeated analysis