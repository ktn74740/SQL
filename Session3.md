Session 3 — MySQL Basics (Part 1)
Types of Data

Relational databases mainly work with structured data, but data in general can be categorized into three types.

Structured Data

Structured data is organized in a clear format with rows and columns and follows a fixed schema.
It is easy to query and analyze using SQL.

Example:
A table storing employee information with columns such as ID, Name, and Age.

Semi-Structured Data

Semi-structured data has some level of organization but does not follow a strict schema.
It usually uses key–value structures.

Examples include:

JSON

XML

Unstructured Data

Unstructured data does not follow a fixed format and is harder to query directly.

Examples:

Images

Videos

Text documents

What Is a Database

A database is a structured system used to store and manage data.
It is controlled by a Database Management System (DBMS).

A DBMS provides:

Efficient data storage

Fast data retrieval

Security and access control

Data consistency and integrity

Examples of popular DBMS systems include:

MySQL

PostgreSQL

Microsoft SQL Server

What Is SQL

SQL (Structured Query Language) is the language used to interact with relational databases.

It allows users to:

Create database structures

Insert data

Modify or delete records

Retrieve information

SQL itself does not store data; instead, it communicates with the database server that manages the data.

What Is a Schema

A schema is a logical container inside a database that organizes different database objects.

It works similarly to a folder that holds related items.

Types of Schema Objects
Tables

Tables store the actual data in the database using rows and columns.

Views

Views are virtual tables created from SQL queries. They do not store data themselves but display results from other tables.

Stored Procedures

Stored procedures are predefined sets of SQL commands stored in the database that can be reused.

Functions

Functions are similar to procedures but are designed to return a single value.

Categories of SQL Commands

SQL commands are divided into different categories based on their purpose.

DDL — Data Definition Language

Used to define or modify the structure of database objects.

Examples:

CREATE

ALTER

DROP

TRUNCATE

DML — Data Manipulation Language

Used to work with the data inside tables.

Examples:

INSERT

UPDATE

DELETE

DQL — Data Query Language

Used to retrieve data from the database.

Main command:

SELECT

DCL — Data Control Language

Used to manage user permissions and access rights.

Examples:

GRANT

REVOKE

TCL — Transaction Control Language

Used to manage database transactions.

Examples:

COMMIT

ROLLBACK

SAVEPOINT

Data Integrity: NULL and Keys
NULL vs NOT NULL

NULL

Represents missing or unknown data

It is not the same as zero or an empty value

NOT NULL

Ensures that a column must always contain a value

Prevents incomplete data from being stored

Primary Key

A Primary Key uniquely identifies each row in a table.

Rules:

Cannot contain NULL values

Cannot have duplicate values

Foreign Key

A Foreign Key links one table to another.

It ensures referential integrity, meaning related data remains consistent across tables.

Table Relationships
Parent–Child Relationship

In relational databases, tables are often connected.

The Parent table stores the main data and contains the Primary Key

The Child table references the parent using a Foreign Key

This relationship prevents orphan records (records that reference data that does not exist).

Referential Actions

Referential actions define what happens when parent records change.

RESTRICT

Prevents deletion of a parent row if related child rows exist.

CASCADE

Automatically deletes or updates child records when the parent record changes.

Constraints

Constraints are rules applied to tables to maintain data accuracy and consistency.

Common constraints include:

PRIMARY KEY

Ensures each row has a unique identifier.

FOREIGN KEY

Creates relationships between tables.

NOT NULL

Requires a column to always contain a value.

UNIQUE

Prevents duplicate values.

CHECK

Validates data using a condition
Example: Age must be greater than or equal to 18.

DEFAULT

Automatically assigns a value if none is provided.

Database Inspection and Management
information_schema

information_schema is a system database that contains metadata about the database structure.

It can be used to inspect:

Table definitions

Column details

Constraints and relationships

Safe Mode

Safe Mode is a MySQL feature designed to prevent accidental changes.

When enabled:

UPDATE and DELETE statements require a WHERE clause

This helps avoid accidentally modifying all rows in a table.

Removing Data: DROP vs DELETE vs TRUNCATE
DELETE

Removes specific rows from a table

Can use a WHERE condition

Changes can be rolled back within a transaction

TRUNCATE

Removes all rows from a table

Much faster than DELETE

Cannot be rolled back in most cases

DROP

Completely removes the table from the database

Deletes both the table structure and its data