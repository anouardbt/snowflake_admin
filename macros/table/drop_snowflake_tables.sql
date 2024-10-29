{%- macro drop_snowflake_tables(variables) -%}
{#
This template drops one or more tables for the Snowflake raw layer.

Required variables:
    tables [VARIABLE SET]
        db [STRING]
        schema [STRING]
        table [STRING]
#}

USE ROLE SECURITYADMIN;

{% for table in variables.tables %}
    USE ROLE ROLE_DATA_ENGINEER;

    DROP TABLE IF EXISTS {{ table.db }}.{{ table.schema }}.{{ table.table }};
{% endfor %}

{%- endmacro -%}