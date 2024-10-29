{%- macro create_snowflake_resource_monitors(variables) -%}

{#
This template is used to create one or more new resource monitors on Snowflake.

It requires the following variables:
    resource_monitors [VARIABLE SET]:
        name [STRING]
        credit_quota [NUMBER]
        trigger_definitions [VARIABLE SET],
            threshold [NUMBER]
            action ['SUSPEND' | 'SUSPEND_IMMEDIATE' | 'NOTIFY']
        warehouses [LIST[STRING]]
            If you don't specify a list of warehouses, the monitor will be attached to the entire account.


    The following resource monitor properties are optional:
        frequency ['MONTHLY' | 'DAILY' | 'WEEKLY' | 'YEARLY' | 'NEVER']
        start_timestamp [STRING | 'IMMEDIATELY']
        end_timestamp [STRING]
        notify_users [LIST[STRING]

Note: account administrators will always receive email notifications.

Reference: https://docs.snowflake.com/en/sql-reference/sql/create-resource-monitor
#}

USE ROLE ACCOUNTADMIN; {# only ACCOUNTADMINs can create resource monitors #}

{% for resource_monitor in variables.resource_monitors %}
    CREATE OR REPLACE RESOURCE MONITOR {{ resource_monitor.monitor_name }} WITH
        CREDIT_QUOTA = {{ resource_monitor.credit_quota }}
    {% if "frequency" in resource_monitor and resource_monitor.frequency|length %}
        FREQUENCY = {{ resource_monitor.frequency }}
    {% endif %}
    {% if "start_timestamp" in resource_monitor and resource_monitor.start_timestamp|length %}
        START_TIMESTAMP = {{ "'{}'".format(resource_monitor.start_timestamp)
                                    if resource_monitor.start_timestamp.upper() != "IMMEDIATELY"
                                    else resource_monitor.start_timestamp }}
    {% endif %}
    {% if "end_timestamp" in resource_monitor and resource_monitor.end_timestamp|length %}
        END_TIMESTAMP = '{{ resource_monitor.end_timestamp }}'
    {% endif %}
    {% if "notify_users" in resource_monitor and resource_monitor.notify_users|length %}
        NOTIFY_USERS = ({{ resource_monitor.notify_users|join(',') }})
    {% endif %}
        TRIGGERS
        {% for trigger_definition in resource_monitor.trigger_definitions %}
            ON {{ trigger_definition.threshold }} PERCENT DO {{ trigger_definition.action }}
        {% endfor %};

    {% if "warehouses" in resource_monitor and resource_monitor.warehouses|length %}
        {% for warehouse in resource_monitor.warehouses %}
            ALTER WAREHOUSE {{ warehouse }} SET RESOURCE_MONITOR = {{ resource_monitor.monitor_name }};
        {% endfor %}
    {% else %}
        ALTER ACCOUNT SET RESOURCE_MONITOR = {{ resource_monitor.monitor_name }};
    {% endif %}
{% endfor %}

{%- endmacro -%}