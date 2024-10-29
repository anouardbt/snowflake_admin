{%- macro drop_tags(variables) -%}
USE ROLE TAG_ADMIN;
USE DATABASE TAGS;
USE SCHEMA TAGS;

{% for tag in variables.tags %}
    DROP TAG IF EXISTS {{ tag.name }};
{% endfor %}
{%- endmacro -%}