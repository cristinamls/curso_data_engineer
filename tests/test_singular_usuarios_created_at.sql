--valida que la creacion de usuarios sea anterior o al tiempo de la fecha de actualizacion

SELECT *
FROM {{ ref('stg_sql_server_dbo__users') }}
WHERE updated_at < created_at AND updated_at_utc < created_at_utc