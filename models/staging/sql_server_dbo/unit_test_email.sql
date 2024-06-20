/*validaremos si el formato de un email es correcto o no a partir de unos datos.
construimos nuestro modelo, solo leeremos los datos de la stg y en la consulta para el campo email pasaremos una función con una expresión regular. 
que devolverá 'True' en caso de que cumpla la condicion '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$' o 'false' en caso contrario.
Hasta este punto no se ha realizado ningún test, tan sólo hemos indicado si un email sería o no válido.
Para validar los datos se ha de crear un fichero .yml como por ejemplo models/marts/core/_core__unit_test.yml  en el que añadiremos 
los casos de prueba y lo que esperamos que ocurra para que pase o no un modelo.*/


with users as (

    select * from {{ ref('stg_sql_server_dbo__users') }}

),
    
validate_users_email as (

    select
        user_id
        first_name,
        last_name,
        email,
        coalesce (regexp_like(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$')= true,false) as is_valid_email_address
    from users

)

select * from validate_users_email