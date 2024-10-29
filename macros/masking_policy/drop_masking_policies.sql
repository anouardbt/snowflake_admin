{% macro drop_masking_policies(variables) %}
    {% for policy in variables.policies %}
        --using the recommended role to create objects in snowflake
        USE ROLE SYSADMIN;
        USE DATABASE {{ policy.db_name }};
        USE SCHEMA {{ policy.schema_name }};

        -- Drop masking policy and UDF

        ALTER TABLE IF EXISTS {{ policy.table }} modify column {{ policy.column }} UNSET MASKING POLICY;

        DROP MASKING POLICY IF EXISTS {{ policy.table }}_pii_masking;

    {% endfor %}
{% endmacro %}