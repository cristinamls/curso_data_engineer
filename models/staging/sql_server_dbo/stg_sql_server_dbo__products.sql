{{
  config(
    materialized='view'
  )
}}

WITH src_products AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'products') }}
    ),

renamed_casted AS (
    SELECT
        inventory
        , name
        , price
        , product_id
        , _fivetran_deleted
        , _fivetran_synced AS date_load
    FROM src_products
    )

SELECT * FROM renamed_casted