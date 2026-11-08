
| Herramientas Utilizadas |
|      |
| :--- |
| Oracle SQL Versión 26.2.0.186 |
| Visual Studio Code |
| Docker version 29.7.2, build a7dcaa6  |
| git version 2.53.0  |
| Github Copilot |

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

| PASOS PARA CREAR EL ESQUEMA |
|      |
| :--- |
| Correr script 01_core_ddl.sql | Tablas Nativas |
| Correr script 02_core_datos.sql | Datos de Tablas Nativas |
| Correr script 03_Catalogos_ddl.sql | Tablas Catalogos |
| Correr script 04_Catalogos_datos.sql | Datos de Tablas Catalogos |
| Correr script 05_Package_ddl.sql | Script de Manejo de Datos |

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

| Pertenece a Seccion A.3 |
| Codigo Error | Descripcion Error |
| :--- | :--- |
| 20001 | Catalogo no existe |
| 20002 | Item duplicado |
| 20003 | Item no existe |

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

| Pertenece a Seccion B |
| Numero de Cuenta | Descripcion de Consulta | Comentarios |
| :--- | :--- | :--- |
| 1910001000011 | Cuenta Existente | Trajo la informacion de forma correcta |
| 1910002000017 | Cuenta Existente | Trajo la informacion de forma correcta |
| 1910003000013 | Cuenta Existente | Trajo la informacion de forma correcta |
| 1910001000011 | Cuenta Existente | Trajo la informacion de forma correcta |
| 1910004000019 | Cuenta Existente | Trajo la informacion de forma correcta |
| 9999999999999 | Cuenta inexistente | Cuando se realiza consulta de cliente por número de cuenta, simplemente no devuelve registros sin errores ni datos parciales |

