{{ 
    config(
        materialized='view'
    ) 
}}
WITH src_orders AS (

    SELECT * 
    FROM {{ ref('fct_orders') }} 

),


renamed_casted AS (

    SELECT 
        DATEDIFF(hour,created_at,delivered_at) as order_time,
        DATEDIFF(day,created_at,delivered_at) as order_journay
    FROM  src_orders
)
--Tiempo medio que tarda un pedido desde que se realiza hasta que se entrega
--AVG () calcula la media de un conjunto de valores dividiendo la suma de estos 
--valores por el recuento de valores no NULL.
SELECT 
    CONCAT(ROUND(AVG(order_time),2),' Horas') as media_tiempo_horas,
    CONCAT(ROUND(AVG(order_journay),2),' dias') as media_tiempo_dias
FROM renamed_casted