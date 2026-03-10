-- creating a practice database for learning basic mysql concepts
CREATE DATABASE office_records;
USE office_records;

-- simple table for testing inserts and table changes
CREATE TABLE sample_users (
    user_id INT,
    full_name VARCHAR(100)
);

-- adding a few sample rows
INSERT INTO sample_users (user_id, full_name)
VALUES
    (1, 'Ananya'),
    (2, 'Rahul'),
    (3, 'Kiran');

-- mysql may allow this because of implicit conversion, but it is not a good practice
INSERT INTO sample_users (user_id, full_name)
VALUES (5, 5);

-- checking current data
SELECT * FROM sample_users;

-- adding a new column
ALTER TABLE sample_users
ADD contact_email VARCHAR(255);

-- renaming the column to something more readable
ALTER TABLE sample_users
RENAME COLUMN contact_email TO email_address;


-- removing the table first if it already exists
DROP TABLE IF EXISTS customers;

-- parent table
CREATE TABLE customers (
    customer_id INT NOT NULL UNIQUE,
    last_name VARCHAR(255) NOT NULL,
    first_name VARCHAR(255),
    age INT
);

-- valid inserts
INSERT INTO customers VALUES (1, 'Reddy', 'Arjun', 30);
INSERT INTO customers VALUES (2, 'Khan', NULL, NULL);

-- duplicate id, should raise an error
INSERT INTO customers VALUES (1, 'Patel', 'Meera', 25);

-- null in last_name, should also fail because of NOT NULL
INSERT INTO customers VALUES (3, NULL, 'Sneha', 28);

-- adding primary key explicitly
ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

-- checking constraints from information_schema
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'office_records'
AND TABLE_NAME = 'customers';

-- dropping and recreating primary key with a custom name
ALTER TABLE customers
DROP PRIMARY KEY;

ALTER TABLE customers
ADD CONSTRAINT pk_customers PRIMARY KEY (customer_id);


-- child table to show foreign key relationship
CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY,
    purchase_date DATE,
    customer_ref INT,
    FOREIGN KEY (customer_ref) REFERENCES customers(customer_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- valid child row
INSERT INTO purchases VALUES (2001, '2024-06-10', 1);

-- invalid because customer 999 does not exist
INSERT INTO purchases VALUES (2002, '2024-06-11', 999);

-- delete should fail because of ON DELETE RESTRICT
DELETE FROM customers WHERE customer_id = 1;

-- updating parent key should reflect in child table because of CASCADE
UPDATE customers
SET customer_id = 4
WHERE customer_id = 1;


-- table to practice check and default constraints
CREATE TABLE staff_info (
    staff_id INT NOT NULL,
    surname VARCHAR(255) NOT NULL,
    given_name VARCHAR(255),
    age INT CHECK (age >= 18),
    city_name VARCHAR(255) DEFAULT 'Chicago'
);

-- inserting without city so default should be applied
INSERT INTO staff_info (staff_id, surname, given_name, age)
VALUES (4, 'Joseph', 'Martin', 21);

-- disabling safe updates for practice
SET SQL_SAFE_UPDATES = 0;

-- deleting one row from sample table
DELETE FROM sample_users
WHERE user_id = 1;

-- removing all rows quickly
TRUNCATE TABLE sample_users;

-- dropping the whole table completely
DROP TABLE sample_users;

-- creating an index for faster lookup on last name
CREATE INDEX idx_customer_lastname
ON customers(last_name);

-- creating a view for adult customers only
CREATE VIEW adult_customers AS
SELECT customer_id, first_name, last_name
FROM customers
WHERE age >= 18;

-- checking the view
SELECT * FROM adult_customers;

-- simple join between parent and child tables
SELECT c.first_name, p.purchase_id, p.purchase_date
FROM customers c
JOIN purchases p
ON c.customer_id = p.customer_ref;

-- transaction example
START TRANSACTION;

INSERT INTO customers VALUES (10, 'Practice', 'User', 25);

-- undoing the insert
ROLLBACK;

-- ending transaction
COMMIT;


-- cleanup
DROP TABLE purchases;
DROP TABLE customers;
DROP TABLE staff_info;
DROP DATABASE office_records;