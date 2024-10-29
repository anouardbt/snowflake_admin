{%- macro create_snowflake_tables(variables) -%}
{#
This template creates one or more tables for the Snowflake raw layer.

Required variables:
    tables [VARIABLE SET]
        db [STRING]
        schema [STRING]
        table [STRING]
#}

USE ROLE SECURITYADMIN;

{% for table in variables.tables %}
    USE ROLE ROLE_DATA_ENGINEER;

    CREATE TABLE IF NOT EXISTS {{ table.db }}.{{ table.schema }}.{{ table.table }} (
        RECORD_METADATA VARIANT,
        RECORD_CONTENT VARIANT,
        __INGESTED_AT TIMESTAMP DEFAULT SYSDATE()
    );
{% endfor %}

{%- endmacro -%}