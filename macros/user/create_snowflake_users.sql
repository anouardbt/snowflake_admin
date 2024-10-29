{%- macro create_snowflake_users(variables) -%}

{#
This template is used to create a new (technical) user on Snowflake.

It requires the following variables:
    users [VARIABLE SET]
        username [STRING]
        default_role [STRING]
        public_key [STRING] (optional) - if not provided, the user's auth method will have to be set up manually
        default_warehouse [STRING] (optional)
#}

USE ROLE SECURITYADMIN;

{% for user in variables.users %}
    CREATE USER IF NOT EXISTS {{ user.username }}
    {% if "public_key" in user and user.public_key|length %}
        RSA_PUBLIC_KEY= '{{ user.public_key }}'
    {% endif %};
    GRANT ROLE {{ user.default_role }} TO USER {{ user.username }};
    ALTER USER {{ user.username }} SET DEFAULT_ROLE={{ user.default_role }};
    {% if "default_warehouse" in user and user.default_warehouse|length %}
        ALTER USER {{ user.username }} SET DEFAULT_WAREHOUSE={{ user.default_warehouse }};
    {% endif %}
{% endfor %}

{%- endmacro -%}