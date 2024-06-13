WITH src_users AS (
    SELECT * 
    FROM {{ref('stg_sql_server_dbo__users')}}
),

renamed_casted AS (
    SELECT
        user_id,
        first_name,
        last_name,
        phone_number,
        email,
        updated_at,
        date_load,
        updated_at_utc,
        created_at_utc
    FROM src_users
)

SELECT * FROM renamed_casted