/* ============================================================
   10 · Infraestructura de verificadores (esquema chk)
   Lo ejecuta base/instalar.ps1. Se puede volver a ejecutar sin perder
   tu historial de intentos (chk.intento).

   Cómo funciona un verificador:
   1. Tú guardas tu resultado en la tabla temporal #respuesta.
   2. chk.sXX_eN normaliza #respuesta (nombres de columna en minúsculas,
      números redondeados a 2 decimales, fechas en formato ISO, texto sin
      espacios sobrantes) y calcula un hash de cada columna y del total.
   3. Compara esos hashes con los esperados. Aquí solo hay hashes:
      ni las consultas de referencia ni los resultados.
   ============================================================ */
USE PayMarket_Analitica;
GO

IF OBJECT_ID(N'chk.ejercicio', N'U') IS NULL
    CREATE TABLE chk.ejercicio (
        ejercicio_id  VARCHAR(20)    NOT NULL CONSTRAINT pk_chk_ejercicio PRIMARY KEY,
        sesion        CHAR(3)        NOT NULL,
        titulo        NVARCHAR(200)  NOT NULL,
        num_filas     INT            NOT NULL,
        pista_filas   NVARCHAR(400)  NULL,
        hash_total    VARBINARY(32)  NOT NULL
    );

IF OBJECT_ID(N'chk.ejercicio_columna', N'U') IS NULL
    CREATE TABLE chk.ejercicio_columna (
        ejercicio_id  VARCHAR(20)    NOT NULL CONSTRAINT fk_chk_columna_ejercicio REFERENCES chk.ejercicio (ejercicio_id),
        orden         TINYINT        NOT NULL,
        nombre        NVARCHAR(128)  NOT NULL,
        familia       VARCHAR(6)     NOT NULL CONSTRAINT ck_chk_columna_familia CHECK (familia IN ('numero', 'texto', 'fecha')),
        hash_columna  VARBINARY(32)  NOT NULL,
        pista         NVARCHAR(400)  NULL,
        CONSTRAINT pk_chk_ejercicio_columna PRIMARY KEY (ejercicio_id, orden),
        CONSTRAINT uq_chk_ejercicio_columna UNIQUE (ejercicio_id, nombre)
    );

IF OBJECT_ID(N'chk.intento', N'U') IS NULL
    CREATE TABLE chk.intento (
        intento_id    INT IDENTITY(1, 1) CONSTRAINT pk_chk_intento PRIMARY KEY,
        ejercicio_id  VARCHAR(20)   NOT NULL,
        fecha_hora    DATETIME2(0)  NOT NULL CONSTRAINT df_chk_intento_fecha DEFAULT SYSDATETIME(),
        correcto      BIT           NOT NULL
    );
GO

/* Familia de un tipo de dato: numero, fecha o texto */
CREATE OR ALTER FUNCTION chk.fn_familia (@tipo SYSNAME)
RETURNS VARCHAR(6)
AS
BEGIN
    RETURN CASE
        WHEN @tipo IN ('tinyint', 'smallint', 'int', 'bigint', 'decimal', 'numeric', 'money', 'smallmoney', 'float', 'real', 'bit')
            THEN 'numero'
        WHEN @tipo IN ('date', 'datetime', 'datetime2', 'smalldatetime', 'datetimeoffset')
            THEN 'fecha'
        ELSE 'texto'
    END;
END;
GO

/* Expresión que convierte una columna en texto normalizado */
CREATE OR ALTER FUNCTION chk.fn_expresion (@columna SYSNAME, @tipo SYSNAME)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @c NVARCHAR(300) = QUOTENAME(@columna);
    DECLARE @e NVARCHAR(MAX) = CASE
        WHEN chk.fn_familia(@tipo) = 'numero'
            THEN N'CONVERT(NVARCHAR(60), CAST(ROUND(CAST(' + @c + N' AS DECIMAL(38, 6)), 2) AS DECIMAL(38, 2)))'
        WHEN @tipo = 'date'
            THEN N'CONVERT(NVARCHAR(10), ' + @c + N', 23)'
        WHEN chk.fn_familia(@tipo) = 'fecha'
            THEN N'CASE WHEN CAST(' + @c + N' AS TIME) = ''00:00:00'' THEN CONVERT(NVARCHAR(10), ' + @c
                 + N', 23) ELSE CONVERT(NVARCHAR(19), ' + @c + N', 120) END'
        ELSE N'LTRIM(RTRIM(CAST(' + @c + N' AS NVARCHAR(4000))))'
    END;
    RETURN N'COALESCE(' + @e + N', N''<nulo>'')';
END;
GO

/* Calcula la firma de #respuesta y la deja en #firma (la crea quien llama).
   Con @ejercicio: usa las columnas esperadas, en su orden.
   Sin @ejercicio: usa todas las columnas de #respuesta. */
CREATE OR ALTER PROCEDURE chk.calcular_firma
    @ejercicio VARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @columnas TABLE (orden INT, nombre NVARCHAR(128), tipo SYSNAME);

    IF @ejercicio IS NULL
        INSERT INTO @columnas (orden, nombre, tipo)
        SELECT c.column_id, LOWER(c.name), TYPE_NAME(c.system_type_id)
        FROM tempdb.sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'tempdb..#respuesta');
    ELSE
        INSERT INTO @columnas (orden, nombre, tipo)
        SELECT e.orden, e.nombre, TYPE_NAME(c.system_type_id)
        FROM chk.ejercicio_columna AS e
        JOIN tempdb.sys.columns AS c
          ON c.object_id = OBJECT_ID(N'tempdb..#respuesta')
         AND LOWER(c.name) COLLATE DATABASE_DEFAULT = e.nombre COLLATE DATABASE_DEFAULT
        WHERE e.ejercicio_id = @ejercicio;

    DECLARE @lista NVARCHAR(MAX), @sql NVARCHAR(MAX);

    SELECT @lista = STRING_AGG(CAST(chk.fn_expresion(nombre, tipo) AS NVARCHAR(MAX)), N', NCHAR(9), ')
                    WITHIN GROUP (ORDER BY orden)
    FROM @columnas;

    SET @sql = N'INSERT INTO #firma (orden, nombre, familia, valor_hash, filas)
        SELECT 0, N''*'', '''',
               HASHBYTES(''SHA2_256'', COALESCE(STRING_AGG(fila, NCHAR(10)) WITHIN GROUP (ORDER BY fila), N'''')),
               COUNT(*)
        FROM (SELECT CONCAT(CAST(N'''' AS NVARCHAR(MAX)), ' + @lista + N') COLLATE Latin1_General_BIN2 AS fila FROM #respuesta) AS x;';
    EXEC sys.sp_executesql @sql;

    SELECT @sql = STRING_AGG(CAST(
        N'INSERT INTO #firma (orden, nombre, familia, valor_hash, filas) SELECT '
        + CAST(orden AS NVARCHAR(10)) + N', N''' + REPLACE(nombre, N'''', N'''''') + N''', '''
        + chk.fn_familia(tipo) + N''', HASHBYTES(''SHA2_256'', COALESCE(STRING_AGG(v, NCHAR(10)) '
        + N'WITHIN GROUP (ORDER BY v), N'''')), COUNT(*) FROM (SELECT CAST('
        + chk.fn_expresion(nombre, tipo) + N' AS NVARCHAR(MAX)) COLLATE Latin1_General_BIN2 AS v FROM #respuesta) AS x;'
        AS NVARCHAR(MAX)), NCHAR(10))
    FROM @columnas;
    EXEC sys.sp_executesql @sql;
END;
GO

/* Verificador genérico: compara #respuesta con lo esperado para @ejercicio */
CREATE OR ALTER PROCEDURE chk.verificar
    @ejercicio VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @msg NVARCHAR(2000), @correcto BIT = 0,
            @filas_esp INT, @hash_esp VARBINARY(32), @pista_filas NVARCHAR(400);

    SELECT @filas_esp = num_filas, @hash_esp = hash_total, @pista_filas = pista_filas
    FROM chk.ejercicio
    WHERE ejercicio_id = @ejercicio;

    IF @hash_esp IS NULL
        SET @msg = N'⚠️ No existe el verificador ' + COALESCE(@ejercicio, N'(vacío)')
                 + N'. Revisa el nombre o reinstala los verificadores (SETUP.md).';

    IF @msg IS NULL AND OBJECT_ID(N'tempdb..#respuesta') IS NULL
        SET @msg = N'❌ No encontré la tabla #respuesta. Revisa que tu SELECT tenga INTO #respuesta justo antes '
                 + N'del FROM y que lo ejecutes en esta misma ventana de SSMS, antes del EXEC.';

    DECLARE @mias TABLE (nombre NVARCHAR(128), tipo SYSNAME);
    IF @msg IS NULL
        INSERT INTO @mias (nombre, tipo)
        SELECT LOWER(name), TYPE_NAME(system_type_id)
        FROM tempdb.sys.columns
        WHERE object_id = OBJECT_ID(N'tempdb..#respuesta');

    /* 1. Columnas que faltan o sobran */
    IF @msg IS NULL
    BEGIN
        DECLARE @faltan NVARCHAR(1000), @n_faltan INT, @sobran NVARCHAR(1000), @n_sobran INT, @esperadas NVARCHAR(1000);

        SELECT @faltan = STRING_AGG(N'`' + e.nombre + N'`', N', ') WITHIN GROUP (ORDER BY e.orden),
               @n_faltan = COUNT(*)
        FROM chk.ejercicio_columna AS e
        WHERE e.ejercicio_id = @ejercicio
          AND NOT EXISTS (SELECT 1 FROM @mias AS m
                          WHERE m.nombre COLLATE DATABASE_DEFAULT = e.nombre COLLATE DATABASE_DEFAULT);

        SELECT @sobran = STRING_AGG(N'`' + m.nombre + N'`', N', '), @n_sobran = COUNT(*)
        FROM @mias AS m
        WHERE NOT EXISTS (SELECT 1 FROM chk.ejercicio_columna AS e
                          WHERE e.ejercicio_id = @ejercicio
                            AND e.nombre COLLATE DATABASE_DEFAULT = m.nombre COLLATE DATABASE_DEFAULT);

        SELECT @esperadas = STRING_AGG(N'`' + nombre + N'`', N', ') WITHIN GROUP (ORDER BY orden)
        FROM chk.ejercicio_columna
        WHERE ejercicio_id = @ejercicio;

        IF @n_faltan > 0
            SET @msg = N'❌ ' + CASE WHEN @n_faltan = 1 THEN N'Falta la columna ' ELSE N'Faltan las columnas ' END
                     + @faltan + N'.'
                     + CASE WHEN @n_sobran > 0 THEN N' En tu tabla aparece ' + @sobran + N': ¿le pusiste otro alias?'
                            ELSE N' Revisa los alias de tu SELECT.' END;
        ELSE IF @n_sobran > 0
            SET @msg = N'❌ ' + CASE WHEN @n_sobran = 1 THEN N'Sobra la columna ' ELSE N'Sobran las columnas ' END
                     + @sobran + N'. El resultado esperado tiene solo estas columnas: ' + @esperadas + N'.';
    END;

    /* 2. Tipo de dato de cada columna */
    IF @msg IS NULL
    BEGIN
        DECLARE @tipos_mal NVARCHAR(1000);
        SELECT @tipos_mal = STRING_AGG(
                   N'`' + e.nombre + N'` debería ser '
                   + CASE e.familia WHEN 'numero' THEN N'un número' WHEN 'fecha' THEN N'una fecha' ELSE N'texto' END
                   + N' y la tuya es '
                   + CASE chk.fn_familia(m.tipo) WHEN 'numero' THEN N'un número' WHEN 'fecha' THEN N'una fecha' ELSE N'texto' END,
                   N'; ') WITHIN GROUP (ORDER BY e.orden)
        FROM chk.ejercicio_columna AS e
        JOIN @mias AS m ON m.nombre COLLATE DATABASE_DEFAULT = e.nombre COLLATE DATABASE_DEFAULT
        WHERE e.ejercicio_id = @ejercicio
          AND e.familia <> chk.fn_familia(m.tipo);

        IF @tipos_mal IS NOT NULL
            SET @msg = N'❌ La columna ' + @tipos_mal + N'. Revisa el cálculo o conviértela con CAST.';
    END;

    /* 3. Número de filas y 4. contenido */
    IF @msg IS NULL
    BEGIN
        CREATE TABLE #firma (orden INT, nombre NVARCHAR(128), familia VARCHAR(6), valor_hash VARBINARY(32), filas INT);
        EXEC chk.calcular_firma @ejercicio;

        DECLARE @filas INT, @hash VARBINARY(32);
        SELECT @filas = filas, @hash = valor_hash FROM #firma WHERE orden = 0;

        IF @filas <> @filas_esp
            SET @msg = N'❌ Tu resultado tiene ' + FORMAT(@filas, N'N0', N'es-PE') + N' '
                     + CASE WHEN @filas = 1 THEN N'fila' ELSE N'filas' END
                     + N'; se esperaban ' + FORMAT(@filas_esp, N'N0', N'es-PE') + N'. '
                     + COALESCE(@pista_filas,
                         CASE WHEN @filas = 0 THEN N'Algún filtro está dejando fuera todas las filas.'
                              WHEN @filas > @filas_esp THEN N'Revisa qué filas estás dejando pasar: puede faltar una condición o haber filas repetidas.'
                              ELSE N'Revisa si algún filtro está dejando fuera filas que sí corresponden.' END);
        ELSE
        BEGIN
            DECLARE @malas NVARCHAR(1000), @n_malas INT, @pista NVARCHAR(400);

            SELECT @malas = STRING_AGG(N'`' + e.nombre + N'`', N', ') WITHIN GROUP (ORDER BY e.orden),
                   @n_malas = COUNT(*)
            FROM chk.ejercicio_columna AS e
            JOIN #firma AS f ON f.nombre COLLATE DATABASE_DEFAULT = e.nombre COLLATE DATABASE_DEFAULT
            WHERE e.ejercicio_id = @ejercicio
              AND f.orden > 0
              AND f.valor_hash <> e.hash_columna;

            SELECT TOP (1) @pista = e.pista
            FROM chk.ejercicio_columna AS e
            JOIN #firma AS f ON f.nombre COLLATE DATABASE_DEFAULT = e.nombre COLLATE DATABASE_DEFAULT
            WHERE e.ejercicio_id = @ejercicio
              AND f.orden > 0
              AND f.valor_hash <> e.hash_columna
              AND e.pista IS NOT NULL
            ORDER BY e.orden;

            IF @n_malas > 0
                SET @msg = N'❌ Tienes el número correcto de filas y las columnas esperadas, pero '
                         + CASE WHEN @n_malas = 1 THEN N'la columna ' + @malas + N' no coincide. '
                                ELSE N'las columnas ' + @malas + N' no coinciden. ' END
                         + COALESCE(@pista, N'Revisa cómo las calculas y qué filas entran en el cálculo.');
            ELSE IF @hash <> @hash_esp
                SET @msg = N'❌ Cada columna tiene los valores correctos por separado, pero no están bien emparejados '
                         + N'fila por fila. Revisa que cada fila junte los datos que le corresponden.';
            ELSE
            BEGIN
                SET @correcto = 1;
                SET @msg = N'✅ ¡Correcto! ' + @ejercicio + N' superado ('
                         + FORMAT(@filas, N'N0', N'es-PE') + CASE WHEN @filas = 1 THEN N' fila).' ELSE N' filas).' END;
            END;
        END;
    END;

    IF EXISTS (SELECT 1 FROM chk.ejercicio WHERE ejercicio_id = @ejercicio)
        INSERT INTO chk.intento (ejercicio_id, correcto) VALUES (@ejercicio, @correcto);

    SELECT @msg AS resultado_verificacion;
    PRINT @msg;
END;
GO

/* Tu avance: EXEC chk.ver_progreso;  o  EXEC chk.ver_progreso 'S01'; */
CREATE OR ALTER PROCEDURE chk.ver_progreso
    @sesion CHAR(3) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT e.sesion,
           e.ejercicio_id,
           e.titulo,
           CASE WHEN MAX(CAST(i.correcto AS INT)) = 1 THEN N'✅' ELSE N'—' END AS superado,
           COUNT(i.intento_id) AS intentos,
           MIN(CASE WHEN i.correcto = 1 THEN i.fecha_hora END) AS primera_vez_correcto
    FROM chk.ejercicio AS e
    LEFT JOIN chk.intento AS i
           ON i.ejercicio_id = e.ejercicio_id
    WHERE @sesion IS NULL OR e.sesion = @sesion
    GROUP BY e.sesion, e.ejercicio_id, e.titulo
    ORDER BY e.sesion, e.ejercicio_id;
END;
GO

/* Huella de los datos: permite comprobar que dos instalaciones son idénticas */
CREATE OR ALTER PROCEDURE chk.huella_datos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT tabla, filas, huella
    FROM (
        SELECT 'core.ubigeo' AS tabla, COUNT(*) AS filas, CHECKSUM_AGG(BINARY_CHECKSUM(*)) AS huella FROM core.ubigeo
        UNION ALL SELECT 'core.canal', COUNT(*), CHECKSUM_AGG(BINARY_CHECKSUM(*)) FROM core.canal
        UNION ALL SELECT 'core.rubro_mcc', COUNT(*), CHECKSUM_AGG(BINARY_CHECKSUM(*)) FROM core.rubro_mcc
        UNION ALL SELECT 'core.codigo_respuesta', COUNT(*), CHECKSUM_AGG(BINARY_CHECKSUM(*)) FROM core.codigo_respuesta
        UNION ALL SELECT 'core.cliente', COUNT(*), CHECKSUM_AGG(BINARY_CHECKSUM(*)) FROM core.cliente
        UNION ALL SELECT 'core.cuenta', COUNT(*), CHECKSUM_AGG(BINARY_CHECKSUM(*)) FROM core.cuenta
        UNION ALL SELECT 'core.comercio', COUNT(*), CHECKSUM_AGG(BINARY_CHECKSUM(*)) FROM core.comercio
        UNION ALL SELECT 'core.promocion', COUNT(*), CHECKSUM_AGG(BINARY_CHECKSUM(*)) FROM core.promocion
        UNION ALL SELECT 'core.tipo_cambio', COUNT(*), CHECKSUM_AGG(BINARY_CHECKSUM(*)) FROM core.tipo_cambio
        UNION ALL SELECT 'core.transaccion', COUNT(*), CHECKSUM_AGG(BINARY_CHECKSUM(*)) FROM core.transaccion
        UNION ALL SELECT 'core.contracargo', COUNT(*), CHECKSUM_AGG(BINARY_CHECKSUM(*)) FROM core.contracargo
        UNION ALL SELECT 'core.credito', COUNT(*), CHECKSUM_AGG(BINARY_CHECKSUM(*)) FROM core.credito
        UNION ALL SELECT 'core.cuota', COUNT(*), CHECKSUM_AGG(BINARY_CHECKSUM(*)) FROM core.cuota
        UNION ALL SELECT 'core.pago_cuota', COUNT(*), CHECKSUM_AGG(BINARY_CHECKSUM(*)) FROM core.pago_cuota
        UNION ALL SELECT 'stg.clientes_legado', COUNT(*), CHECKSUM_AGG(BINARY_CHECKSUM(*)) FROM stg.clientes_legado
        UNION ALL SELECT 'stg.liquidacion_pos', COUNT(*), CHECKSUM_AGG(BINARY_CHECKSUM(*)) FROM stg.liquidacion_pos
    ) AS t
    ORDER BY tabla;
END;
GO
