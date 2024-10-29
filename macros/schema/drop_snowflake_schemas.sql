{%- macro drop_snowflake_schemas(variables) -%}

{#
When deleting schema we should clear the roles so we do not have orphan roles
This script ensures we remove any roles related to the schema
#}
{#
To delete a schema we need the following variables:
    schemas [VARIABLE SET]
        db_name [STRING]
        schema_name [STRING]
#}

{%- for schema in variables.schemas -%}
{%- set schema_name = schema.get("schema_name") -%}
{%- set db_name = schema.get("db_name") -%}

    --using the recommended role to create objects in snowflake
    USE ROLE SYSADMIN;
    USE DATABASE {{ db_name }};

    DROP SCHEMA IF EXISTS {{ db_name }}.{{ schema.schema_name }};

    -- using security admin to drop the roles
    USE ROLE SECURITYADMIN;

    --Drop roles if they exist

    --Dropping read role
    DROP ROLE IF EXISTS ROLE_{{ db_name }}_{{ schema.schema_name }}_RO;

    --Dropping read write role
    DROP ROLE IF EXISTS ROLE_{{ db_name }}_{{ schema.schema_name }}_RW;

{% endfor %}
{%- endmacro -%}