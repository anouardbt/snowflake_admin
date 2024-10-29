{%- macro create_snowflake_warehouses(variables) -%}

{#
This template is used to create a new virtual warehouse on Snowflake.

It requires the following variables:
    warehouses [VARIABLE SET]
        wh_name [STRING]
        wh_size ['XSMALL' | 'SMALL' | 'MEDIUM' | 'LARGE' | 'XLARGE' | 'XXLARGE' | 'XXXLARGE' | 'X4LARGE' | 'X5LARGE' | 'X6LARGE']
        wh_user_roles [LIST[STRING]]

The following variables are optional:
    wh_type ['STANDARD' | 'SNOWPARK-OPTIMIZED']
    wh_scaling_policy ['STANDARD' | 'ECONOMY'] - only for Snowflake Enterprise Edition or higher
    wh_auto_suspend [NUMBER]
    wh_auto_resume [BOOLEAN]
    wh_initially_suspended [BOOLEAN]
    wh_comment [STRING]
    wh_query_acceleration [BOOLEAN] - only for Snowflake Enterprise Edition or higher
#}
{%- for warehouse in variables.warehouses -%}
    USE ROLE SYSADMIN;

    CREATE OR REPLACE WAREHOUSE {{ warehouse.wh_name }}
        WAREHOUSE_TYPE = {{ warehouse.wh_type|default("STANDARD") }}
        WAREHOUSE_SIZE = {{ warehouse.wh_size }}
        {% if wh_scaling_policy is defined and wh_scaling_policy|length %}
            SCALING_POLICY = {{ warehouse.wh_scaling_policy }}
        {% endif %}
        AUTO_SUSPEND = {{ warehouse.wh_auto_suspend|default(120) }}
        AUTO_RESUME = {{ warehouse.wh_auto_resume|default("TRUE") }}
        INITIALLY_SUSPENDED = {{ warehouse.wh_initially_suspended|default("TRUE") }}
        COMMENT = '{{ warehouse.wh_comment|default('Created by DBT') }}'
        {% if wh_query_acceleration is defined %}
            ENABLE_QUERY_ACCELERATION = {{ warehouse.wh_query_acceleration }}
        {% endif %};

    USE ROLE SECURITYADMIN;

    {% for wh_user_role in warehouse.wh_user_roles %}
        GRANT USAGE ON WAREHOUSE {{ warehouse.wh_name }} TO ROLE {{ wh_user_role }};
    {% endfor %}

{% endfor %}
{%- endmacro -%}