{{ 
    config(
        materialized="view"
    ) 
}}
WITH src_users AS (
    SELECT * 
    FROM {{ref('int_orders_group_by_users')}}
),

renamed_casted AS (
    SELECT 
        COUNT(*) AS total_usuarios,
        total_orders
    FROM 
        src_users
    GROUP BY 
        total_orders
    ORDER BY
        total_orders ASC
)

SELECT * FROM renamed_casted