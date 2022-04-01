{% macro customer_model(model_name, customer_name) %}

    {% set rel = ref(model_name) %}

    {{ config(schema=customer_name, alias=model_name) }}

    select {{ dbt_utils.star(rel, except=['customer']) }}
    from {{ rel }}
    where customer = '{{ customer_name | upper }}'

{% endmacro %}