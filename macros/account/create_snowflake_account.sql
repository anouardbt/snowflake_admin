{%- macro create_snowflake_account(variables) -%}

{#
Creates one or more accounts in the current Snowflake organization.

Also used to implement DEV/UAT separation within the same Snowflake instance.

Required variables:
    accounts [VARIABLE SET]
        account_name [STRING]
        admin_name [STRING]
        admin_email [STRING]
        admin_public_key [STRING] OR admin_password [STRING]
        sf_edition ['standard'|'enterprise'|'business_critical']
        region [STRING]
        comment [STRING]
#}

USE ROLE ORGADMIN;

{% for account in variables.accounts %}
    CREATE ACCOUNT {{ account.account_name }}
    ADMIN_NAME = '{{ account.admin_name }}'
    {# admin logs in via public key OR password - public key has precedence over password#}
    {% if 'admin_public_key' in account and account.admin_public_key|length %}
        ADMIN_RSA_PUBLIC_KEY = '{{ account.admin_public_key }}'
    {% elif 'admin_password' in account and account.admin_password|length %}
        ADMIN_PASSWORD = '{{ account.admin_password }}'
    {% endif %}
    EMAIL = '{{ account.admin_email }}'
    EDITION = {{ account.sf_edition }}
    REGION = {{ account.region }}
    COMMENT = '{{ account.comment }}';
{% endfor %}
{%- endmacro -%}

