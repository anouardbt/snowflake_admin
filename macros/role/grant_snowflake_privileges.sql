{%- macro grant_snowflake_privileges(variables) -%}

{#
This script is used to grant a set of privileges on a certain object to a role.

See the following page for a definition of allowed privileges and objects:
https://docs.snowflake.com/en/sql-reference/sql/grant-privilege

Input variables:
    privileges [VARIABLE SET]
        role [STRING]
        object_type [STRING]
        object_name [STRING] - ignored for ACCOUNT object
        privileges [LIST[STRING]]
#}
{%- for privilege in variables.privileges -%}
    {%- set role = privilege.get("role") -%}
    {%- set object_type = privilege.get("object_type") -%}
    {%- set privileges = privilege.get("privileges") -%}

    {% if object_type == "ACCOUNT" %}
        USE ROLE ACCOUNTADMIN;
        GRANT {{ privileges|join(',') }} ON {{ object_type }} TO ROLE {{ role }};
    {% else %}
        USE ROLE SECURITYADMIN;
        GRANT {{ privileges|join(',') }} ON {{ object_type }} {{ object_name }} TO ROLE {{ role }};
    {% endif %}
{%- endfor -%}

{%- endmacro -%}