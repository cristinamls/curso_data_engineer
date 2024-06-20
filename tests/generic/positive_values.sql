/*Los test genéricos son piezas de lógica reutilizables que pueden aplicarse a cualquier modelo dbt
valida si los valores de una columna son positivos.*/


{% test positive_values(model, column_name) %}


   select *
   from {{ model }}
   where {{ column_name }} < 0


{% endtest %}