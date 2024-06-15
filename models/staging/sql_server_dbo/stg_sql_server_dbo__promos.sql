{{
  config(
    materialized='view'
  )
}}

WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
    ),

renamed_casted AS (
    
    SELECT
        MD5(promo_id) AS promo_id
        , promo_id AS promo_name
        , discount
        , CASE
            WHEN status = 'inactive' THEN 0
            WHEN status = 'active' THEN 1
        END AS status
        , _fivetran_deleted AS date_delete
        , convert_timezone('UTC',_fivetran_synced) AS date_load
        -- , convert_timezone('UTC',_fivetran_synced)::date AS date_load_no_time
    FROM src_promos
    )
    ,
    added_row AS (
        SELECT 
            md5('') AS id_promocion,
            'no promotion' AS promo_name,
            '0' AS discount,
            '0' AS status,
            null AS _fivetran_deleted,
            CURRENT_TIMESTAMP AS _fivetran_synced
    )

SELECT * FROM renamed_casted
UNION ALL
SELECT * FROM added_row