/* comprueba si hay algún caso en el que la fecha de entrega es anterior 
a la fecha en que se realizó el pedido, el resultado debe ser 0 rows, lo contrario
no tendría sentido lógico e indicaría algún tipo de problema con los datos */

SELECT *
FROM {{ ref('stg_sql_server_dbo__orders') }}
WHERE delivered_at < created_at
