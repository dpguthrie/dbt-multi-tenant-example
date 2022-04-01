{% if execute %}

-- Set models to create within each customer's schema
{% set models = [
    'dim_customers',
    'dim_parts',
    'dim_suppliers',
    'fct_order_items',
    'fct_orders'
] %}

-- Retrieve schemas to build objects into based on CUST_ prefix
{% set schemas_sql %}

select schema_name
from information_schema.schemata
where schema_name like 'CUST_%';

{% endset %}

{% set customer_schemas = run_query(schemas_sql).columns[0].values() %}

-- Loop through each customer, model and build in customer schema
{% for schema in customer_schemas %}

    {% for model in models %}

        use database {{ target.database }};

        -- _2 suffix just to distinguish between other way of building these objects
        create or replace table {{ schema }}.{{ model }}_2 as
            {{ customer_model(model, schema) }}

    {% endfor %}

{% endfor %}

{% endif %}