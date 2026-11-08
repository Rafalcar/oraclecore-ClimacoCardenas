SELECT
    a.account_no as NUMERO_DE_CUENTA,
    a.product_type as TIPO_DE_PRODUCTO,
    a.currency as MONEDA,
    a.balance as SALDO,
    a.status AS ESTADO_CUENTA,
    c.customer_id as ID_CLIENTE,
    CASE c.person_type
        WHEN 'N' THEN 'Natural'
        WHEN 'J' THEN 'Jurídica'
    END AS TIPO_PERSONA,
    c.doc_type as TIPO_DOCUMENTO,
    c.doc_number as NUM_DOCUMENTO,
    CASE
        WHEN c.person_type = 'N' THEN
            TRIM(
                REGEXP_REPLACE( -- concatena nombre y apellido
                    NVL(c.first_name, '') || ' ' || NVL(c.last_name, ''),
                    '[[:space:]]+',
                    ' '
                )
            )
        ELSE
            TRIM(c.business_name)
    END AS NOMBRE_CLIENTE,

    CASE
        WHEN c.person_type = 'N'
             AND c.birth_date IS NOT NULL
        THEN TO_CHAR(c.birth_date, 'YYYY-MM-DD')

        WHEN c.person_type = 'J'
             AND c.incorporation_date IS NOT NULL
        THEN TO_CHAR(c.incorporation_date, 'YYYY-MM-DD')

        ELSE ''
    END AS FECHA_REFERENCIA,

    CASE
        WHEN c.person_type = 'N'
             AND c.birth_date IS NOT NULL
        THEN 'Fecha de Nacimiento'

        WHEN c.person_type = 'J'
             AND c.incorporation_date IS NOT NULL
        THEN 'Fecha de Constitución'

        ELSE 'No registrada'
    END AS TIPO_REFERENCIA_FECHA,

    NVL(
        LISTAGG( -- se consolidan los usuarios en linea en un solo campo
            u.username || ' (' ||
            CASE u.status
                WHEN 'A' THEN 'Activo'
                WHEN 'B' THEN 'Bloqueado'
                WHEN 'I' THEN 'Inactivo'
            END || ')',
            ', '
        ) WITHIN GROUP (ORDER BY u.username),
        ''
    ) AS USUARIOS_EN_LINEA

FROM core_account a
INNER JOIN core_customer c
    ON c.customer_id = a.customer_id

LEFT JOIN olb_user u
    ON u.customer_id = c.customer_id

WHERE a.account_no = '&account_no' -- colocamos el numero como parametro de entrada

GROUP BY
    a.account_no,
    a.product_type,
    a.currency,
    a.balance,
    a.status,
    c.customer_id,
    c.person_type,
    c.doc_type,
    c.doc_number,
    c.first_name,
    c.last_name,
    c.business_name,
    c.birth_date,
    c.incorporation_date;