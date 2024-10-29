{%- macro drop_snowflake_warehouses(variables) -%}

{#
This template is used to drop a warehouse on Snowflake.

It requires the following variables:
    warehouses [VARIABLE SET]
        wh_name [STRING]

#}
{%- for warehouse in variables.warehouses -%}
    USE ROLE SYSADMIN;
    DROP WAREHOUSE IF EXISTS {{ wh_name }};

{% endfor %}
{%- endmacro -%}