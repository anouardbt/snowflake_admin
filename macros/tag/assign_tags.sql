{% macro assign_tags(variables) %}

USE ROLE TAG_ADMIN;
USE DATABASE TAGS;
USE SCHEMA TAGS;

{% for assignment in variables.assignments %}
    ALTER {{ assignment.object_type }} IF EXISTS {{ assignment.object_name }}
    SET TAG {% for tag in assignment.tags %}{{ tag.name }} = '{{ tag.value }}'{% if not loop.last %}, {% endif %}{% endfor %};
{% endfor %}

{% endmacro %}
