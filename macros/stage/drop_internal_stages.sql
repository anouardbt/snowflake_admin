{#
This script will generate an internal stage to store UDFs. Also all current UDFs are uploaded into the stage.

Required variables:
    db_name [STRING]
    schema [STRING]
    stage [VARIABLE SET]
        stage_name: [STRING]
#}
{% macro drop_internal_stages(variables) %}
    {% for stage in variables.stages %}

    --using the recommended role to create objects in snowflake
    USE ROLE SYSADMIN;
    USE DATABASE {{ db_name }};
    USE SCHEMA {{ schema }};

    -- Drop internal stage
    DROP STAGE IF EXISTS {{ stage.stage_name }};
    {% endfor %}
{% endmacro %}
