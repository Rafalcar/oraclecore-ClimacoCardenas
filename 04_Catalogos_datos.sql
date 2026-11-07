-- =====================================================================
-- SECCION A - A.1 Modelado de Catalogos
-- =====================================================================
SET DEFINE OFF
-- Catalogos
INSERT INTO ttem_catalog (cat_id, cat_code, cat_name, description, status, created_by, created_at, updated_by, updated_at) 
VALUES (1, 'MONEDA', 'Monedas', 'Catálogo de monedas', 'A', 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE);
INSERT INTO ttem_catalog (cat_id, cat_code, cat_name, description, status, created_by, created_at, updated_by, updated_at) 
VALUES (2, 'TIPO_COMISION', 'Tipos de comisión', 'Catálogo de tipos de comisión', 'A', 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE);
INSERT INTO ttem_item (item_id, cat_id, item_code, item_name, item_value, display_order, status, valid_from, valid_to, created_by, created_at, updated_by, updated_at) 
VALUES (1, 1, 'PEN', 'Sol Peruano', 'PEN', 1, 'A', DATE '2026-01-01', NULL, 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE);
INSERT INTO ttem_item (item_id, cat_id, item_code, item_name, item_value, display_order, status, valid_from, valid_to, created_by, created_at, updated_by, updated_at) 
VALUES (2, 1, 'USD', 'Dólar Estadounidense', 'USD', 2, 'A', DATE '2026-01-01', NULL, 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE);
INSERT INTO ttem_item (item_id, cat_id, item_code, item_name, item_value, display_order, status, valid_from, valid_to, created_by, created_at, updated_by, updated_at) 
VALUES (3, 2, 'COM_MANT', 'Comisión de mantenimiento', 'COM_MANT', 1, 'A', DATE '2026-01-01', NULL, 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE);

PROMPT Verificacion de carga (valores esperados entre parentesis):
SELECT 'TTEM_CATALOG (2)', COUNT(*) FROM ttem_catalog
UNION ALL SELECT 'TTEM_ITEM (2)', COUNT(*) FROM ttem_item;

COMMIT;