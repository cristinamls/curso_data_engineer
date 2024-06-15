WITH src_addresses AS (
    SELECT * 
    FROM {{ref('stg_sql_server_dbo__addresses')}}
),

renamed_casted AS (
    SELECT
        address_id,
        zipcode,
        country,
        address,
        state
    FROM src_addresses
)

SELECT * FROM renamed_casted