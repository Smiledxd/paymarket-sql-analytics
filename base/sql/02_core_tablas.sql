/* ============================================================
   02 · Tablas del esquema core (datos limpios del negocio)
   Lo ejecuta base/instalar.ps1. Descripción de cada columna: base/diccionario_datos.md
   ============================================================ */
USE PayMarket_Analitica;
GO

CREATE TABLE core.ubigeo (
    ubigeo_id       CHAR(6)      NOT NULL CONSTRAINT pk_ubigeo PRIMARY KEY,
    departamento    VARCHAR(40)  NOT NULL,
    provincia       VARCHAR(40)  NOT NULL,
    distrito        VARCHAR(60)  NOT NULL,
    region_natural  VARCHAR(10)  NOT NULL,
    CONSTRAINT ck_ubigeo_formato CHECK (ubigeo_id NOT LIKE '%[^0-9]%'),
    CONSTRAINT ck_ubigeo_region  CHECK (region_natural IN ('Costa', 'Sierra', 'Selva'))
);

CREATE TABLE core.canal (
    canal_id      TINYINT      NOT NULL CONSTRAINT pk_canal PRIMARY KEY,
    nombre_canal  VARCHAR(30)  NOT NULL CONSTRAINT uq_canal_nombre UNIQUE
);

CREATE TABLE core.rubro_mcc (
    mcc          CHAR(4)      NOT NULL CONSTRAINT pk_rubro_mcc PRIMARY KEY,
    descripcion  VARCHAR(80)  NOT NULL,
    grupo        VARCHAR(30)  NOT NULL,
    CONSTRAINT ck_rubro_mcc_formato CHECK (mcc NOT LIKE '%[^0-9]%')
);

CREATE TABLE core.codigo_respuesta (
    codigo_respuesta  CHAR(2)      NOT NULL CONSTRAINT pk_codigo_respuesta PRIMARY KEY,
    descripcion       VARCHAR(60)  NOT NULL,
    tipo_respuesta    VARCHAR(25)  NOT NULL,
    CONSTRAINT ck_codigo_respuesta_tipo
        CHECK (tipo_respuesta IN ('Aprobada', 'Rechazo del cliente', 'Rechazo técnico', 'Sospecha de fraude'))
);

CREATE TABLE core.cliente (
    cliente_id            INT           NOT NULL CONSTRAINT pk_cliente PRIMARY KEY,
    tipo_documento        VARCHAR(3)    NOT NULL,
    numero_documento      VARCHAR(12)   NOT NULL,
    nombres               VARCHAR(60)   NOT NULL,
    apellido_paterno      VARCHAR(40)   NOT NULL,
    apellido_materno      VARCHAR(40)   NULL,
    fecha_nacimiento      DATE          NULL,
    sexo                  CHAR(1)       NOT NULL,
    correo                VARCHAR(100)  NULL,
    celular               CHAR(9)       NULL,
    ubigeo_id             CHAR(6)       NOT NULL CONSTRAINT fk_cliente_ubigeo REFERENCES core.ubigeo (ubigeo_id),
    fecha_alta            DATE          NOT NULL,
    canal_adquisicion     VARCHAR(20)   NOT NULL,
    cliente_referidor_id  INT           NULL CONSTRAINT fk_cliente_referidor REFERENCES core.cliente (cliente_id),
    estado                VARCHAR(10)   NOT NULL,
    CONSTRAINT uq_cliente_documento UNIQUE (tipo_documento, numero_documento),
    CONSTRAINT ck_cliente_tipo_documento CHECK (tipo_documento IN ('DNI', 'CE')),
    CONSTRAINT ck_cliente_numero_documento CHECK (
        numero_documento NOT LIKE '%[^0-9]%'
        AND ((tipo_documento = 'DNI' AND LEN(numero_documento) = 8)
          OR (tipo_documento = 'CE'  AND LEN(numero_documento) = 9))),
    CONSTRAINT ck_cliente_sexo CHECK (sexo IN ('F', 'M')),
    CONSTRAINT ck_cliente_celular CHECK (celular LIKE '9[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT ck_cliente_correo CHECK (correo LIKE '_%@_%._%'),
    CONSTRAINT ck_cliente_canal CHECK (canal_adquisicion IN ('Orgánico', 'Campaña digital', 'Referido')),
    CONSTRAINT ck_cliente_referido CHECK (
        (canal_adquisicion = 'Referido' AND cliente_referidor_id IS NOT NULL)
        OR (canal_adquisicion <> 'Referido' AND cliente_referidor_id IS NULL)),
    CONSTRAINT ck_cliente_no_autorreferido CHECK (cliente_referidor_id <> cliente_id),
    CONSTRAINT ck_cliente_estado CHECK (estado IN ('Activo', 'Bloqueado', 'Cerrado')),
    CONSTRAINT ck_cliente_nacimiento CHECK (fecha_nacimiento < fecha_alta)
);
CREATE UNIQUE INDEX uq_cliente_correo ON core.cliente (correo) WHERE correo IS NOT NULL;

CREATE TABLE core.cuenta (
    cuenta_id            INT          NOT NULL CONSTRAINT pk_cuenta PRIMARY KEY,
    cliente_id           INT          NOT NULL CONSTRAINT fk_cuenta_cliente REFERENCES core.cliente (cliente_id),
    moneda               CHAR(3)      NOT NULL,
    fecha_apertura       DATE         NOT NULL,
    estado               VARCHAR(10)  NOT NULL,
    fecha_cambio_estado  DATE         NULL,
    CONSTRAINT uq_cuenta_cliente_moneda UNIQUE (cliente_id, moneda),
    CONSTRAINT ck_cuenta_moneda CHECK (moneda IN ('PEN', 'USD')),
    CONSTRAINT ck_cuenta_estado CHECK (estado IN ('Activa', 'Bloqueada', 'Cerrada')),
    CONSTRAINT ck_cuenta_fecha_estado CHECK (
        (estado = 'Activa' AND fecha_cambio_estado IS NULL)
        OR (estado <> 'Activa' AND fecha_cambio_estado >= fecha_apertura))
);

CREATE TABLE core.comercio (
    comercio_id       INT           NOT NULL CONSTRAINT pk_comercio PRIMARY KEY,
    ruc               CHAR(11)      NOT NULL CONSTRAINT uq_comercio_ruc UNIQUE,
    razon_social      VARCHAR(120)  NOT NULL,
    nombre_comercial  VARCHAR(80)   NOT NULL CONSTRAINT uq_comercio_nombre UNIQUE,
    mcc               CHAR(4)       NOT NULL CONSTRAINT fk_comercio_mcc REFERENCES core.rubro_mcc (mcc),
    ubigeo_id         CHAR(6)       NOT NULL CONSTRAINT fk_comercio_ubigeo REFERENCES core.ubigeo (ubigeo_id),
    modalidad         VARCHAR(10)   NOT NULL,
    fecha_afiliacion  DATE          NOT NULL,
    tasa_mdr          DECIMAL(6,4)  NOT NULL,
    estado            VARCHAR(12)   NOT NULL,
    CONSTRAINT ck_comercio_ruc CHECK (ruc NOT LIKE '%[^0-9]%' AND LEFT(ruc, 2) IN ('10', '20')),
    CONSTRAINT ck_comercio_modalidad CHECK (modalidad IN ('Presencial', 'Online')),
    CONSTRAINT ck_comercio_tasa CHECK (tasa_mdr >= 0 AND tasa_mdr < 0.10),
    CONSTRAINT ck_comercio_estado CHECK (estado IN ('Activo', 'Suspendido'))
);

CREATE TABLE core.promocion (
    promocion_id          INT           NOT NULL CONSTRAINT pk_promocion PRIMARY KEY,
    nombre                VARCHAR(60)   NOT NULL CONSTRAINT uq_promocion_nombre UNIQUE,
    tipo_beneficio        VARCHAR(10)   NOT NULL,
    porcentaje_beneficio  DECIMAL(5,2)  NOT NULL,
    tope_beneficio        DECIMAL(10,2) NOT NULL,
    fecha_inicio          DATE          NOT NULL,
    fecha_fin             DATE          NOT NULL,
    CONSTRAINT ck_promocion_tipo CHECK (tipo_beneficio IN ('Cashback', 'Descuento')),
    CONSTRAINT ck_promocion_porcentaje CHECK (porcentaje_beneficio > 0 AND porcentaje_beneficio <= 100),
    CONSTRAINT ck_promocion_fechas CHECK (fecha_fin >= fecha_inicio)
);

CREATE TABLE core.tipo_cambio (
    fecha   DATE          NOT NULL CONSTRAINT pk_tipo_cambio PRIMARY KEY,
    compra  DECIMAL(6,3)  NOT NULL,
    venta   DECIMAL(6,3)  NOT NULL,
    CONSTRAINT ck_tipo_cambio CHECK (compra > 0 AND venta >= compra)
);

CREATE TABLE core.transaccion (
    transaccion_id    INT            NOT NULL CONSTRAINT pk_transaccion PRIMARY KEY,
    fecha_hora        DATETIME2(0)   NOT NULL,
    cuenta_id         INT            NOT NULL CONSTRAINT fk_transaccion_cuenta REFERENCES core.cuenta (cuenta_id),
    comercio_id       INT            NOT NULL CONSTRAINT fk_transaccion_comercio REFERENCES core.comercio (comercio_id),
    canal_id          TINYINT        NOT NULL CONSTRAINT fk_transaccion_canal REFERENCES core.canal (canal_id),
    moneda            CHAR(3)        NOT NULL,
    monto             DECIMAL(12,2)  NOT NULL,
    codigo_respuesta  CHAR(2)        NOT NULL CONSTRAINT fk_transaccion_codigo REFERENCES core.codigo_respuesta (codigo_respuesta),
    estado            VARCHAR(10)    NOT NULL,
    comision          DECIMAL(12,2)  NOT NULL,
    promocion_id      INT            NULL CONSTRAINT fk_transaccion_promocion REFERENCES core.promocion (promocion_id),
    latencia_ms       INT            NOT NULL,
    CONSTRAINT ck_transaccion_moneda CHECK (moneda IN ('PEN', 'USD')),
    CONSTRAINT ck_transaccion_monto CHECK (monto > 0),
    CONSTRAINT ck_transaccion_estado CHECK (estado IN ('Aprobada', 'Rechazada', 'Extornada')),
    CONSTRAINT ck_transaccion_estado_codigo CHECK (
        (estado = 'Rechazada' AND codigo_respuesta <> '00')
        OR (estado <> 'Rechazada' AND codigo_respuesta = '00')),
    CONSTRAINT ck_transaccion_comision CHECK (comision >= 0 AND (estado = 'Aprobada' OR comision = 0)),
    CONSTRAINT ck_transaccion_latencia CHECK (latencia_ms > 0)
);

CREATE TABLE core.contracargo (
    contracargo_id     INT            NOT NULL CONSTRAINT pk_contracargo PRIMARY KEY,
    transaccion_id     INT            NOT NULL CONSTRAINT fk_contracargo_transaccion REFERENCES core.transaccion (transaccion_id)
                                               CONSTRAINT uq_contracargo_transaccion UNIQUE,
    fecha_contracargo  DATE           NOT NULL,
    motivo             VARCHAR(60)    NOT NULL,
    estado             VARCHAR(25)    NOT NULL,
    monto              DECIMAL(12,2)  NOT NULL,
    CONSTRAINT ck_contracargo_motivo CHECK (motivo IN ('No reconoce la compra', 'Producto o servicio no recibido',
        'Producto defectuoso o distinto al ofrecido', 'Cobro duplicado', 'Fraude con tarjeta')),
    CONSTRAINT ck_contracargo_estado CHECK (estado IN ('En proceso', 'A favor del cliente', 'A favor del comercio')),
    CONSTRAINT ck_contracargo_monto CHECK (monto > 0)
);

CREATE TABLE core.credito (
    credito_id        INT            NOT NULL CONSTRAINT pk_credito PRIMARY KEY,
    cliente_id        INT            NOT NULL CONSTRAINT fk_credito_cliente REFERENCES core.cliente (cliente_id),
    fecha_desembolso  DATE           NOT NULL,
    monto             DECIMAL(10,2)  NOT NULL,
    tea               DECIMAL(6,4)   NOT NULL,
    plazo_meses       TINYINT        NOT NULL,
    estado            VARCHAR(10)    NOT NULL,
    CONSTRAINT ck_credito_monto CHECK (monto > 0),
    CONSTRAINT ck_credito_tea CHECK (tea > 0 AND tea < 2),
    CONSTRAINT ck_credito_plazo CHECK (plazo_meses IN (3, 6, 9, 12)),
    CONSTRAINT ck_credito_estado CHECK (estado IN ('Vigente', 'Cancelado'))
);

CREATE TABLE core.cuota (
    credito_id         INT            NOT NULL CONSTRAINT fk_cuota_credito REFERENCES core.credito (credito_id),
    numero_cuota       TINYINT        NOT NULL,
    fecha_vencimiento  DATE           NOT NULL,
    monto_cuota        DECIMAL(10,2)  NOT NULL,
    capital            DECIMAL(10,2)  NOT NULL,
    interes            DECIMAL(10,2)  NOT NULL,
    CONSTRAINT pk_cuota PRIMARY KEY (credito_id, numero_cuota),
    CONSTRAINT ck_cuota_montos CHECK (capital > 0 AND interes >= 0 AND monto_cuota = capital + interes)
);

CREATE TABLE core.pago_cuota (
    pago_id       INT            NOT NULL CONSTRAINT pk_pago_cuota PRIMARY KEY,
    credito_id    INT            NOT NULL,
    numero_cuota  TINYINT        NOT NULL,
    fecha_pago    DATE           NOT NULL,
    monto         DECIMAL(10,2)  NOT NULL,
    CONSTRAINT fk_pago_cuota_cuota FOREIGN KEY (credito_id, numero_cuota) REFERENCES core.cuota (credito_id, numero_cuota),
    CONSTRAINT ck_pago_cuota_monto CHECK (monto > 0)
);
GO
