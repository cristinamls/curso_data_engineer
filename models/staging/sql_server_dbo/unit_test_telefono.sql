WITH src_users AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__users') }}
),
    
renamed_casted AS (

    SELECT
        user_id
        first_name,
        last_name,
        phone_number,
        coalesce(regexp_like(phone_number, '^\\d{3}-\\d{3}-\\d{4}$') = true, false) as is_valid_phone_number
    FROM src_users

)

SELECT * FROM renamed_casted