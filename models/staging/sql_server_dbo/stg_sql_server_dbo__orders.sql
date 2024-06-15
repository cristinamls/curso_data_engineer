{{ config(materialized="view") }}

with
    src_orders as (select * from {{ source("sql_server_dbo", "orders") }}),

    renamed_casted as (
        select
            order_id,
            convert_timezone('UTC', created_at)::date as created_at,
            user_id,
            address_id,
            nullif(tracking_id, '') as tracking_id,
            case
                when shipping_service like ''
                then null
                else {{ dbt_utils.generate_surrogate_key(["shipping_service"]) }}
            end as shipping_service_id,
            order_total as order_total_dollars,
            order_cost as order_cost_dollars,
            shipping_cost as shipping_cost_dollars,
            case
                when status like 'preparing'
                then 0
                when status like 'shipped'
                then 1
                when status like 'delivered'
                then 2
            end as status_id,
            convert_timezone('UTC', delivered_at)::date as delivered_at,
            convert_timezone('UTC', estimated_delivery_at)::date as estimated_delivery_at,
            case
                when promo_id = ''
                then {{ dbt_utils.generate_surrogate_key(["'no promo'"]) }}
                else {{ dbt_utils.generate_surrogate_key(["promo_id"]) }}
            end as promo_id,
            coalesce(_fivetran_deleted, false) as date_deleted,
            convert_timezone('UTC', _fivetran_synced)::date as date_load
        from src_orders
    )

select *
from renamed_casted
