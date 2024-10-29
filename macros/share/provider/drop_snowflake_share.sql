{%- macro drop_snowflake_share(variables) -%}

{#
To drop a share we need the following variables:
    shares [VARIABLE SET]
        share_name [STRING]
#}

{% for share in variables.shares %}
    USE ROLE ACCOUNTADMIN;

    DROP SHARE IF EXISTS {{ share.share_name }};

{% endfor %}
{%- endmacro -%}