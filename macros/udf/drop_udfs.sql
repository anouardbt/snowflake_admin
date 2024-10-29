{#
This script will generate Python UDFs based on the required parameters and store them in an internal stage.

Required variables:
    db_name [STRING]
    schema [STRING]
    warehouse [STRING]
    udfs [VARIABLE SET]
        udf_name: [STRING]
        udf_args: [VARIABLE SET]
            name: [STRING]
            type: [STRING]
        udf_return_type: [STRING]
        udf_handler: [STRING]
        udf_stage: [STRING]
        udf_module_name: [STRING]
#}
{% macro drop_udfs(variables) %}
    {% for udf in variables.udfs %}

        --using the recommended role to create objects in snowflake
        USE ROLE SYSADMIN;
        USE DATABASE {{ variables.db_name }};
        USE SCHEMA {{ variables.schema }};
        USE WAREHOUSE {{ variables.warehouse }};

        -- Drop UDF

        DROP FUNCTION IF EXISTS {{ udf.udf_name }}({% for args in udf.udf_args %}{{ args.type }}{% if not loop.last %}, {% endif %}{% endfor %});

    {% endfor %}
{% endmacro %}