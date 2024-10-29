{%- macro create_snowflake_schemas(variables) -%}

{#
The create a schema, this script will create the schema in the specified database and will create
RO and RW roles which are inherited by the DB_RO and DB_RW role, this way permissions are
granular enough that if we decide to grant permissions on a specific schema we can do this
but if we need to grant permissions on the database we can manage permissions with ease.

Required variables:
    schemas [VARIABLE SET]
        db_name [STRING]
        schema_name [STRING]
        comment [STRING]
#}

{%- for schema in variables.schemas -%}
{%- set schema_name = schema.get("schema_name") -%}
{%- set db_name = schema.get("db_name") -%}
{%- set comment = schema.get("comment") -%}

    --using the recommended role to create objects in snowflake
    USE ROLE SYSADMIN;
    USE DATABASE {{ db_name }};

    CREATE SCHEMA IF NOT EXISTS {{ db_name }}.{{ schema_name }}
    WITH COMMENT = '{{ comment }}';

    -- Using security admin to create the roles
    USE ROLE SECURITYADMIN;

    -- Creating roles if they do not exist

    -- Creating read role
    CREATE ROLE IF NOT EXISTS ROLE_{{ db_name }}_{{ schema_name }}_RO
    WITH COMMENT = 'Role that can read all objects in schema {{ db_name }}.{{ schema_name }}';

    -- Creating read/write role
    CREATE ROLE IF NOT EXISTS ROLE_{{ db_name }}_{{ schema_name }}_RW
    WITH COMMENT = 'Role that can read and write all objects in schema {{ db_name }}.{{ schema_name }}';

    -- Granting usage on database
    GRANT USAGE ON DATABASE {{ db_name }}
    TO ROLE ROLE_{{ db_name }}_{{ schema_name }}_RO;

    GRANT USAGE ON DATABASE {{ db_name }}
    TO ROLE ROLE_{{ db_name }}_{{ schema_name }}_RW;

    -- Granting usage on schema
    GRANT USAGE ON SCHEMA {{ db_name }}.{{ schema_name }}
    TO ROLE ROLE_{{ db_name }}_{{ schema_name }}_RO;

    GRANT USAGE ON SCHEMA {{ db_name }}.{{ schema_name }}
    TO ROLE ROLE_{{ db_name }}_{{ schema_name }}_RW;

    -- Grant permissions on current and future tables in schema

    -- To RO role - select only
    GRANT SELECT ON ALL TABLES IN SCHEMA {{ db_name }}.{{ schema_name }}
    TO ROLE ROLE_{{ db_name }}_{{ schema_name }}_RO;
    GRANT SELECT ON FUTURE TABLES IN SCHEMA {{ db_name }}.{{ schema_name }}
    TO ROLE ROLE_{{ db_name }}_{{ schema_name }}_RO;

    GRANT SELECT ON ALL VIEWS IN SCHEMA {{ db_name }}.{{ schema_name }}
    TO ROLE ROLE_{{ db_name }}_{{ schema_name }}_RO;
    GRANT SELECT ON FUTURE VIEWS IN SCHEMA {{ db_name }}.{{ schema_name }}
    TO ROLE ROLE_{{ db_name }}_{{ schema_name }}_RO;

    -- To RW role - all privileges
    GRANT ALL ON SCHEMA {{ db_name }}.{{ schema_name }}
    TO ROLE ROLE_{{ db_name }}_{{ schema_name }}_RW;

    GRANT ALL ON ALL TABLES IN SCHEMA {{ db_name }}.{{ schema_name }}
    TO ROLE ROLE_{{ db_name }}_{{ schema_name }}_RW;
    GRANT ALL ON FUTURE TABLES IN SCHEMA {{ db_name }}.{{ schema_name }}
    TO ROLE ROLE_{{ db_name }}_{{ schema_name }}_RW;

    GRANT ALL ON ALL VIEWS IN SCHEMA {{ db_name }}.{{ schema_name }}
    TO ROLE ROLE_{{ db_name }}_{{ schema_name }}_RW;
    GRANT ALL ON FUTURE VIEWS IN SCHEMA {{ db_name }}.{{ schema_name }}
    TO ROLE ROLE_{{ db_name }}_{{ schema_name }}_RW;

    GRANT ROLE ROLE_{{ db_name }}_{{ schema_name }}_RO
    TO ROLE ROLE_{{ db_name }}_{{ schema_name }}_RW;

    GRANT ROLE ROLE_{{ db_name }}_{{ schema_name }}_RO
    TO ROLE ROLE_{{ db_name }}_RO;

    GRANT ROLE ROLE_{{ db_name }}_{{ schema_name }}_RW
    TO ROLE ROLE_{{ db_name }}_RW;

    -- Following snowflake best practice and granting all custom roles to sysadmin
    GRANT ROLE ROLE_{{ db_name }}_{{ schema_name }}_RO
    TO ROLE SYSADMIN;

    GRANT ROLE ROLE_{{ db_name }}_{{ schema_name }}_RW
    TO ROLE SYSADMIN;

{% endfor %}
{%- endmacro -%}