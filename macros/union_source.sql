{% macro union_source(schema_pattern, table_pattern) %}

    {% set relations = dbt_utils.get_relations_by_pattern(
        schema_pattern=schema_pattern,
        table_pattern=table_pattern
    ) %}

    {{ dbt_utils.union_relations(relations=relations, source_column_name='_customer_schema') }}

{% endmacro %}
