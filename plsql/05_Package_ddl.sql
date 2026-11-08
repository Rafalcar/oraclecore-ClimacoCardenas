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


    /* Excepciones de negocio */
    e_catalog_no_existe EXCEPTION;
    e_item_no_existe EXCEPTION;
    e_item_duplicado EXCEPTION;
    
    -- Consulta de Item 
    PROCEDURE P_GET_ITEM_ID (
        p_item_id IN NUMBER,
        p_item_json OUT CLOB
    );   

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

    -- Implementacion de Consulta de Item 
    PROCEDURE P_GET_ITEM_ID (
        p_item_id IN NUMBER,
        p_item_json OUT CLOB -- parametro de salida CLOB
    ) AS

    l_count NUMBER;

    BEGIN

    -- Validamos la existencia del item

    SELECT COUNT(*)
    INTO l_count
    FROM ttem_item
    WHERE item_id = p_item_id;

    IF l_count = 0 THEN
        RAISE_APPLICATION_ERROR(
            -20003,
            'Item no existe'
        );
    END IF;

    -- Construcción del JSON usando funciones nativas Oracle
    SELECT JSON_OBJECT(
               'itemId' VALUE i.item_id,
               'catalogId' VALUE c.cat_id,
               'catalogCode' VALUE c.cat_code,
               'itemCode' VALUE i.item_code,
               'name' VALUE i.item_name,
               'value' VALUE i.item_value,
               'status' VALUE i.status,
               'validFrom' VALUE TO_CHAR(i.valid_from, 'YYYY-MM-DD'),
               'validTo' VALUE TO_CHAR(i.valid_to, 'YYYY-MM-DD')
               RETURNING CLOB
           )
    INTO p_item_json --parametro de salida que recibe la informacion
    FROM ttem_item i
         INNER JOIN ttem_catalog c
             ON c.cat_id = i.cat_id
    WHERE i.item_id = p_item_id;

    END P_GET_ITEM_ID;

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
    
        l_count NUMBER;
        
    BEGIN
        
        -- Validar que exista el catálogo
        SELECT COUNT(*)
        INTO l_count
        FROM ttem_catalog
        WHERE cat_id = p_cat_id;

        IF l_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Catalogo no existe');
        END IF;

        -- Validar item duplicado dentro del catálogo
        SELECT COUNT(*)
        INTO l_count
        FROM ttem_item
        WHERE cat_id = p_cat_id
          AND item_code = p_item_code;

        IF l_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Item duplicado');
        END IF;
    
    
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
    
        l_count NUMBER;
    
    BEGIN
    
        -- Validar existencia del item
        SELECT COUNT(*)
        INTO l_count
        FROM ttem_item
        WHERE item_id = p_item_id;

        IF l_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Item no existe');
        END IF;
    
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
    
        l_count NUMBER;
        
    BEGIN
        
        -- Validar existencia del item
        SELECT COUNT(*)
        INTO l_count
        FROM ttem_item
        WHERE item_id = p_item_id;

        IF l_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Item no existe');
        END IF;
    
    
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
        l_count NUMBER;
    BEGIN
    
        -- Validar existencia del catálogo
        SELECT COUNT(*)
        INTO l_count
        FROM ttem_catalog
        WHERE cat_id = p_cat_id;

        IF l_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Catalogo no existe');
        END IF;
    
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