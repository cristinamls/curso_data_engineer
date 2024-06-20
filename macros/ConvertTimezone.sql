/*Macro que convierte la fecha '2020-01-01 00:00:00' a UTC Coordinated Universal Time timezone*/

{% macro to_utc (column_name) %}
    CONVERT_TIMEZONE('UTC', TO_TIMESTAMP_TZ ({{column_name}}))
{% endmacro %}