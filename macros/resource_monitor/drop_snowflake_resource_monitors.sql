{%- macro drop_snowflake_resource_monitors(variables) -%}

{#
This template is used to drop one or more resource monitors on Snowflake.

It requires the following variables:
    resource_monitors [VARIABLE SET]:
        name [STRING]

#}

USE ROLE ACCOUNTADMIN;

{% for resource_monitor in variables.resource_monitors %}
    DROP RESOURCE MONITOR IF EXISTS {{ resource_monitor.name }};
{% endfor %}

{%- endmacro -%}