Session 2 — Big Data, Hadoop and Spark
Big Data and the Limits of Traditional Systems

Big Data refers to datasets that are extremely large, generated very quickly, or highly complex. Traditional databases and single-machine systems struggle to handle such data efficiently.

As organizations started dealing with terabytes and petabytes of data, several problems appeared:

Limited storage capacity on single servers

Very slow processing times

Increased chances of hardware failures

To overcome these challenges, distributed systems were introduced. In these systems, both data storage and computation are distributed across many machines working together.

Why Hadoop Was Developed

Hadoop was created to solve the challenges of processing massive amounts of data using clusters of inexpensive machines.

Its main goals are:

Store very large datasets reliably

Process data using parallel computation

Automatically recover from hardware failures

This approach allows organizations to scale their systems easily by adding more machines.

HDFS — Hadoop Distributed File System

HDFS is the storage component of Hadoop. Instead of storing files on a single machine, HDFS divides large files into smaller blocks and distributes them across multiple machines in the cluster.

Each block is replicated (usually three copies) so that data is not lost if one machine fails.

HDFS Components

NameNode

Maintains metadata about the file system

Tracks file names and block locations

Does not store the actual data

DataNode

Stores the real data blocks

Handles read and write operations

Communicates with the NameNode

YARN Architecture — Resource Management

YARN stands for Yet Another Resource Negotiator.
It manages resources in the Hadoop cluster and schedules jobs.

You can think of YARN as the operating system of the cluster.

Main Components

Resource Manager

The central authority of the cluster

Allocates resources to different applications

Node Manager

Runs on each machine in the cluster

Executes tasks assigned by the Resource Manager

MapReduce — Hadoop Processing Model

MapReduce is the processing model used in Hadoop for handling large-scale batch processing.

The process happens in two main stages:

Map Phase

The input data is broken down into smaller pieces and converted into key–value pairs.

Reduce Phase

The system aggregates and combines values that share the same key.

Important Note:
MapReduce only defines how data is processed. It does not enforce data quality or validation.

Why MapReduce Is Slow

One major limitation of MapReduce is that it relies heavily on disk operations.

For each stage of processing:

Data is read from disk

Processed

Written back to disk

This constant disk I/O causes slower execution, which led to the development of Apache Spark.

Apache Spark — Fast In-Memory Processing

Apache Spark was created as a faster alternative to MapReduce.

Unlike Hadoop MapReduce, Spark performs most computations in memory (RAM) instead of disk.

Benefits of Spark:

Faster processing

Better support for machine learning

Suitable for both batch and streaming workloads

Spark can still use storage systems such as:

HDFS

Amazon S3

Cloud storage platforms

Spark Architecture

A Spark system is composed of several components working together.

Spark Application

This is the job or program submitted by the user.

Driver Program

The driver acts as the controller of the application.
It creates the execution plan (DAG) and manages the overall job.

Cluster Manager

Responsible for allocating resources to Spark applications.

Examples include:

YARN

Kubernetes

Spark Standalone mode

Executors

Executors are worker processes that run tasks and perform computations.
They can also store intermediate data in memory.

RDD — Resilient Distributed Dataset

RDD is one of Spark’s core concepts.

An RDD is:

Distributed across multiple nodes

Immutable (cannot be changed once created)

Fault tolerant

If a node fails, Spark can recompute the lost data automatically.

RDDs enable efficient in-memory data processing.

DAG — Directed Acyclic Graph

Spark uses a DAG (Directed Acyclic Graph) to represent the execution plan of a job.

The DAG defines:

The sequence of operations

Dependencies between tasks

Spark only executes these operations when an action is triggered, allowing it to optimize the execution process.

Hadoop vs Spark Comparison
Feature	Hadoop (MapReduce)	Spark
Processing Type	Disk-based	In-memory
Speed	Slower	Faster
Supported Workloads	Batch processing only	Batch, Streaming, Machine Learning
Ease of Use	More complex	Easier for developers
Conceptual Mapping

Some Hadoop and Spark components play similar roles:

Hadoop NameNode → Spark Driver

Hadoop DataNode → Spark Executor

Hadoop MapReduce → Spark DAG execution

Hadoop Disk-based processing → Spark RAM-based processing

Big Data Ecosystem and Cloud Platforms

Even though technologies differ between cloud providers, the overall architecture and concepts remain similar.

AWS

S3 – Data lake storage

Glue – ETL service

Redshift – Data warehouse

Microsoft Azure

Blob Storage

Data Factory

Synapse Analytics

Google Cloud Platform (GCP)

Cloud Storage

Dataflow

BigQuery

Data Governance and Data Quality

Managing data properly requires governance practices.

Data Lineage

Tracks where data originates from and how it changes throughout the pipeline.

Data Cataloging

Creates a searchable inventory of datasets.

Examples:

AWS Glue Catalog

Apache Atlas

Data Quality

Ensures data accuracy using checks such as:

Schema validation

Null value checks

Data validation frameworks (e.g., Great Expectations)

Unit Testing

Testing ETL pipelines helps detect problems early and prevents pipeline failures.

Data Delivery and Real-Time Systems

Once data is processed and stored, it must be delivered to end users or applications.

Data Delivery

Common delivery methods include:

Dashboards (Power BI, Tableau)

APIs (FastAPI, Flask)

Real-Time Processing Tools

Some systems require real-time data processing, such as fraud detection or live alerts.

Common tools include:

Apache Kafka

Spark Streaming

Amazon Kinesis