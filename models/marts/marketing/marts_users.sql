WITH src_users AS (
    SELECT * 
    FROM {{ref('dim_users')}}
),

src_address AS (
    SELECT *
    FROM {{ref('dim_addresses')}}
),

src_users_aggregations AS (
    SELECT * 
    FROM {{ref('int_users_aggregations')}}
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
        -- a.address,
        -- a.zipcode,
        -- a.state,
        -- a.country,
        ua.total_orders,
        ua.total_products,
        ua.different_products
    FROM src_users u
    LEFT JOIN src_users_aggregations ua ON ua.user_id = u.user_id
    -- LEFT JOIN src_address a ON u.address_id = a.address_id

)

SELECT * FROM renamed_casted