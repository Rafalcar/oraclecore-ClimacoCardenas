-- Creanis el Objeto que representa la estructura de un Ítem
CREATE OR REPLACE TYPE TYP_TTEM_ITEM AS OBJECT (
    item_id       NUMBER(10),
    cat_id        NUMBER(10),
    item_code     VARCHAR2(30),
    item_name     VARCHAR2(200),
    item_value    VARCHAR2(200),
    display_order NUMBER(5),
    status        CHAR(1),
    valid_from    DATE,
    valid_to      DATE
);
/

-- Colección (tabla en memoria) para manejo mas eficiente de los registros
CREATE OR REPLACE TYPE TYP_TTEM_ITEM_TAB AS TABLE OF TYP_TTEM_ITEM;
/


-- Creamos el packege para Insercion, Eliminacion y Actualizacion de Items

-- Especificacion de cara al cliente

CREATE OR REPLACE PACKAGE PKG_TTEM_CATALOG AS

    -- Operación para Insertar Ítems
    PROCEDURE P_INSERT_ITEM (
        p_item_id       IN NUMBER,
        p_cat_id        IN NUMBER,
        p_item_code     IN VARCHAR2,
        p_item_name     IN VARCHAR2,
        p_item_value    IN VARCHAR2,
        p_display_order IN NUMBER,
        p_valid_from    IN DATE,
        p_user          IN VARCHAR2
    );

    -- Operación para Actualizar Ítems
    PROCEDURE P_UPDATE_ITEM (
        p_item_id       IN NUMBER,
        p_item_name     IN VARCHAR2,
        p_item_value    IN VARCHAR2,
        p_display_order IN NUMBER,
        p_status        IN CHAR,
        p_user          IN VARCHAR2
    );

    -- Operación para Eliminación Lógica
    PROCEDURE P_DELETE_ITEM (
        p_item_id       IN NUMBER,
        p_user          IN VARCHAR2
    );

    -- Consulta que retorna la colección en memoria
    FUNCTION F_GET_ITEMS_BY_CATALOG (
        p_cat_id IN NUMBER
    ) RETURN TYP_TTEM_ITEM_TAB;

END PKG_TTEM_CATALOG;
/


-- Cuerpo del paquete donde se realiza la accion

CREATE OR REPLACE PACKAGE BODY PKG_TTEM_CATALOG AS

    -- Implementación de Insertar
    PROCEDURE P_INSERT_ITEM (
        p_item_id       IN NUMBER,
        p_cat_id        IN NUMBER,
        p_item_code     IN VARCHAR2,
        p_item_name     IN VARCHAR2,
        p_item_value    IN VARCHAR2,
        p_display_order IN NUMBER,
        p_valid_from    IN DATE,
        p_user          IN VARCHAR2
    ) AS
    BEGIN
        INSERT INTO ttem_item (
            item_id, cat_id, item_code, item_name, item_value, 
            display_order, status, valid_from, created_by, created_at, 
            updated_by, updated_at
        ) VALUES (
            p_item_id, p_cat_id, p_item_code, p_item_name, p_item_value, 
            p_display_order, 'A', p_valid_from, p_user, SYSDATE, 
            p_user, SYSDATE
        );
    END P_INSERT_ITEM;

    -- Implementación de Actualizar
    PROCEDURE P_UPDATE_ITEM (
        p_item_id       IN NUMBER,
        p_item_name     IN VARCHAR2,
        p_item_value    IN VARCHAR2,
        p_display_order IN NUMBER,
        p_status        IN CHAR,
        p_user          IN VARCHAR2
    ) AS
    BEGIN
        UPDATE ttem_item
        SET item_name     = p_item_name,
            item_value    = p_item_value,
            display_order = p_display_order,
            status        = p_status,
            updated_by    = p_user,
            updated_at    = SYSDATE
        WHERE item_id = p_item_id;
    END P_UPDATE_ITEM;

    -- Implementación de Eliminación Lógica (Cambio a estado 'I')
    -- Es mejor un eliminacion logica por temas de trazabilidad, historicos y mantenimiento
    PROCEDURE P_DELETE_ITEM (
        p_item_id       IN NUMBER,
        p_user          IN VARCHAR2
    ) AS
    BEGIN
        UPDATE ttem_item
        SET status     = 'I',
            updated_by = p_user,
            updated_at = SYSDATE
        WHERE item_id = p_item_id;
    END P_DELETE_ITEM;

    -- Implementación de la consulta con la Colección
    FUNCTION F_GET_ITEMS_BY_CATALOG (
        p_cat_id IN NUMBER
    ) RETURN TYP_TTEM_ITEM_TAB AS
        v_item_list TYP_TTEM_ITEM_TAB := TYP_TTEM_ITEM_TAB(); -- crea una lista vacia en memoria
    BEGIN
        SELECT TYP_TTEM_ITEM(
                   item_id, cat_id, item_code, item_name, item_value, 
                   display_order, status, valid_from, valid_to
               ) -- select que llena la lista vacia
        BULK COLLECT INTO v_item_list -- recupera los datos en memoria de forma mas rapida
        FROM ttem_item
        WHERE cat_id = p_cat_id 
          AND status = 'A'; -- Filtra los eliminados lógicos o inactivos
        
        RETURN v_item_list;
    END F_GET_ITEMS_BY_CATALOG;

END PKG_TTEM_CATALOG;
/