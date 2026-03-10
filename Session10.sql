USE sakila;

-- =========================================
-- SESSION 10 : INDEXING & QUERY FINE-TUNING
-- =========================================


-- ===============================
-- 1) INDEXING BASICS
-- ===============================

-- Index = data structure (B-Tree in MySQL)
-- helps database find rows faster instead of scanning entire table

SELECT *
FROM customer
WHERE last_name = 'SMITH';


-- ===============================
-- 2) PRIMARY KEY (CLUSTERED INDEX)
-- ===============================

-- In InnoDB the primary key is the clustered index
-- table rows are stored physically in primary key order

SELECT *
FROM customer
WHERE customer_id = 5;


-- ===============================
-- 3) SECONDARY (NON-CLUSTERED) INDEX
-- ===============================

-- check query execution plan
EXPLAIN
SELECT *
FROM customer
WHERE last_name = 'SMITH';


-- create secondary index
CREATE INDEX idx_customer_lastname
ON customer(last_name);


-- check plan again after index creation
EXPLAIN
SELECT *
FROM customer
WHERE last_name = 'SMITH';


-- extra practice: check index effect on another column
EXPLAIN
SELECT *
FROM customer
WHERE store_id = 1;


-- ===============================
-- 4) NATURAL KEY VS SURROGATE KEY
-- ===============================

-- natural key example (real-world meaning)
CREATE TABLE employee_natural (
    ssn CHAR(11) PRIMARY KEY,
    emp_name VARCHAR(100),
    department VARCHAR(50)
);

-- surrogate key example (recommended approach)
CREATE TABLE employee_surrogate (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    ssn CHAR(11),
    emp_name VARCHAR(100),
    department VARCHAR(50)
);

INSERT INTO employee_surrogate (ssn, emp_name, department)
VALUES
('123-45-6789','Alice','Finance'),
('123-45-6789','Bob','IT');


-- ===============================
-- 5) QUERY FINE TUNING PRACTICES
-- ===============================


-- avoid SELECT * when possible
SELECT first_name, last_name
FROM customer;


-- filter rows early using WHERE before GROUP BY
SELECT store_id,
       COUNT(*) AS total_customers
FROM customer
WHERE active = 1
GROUP BY store_id
HAVING COUNT(*) > 200;


-- JOIN often performs better than nested subqueries
SELECT c.first_name
FROM customer c
JOIN store s
  ON c.store_id = s.store_id
WHERE s.address_id = 1;


-- avoid applying functions on indexed columns
EXPLAIN
SELECT *
FROM rental
WHERE YEAR(rental_date) = 2005;


-- better version preserving index usage
EXPLAIN
SELECT *
FROM rental
WHERE rental_date BETWEEN '2005-01-01' AND '2005-12-31';


-- limit result set when exploring large tables
SELECT *
FROM film
ORDER BY film_id
LIMIT 1000;


-- analyze execution plan
EXPLAIN
SELECT *
FROM customer
WHERE store_id = 1;


-- using CTE to simplify complex logic
WITH high_value_customers AS (
    SELECT customer_id,
           SUM(amount) AS total_paid
    FROM payment
    GROUP BY customer_id
    HAVING SUM(amount) > 100
)
SELECT c.first_name,
       c.last_name,
       hv.total_paid
FROM customer c
JOIN high_value_customers hv
  ON c.customer_id = hv.customer_id;


-- maintain optimizer statistics
ANALYZE TABLE customer;
OPTIMIZE TABLE rental;


-- pagination optimization example
SELECT *
FROM payment
LIMIT 1000,10;


-- better pagination approach
SELECT *
FROM payment
WHERE payment_id > 1000
LIMIT 10;


-- ===============================
-- INDEX DESIGN NOTES
-- ===============================

-- indexes work best on high-cardinality columns
-- avoid indexing columns with very few distinct values


-- ===============================
-- CONCEPT QUESTIONS (CLASS DISCUSSION)
-- ===============================

-- Q1: what happens if a column is not indexed?
-- database performs a full table scan (reads every row)


-- Q2: does an index store full table rows?
-- no, it stores indexed value + pointer to primary key row


-- Q3: why is primary key called clustered index?
-- because table rows are physically stored in PK order


-- Q4: can a table have multiple clustered indexes?
-- no, only one clustered index per table


-- Q5: how secondary index lookup works
-- step1: search secondary index
-- step2: get primary key reference
-- step3: fetch actual row from clustered index


-- Q6: do indexes always improve performance?
-- they speed up SELECT but slow INSERT/UPDATE/DELETE


-- Q7: natural vs surrogate key
-- natural: real-world value (email, ssn)
-- surrogate: artificial numeric id (recommended)


-- Q8: are all primary keys natural keys?
-- no, most systems use surrogate keys


-- Q9: are all natural keys primary keys?
-- no, they are often enforced using UNIQUE constraints


-- Q10: why optimizer sometimes ignores an index
-- low selectivity, functions on column, outdated stats


ANALYZE TABLE customer;


-- cleanup example index if needed
DROP INDEX idx_customer_lastname ON customer;