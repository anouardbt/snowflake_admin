{% macro run_flow(tasks) %}
    {% set all_macros = {
        "create_internal_stages": create_internal_stages,
        "create_udfs": create_udfs,
        "create_masking_policies": create_masking_policies,
        "create_snowflake_roles": create_snowflake_roles,
        "create_snowflake_databases": create_snowflake_databases,
        "create_snowflake_schemas": create_snowflake_schemas,
        "set_snowflake_timezone": set_snowflake_timezone,
        "grant_snowflake_privileges": grant_snowflake_privileges,
        "create_snowflake_warehouses": create_snowflake_warehouses,
        "create_snowflake_resource_monitors": create_snowflake_resource_monitors,
        "create_snowflake_db_from_share": create_snowflake_db_from_share,
        "create_snowflake_users": create_snowflake_users,
        "grant_snowflake_roles": grant_snowflake_roles,
        "create_snowflake_account": create_snowflake_account,
        "create_snowflake_tables": create_snowflake_tables,
        "tagging_setup": tagging_setup,
        "create_tags": create_tags,
        "assign_tags": assign_tags
    } %}

    {% set sql %}

    {% for task in tasks %}
        BEGIN TRANSACTION;
        {% if "variables" in task %}
            {{ all_macros[task.macro](task.variables) }}
        {% else %}
            {{ all_macros[task.macro]() }}
        {% endif %}
        COMMIT;
    {% endfor %}

    {% endset %}
    
    {% do print("######## Flow SQL code ########")%}
    {% do print(sql) %}
    {% do print("###############################") %}

    {% if var("DRY_RUN", True) %}
        {% do print("Dry run mode is enabled. No code will be executed.")%}
    {% else %}
        {% do print("Executing SQL code...")%}
        {% do run_query(sql) %}
    {% endif %}
{% endmacro %}