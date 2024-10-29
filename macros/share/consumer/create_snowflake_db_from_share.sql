{%- macro create_snowflake_db_from_share(variables) -%}

{#
To create a database from a share we need the following variables:
    shares [VARIABLE SET]
        provider_account [STRING]
        share_name [STRING]
        db_name [STRING]
#}

{% for share in variables.shares %}
    USE ROLE ACCOUNTADMIN;

    CREATE DATABASE IF NOT EXISTS {{ share.db_name }}
    FROM SHARE {{ share.provider_account }}.{{ share.share_name }};

    USE ROLE SECURITYADMIN;

    CREATE ROLE IF NOT EXISTS ROLE_{{ share.db_name }}_RO
    WITH COMMENT = 'Role that can read all objects in all schemas in {{ share.db_name }}';

    GRANT IMPORTED PRIVILEGES ON DATABASE {{ share.db_name }} TO ROLE_{{ share.db_name }}_RO;

    GRANT ROLE ROLE_{{ share.db_name }}_RO TO ROLE SYSADMIN;

    GRANT ROLE ROLE_{{ share.db_name }}_RO TO ROLE PUBLIC;

{% endfor %}
{%- endmacro -%}