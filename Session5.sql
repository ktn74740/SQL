USE sakila;

-- string functions are used to format, extract, search, and manipulate text values

SELECT title
FROM film;

SELECT title,
       LPAD(RPAD(title, 20, '*'), 25, '*') AS padded_title
FROM film
LIMIT 5;

SELECT title,
       LPAD(title, 20, '*') AS left_pad_only
FROM film
LIMIT 5;

-- SUBSTRING extracts part of a string using starting position and length
SELECT title,
       SUBSTRING(title, 1, 9) AS short_title
FROM film;

SELECT CONCAT(first_name, '.', last_name) AS customer_tag
FROM customer;

SELECT title,
       REVERSE(title) AS reversed_title
FROM film
LIMIT 5;

SELECT title,
       LENGTH(title) AS bytes_in_title
FROM film
WHERE LENGTH(title) = 8;

SELECT email
FROM customer;

SELECT email,
       SUBSTRING(email, LOCATE('@', email) + 1) AS email_domain
FROM customer;

SELECT email,
       SUBSTRING_INDEX(SUBSTRING(email, LOCATE('@', email) + 1), '.', -1) AS domain_end
FROM customer;

SELECT SUBSTRING_INDEX(email, '@', 1) AS email_user
FROM customer;

SELECT title,
       UPPER(title) AS upper_title,
       LOWER(title) AS lower_title
FROM film
WHERE UPPER(title) LIKE '%LOVELY%'
   OR UPPER(title) LIKE '%MAN';

SELECT title,
       LOWER(title) AS lower_title
FROM film;

-- LEFT and RIGHT help inspect prefixes and suffixes in text
SELECT LEFT(title, 2) AS start_part,
       RIGHT(title, 3) AS end_part,
       COUNT(*) AS film_count
FROM film
GROUP BY LEFT(title, 2), RIGHT(title, 3)
ORDER BY film_count DESC;

SELECT LEFT(title, 2) AS start_part,
       RIGHT(title, 3) AS end_part,
       title
FROM film;

-- CASE is useful for labeling values into custom groups
SELECT last_name,
       CASE
           WHEN LEFT(last_name, 1) BETWEEN 'A' AND 'M' THEN 'Group A-M'
           WHEN LEFT(last_name, 1) BETWEEN 'N' AND 'Z' THEN 'Group N-Z'
           ELSE 'Other'
       END AS name_bucket
FROM customer;

SELECT title,
       REPLACE(title, 'A', 'x') AS replaced_title
FROM film
WHERE title LIKE '% %';

-- REGEXP allows pattern-based searching
SELECT customer_id, last_name
FROM customer
WHERE last_name NOT REGEXP '[^aeiouAEIOU]{3}';

SELECT LOWER(title) AS title_in_lower
FROM film
WHERE title REGEXP '[aeiouAEIOU]$';

SELECT title,
       RIGHT(title, 2) AS last_two_letters
FROM film
WHERE title REGEXP '[eE]$';

SELECT RIGHT(title, 1) AS ending_letter,
       COUNT(*) AS total_titles
FROM film
WHERE title REGEXP '[aeiouAEIOU]$'
GROUP BY RIGHT(title, 1);

SELECT title,
       RIGHT(title, 1) AS ending_letter
FROM film
WHERE title REGEXP '[Ee]$';

-- extra practice: titles that begin with a vowel
SELECT title
FROM film
WHERE title REGEXP '^[AEIOUaeiou]';

-- extra practice: count customers whose last names start with S
SELECT COUNT(*) AS last_names_starting_s
FROM customer
WHERE last_name REGEXP '^[Ss]';


-- math functions are used for calculations, rounding, random values, and numeric transformations

-- in MySQL, ^ means bitwise XOR, not exponent
SELECT title,
       rental_rate,
       rental_rate ^ 3 AS xor_result
FROM film;

SELECT customer_id,
       COUNT(payment_id) AS payment_count,
       SUM(amount) AS total_amount,
       SUM(amount) / COUNT(payment_id) AS avg_amount
FROM payment
GROUP BY customer_id;

SELECT rental_duration, cost_efficiency_dup1
FROM film;

SELECT rental_duration
FROM film;

-- this adds a new practice column to the existing film table
ALTER TABLE film
ADD COLUMN cost_efficiency_dup1 DECIMAL(6,2);

SET SQL_SAFE_UPDATES = 0;

UPDATE film
SET cost_efficiency_dup1 = rental_duration * 2
WHERE length IS NOT NULL;

SELECT *
FROM film;

SELECT customer_id,
       RAND() * 100 AS random_decimal,
       FLOOR(RAND() * 100) AS random_integer
FROM customer
LIMIT 5;

-- POWER is the correct way to do exponents in MySQL
SELECT film_id,
       rental_duration,
       POWER(rental_duration, 2) AS squared_duration
FROM film
LIMIT 5;

SELECT film_id,
       length,
       MOD(length, 60) AS extra_minutes
FROM film;

SELECT rental_rate,
       CEIL(rental_rate) AS rounded_up,
       FLOOR(rental_rate) AS rounded_down
FROM film;

SELECT rental_rate,
       ROUND(replacement_cost / rental_rate, 0) AS whole_ratio,
       ROUND(replacement_cost / rental_rate, 1) AS one_decimal_ratio
FROM film;

-- extra practice: check which films have even rental_duration values
SELECT film_id, title, rental_duration
FROM film
WHERE MOD(rental_duration, 2) = 0;

-- extra practice: compare replacement cost against rental rate
SELECT film_id,
       title,
       replacement_cost,
       rental_rate,
       ROUND(replacement_cost - rental_rate, 2) AS cost_gap
FROM film
LIMIT 10;


-- date and time functions help extract, compare, and format date values

SELECT rental_id,
       return_date,
       rental_date,
       DATEDIFF(return_date, rental_date) AS rental_days
FROM rental
WHERE return_date IS NOT NULL;

SELECT last_update,
       DAYNAME(last_update) AS day_name,
       MONTHNAME(last_update) AS month_name
FROM film;

SELECT rental_date,
       YEAR(rental_date) AS rental_year
FROM rental;

SELECT payment_date
FROM payment;

SELECT payment_date,
       DATE(payment_date) AS payment_day,
       SUM(amount) AS total_paid
FROM payment
GROUP BY DATE(payment_date), payment_date
ORDER BY payment_day DESC;

SELECT *
FROM payment;

SELECT customer_id, amount, payment_date
FROM payment
WHERE payment_date >= NOW() - INTERVAL 1 DAY;

SELECT MAX(payment_date)
FROM payment;

SELECT customer_id, amount, payment_date
FROM payment
WHERE payment_date >= (
    SELECT MAX(payment_date) - INTERVAL 10 DAY
    FROM payment
);

SELECT NOW() - INTERVAL 1 DAY AS yesterday_time;

SELECT CONCAT('Today is: ', CURDATE()) AS today_message;
SELECT CONCAT('Current timestamp: ', NOW()) AS current_message;

SELECT NOW(), CURDATE(), CURRENT_TIME;

-- extra practice: how many payments happened on each calendar date
SELECT DATE(payment_date) AS payment_day,
       COUNT(*) AS number_of_payments
FROM payment
GROUP BY DATE(payment_date)
ORDER BY payment_day;

-- extra practice: latest rental recorded in the table
SELECT MAX(rental_date) AS latest_rental_date
FROM rental;


-- CAST converts one data type into another

ALTER TABLE payment
ADD COLUMN amount_str VARCHAR(20);

SET SQL_SAFE_UPDATES = 0;

UPDATE payment
SET amount_str = CAST(amount AS CHAR);

SELECT *
FROM customer;

SELECT *
FROM payment;

ALTER TABLE payment
DROP COLUMN amount_str;

SELECT amount,
       amount_str,
       amount + 10 AS numeric_add,
       amount_str + 10 AS string_add
FROM payment
LIMIT 5;

SHOW COLUMNS FROM payment;
SELECT CAST('2017-08-25' AS DATETIME) AS converted_datetime;