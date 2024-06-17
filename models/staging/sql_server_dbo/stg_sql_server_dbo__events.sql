{{
  config(
    materialized='view'
  )
}}

WITH src_events AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'events') }}
    ),

renamed_casted AS (
    SELECT
        convert_timezone('UTC', created_at) created_at
        , event_id
        ,  md5(event_type) as event_type_id
        , NULLIF(order_id, '') AS order_id
        , page_url
        , NULLIF(product_id , '' ) AS product_id
        , session_id
        , user_id
        , coalesce(_fivetran_deleted, false) AS date_deleted
        , convert_timezone('UTC',_fivetran_synced) AS _fivetran_synced
    FROM src_events
    )

SELECT * FROM renamed_casted