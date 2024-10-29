{%- macro set_snowflake_timezone(variables) -%}

{#
Sets the default timezone for the current Snowflake account.

To set the timezone in Snowflake we need following variables:
    timezone [STRING]
#}

{%- set timezone = variables.get("timezone") -%}

USE ROLE ACCOUNTADMIN;

ALTER ACCOUNT SET TIMEZONE = '{{ timezone }}';

{%- endmacro -%}