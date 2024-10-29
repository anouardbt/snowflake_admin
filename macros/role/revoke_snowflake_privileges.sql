{%- macro revoke_snowflake_privileges(variables) -%}

{#
This script is used to revoke a set of privileges on a certain object from a role.

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
        REVOKE {{ privileges|join(',') }} ON {{ object_type }} FROM ROLE {{ role }};
    {% else %}
        USE ROLE SECURITYADMIN;
        REVOKE {{ privileges|join(',') }} ON {{ object_type }} {{ object_name }} FROM ROLE {{ role }};
    {% endif %}
{%- endfor -%}

{%- endmacro -%}