USE sakila;

-- JOIN is used to connect related tables through matching keys

-- INNER JOIN keeps only rows that match in both tables
SELECT f.title,
       l.name AS language_name
FROM film f
INNER JOIN language l
    ON f.language_id = l.language_id;

-- extra practice: customer with matching address
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       a.address
FROM customer c
INNER JOIN address a
    ON c.address_id = a.address_id;


-- LEFT JOIN keeps all rows from the left table even if right side is missing
SELECT f.title,
       c.name AS category_name
FROM film f
LEFT JOIN film_category fc
    ON f.film_id = fc.film_id
LEFT JOIN category c
    ON fc.category_id = c.category_id;

SELECT c.customer_id,
       c.first_name,
       r.rental_id
FROM customer c
LEFT JOIN rental r
    ON c.customer_id = r.customer_id;


-- MySQL does not support FULL OUTER JOIN directly
-- common workaround = LEFT JOIN + UNION + RIGHT JOIN
SELECT a.actor_id,
       a.first_name,
       fa.film_id
FROM actor a
LEFT JOIN film_actor fa
    ON a.actor_id = fa.actor_id

UNION

SELECT a.actor_id,
       a.first_name,
       fa.film_id
FROM actor a
RIGHT JOIN film_actor fa
    ON a.actor_id = fa.actor_id;


SELECT c.customer_id,
       r.rental_id
FROM customer c
LEFT JOIN rental r
    ON c.customer_id = r.customer_id

UNION

SELECT c.customer_id,
       r.rental_id
FROM customer c
RIGHT JOIN rental r
    ON c.customer_id = r.customer_id;


-- SELF JOIN means a table is joined with itself
SELECT s1.staff_id AS staff_1,
       s2.staff_id AS staff_2,
       s1.store_id
FROM staff s1
JOIN staff s2
    ON s1.store_id = s2.store_id
WHERE s1.staff_id <> s2.staff_id;

SELECT *
FROM staff;


-- small demo table for self join practice
CREATE TABLE sakila.branch_staff_demo (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    branch_no INT
);

INSERT INTO sakila.branch_staff_demo (emp_id, emp_name, branch_no)
VALUES
    (1, 'Asha', 1),
    (2, 'Ravi', 1),
    (3, 'Kunal', 2),
    (4, 'Megha', 2),
    (5, 'Tarun', 1);

SELECT d1.emp_id AS employee_1_id,
       d1.emp_name AS employee_1_name,
       d2.emp_id AS employee_2_id,
       d2.emp_name AS employee_2_name,
       d1.branch_no
FROM sakila.branch_staff_demo d1
JOIN sakila.branch_staff_demo d2
    ON d1.branch_no = d2.branch_no
   AND d1.emp_id <> d2.emp_id
ORDER BY d1.branch_no, d1.emp_id;


-- EXISTS returns TRUE if at least one matching row is found
SELECT DISTINCT p.customer_id, p.rental_id
FROM payment p
WHERE EXISTS (
    SELECT 1
    FROM rental r
    WHERE r.customer_id = p.customer_id
);

-- extra practice: customers who have at least one rental
SELECT c.customer_id,
       c.first_name,
       c.last_name
FROM customer c
WHERE EXISTS (
    SELECT 1
    FROM rental r
    WHERE r.customer_id = c.customer_id
);


-- UNION combines results and removes duplicates
SELECT s.email
FROM customer c
LEFT JOIN staff s
    ON 1 = 0

UNION

SELECT s.email
FROM staff s
LEFT JOIN customer c
    ON 1 = 0;


-- CROSS JOIN creates every possible combination of rows
SELECT c.customer_id,
       s.staff_id
FROM customer c
CROSS JOIN staff s;


-- normalization reduces duplicate data and improves consistency
-- denormalization keeps repeated data to improve read performance in some cases