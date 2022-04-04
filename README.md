# Schema-Based Multitenancy

This project is meant to showcase options for data modeling where each customer has their own individual schema within a database

## Loom

Watch a ~15 minute video detailing the options below:  https://www.loom.com/share/0461b3473e34495586fbeed54671425e

## Requirements

The [dbt_utils](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/) package is used in this project.  Specifically:

- [`get_relations_by_pattern`](https://github.com/dbt-labs/dbt-utils/tree/0.8.2/#get_relations_by_pattern-source)
- [`star`](https://github.com/dbt-labs/dbt-utils/tree/0.8.2/#star-source)
- [`union_relations`](https://github.com/dbt-labs/dbt-utils/tree/0.8.2/#union_relations-source)

## Options

Each of the options have a couple shared requirements:

- [`union_source`](macros/union_source.sql) macro will be used to create staging models that contain data for all customers
- [`customer_model`](macros/customer_model.sql) macro will be used to select from the "master" table (contains all customer data) and filter down to the appropriate customer.

### Option 1 (Explicit But Hard to Maintain)

This option requires that you explicitly create the models you'd like to replicate for each customer.  Some basic math:

- 5 dim/fct models to replicate for each customer
- 100 customers
- 500 models you'll need to create
- Each model will have to be prefixed with the customer (`cust_1_dim_customers.sql`, `cust_2_dim_customers.sql`, ..., `cust_n_dim_customers.sql`)

The benefit here is that we have explicitly defined our models and they'll be included in our lineage graph.  The downside of this approach is that it is not scalable and becomes very hard to maintain as more customers are added.

### Option 2 (Programmatic But Not Explicit)

This option requires that we create those same customer-specific fct/dim models through the use of a macro.  The macro will loop through each customer schema and defined set of models
and create tables by explicitly defining DDL.  We'll lose the lineage here but will be much more scalable as both customers and models to share increase.

The job for this option should be defined with at least the following commands (and in this order):

1. dbt run
2. dbt run-operation create_customer_tables

The first command will create the tables containing all customer data and the second command will run the macro to create customer-specific models.
