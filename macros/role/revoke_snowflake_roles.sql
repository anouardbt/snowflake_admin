{%- macro revoke_snowflake_roles(variables) -%}

{#
In this script we revoke roles specified from a user/role.
#}

{#
To assign a set of grants we need the following variables:
    grants [VARIABLE SET]
        grantee_name [STRING]
        grantee_type ['user'|'role']
        roles [list[STRING]]
#}

{% for grant in variables.grants %}
    {% for role in grant.roles %}
        REVOKE ROLE {{ role }} FROM {{ grant.grantee_type }} {{ grant.grantee_name }};
    {% endfor %}
{% endfor %}
{%- endmacro -%}