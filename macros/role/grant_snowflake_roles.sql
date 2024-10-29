{%- macro grant_snowflake_roles(variables) -%}

{#
In this script we grant users/roles a list of roles specified for each user/role.
#}

{#
To assign a set of grants we need the following variables:
    grants [VARIABLE SET]
        grantee_name [STRING]
        grantee_type ['user'|'role']
        roles [list[STRING]]
#}
USE ROLE ACCOUNTADMIN;
{% for grant in variables.grants %}
    {% for role in grant.roles %}
        GRANT ROLE {{ role }} TO {{ grant.grantee_type }} {{ grant.grantee_name }};
    {% endfor %}
{% endfor %}
{%- endmacro -%}