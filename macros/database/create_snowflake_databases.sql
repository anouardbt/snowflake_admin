{%- macro create_snowflake_databases(variables) -%}

{#
In this script we create a database along with a set of core roles to ensure we manage permissions consistently.
We distinguish between read-only and read/write roles.
in addition to that, we add comments to all objects so we are able to make sense of
why they were created and how they are linked.
#}

{#
To create a database we need the following variables:
    databases [VARIABLE SET]
        db_name [STRING]
        comment [STRING]
#}

{%- for database in variables.databases -%}
{%- set db_name = database.get("db_name") -%}
{%- set comment = database.get("comment") -%}

USE ROLE SYSADMIN;

CREATE DATABASE IF NOT EXISTS {{ db_name }}
WITH COMMENT = '{{ comment }}';

USE ROLE SECURITYADMIN;

CREATE ROLE IF NOT EXISTS ROLE_{{ db_name }}_RO
WITH COMMENT = 'Role that can read all objects in all schemas in {{ db_name }}';
CREATE ROLE IF NOT EXISTS ROLE_{{ db_name }}_RW
WITH COMMENT = 'Role that can read and write to all objects in all schemas in {{ db_name }}';

GRANT USAGE ON DATABASE {{ db_name }}
TO ROLE ROLE_{{ db_name }}_RO;

GRANT ALL PRIVILEGES ON DATABASE {{ db_name }}
TO ROLE ROLE_{{ db_name }}_RW;

GRANT USAGE ON ALL SCHEMAS IN DATABASE {{ db_name }}
TO ROLE ROLE_{{ db_name }}_RO;
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE {{ db_name }}
TO ROLE ROLE_{{ db_name }}_RO;
GRANT SELECT ON ALL TABLES IN DATABASE {{ db_name }}
TO ROLE ROLE_{{ db_name }}_RO;
GRANT SELECT ON FUTURE TABLES IN DATABASE {{ db_name }}
TO ROLE ROLE_{{ db_name }}_RO;
GRANT SELECT ON ALL VIEWS IN DATABASE {{ db_name }}
TO ROLE ROLE_{{ db_name }}_RO;
GRANT SELECT ON FUTURE VIEWS IN DATABASE {{ db_name }}
TO ROLE ROLE_{{ db_name }}_RO;

GRANT ALL PRIVILEGES ON ALL SCHEMAS IN DATABASE {{ db_name }}
TO ROLE ROLE_{{ db_name }}_RW;
GRANT ALL PRIVILEGES ON FUTURE SCHEMAS IN DATABASE {{ db_name }}
TO ROLE ROLE_{{ db_name }}_RW;
GRANT ALL PRIVILEGES ON ALL TABLES IN DATABASE {{ db_name }}
TO ROLE ROLE_{{ db_name }}_RW;
GRANT ALL PRIVILEGES ON FUTURE TABLES IN DATABASE {{ db_name }}
TO ROLE ROLE_{{ db_name }}_RW;
GRANT ALL PRIVILEGES ON ALL VIEWS IN DATABASE {{ db_name }}
TO ROLE ROLE_{{ db_name }}_RW;
GRANT ALL PRIVILEGES ON FUTURE VIEWS IN DATABASE {{ db_name }}
TO ROLE ROLE_{{ db_name }}_RW;

-- snowflake best practice to assign all custom roles to sysadmin

{# grant read access to local users by default #}
GRANT ROLE ROLE_{{ db_name }}_RO
TO ROLE PUBLIC;

GRANT ROLE ROLE_{{ db_name }}_RW
TO ROLE SYSADMIN;

GRANT ROLE ROLE_{{ db_name }}_RO
TO ROLE SYSADMIN;

{%- endfor -%}
{%- endmacro -%}