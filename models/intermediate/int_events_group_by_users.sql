/*Macro que devuelve los diferentes eventos cuando sea llamada desde el modelo.*/

{{
  config(
    materialized='table'
  )
}}

WITH 

src_events AS ( 
    SELECT *
    FROM {{ ref('stg_sql_server_dbo__events') }} 
),


{% set event_types = ["checkout", "package_shipped", "add_to_cart","page_view"] %}

renamed_casted AS (
    SELECT
        user_id,
        {%- for event_type in event_types %}
        sum(case when event_type = '{{event_type}}' then 1 end) as {{event_type}}_amount
        {%- if not loop.last %},{% endif -%}
        {% endfor %}
    FROM src_events
    GROUP BY 1
    )


SELECT *
FROM renamed_casted