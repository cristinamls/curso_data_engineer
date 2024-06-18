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

src_products AS (
    SELECT *
    FROM {{ref('stg_sql_server_dbo__products')}}
),

renamed_casted AS (
    SELECT 
        o.order_id,
        o.address_id,
        o.user_id,
        o.promo_id,
        o.created_at,
        o.shipping_service_id,
        o.tracking_id,
        oi.product_id,
        o.status_id AS shipping_status_id,
        oi.quantity AS product_quantity,
        ROUND(p.price_dollar * oi.quantity, 2) AS total_price_per_product
    FROM
        src_orders AS o 
            LEFT JOIN src_order_items AS oi ON o.order_id = oi.order_id
            LEFT JOIN src_products AS p ON oi.product_id = p.product_id
    ORDER BY o.order_id
)


SELECT * FROM renamed_casted