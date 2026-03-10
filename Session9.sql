USE sakila;

-- ===============================
-- 1) STORED PROCEDURES CONCEPT
-- ===============================

-- A stored procedure is a reusable SQL program stored in the database
-- It can contain multiple SQL statements and accept parameters


-- ===============================
-- 2) DELIMITER
-- ===============================

-- MySQL normally ends commands with ;
-- For procedures we temporarily change it so MySQL doesn't stop too early

-- ===============================
-- 3) STORED PROCEDURE WITH IN PARAMETER
-- ===============================

DROP PROCEDURE IF EXISTS GetCustomerPayments;

DELIMITER //

CREATE PROCEDURE GetCustomerPayments(IN cust_id INT)
BEGIN
    SELECT payment_id,
           amount,
           payment_date
    FROM payment
    WHERE customer_id = cust_id;
END;
//

DELIMITER ;

-- example call
CALL GetCustomerPayments(7);


-- ===============================
-- 4) STORED PROCEDURE WITH OUT PARAMETER
-- ===============================

DROP PROCEDURE IF EXISTS CustomerTotalPaid;

DELIMITER //

CREATE PROCEDURE CustomerTotalPaid(IN cust_id INT, OUT total_paid DECIMAL(10,2))
BEGIN
    SELECT SUM(amount) INTO total_paid
    FROM payment
    WHERE customer_id = cust_id;
END;
//

DELIMITER ;

-- example usage
CALL CustomerTotalPaid(6, @total);
SELECT @total;


-- ===============================
-- 5) DYNAMIC SQL IN STORED PROCEDURE
-- ===============================

-- dynamic SQL builds a query as a string and executes it

DROP PROCEDURE IF EXISTS CountRowsDynamic;

DELIMITER //

CREATE PROCEDURE CountRowsDynamic(IN table_name VARCHAR(64))
BEGIN
    SET @query_text = CONCAT('SELECT COUNT(*) AS total_rows FROM ', table_name);

    PREPARE stmt FROM @query_text;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END;
//

DELIMITER ;

CALL CountRowsDynamic('sakila.customer');


-- ===============================
-- 6) INOUT PARAMETER PROCEDURE
-- ===============================

-- INOUT parameter acts as both input and output

DROP PROCEDURE IF EXISTS AddCustomerRentals;

DELIMITER //

CREATE PROCEDURE AddCustomerRentals(IN cust_id INT, INOUT rental_counter INT)
BEGIN
    SELECT COUNT(*) + rental_counter INTO rental_counter
    FROM rental
    WHERE customer_id = cust_id;
END;
//

DELIMITER ;

SET @rent_count = 0;
CALL AddCustomerRentals(3, @rent_count);
SELECT @rent_count;


-- ===============================
-- 7) INFORMATION_SCHEMA (METADATA)
-- ===============================

-- information_schema stores metadata about database objects

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'sakila';

-- extra practice: list columns for film table
SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'sakila'
AND table_name = 'film';


-- ===============================
-- 8) PROGRAM USING CURSOR + DYNAMIC SQL
-- ===============================

-- create temporary table to store generated queries
DROP TEMPORARY TABLE IF EXISTS select_queries;

CREATE TEMPORARY TABLE select_queries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    query_text TEXT
);

DELIMITER //

CREATE PROCEDURE StoreSelectQueries(IN db_name VARCHAR(64))
BEGIN
    DECLARE finished INT DEFAULT FALSE;
    DECLARE table_var VARCHAR(64);

    DECLARE table_cursor CURSOR FOR
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = db_name;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = TRUE;

    OPEN table_cursor;

    read_loop: LOOP
        FETCH table_cursor INTO table_var;

        IF finished THEN
            LEAVE read_loop;
        END IF;

        SET @query_build = CONCAT('SELECT COUNT(*) FROM ', db_name, '.', table_var, ';');

        INSERT INTO select_queries(query_text)
        VALUES (@query_build);

    END LOOP;

    CLOSE table_cursor;
END;
//

DELIMITER ;

-- run the procedure
CALL StoreSelectQueries('sakila');

-- check generated queries
SELECT *
FROM select_queries;