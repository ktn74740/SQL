USE sakila;

-- STRING FUNCTIONS

SELECT title,
       SUBSTRING(title, 1, 3) AS short_title
FROM film;

SELECT CONCAT(first_name, ' @ ', last_name) AS display_name
FROM customer;

SELECT title,
       LENGTH(title) AS title_length
FROM film
WHERE LENGTH(title) > 15;


-- extract domain from email
SELECT email,
       SUBSTRING(email, LOCATE('@', email) + 1) AS domain_part
FROM customer;

SELECT email,
       SUBSTRING_INDEX(SUBSTRING(email, LOCATE('@', email) + 1), '.', 1) AS provider_name
FROM customer;

SELECT SUBSTRING_INDEX(email, '@', -1) AS email_tail
FROM customer;


-- case-insensitive search using UPPER
SELECT title
FROM film
WHERE UPPER(title) LIKE '%LOVELY%'
   OR UPPER(title) LIKE '%MAN';

SELECT title,
       LOWER(title) AS lower_title
FROM film;

-- extra practice
SELECT title
FROM film
WHERE UPPER(title) LIKE '%DOG%';


-- GROUPING FILMS BY FIRST AND LAST LETTER
SELECT LEFT(title, 1) AS first_letter,
       RIGHT(title, 1) AS last_letter,
       COUNT(*) AS film_count
FROM film
GROUP BY LEFT(title, 1), RIGHT(title, 1)
ORDER BY film_count DESC;

SELECT LEFT(title, 1) AS first_letter,
       RIGHT(title, 1) AS last_letter,
       title
FROM film;


-- CASE statement for grouping customers
SELECT last_name,
       CASE
           WHEN LEFT(last_name, 1) BETWEEN 'A' AND 'M' THEN 'Group A-M'
           WHEN LEFT(last_name, 1) BETWEEN 'N' AND 'Z' THEN 'Group N-Z'
           ELSE 'Other'
       END AS group_label
FROM customer;


-- replace characters
SELECT title,
       REPLACE(title, 'A', 'x') AS updated_title
FROM film
WHERE title LIKE '% %';


-- REGEXP examples
SELECT customer_id, last_name
FROM customer
WHERE last_name REGEXP '[^aeiouAEIOU]{3}';

SELECT title
FROM film
WHERE title REGEXP '[aeiouAEIOU]$';

SELECT RIGHT(title, 1) AS ending_letter,
       COUNT(*) AS total_titles
FROM film
WHERE title REGEXP '[aeiouAEIOU]$'
GROUP BY RIGHT(title, 1);


-- MATH OPERATIONS

SELECT title,
       rental_rate,
       rental_rate * 2 AS double_rate
FROM film;

SELECT customer_id,
       COUNT(payment_id) AS payment_count,
       SUM(amount) AS total_paid,
       SUM(amount) / COUNT(payment_id) AS avg_payment
FROM payment
GROUP BY customer_id;


-- ALTER TABLE modifies schema
ALTER TABLE film
ADD COLUMN cost_efficiency DECIMAL(6,2);

-- UPDATE modifies data
UPDATE film
SET cost_efficiency = replacement_cost / length
WHERE length IS NOT NULL;

SELECT *
FROM film;


-- DATE FUNCTIONS

SELECT rental_id,
       DATEDIFF(return_date, rental_date) AS days_rented
FROM rental
WHERE return_date IS NOT NULL;

SELECT MONTH(last_update)
FROM film;

SELECT DATE(payment_date) AS pay_date,
       SUM(amount) AS total_paid
FROM payment
GROUP BY DATE(payment_date)
ORDER BY pay_date DESC;

SELECT customer_id, amount, payment_date
FROM payment
WHERE payment_date >= NOW() - INTERVAL 1 DAY;

SELECT MAX(payment_date)
FROM payment;

SELECT customer_id, amount, payment_date
FROM payment
WHERE payment_date >= (
    SELECT MAX(payment_date) - INTERVAL 1 DAY
    FROM payment
);

SELECT NOW() - INTERVAL 1 DAY AS yesterday;

SELECT CONCAT('Today is: ', CURDATE());
SELECT CONCAT('Current time: ', NOW());

SELECT NOW(), CURDATE(), CURRENT_TIME;


-- SUBQUERIES

SELECT first_name, last_name
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM customer
);

SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id IN (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    HAVING COUNT(film_id) > 10
);


-- correlated subquery example
SELECT actor_id,
       first_name,
       last_name,
       (
           SELECT COUNT(*)
           FROM film_actor
           WHERE film_actor.actor_id = actor.actor_id
       ) AS film_count
FROM actor;


-- DERIVED TABLE (temporary result table)
SELECT a.actor_id, a.first_name, a.last_name, fa.film_count
FROM actor a
JOIN (
    SELECT actor_id, COUNT(film_id) AS film_count
    FROM film_actor
    GROUP BY actor_id
    HAVING COUNT(film_id) > 10
) fa
ON a.actor_id = fa.actor_id;


SELECT customer_id, total_spent
FROM (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
    ORDER BY total_spent DESC
    LIMIT 5
) AS top_customers;


SELECT *
FROM (
    SELECT last_name,
           CASE
               WHEN LEFT(last_name, 1) BETWEEN 'A' AND 'M' THEN 'Group A-M'
               WHEN LEFT(last_name, 1) BETWEEN 'N' AND 'Z' THEN 'Group N-Z'
               ELSE 'Other'
           END AS group_label
    FROM customer
) AS grouped_customers
WHERE group_label = 'Group N-Z';


-- compare value with aggregate result
SELECT customer_id, amount
FROM payment
WHERE amount > (
    SELECT AVG(amount)
    FROM payment
);


-- CORRELATED SUBQUERY example
SELECT title,
       (SELECT COUNT(*)
        FROM film_actor fa
        WHERE fa.film_id = f.film_id) AS actor_count
FROM film f;


SELECT payment_id, customer_id, amount, payment_date
FROM payment p1
WHERE amount > (
    SELECT AVG(amount)
    FROM payment p2
    WHERE p2.customer_id = p1.customer_id
);


-- ------------------------------------------------
-- RELATIONSHIP TYPES IN DATABASE DESIGN
-- ------------------------------------------------

-- 1:1 Relationship
-- each row in table A matches exactly one row in table B
-- example: user -> user_profile

-- 1:M Relationship
-- one parent row can have many child rows
-- example: customer -> orders

-- M:1 Relationship
-- many child rows belong to one parent
-- example: many orders belong to one customer

-- M:M Relationship
-- many rows from table A connect to many rows in table B
-- solved using a bridge/junction table
-- example: students <-> courses or actors <-> films

-- JOIN behavior notes
-- INNER JOIN returns only matching rows
-- LEFT JOIN returns all rows from left table and matching rows from right table
-- if no match exists, right-side columns become NULL