{%- macro drop_snowflake_db_from_share(variables) -%}

{#
To delete a database created from a share we need the following variables:
    shares [VARIABLE SET]
        db_name [STRING]
#}

{% for share in variables.shares %}
    USE ROLE SECURITYADMIN;

    DROP ROLE IF EXISTS ROLE_{{ share.db_name }}_RO;

    USE ROLE ACCOUNTADMIN;

    DROP DATABASE IF EXISTS {{ share.db_name }};
{% endfor %}
{%- endmacro -%}