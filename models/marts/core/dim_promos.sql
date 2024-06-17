{{
  config(
    materialized='view'
  )
}}

WITH src_promos AS (
    SELECT * 
    FROM {{ref('stg_sql_server_dbo__promos')}}
),

renamed_casted AS (
    SELECT *
    FROM src_promos
)

SELECT * FROM renamed_casted