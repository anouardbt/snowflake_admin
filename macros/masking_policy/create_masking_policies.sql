{% macro create_masking_policies(variables) %}
    {% for policy in variables.policies %}
        --using the recommended role to create objects in snowflake
        USE ROLE SYSADMIN;
        USE DATABASE {{ variables.db_name }};
        USE SCHEMA {{ policy.schema_name }};
        USE WAREHOUSE COMPUTE_WH;

        -- Setup data masking on consumer table

        ALTER TABLE IF EXISTS {{ policy.table }} modify column {{ policy.column }} UNSET MASKING POLICY;

        CREATE OR REPLACE MASKING POLICY {{ policy.table }}_pii_masking AS (payload variant) returns variant ->
        {{ policy.masking_policy_udf }}(payload, {{ policy.fields }});

        ALTER TABLE IF EXISTS {{ policy.table }} modify column {{ policy.column }} set MASKING POLICY {{ policy.table }}_pii_masking;
    {% endfor %}
{% endmacro %}