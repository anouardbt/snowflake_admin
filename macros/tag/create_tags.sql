{%- macro create_tags(variables) -%}
USE ROLE TAG_ADMIN;
USE DATABASE TAGS;
USE SCHEMA TAGS;

{% for tag in variables.tags %}
    CREATE TAG IF NOT EXISTS {{ tag.name }}
    {% if "allowed_values" in tag %}
        ALLOWED_VALUES {% for value in tag.allowed_values %}'{{ value }}'{% if not loop.last %}, {% endif %}{% endfor %}
    {% endif %}
    {% if "comment" in tag %}
        COMMENT = '{{ tag.comment }}'
    {% endif %};
{% endfor %}
{%- endmacro -%}