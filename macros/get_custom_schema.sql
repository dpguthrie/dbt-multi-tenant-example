{% macro generate_schema_name(custom_schema_name, node) -%}
    {{ generate_schema_name_for_env(custom_schema_name, node) }}
{%- endmacro %}

{% macro generate_alias_name(custom_alias_name=none, node=none) -%}

    {%- if custom_alias_name is none or target.name != 'prod' -%}

        {{ node.name }}

    {%- else -%}

        {{ custom_alias_name | trim }}

    {%- endif -%}

{%- endmacro %}