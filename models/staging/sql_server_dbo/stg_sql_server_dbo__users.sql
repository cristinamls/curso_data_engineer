{{
  config(
    materialized='view'
  )
}}

WITH src_users AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'users') }}
    ),

renamed_casted AS (
    SELECT
        address_id
        , created_at
        , email
        -- Columna para comprobar validacion email en el models/marts/core/_core_unit_test.yml
        -- {email: ekollaschek2q@tuttocitta.it, is_valid_email_address: true}
        , coalesce (regexp_like(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$')= true,false) as is_valid_email_address
        , first_name
        , last_name
        , phone_number
        , total_orders
        , user_id
        , _fivetran_deleted
        , updated_at
        , _fivetran_synced AS date_load
        -- uso de macro convertir fecha utc
        , {{ to_utc('updated_at') }} as updated_at_utc
        -- conversion fecha sin macro
        , convert_timezone('UTC',created_at) as created_at_utc
        
    FROM src_users
    )

SELECT * FROM renamed_casted