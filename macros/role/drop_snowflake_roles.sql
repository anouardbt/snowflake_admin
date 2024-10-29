{%- macro drop_snowflake_roles(variables) -%}

{#
In this script we drop a set of roles.
#}

{#
To drop a set of roles we need the following variables:
    roles [VARIABLE SET]
        role_name [STRING]
#}

USE ROLE SECURITYADMIN;

{%- for role in variables.roles -%}
    DROP ROLE IF EXISTS {{ role.role_name }};
{%- endfor -%}
{%- endmacro -%}