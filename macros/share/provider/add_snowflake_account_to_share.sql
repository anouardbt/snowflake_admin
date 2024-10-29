{%- macro add_snowflake_account_to_share(variables) -%}

{#
To add consumer accounts to a share we need the following variables:
    shares [VARIABLE SET]
        share_name [STRING]
        consumer_accounts [STRING list]
#}

{% for share in variables.shares %}
    USE ROLE ACCOUNTADMIN;

    ALTER SHARE IF EXISTS {{ share.share_name }} ADD ACCOUNTS={{ share.consumer_accounts|join(", ") }};

{% endfor %}
{%- endmacro -%}