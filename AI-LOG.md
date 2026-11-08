## Uso de Inteligencia Artificial

### Herramientas utilizadas

Durante el desarrollo de la solución se utilizó **Microsoft 365 Copilot (GPT)** como herramienta de apoyo técnico para:

- Validación de diseños de tablas Oracle.
- Revisión del estándar de nomenclatura definido en el Anexo C.
- Diseño inicial del modelo de catálogos parametrizables.
- Construcción y revisión de packages PL/SQL.
- Generación de consultas SQL.
- Construcción de documentos JSON mediante funciones nativas de Oracle.
- Identificación de mejoras y validaciones de negocio.

La herramienta fue utilizada como apoyo técnico y todas las propuestas fueron revisadas, adaptadas y validadas manualmente antes de incorporarse a la solución final.

---

# Decisiones Técnicas

## Modelo de Catálogos

Se implementaron las tablas:

- `ttem_catalog`
- `ttem_item`

El modelo utiliza una relación maestro-detalle:

- Un catálogo puede contener múltiples ítems.
- Cada ítem pertenece a un único catálogo.
- Se implementó integridad referencial mediante clave foránea.
- Se incorporaron vigencias (`valid_from` y `valid_to`).
- Se incorporaron campos de auditoría para creación y actualización.

### Justificación

Este diseño permite mantener catálogos parametrizables sin necesidad de realizar cambios estructurales en la base de datos cada vez que se incorpora un nuevo catálogo o ítem de negocio.

---

## Auditoría

Se implementó la tabla:

```sql
ttem_audit_log