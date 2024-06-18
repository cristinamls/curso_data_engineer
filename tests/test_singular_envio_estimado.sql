/* comprueba si hay algún caso en el que la fecha estimada de entrega es anterior
a la fecha en que se realizó el pedido, en caso de que el resultado no sea 0,
 no tendría sentido lógico e indicaría algún tipo de problema con los datos */

SELECT *
FROM {{ ref('stg_sql_server_dbo__orders') }}
WHERE  estimated_delivery_at < created_at