/*validaremos si el formato de un telefono es correcto o no a partir de unos datos.
Construimos nuestro modelo, solo leeremos los datos de la stg y en la consulta para el campo telefono pasaremos una función con una expresión regular. 
que devolverá 'True' en caso de que cumpla la condicion '^\\d{3}-\\d{3}-\\d{4}$' o 'false' en caso contrario
Hasta este punto no se ha realizado ningún test, tan sólo hemos indicado si un email sería o no válido.
Para validar los datos se ha de crear un fichero .yml como por ejemplo models/marts/core/_core__unit_test.yml  en el que añadiremos 
los casos de prueba y lo que esperamos que ocurra para que pase o no un modelo.*/

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