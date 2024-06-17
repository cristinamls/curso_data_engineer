{{
  config(
    materialized='table'
  )
}}

WITH src_orders AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__orders') }}
),

src_order_items AS (
    SELECT * 
    FROM {{ref('stg_sql_server_dbo__order_items')}}
),

renamed_casted AS (
    SELECT DISTINCT
        o.order_id,
        address_id,
        promo_id,
        user_id,
        created_at,
        estimated_delivery_at,
        delivered_at,
        order_cost_dollars,
        order_total_dollars,
        shipping_cost_dollars,
        (order_total_dollars - (shipping_cost_dollars + order_cost_dollars))::INT AS discount
    FROM 
        src_orders o JOIN src_order_items oi ON o.order_id = oi.order_id   
)
SELECT * FROM renamed_casted