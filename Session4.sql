USE sakila;

-- DQL is mainly used to read data from tables using SELECT

-- full actor table
SELECT *
FROM actor;

-- picking only the columns needed
SELECT actor_id, first_name, last_name
FROM actor;


-- DISTINCT helps remove repeated values from the output
SELECT DISTINCT first_name
FROM actor;

SELECT DISTINCT rating
FROM film;

-- extra practice: list all unique rental durations available in films
SELECT DISTINCT rental_duration
FROM film
ORDER BY rental_duration;


-- COUNT is an aggregate function used to measure rows or values
SELECT COUNT(*) AS total_film_rows
FROM film;

SELECT COUNT(title) AS non_null_titles
FROM film;

SELECT COUNT(DISTINCT title) AS unique_titles
FROM film;

SELECT COUNT(first_name) AS total_first_names
FROM actor;

SELECT COUNT(DISTINCT first_name) AS unique_first_names
FROM actor;


-- LIMIT is useful when you only want to preview a few rows
SELECT first_name, last_name
FROM actor
LIMIT 5;

-- extra practice: show first 8 customers from the customer table
SELECT customer_id, first_name, last_name
FROM customer
LIMIT 8;


-- WHERE filters rows before they are returned
SELECT film_id, title, original_language_id
FROM film
WHERE original_language_id IS NULL;

SELECT film_id, title, length
FROM film
WHERE length >= 92;

SELECT film_id, title, rating, length
FROM film
WHERE rating = 'R'
  AND length >= 92;


-- ORDER BY is used to sort the result
SELECT title, rental_rate
FROM film;

SELECT title, rental_rate
FROM film
ORDER BY rental_rate DESC;

SELECT title, rental_rate
FROM film
ORDER BY rental_rate ASC;


-- combining conditions with AND / OR
SELECT film_id, title, rating, rental_duration, rental_rate
FROM film
WHERE rating = 'PG'
  AND rental_duration = 5
ORDER BY rental_rate;

SELECT film_id, title, rating, rental_duration, rental_rate
FROM film
WHERE rating = 'PG'
   OR rental_duration = 5
ORDER BY rental_rate;


-- NOT, <> and NOT IN help exclude values
SELECT film_id, title, rental_duration, rental_rate
FROM film
WHERE rental_duration NOT IN (6, 7, 3)
ORDER BY rental_rate;

SELECT film_id, title, rental_duration, rental_rate
FROM film
WHERE rental_duration <> 6
ORDER BY rental_rate;

SELECT film_id, title, rental_duration, rental_rate
FROM film
WHERE NOT rental_duration = 6
ORDER BY rental_rate;


-- parentheses help control condition priority
SELECT film_id, title, rental_duration, rating, rental_rate
FROM film
WHERE rental_duration = 6
  AND (rating = 'G' OR rating = 'PG')
ORDER BY rental_rate;


-- LIKE is used for pattern matching
SELECT city
FROM city
WHERE city LIKE 'A%s';

SELECT city
FROM city
WHERE city LIKE '_a_';

-- extra practice: cities ending with the letter "a"
SELECT city
FROM city
WHERE city LIKE '%a';


-- NULL means value is missing or unknown
SELECT rental_id, inventory_id, customer_id, return_date
FROM rental
WHERE return_date IS NULL;

SELECT rental_id, inventory_id, customer_id, return_date
FROM rental
WHERE return_date IS NOT NULL
LIMIT 10;


-- BETWEEN checks values inside an inclusive range
SELECT rental_id, inventory_id, customer_id, return_date
FROM rental
WHERE return_date BETWEEN '2005-05-26' AND '2005-05-30';


-- GROUP BY is used when aggregate values are needed per category/group
SELECT customer_id, COUNT(*) AS total_rentals
FROM rental
GROUP BY customer_id
ORDER BY total_rentals DESC;

SELECT customer_id, COUNT(*) AS repeat_count
FROM rental
GROUP BY customer_id
ORDER BY repeat_count DESC;

-- extra practice: number of films available in each rating category
SELECT rating, COUNT(*) AS film_count
FROM film
GROUP BY rating
ORDER BY film_count DESC;


-- HAVING filters grouped results after aggregation
SELECT customer_id, COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id
HAVING COUNT(*) <= 30
ORDER BY rental_count DESC;

SELECT customer_id, SUM(amount) AS total_paid
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 100
ORDER BY total_paid DESC;


-- aliases make output easier to read
SELECT customer_id, SUM(amount) AS total_paid
FROM payment
GROUP BY customer_id
ORDER BY total_paid DESC;

SELECT a.first_name, a.last_name
FROM actor AS a
LIMIT 10;


-- WHERE vs HAVING:
-- WHERE filters rows first, HAVING filters grouped data later
SELECT customer_id, COUNT(*) AS payments_above_5
FROM payment
WHERE amount > 5
GROUP BY customer_id
ORDER BY payments_above_5 DESC;

SELECT customer_id, SUM(amount) AS total_amount
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 100
ORDER BY total_amount DESC;


-- execution order concept:
-- FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY -> LIMIT

SELECT film_id, title, length
FROM film
ORDER BY length DESC
LIMIT 10;

SELECT rating, COUNT(*) AS total_films
FROM film
GROUP BY rating
ORDER BY total_films DESC;

SELECT city
FROM city
WHERE city LIKE '%an%';

SELECT customer_id, COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id
HAVING COUNT(*) = 30
ORDER BY customer_id;