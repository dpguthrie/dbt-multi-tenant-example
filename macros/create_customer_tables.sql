{% macro create_customer_tables() %}

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

        -- Only build in customer schemas when in prod
        {% set schema = schema if target.name == 'prod' else target.schema %}

        {% do log('Schema is: ' ~ schema, info=True) %}

        {% for model in models %}

            {% set model_sql %}

            -- _2 suffix just to distinguish between other way of building these objects
            create or replace table {{ target.database }}.{{ schema }}.{{ model }}_2 as
                {{ customer_model(model, schema) }};

            {% endset %}

            {% do run_query(model_sql) %}

            {% do log(schema ~ '.' ~ model ~ ' Successfully Built!', info=true) %}

        {% endfor %}

    {% endfor %}

{% endmacro %}
