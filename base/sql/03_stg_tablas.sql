/* ============================================================
   03 · Tablas del esquema stg (datos crudos, sucios a propósito)
   Todo es texto, sin llaves ni restricciones: así llegan los archivos
   de los sistemas antiguos. Las limpiarás en S15, S16 y S17.
   ============================================================ */
USE PayMarket_Analitica;
GO

-- Exportación del sistema de registro antiguo (clientes registrados hasta junio de 2025)
CREATE TABLE stg.clientes_legado (
    id_legado       VARCHAR(20)   NULL,
    tipo_doc        VARCHAR(20)   NULL,
    nro_doc         VARCHAR(20)   NULL,
    nombres         VARCHAR(100)  NULL,
    apellidos       VARCHAR(100)  NULL,
    fecha_nac       VARCHAR(30)   NULL,
    sexo            VARCHAR(20)   NULL,
    email           VARCHAR(120)  NULL,
    telefono        VARCHAR(30)   NULL,
    ubigeo          VARCHAR(10)   NULL,
    fecha_registro  VARCHAR(30)   NULL,
    canal_origen    VARCHAR(30)   NULL
);

-- Archivos diarios de liquidación de POS (operaciones de abril a junio de 2026)
CREATE TABLE stg.liquidacion_pos (
    archivo          VARCHAR(40)  NULL,
    fecha_proceso    VARCHAR(20)  NULL,
    ruc_comercio     VARCHAR(20)  NULL,
    nro_operacion    VARCHAR(20)  NULL,
    fecha_operacion  VARCHAR(20)  NULL,
    hora_operacion   VARCHAR(10)  NULL,
    moneda           VARCHAR(5)   NULL,
    monto_bruto      VARCHAR(20)  NULL,
    comision         VARCHAR(20)  NULL,
    igv_comision     VARCHAR(20)  NULL,
    monto_neto       VARCHAR(20)  NULL
);
GO
