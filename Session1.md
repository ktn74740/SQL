Data Engineering

Raw data coming from logs, transactions, APIs, and applications is usually messy, incomplete, and unreliable. Because of this, it cannot be used directly for analysis.

Data Engineering focuses on building systems that transform this raw data into something reliable and useful for analysis.

Data vs Information

Data (Raw Data)

Basic facts without context

Example: 100, "John"

Information (Processed Data)

Data that has meaning after processing

Example: “John scored 100 marks”

Meaning is not stored in the raw data itself — it is created after processing.
Data engineers make the data usable, while analysts and data scientists interpret it to generate insights.

Data Engineering Lifecycle

Data always moves through a series of stages. If any stage fails, the entire data pipeline can break.

1. Data Collection

Data is generated from different sources such as:

Applications

APIs

Sensors

Databases

At this stage the data is raw and untrusted.

2. Data Ingestion

This step moves the collected data into the data system.

There are two common ingestion methods:

Batch Processing

Runs on a schedule

Cheaper and easier to manage

Real-time Processing

Continuous data flow

More complex but faster insights

3. Data Processing (Transformation)

This is where raw data becomes structured and usable.

Common operations include:

Cleaning data

Removing duplicates

Joining multiple datasets

Aggregating results

Tools often used here include:

SQL

Apache Spark

4. Data Storage

Processed data is stored in specialized systems:

Data Lakes

Store raw and semi-structured data

Flexible storage format

Data Warehouses

Structured storage

Optimized for fast analytical queries

5. Data Analysis

Once data is clean and structured, it can be analyzed using BI tools and analytics systems.

6. Data Consumption

The final step where data generates business value through:

Dashboards

APIs

Machine Learning models

ETL vs ELT
ETL (Extract → Transform → Load)

In this approach:

Data is extracted from sources

Transformed and cleaned

Then loaded into storage

Advantages:

Strong control over data quality

Disadvantages:

Less flexible when data needs to be reprocessed

ELT (Extract → Load → Transform)

Here:

Data is extracted

Loaded into storage first

Transformation happens later

Why ELT is popular today:

Cloud storage is inexpensive

Raw data can be stored and reprocessed later if needed

Key Technologies in the Data Engineering Stack
Hadoop

Hadoop introduced the idea of distributed storage and processing.

It uses:

HDFS for distributed storage

Cluster-based processing for handling large datasets

Apache Spark

Spark is a modern data processing engine.

Key features:

Parallel processing

In-memory computation

Much faster than older systems

Snowflake

Snowflake is a cloud-based data warehouse.

Important characteristics:

Separates compute from storage

Automatically scales

Built specifically for analytics workloads rather than transactional systems

Automation vs Orchestration
Automation

Automation refers to a single task running automatically.

Example:

A script that runs daily to process data.

Orchestration

Orchestration manages the entire workflow, including:

Task order

Dependencies between tasks

Failure handling

Retries

Scheduling

Example:
Task B should start only after Task A completes successfully.

A widely used orchestration tool is Apache Airflow.

Data Engineering Architecture Overview

A typical data engineering system moves data from multiple sources to final consumers.

Data Sources

Raw data can originate from:

Operational databases (MySQL, PostgreSQL)

APIs

Files such as JSON or CSV

Event streaming systems like Kafka

This data is usually untrusted and unstructured.

Data Ingestion

Data is moved into the platform through:

Batch pipelines (scheduled jobs)

Real-time streaming pipelines

Technologies used include Kafka and Python.

Data Lake (Raw Storage)

A Data Lake acts as a centralized storage system.

Characteristics:

Stores data in its original format

Highly scalable and cost-effective

Uses schema-on-read

Common platforms:

Amazon S3

Google Cloud Storage

It acts as a single source of truth for raw data.

Data Processing and Refinement

This stage transforms raw data into structured datasets.

Processing engines such as Spark or SQL systems perform operations like:

Deduplication

Data joins

Data transformations

The goal is to produce clean and standardized datasets.

Data Warehouse (Analytics Layer)

A data warehouse stores structured and optimized data for analytical queries.

Examples:

Snowflake

BigQuery

These systems are optimized for:

Reporting

Business intelligence

Analytical workloads

They are not designed for transactional operations.

Data Consumption

At this stage the data is used to generate business insights.

Common outputs include:

Dashboards (Tableau, Power BI)

APIs

Machine learning models

Orchestration Layer

Orchestration tools coordinate the entire pipeline.

They manage:

Job scheduling

Task dependencies

Error handling

Monitoring

Examples:

Airflow

Prefect

This layer acts as the central controller of the data pipeline.

Medallion Architecture

The Medallion Architecture organizes data into three quality layers.

Bronze Layer (Raw Data Layer)

The Bronze layer stores raw data exactly as it arrives from sources such as APIs or event streams.

Characteristics:

Schema-on-read

Contains duplicates or errors

Preserves the full historical record

Its main purpose is data recovery and traceability.

Silver Layer (Cleaned Data Layer)

In the Silver layer, raw data is cleaned and structured.

Typical operations include:

Deduplication

Filtering invalid data

Basic validation

Joining data from different sources

This layer produces reliable datasets suitable for analysis.

Gold Layer (Business-Ready Layer)

The Gold layer contains fully curated datasets ready for business use.

Characteristics:

Aggregated metrics

Business-level data models

Optimized for performance

This layer is used directly by:

Dashboards

Reports

Machine learning models