{{ 
    config(
        materialized="view"
    ) 
}}
WITH src_users AS (
    SELECT * 
    FROM {{ref('dim_users')}}
),

renamed_casted AS (
    SELECT 
        COUNT(*) AS total_usuarios
    FROM 
        src_users

)

SELECT * FROM renamed_casted