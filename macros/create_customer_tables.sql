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
        {% set build_schema = schema if target.name == 'prod' else target.schema %}

        {% for model in models %}

            -- Prefix with customer schema when not in prod
            {% set build_model = model if target.name == 'prod' else schema + '_' + model %}

            {% set model_sql %}

            -- _2 suffix just to distinguish between other way of building these objects
            create or replace table {{ target.database }}.{{ build_schema }}.{{ build_model }}_2 as
                {{ customer_model(model, schema) }};

            {% endset %}

            {% do run_query(model_sql) %}

            {% do log(build_schema ~ '.' ~ build_model ~ ' Successfully Built!', info=true) %}

        {% endfor %}

    {% endfor %}

{% endmacro %}
