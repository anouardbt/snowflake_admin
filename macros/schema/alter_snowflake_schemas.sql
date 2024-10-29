{%- macro alter_snowflake_schemas(variables) -%}

{#
In the alter script we will update the schema name and as we do this we will
update the role names associated with the schema, this means it will be easier
to identify schemas and the roles associated with them
if a comment variable is provided we can alter the comment but it is not required.
#}
{#
To alter a schema we need the following variables:
    schemas [VARIABLE SET]
        db_name [STRING]
        old_schema_name [STRING]
        new_schema_name [STRING]
        comment [STRING]
#}

{%- for schema in variables.schemas -%}

    {% if 'old_schema_name' in schema and 'new_schema_name' in schema and schema.old_schema_name|length and schema.new_schema_name|length %}
        ALTER SCHEMA IF EXISTS {{ schema.db_name }}.{{ schema.old_schema_name }}
        RENAME TO {{ schema.new_schema_name }};

        {% if 'comment' in schema and schema.comment|length %}
            ALTER SCHEMA IF EXISTS {{ schema.db_name }}.{{ schema.new_schema_name }}
            SET COMMENT = '{{ schema.comment }}';
        {% endif %}

        -- using security admin to update the roles
        USE ROLE SECURITYADMIN;

        --Updating read role
        ALTER ROLE IF EXISTS ROLE_{{ schema.db_name }}_{{ schema.old_schema_name }}_RO
        RENAME TO ROLE_{{ schema.db_name }}_{{ schema.new_schema_name }}_RO;
        ALTER ROLE IF EXISTS ROLE_{{ schema.db_name }}_{{ schema.new_schema_name }}_RO
        SET COMMENT = 'Role that can read all objects in schema {{ schema.db_name }}.{{ schema.new_schema_name }}';

        --Updating read/write role
        ALTER ROLE IF EXISTS ROLE_{{ schema.db_name }}_{{ schema.old_schema_name }}_RW
        RENAME TO ROLE_{{ schema.db_name }}_{{ schema.new_schema_name }}_RW;
        ALTER ROLE IF EXISTS ROLE_{{ schema.db_name }}_{{ schema.new_schema_name }}_RW
        SET COMMENT = 'Role that can read and write all objects in schema {{ schema.db_name }}.{{ schema.new_schema_name }}';

        -- Following snowflake best practice and granting all custom roles to sysadmin
        GRANT ROLE ROLE_{{ schema.db_name }}_{{ schema.new_schema_name }}_RO
        TO ROLE SYSADMIN;

        GRANT ROLE ROLE_{{ schema.db_name }}_{{ schema.new_schema_name }}_RW
        TO ROLE SYSADMIN;
    {% endif %}
{% endfor %}
{%- endmacro -%}