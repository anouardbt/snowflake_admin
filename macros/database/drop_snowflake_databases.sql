{%- macro drop_snowflake_databases(variables) -%}

{#
Before we drop the database we remove the RO and RW permissions
this way we are cleaning up after ourselves and do not have lots of permissions
hanging around related to the database once it has been dropped
#}

{#
To drop a database we need the following variables:
    databases [VARIABLE SET]
        db_name [STRING]
#}

{%- for db in variables.databases -%}

    USE ROLE SECURITYADMIN;

    DROP ROLE IF EXISTS ROLE_{{ db.db_name }}_RO;
    DROP ROLE IF EXISTS ROLE_{{ db.db_name }}_RW;

    USE ROLE SYSADMIN;
    DROP DATABASE IF EXISTS {{ db.db_name }};

{%- endfor -%}
{%- endmacro -%}