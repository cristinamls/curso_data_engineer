{{
  config(
    materialized='table'
  )
}}

WITH src_users AS (
    SELECT * 
    FROM {{ref('stg_sql_server_dbo__users')}}
),

src_orders AS (
    SELECT *
    FROM {{ref('stg_sql_server_dbo__orders')}}
),

src_order_items AS (
    SELECT *
    FROM {{ref('stg_sql_server_dbo__order_items')}}
),

renamed_casted AS (
    SELECT
        u.user_id,
        COUNT(o.order_id) AS total_orders,
        ROUND(SUM(o.order_cost_dollars),2) AS total_orders_cost,
        ROUND(SUM(o.shipping_cost_dollars),2) AS total_shipping_cost,
        SUM(oi.quantity) AS total_products,
        COUNT(oi.product_id) AS different_products,
        ROUND(SUM(o.order_total_dollars - (o.shipping_cost_dollars + o.order_cost_dollars)),2) AS total_discounts
    FROM src_users u 
        LEFT JOIN src_orders o ON u.user_id = o.user_id
        LEFT JOIN src_order_items oi ON o.order_id = oi.order_id
    GROUP BY 
        u.user_id
)

SELECT * FROM renamed_casted