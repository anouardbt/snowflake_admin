{%- macro create_snowflake_roles(variables) -%}

{#
In this script we create a set of roles, along with comments and optionally preexisting roles they should be assigned.
#}

{#
To create a set of roles we need the following variables:
    roles [VARIABLE SET]
        role_name [STRING]
        comment [STRING]
        role_assignments [list of STRING]
#}

USE ROLE SECURITYADMIN;

{%- for role in variables.roles -%}
{%- set role_name = role.get("role_name") -%}
{%- set comment = role.get("comment") -%}

CREATE ROLE IF NOT EXISTS {{ role_name }}
WITH COMMENT = '{{ comment }}';

GRANT ROLE {{ role_name }} TO ROLE SYSADMIN;

{% if "role_assignments" in role %}
    {% set role_assignments = role.get("role_assignments") %}
    {% set grants = { "grants": [{"grantee_name": role_name,
        "grantee_type": "role",
        "roles": role_assignments}] } %}
    {{ grant_snowflake_roles(grants) }}
{% endif %}

{%- endfor -%}
{%- endmacro -%}