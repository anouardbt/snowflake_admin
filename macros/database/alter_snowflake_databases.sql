{%- macro alter_snowflake_databases(variables) -%}

{#
In this script we are renaming the database and updating the role names.
This way we are keeping the naming convention consistent and ensuring
linked objects are easier to identify
#}
{#
To ALTER a list of databases we need the following variables:
    databases [VARIABLE SET]
        old_db_name [STRING]
        new_db_name [STRING]
#}

{%- for db in variables.databases -%}

    {% if 'old_db_name' in db  and 'new_db_name' in db and db.old_db_name|length and db.new_db_name|length %}
        ALTER DATABASE IF EXISTS {{ db.old_db_name }} RENAME TO {{ db.new_db_name }};

        USE ROLE SECURITYADMIN;

        ALTER ROLE IF EXISTS ROLE_{{ db.old_db_name }}_RO RENAME TO ROLE_{{ db.new_db_name }}_RO;
        ALTER ROLE IF EXISTS ROLE_{{ db.new_db_name }}_RO SET COMMENT = 'Role that can read all objects in
        all schemas in {{ db.new_db_name }}';

        ALTER ROLE IF EXISTS ROLE_{{ db.old_db_name }}_RW RENAME TO ROLE_{{ db.new_db_name }}_RW;
        ALTER ROLE IF EXISTS ROLE_{{ db.new_db_name }}_RW SET COMMENT = 'Role that can read and write to all
        objects in all schemas in {{ db.new_db_name }}';

        -- snowflake best practice is to ensure all custom roles go to SYSADMIN
        GRANT ROLE ROLE_{{ db.new_db_name }}_RO
        TO ROLE SYSADMIN;
        GRANT ROLE ROLE_{{ db.new_db_name }}_RW
        TO ROLE SYSADMIN;
    {% endif %}

{%- endfor -%}
{%- endmacro -%}