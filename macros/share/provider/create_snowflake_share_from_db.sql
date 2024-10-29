{%- macro create_snowflake_share_from_db(variables) -%}

{#
To create a share for a database we need the following variables:
    shares [VARIABLE SET]
        share_name [STRING]
        db_name [STRING]
        comment [STRING]
        consumer_accounts [STRING list]
#}

{% for share in variables.shares %}
    USE ROLE ACCOUNTADMIN;

    CREATE SHARE IF NOT EXISTS {{ share.share_name }};

    {% if 'comment' in share and share.comment|length %}
        ALTER SHARE {{ share.share_name }} SET COMMENT = '{{ share.comment }}';
    {% endif %}

    ALTER SHARE {{ share.share_name }} ADD ACCOUNTS={{ share.consumer_accounts|join(", ") }};

    USE ROLE SECURITYADMIN;

    GRANT ROLE ROLE_{{ share.db_name }}_RO TO SHARE {{ share.share_name }};

{% endfor %}
{%- endmacro -%}