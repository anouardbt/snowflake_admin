{#
This script will generate an internal stage to store UDFs. Also all current UDFs are uploaded into the stage.

Required variables:
    db_name [STRING]
    schema [STRING]
    stage [VARIABLE SET]
        stage_name: [STRING]
#}
{% macro create_internal_stages(variables) %}
    {% for stage in variables.stages %}

        --using the recommended role to create objects in snowflake
        USE ROLE SYSADMIN;
        USE DATABASE {{ variables.db_name }};
        USE SCHEMA {{ variables.schema }};

        -- Setup internal stage and store UDFs
        CREATE STAGE IF NOT EXISTS {{ stage.stage_name }};
        PUT 'file://udfs/*.py' @{{ stage.stage_name }}
            OVERWRITE = TRUE;
    {% endfor %}
{% endmacro %}
