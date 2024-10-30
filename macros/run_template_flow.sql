{% macro run_template_flow(branch_name, dry_run=True) %}
  {% set config = {
    "tasks": [
      {
        "macro": "set_snowflake_timezone",
        "variables": {
          "timezone": "UTC"
        }
      },
      {
        "macro": "create_snowflake_roles",
        "variables": {
          "roles": [
            {
              "role_name": "ROLE_DATA_ENGINEER_" ~ branch_name,
              "comment": "Role used by data engineers for branch " ~ branch_name
            },
            {
              "role_name": "ROLE_ANALYTICS_ENGINEER_{{ branch_name }}" ~ branch_name,
              "comment": "Role used by analytics engineers"
            }
          ]
        }
      },
      {
        "macro": "create_snowflake_warehouses",
        "variables": {
          "warehouses": [
            {
              "wh_name": "COMPUTE_WH",
              "wh_size": "XSMALL",
              "wh_user_roles": ["PUBLIC"]
            },
            {
              "wh_name": "DATA_ENGINEER_WH",
              "wh_size": "XSMALL",
              "wh_user_roles": ["ROLE_DATA_ENGINEER"]
            },
            {
              "wh_name": "ANALYTICS_ENGINEER_WH",
              "wh_size": "XSMALL",
              "wh_user_roles": ["ROLE_ANALYTICS_ENGINEER"]
            }
          ]
        }
      },
      {
        "macro": "create_snowflake_resource_monitors",
        "variables": {
          "resource_monitors": [
            {
              "monitor_name": "DATA_ENGINEER_MONITOR",
              "credit_quota": 5,
              "warehouses": ["DATA_ENGINEER_WH"],
              "trigger_definitions": [
                {
                  "threshold": 50,
                  "action": "NOTIFY"
                },
                {
                  "threshold": 90,
                  "action": "NOTIFY"
                },
                {
                  "threshold": 100,
                  "action": "NOTIFY"
                }
              ]
            },
            {
              "monitor_name": "ANALYTICS_ENGINEER_MONITOR",
              "credit_quota": 5,
              "warehouses": ["ANALYTICS_ENGINEER_WH"],
              "trigger_definitions": [
                {
                  "threshold": 50,
                  "action": "NOTIFY"
                },
                {
                  "threshold": 90,
                  "action": "NOTIFY"
                },
                {
                  "threshold": 100,
                  "action": "NOTIFY"
                }
              ]
            },
            {
              "monitor_name": "ACCOUNT_MONITOR",
              "credit_quota": 250,
              "trigger_definitions": [
                {
                  "threshold": 50,
                  "action": "NOTIFY"
                },
                {
                  "threshold": 90,
                  "action": "NOTIFY"
                },
                {
                  "threshold": 100,
                  "action": "NOTIFY"
                }
              ]
            }
          ]
        }
      },
      {
        "macro": "create_snowflake_databases",
        "variables": {
          "databases": [
            {
              "db_name": "RAW",
              "comment": "Database for the raw data layer. Also known as ingestion layer or landing area. Stores unprocessed data ingested from a data source."
            },
            {
              "db_name": "ANALYTICS",
              "comment": "Database for the analytics data layer. Used by dbt for data models."
            }
          ]
        }
      },
      {
        "macro": "grant_snowflake_roles",
        "variables": {
          "grants": [
            {
              "grantee_name": "ROLE_DATA_ENGINEER",
              "grantee_type": "role",
              "roles": ["ROLE_RAW_RW", "ROLE_ANALYTICS_RO"]
            },
            {
              "grantee_name": "ROLE_ANALYTICS_ENGINEER",
              "grantee_type": "ROLE",
              "roles": ["ROLE_RAW_RO", "ROLE_ANALYTICS_RW"]
            }
          ]
        }
      },
      {
        "macro": "create_snowflake_schemas",
        "variables": {
          "schemas": [
            {
              "schema_name": "DBT_DEMO",
              "db_name": "RAW",
              "comment": "Schema for data for demoing dbt object management for Snowflake"
            },
            {
              "schema_name": "DBT_DEMO",
              "db_name": "ANALYTICS",
              "comment": "Analytics schema for dbt demo"
            }
          ]
        }
      },
      {
        "macro": "create_snowflake_tables",
        "variables": {
          "tables": [
            {
              "db": "RAW",
              "schema": "DBT_DEMO",
              "table": "dbt_demo"
            }
          ]
        }
      }
    ]
  } %}
  {% do run_flow(config.tasks) %}
{% endmacro %}