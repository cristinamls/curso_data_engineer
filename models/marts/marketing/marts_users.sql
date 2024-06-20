WITH src_users AS (
    SELECT * 
    FROM {{ref('dim_users')}}
),

src_address AS (
    SELECT *
    FROM {{ref('dim_addresses')}}
),

src_orders_users AS (
    SELECT * 
    FROM {{ref('int_orders_group_by_users')}}
),

src_events_users AS (
    SELECT * 
    FROM {{ref('int_events_group_by_users')}}
),


renamed_casted AS (
    SELECT DISTINCT
        u.user_id,
        u.first_name,
        u.last_name,
        u.email,
        u.phone_number,
        u.date_load,
        u.updated_at,
        u.updated_at_utc,
        u.created_at_utc,
        a.address,
        a.zipcode,
        a.state,
        a.country,
        ugb.total_orders,
        ugb.total_products,
        ugb.different_products,
        eu.checkout_amount,
        eu.package_shipped_amount,
        eu.add_to_cart_amount,
        eu.page_view_amount
    FROM 
        src_users u
            LEFT JOIN src_orders_users ugb ON ugb.user_id = u.user_id
            LEFT JOIN src_address a ON u.address_id = a.address_id
            LEFT JOIN src_events_users eu ON eu.user_id = u.user_id
)

SELECT * FROM renamed_casted