{%- macro drop_snowflake_users(variables) -%}

{#
This template is used to drop a user on Snowflake.

It requires the following variables:
    users [VARIABLE SET]
        username [STRING]
#}

USE ROLE SECURITYADMIN;

{% for user in variables.users %}
    DROP USER IF EXISTS {{ user.username }};
{% endfor %}

{%- endmacro -%}