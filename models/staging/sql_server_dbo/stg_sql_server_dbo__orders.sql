{{ 
    config(
        materialized="view"
    ) 
}}

WITH
src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
),

renamed_casted AS (
    SELECT
        order_id,
        convert_timezone('UTC', created_at)::date AS created_at,
        user_id,
        address_id,
        nullif(tracking_id, '') AS tracking_id,

        CASE
            WHEN shipping_service = ''
            THEN null
            ELSE {{ dbt_utils.generate_surrogate_key(["shipping_service"]) }}
        END AS shipping_service_id,
        
        order_total AS order_total_dollars,
        order_cost AS order_cost_dollars,
        shipping_cost AS shipping_cost_dollars,
        CASE
            WHEN status = 'preparing'
            THEN 0
            WHEN status = 'shipped'
            THEN 1
            WHEN status = 'delivered'
            then 2
        END AS status_id,
        convert_timezone('UTC', delivered_at)::date AS delivered_at,
        convert_timezone('UTC', estimated_delivery_at)::date AS estimated_delivery_at,
        CASE
            WHEN promo_id = ''
            THEN {{ dbt_utils.generate_surrogate_key(["'no promo'"]) }}
            ELSE {{ dbt_utils.generate_surrogate_key(["promo_id"]) }}
        END AS promo_id,
        coalesce(_fivetran_deleted, false) AS date_deleted,
        convert_timezone('UTC', _fivetran_synced)::date AS date_load
    FROM 
        src_orders
)

SELECT * FROM renamed_casted
