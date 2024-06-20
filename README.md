# README Curso Data Engineering
Aquí tendremos toda la información sobre nuestro proyecto y repositorio, que está relacionado con dbt y Snowflake

### Presentación del Proyecto: Estructura y Capas de Datos

---

#### 1. Introducción

Bienvenidos a la presentación del proyecto de estructura y capas de datos utilizando dbt. En esta sesión, exploraremos cómo hemos diseñado y organizado nuestras capas de datos para optimizar el manejo, transformación y análisis de información clave para nuestro negocio.

---

#### 2. Contexto del Proyecto

El repositorio `curso_data_engineer` alberga un proyecto dedicado a la implementación de una arquitectura de datos robusta, dividida en capas de Staging, Intermediate y Marts utilizando dbt. Este enfoque nos permite gestionar eficientemente la ingesta, transformación y disponibilidad de datos para su posterior análisis y reporting.

---

#### 3. Objetivos

Nuestro principal objetivo con este proyecto es establecer una arquitectura escalable y modular que garantice la consistencia y calidad de los datos en todas las etapas del proceso de manejo de datos. Además, buscamos mejorar la agilidad y capacidad de respuesta del negocio a través de datos confiables y accesibles.

---

#### 4. Estructura y Capas de Datos

- **Staging Layer:**
  - **Propósito:** Almacén inicial de datos crudos provenientes de diversas fuentes.
  - **Proceso:** Ingesta de datos sin procesar sin aplicar transformaciones significativas, preparándolos para el procesamiento posterior.
  
- **Intermediate Layer:**
  - **Propósito:** Capa intermedia donde se aplican transformaciones y limpieza de datos.
  - **Proceso:** Utilización de dbt para definir y ejecutar modelos que transforman datos del staging layer en formatos más estructurados y útiles para análisis avanzados.
  
- **Marts (Data Marts):**
  - **Propósito:** Repositorios optimizados para análisis específicos o departamentales.
  - **Proceso:** Creación de modelos dbt diseñados para responder a preguntas de negocio específicas, facilitando la generación de informes y análisis ad-hoc.

![Captura de pantalla 2024-06-19 103138](https://github.com/cristinamls/curso_data_engineer/assets/170645478/676c2e9d-e2c9-4e4d-9b4e-57ecc031f2f0)

---

#### 5. Tecnologías Clave ELT

- **DBT (Data Build Tool):** Herramienta fundamental para la definición, ejecución y documentación de transformaciones de datos.
- **Snowflake (Dw):** Plataforma de almacenamiento de datos basada en computación en la nube.
- **SQL:** Lenguaje utilizado dentro de dbt para manipulación y modelado de datos.
- **Python/Jinja:** Es un motor de plantilla desarrollado en Python. dbt puede usar Jinja combinado con SQL.

---

#### 6. Proceso de Desarrollo

Database cargada en Snowflake, con datos que provienen de dos fuentes/sources: google_sheets y sql_server_db. 
Los datos son distribuidos mediante un proceso de transformación y modelado en tres capas: bronze (datos crudos), silver (datos transformados y casteados) y gold (datos modelados en tablas de dimension y de hechos), que en dbt se corresponderan al directorio staging y el directorio marts. 

![BBDD](https://github.com/cristinamls/curso_data_engineer/assets/170645478/caf0ba6c-db70-4732-8fa8-62beb36c4931)

La capa de staging es el directorio main de modelos en este proyecto dbt, en ella también se almacenará la capa base, los modelos base no son siempre necesarios.
Los modelos intermedios son donde empezamos a aplicar la lógica de negocio y a unir los modelos de staging, por ejemplo, en int_orders_group_by_users, agrupamos users con orders y orders_items para luego usarlo en marts.marketing.
 
Marts es el otro directorio principal de modelos de un proyecto dbt. Los marts se basan tradicionalmente en entidades (tablas de dimensiones) y procesos de negocio (tablas de hechos), y se pueden agrupar por unidades de negocio (Márketing o Producto)

---

#### 7. Test
Los test son pruebas para validar que los datos de nuestros modelos y sources son correctos.

7.1 `Test singulares`: Son archivos .sql guardados en el directorio /tests/ de nuestro proyecto de dbt.

- test_singular_envio_estimado
- test_singular_pedido_anterior_entrega
- test_singular_usuarios_created_at

7.2 `Test genéricos`: Son piezas de lógica reutilizables que pueden aplicarse a cualquier modelo dbt. 

- generic.positive_values

7.3 Además dbt tiene cuatro test genéricos ya definidos y listos para usar: 

- `unique` : El valor de la columna debe ser único en toda la tabla.

- `not_null` : El valor de la columna no debe contener valores nulos.

- `accepted_values` : El valor de la columna debe estar entre una de las siguientes por ejemplo: "realizado", "enviado", "completado" o "devuelto".

- `relationships`: El valor de la columna es un identificador que se relaciona con otra tabla o modelo (integridad referencial).
 

7.4 `Unit test`: Las pruebas unitarias deben definirse en un archivo YML en el directorio models/ Se leerán datos de la stg y en la consulta para el campo email/telefono, se pasará una función con una expresión regular.
- unit_test_mail
- unit_test_telefono

En resumen, los test son piezas importantes para la consistencia y calidad de los datos. Si los datos no pasan satisfactoriamente los test definidos, no puede finalizarse el dbt build, teniendo que volver a reparar o depurar los datos.

![Captura de pantalla Test Success](https://github.com/cristinamls/curso_data_engineer/assets/170645478/013116d9-b559-4304-9e01-93281c432aa6)

![Captura de pantalla Test Fail](https://github.com/cristinamls/curso_data_engineer/assets/170645478/5440ba3c-f40f-479f-b225-ecb3c904d061)

---

#### 8. Macros
Las macros son trozos de código (SQL + jinja) que pueden ser reutilizados tantas veces sea necesario.

- ConvertTimezone, macro que convierte la fecha '2000-01-01 00:00:00' a UTC Coordinated Universal Time timezone
- Date Spine, que existe dentro del paquete de dbt-utils existen macros (folder sql), esta macro genera una columna con una lista de fechas consecutivas en un período determinado. Esta macro se ha usado para construir la dimension tiempo.
- Generate subrogate key, tambien dentro de las macros de dbt utils, usado por ejemplo para generar id cuando estaba vacio.
- Event Types, es una macro que devuelve los distintos eventos, usada en la capa intermediate como int_events_group_by.sql

---

#### 9. Snapshots

Herramienta que registra los cambios de una tabla mutable en el tiempo.
- budget_snapshot.sql
- orders_snapshot.sql

El comando para ejecutar una instantánea es **dbt snapshot**.



---

#### 10. Resultados y Beneficios

Gracias a la implementación de esta estructura de capas de datos con dbt, hemos logrado mejorar la calidad y coherencia de nuestros datos, reduciendo los tiempos de preparación y aumentando la confianza en nuestros análisis y reportes. Además, hemos facilitado la colaboración entre equipos al proporcionar una fuente única y confiable de verdad.

---

#### 11. Conclusiones

En conclusión, la estructura de capas de datos implementada con dbt en este proyecto ha demostrado ser fundamental para mejorar nuestra capacidad para manejar, transformar y analizar datos de manera eficiente y efectiva. Estamos emocionados por las oportunidades futuras que esta arquitectura escalable nos ofrece para seguir innovando y respondiendo ágilmente a las demandas del mercado.


