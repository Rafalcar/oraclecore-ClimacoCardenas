-- =====================================================================
-- SECCION A - A.1 Modelado de Catalogos
-- =====================================================================
CREATE TABLE ttem_catalog (
    cat_id NUMBER(10) NOT NULL,
    cat_code VARCHAR2(30) NOT NULL,
    cat_name VARCHAR2(100) NOT NULL,
    description VARCHAR2(250),
    status CHAR(1) DEFAULT 'A' NOT NULL,
    -- Datos de Auditoria --  
    created_by VARCHAR2(30) NOT NULL,
    created_at DATE DEFAULT SYSDATE NOT NULL,
    updated_by VARCHAR2(30) NOT NULL,
    updated_at DATE NOT NULL,
    --- se coloca cat id como llave primaria 
    CONSTRAINT pk_ttem_catalog
        PRIMARY KEY (cat_id),    
    -- se coloca cat code como codigo unico
    CONSTRAINT uk_ttem_catalog_catalog_code
        UNIQUE (cat_code),
    -- se restrinje estado a estos dos valores    
    CONSTRAINT ck_ttem_catalog_status
        CHECK (status IN ('A','I'))
);
CREATE TABLE ttem_item (
    item_id NUMBER(10) NOT NULL,
    cat_id NUMBER(10) NOT NULL,
    item_code VARCHAR2(30) NOT NULL,
    item_name VARCHAR2(200) NOT NULL,
    item_value VARCHAR2(200),
    display_order NUMBER(5) DEFAULT 0 NOT NULL,
    status CHAR(1) DEFAULT 'A' NOT NULL,
    valid_from DATE NOT NULL,
    valid_to DATE,
    -- Datos de Auditoria --
    created_by VARCHAR2(30) NOT NULL,
    created_at DATE DEFAULT SYSDATE NOT NULL,
    updated_by VARCHAR2(30) NOT NULL,
    updated_at DATE NOT NULL,
    -- se coloca item id como llave primaria
    CONSTRAINT pk_ttem_item
        PRIMARY KEY (item_id),
    -- Se coloca cat id como llave foranea con ttem_catalogo
    CONSTRAINT fk_ttem_item_ttem_catalog
        FOREIGN KEY (cat_id)
        REFERENCES ttem_catalog (cat_id),
    -- se define la combinacion cat id, item code como unico
    CONSTRAINT uk_ttem_item_catalog_code
        UNIQUE (cat_id, item_code),
    -- se restrinje estado a estos dos valores
    CONSTRAINT ck_ttem_item_status
        CHECK (status IN ('A','I')),
    -- se agrega validacion de fecha desde hasta
    CONSTRAINT ck_ttem_item_valid_to
        CHECK (
            valid_to IS NULL
            OR valid_to >= valid_from
        )
);
CREATE INDEX ix_ttem_item_catalog_id
ON ttem_item (cat_id);
CREATE TABLE ttem_audit_log (
    audit_id NUMBER(12) NOT NULL,
    table_name VARCHAR2(30) NOT NULL,
    record_id NUMBER(10) NOT NULL,
    operation_type VARCHAR2(10) NOT NULL,
    old_value VARCHAR2(4000),
    new_value VARCHAR2(4000),
    audit_user VARCHAR2(30) NOT NULL,
    audit_date TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT pk_ttem_audit_log
        PRIMARY KEY (audit_id),
    CONSTRAINT ck_ttem_audit_operation
        CHECK (operation_type IN ('INSERT','UPDATE','DELETE'))
);