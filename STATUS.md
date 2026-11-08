| Requisito | Estado | Nota |
| :--- | :--- | :--- |
| A.1 Modelado de Catalogos | Hecho | Se crea tablas TTEM_CATALOG, TTEM_ITEM con sus constraints y datos iniciales |
| A.2 Package de Mantenimiento | Hecho | Se crea package con sus operaciones de insertar, eliminar, actualizar, y un objeto con su coleccion |
| A.3 Excepciones propias | Hecho | Se crean excepciones de existencia de items, duplicados, validacion de vigencias, se definen los codigos de error con sus descripciones |
| A.4 JSON por ItemId | Hecho | Se crea procedimiento que recibe un item y devuelve resultado construido con json nativo de oracle |
| B Consulta de cliente | Hecho | Se crea consulta con variable de sustitucion y devuelva una fila por cuenta, asi como los usuarios dentro de una sola columna utilizando LISTAGG. |
| C Transferencia | No Hecho | No hubo suficiente tiempo |
| A.5 BULK COLLECT y FORALL | No hecho | No hubo suficiente tiempo |
| D Propuesta de mejora | No Hecho | No hubo suficiente tiempo |