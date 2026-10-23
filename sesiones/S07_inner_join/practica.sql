/* ============================================================
   S07 · INNER JOIN
   Guía: sesiones/S07_inner_join/guia.md
   Pregunta del día: ¿Qué rubros y departamentos facturan más?

   Desde hoy la ficha de traducción viene vacía: respóndela en
   comentarios ANTES de escribir tu consulta.
   ============================================================ */
USE PayMarket_Analitica;
GO


/* ============================================================
   📘 EJEMPLO DE JUGUETE — la librería "El Lector Andino" en tres tablas
   ============================================================ */
DROP TABLE IF EXISTS #autores;
DROP TABLE IF EXISTS #libros;
DROP TABLE IF EXISTS #ventas_libros;
DROP TABLE IF EXISTS #cambio;

SELECT autor_id, nombre, pais
INTO #autores
FROM (VALUES (1, 'Rosa Paredes', 'Perú'), (2, 'Luis Ccori', 'Perú'), (3, 'Marta Gil', 'Chile')) AS v (autor_id, nombre, pais);

SELECT libro_id, titulo, autor_id, precio
INTO #libros
FROM (VALUES (10, 'Cuentos del río', 1, 35.00), (11, 'Poemas de la puna', 2, 28.50),
             (12, 'Historias de Tarapoto', 1, 40.00), (13, 'Mar de invierno', 3, 30.00)) AS v (libro_id, titulo, autor_id, precio);

SELECT venta_id, libro_id, CAST(fecha AS DATETIME2(0)) AS fecha, moneda, importe
INTO #ventas_libros
FROM (VALUES (1, 10, '2026-03-02 10:30:00', 'PEN', 35.00), (2, 13, '2026-03-02 17:05:00', 'USD', 8.00),
             (3, 12, '2026-03-03 09:10:00', 'PEN', 40.00), (4, 10, '2026-03-03 19:45:00', 'PEN', 35.00),
             (5, 11, '2026-03-03 20:00:00', 'USD', 7.50)) AS v (venta_id, libro_id, fecha, moneda, importe);

SELECT CAST(fecha AS DATE) AS fecha, compra
INTO #cambio
FROM (VALUES ('2026-03-02', 3.650), ('2026-03-03', 3.640)) AS v (fecha, compra);

-- 1) Dos tablas: cada libro con el nombre de su autor
SELECT l.titulo, a.nombre AS autor
FROM #libros AS l
JOIN #autores AS a ON a.autor_id = l.autor_id;

-- 2) Tres tablas: cada venta con su libro y su autor (sigue habiendo una fila por venta)
SELECT v.venta_id, l.titulo, a.nombre AS autor, a.pais
FROM #ventas_libros AS v
JOIN #libros AS l ON l.libro_id = v.libro_id
JOIN #autores AS a ON a.autor_id = l.autor_id;

-- 3) Resumen después de unir: ventas por país del autor
SELECT a.pais, COUNT(*) AS ventas
FROM #ventas_libros AS v
JOIN #libros AS l ON l.libro_id = v.libro_id
JOIN #autores AS a ON a.autor_id = l.autor_id
GROUP BY a.pais;

-- 4) Unir por fecha y convertir solo lo que está en dólares
SELECT v.venta_id, v.moneda, v.importe, c.compra,
       CASE WHEN v.moneda = 'USD' THEN v.importe * c.compra ELSE v.importe END AS importe_soles
FROM #ventas_libros AS v
JOIN #cambio AS c ON c.fecha = CAST(v.fecha AS DATE);

-- Descomenta y ejecuta: error 209, 'autor_id' existe en las dos tablas
-- SELECT titulo, autor_id FROM #libros AS l JOIN #autores AS a ON a.autor_id = l.autor_id;
GO


/* ============================================================
   ✍️ EJERCICIO 1 — Facturación presencial y online
   El directorio discute si invertir más en comercios presenciales u
   online. Con las operaciones APROBADAS en SOLES del primer semestre
   de 2026, compara ambas modalidades de comercio.

   Qué lograr: una fila por modalidad. Columnas:
     modalidad, operaciones, facturacion

   FICHA DE TRADUCCIÓN (respóndela tú)
   -- 1. ¿Qué me piden? 2 filas, modalidad presencial y online
   -- 2. ¿Dónde está? core.comercio y core.transacciones
   -- 3. ¿Qué filas?
   -- 4. ¿Resumir? si
   -- 5. ¿Qué muestro? resumen
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí (termina tu SELECT con INTO #respuesta antes del FROM)
SELECT
    comercio.modalidad AS modalidad,
    COUNT(*) AS operaciones,
    SUM(t.monto) AS facturacion,
    SUM(t.monto) / COUNT(*) AS ticket_promedio
--INTO #respuesta
FROM core.comercio AS comercio
JOIN core.transaccion AS t ON comercio.comercio_id = t.comercio_id
WHERE
    t.moneda = 'PEN'
    AND t.estado = 'Aprobada'
    AND (t.fecha_hora >= '20260101'
    AND t.fecha_hora < '20260701')
GROUP BY
    comercio.modalidad


EXEC chk.s07_e1;
GO
/* Para pensar: ¿qué modalidad tiene el ticket más alto? Calcúlalo
   con tus dos columnas. ¿Te sorprende? */
   /*Aunque el canal presencial tiene más operaciones. El ticket promedio más alto va para el canal Online
   Lo cual, sí me sorprende pero analizandolo, tiene su por qué, ya que las personas no suelen llevar montos grandes en efectivo*/

/* ============================================================
   ✍️ EJERCICIO 2 — Facturación y comisión por grupo de rubro
   Con las operaciones APROBADAS en SOLES del primer semestre de 2026,
   resume por grupo de rubro (la columna grupo de core.rubro_mcc).

   Qué lograr: una fila por grupo. Columnas:
     grupo, operaciones, facturacion, comision_total

   FICHA DE TRADUCCIÓN (respóndela tú)
   -- 1. ¿Qué me piden?
   -- 2. ¿Dónde está? (dibuja el camino entre tablas)
   -- 3. ¿Qué filas?
   -- 4. ¿Resumir?
   -- 5. ¿Qué muestro?
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí
SELECT
    rubro.grupo AS grupo,
    COUNT(*) AS operaciones,
    SUM(t.monto) AS facturacion,
    SUM(t.comision) AS comision_total
    --CAST(100.00 * SUM(t.comision) / SUM(t.monto) AS decimal(10,2)) AS pct_grupo
INTO #respuesta
FROM core.transaccion AS t
JOIN core.comercio AS comercio ON  t.comercio_id = comercio.comercio_id
JOIN core.rubro_mcc AS rubro ON comercio.mcc = rubro.mcc
WHERE
    t.estado = 'Aprobada'
    AND t.moneda = 'PEN'
    AND (t.fecha_hora >= '20260101'
    AND t.fecha_hora < '20260701')
GROUP BY
    rubro.grupo

EXEC chk.s07_e2;
GO
/* Para pensar: divide comision_total entre facturacion para cada grupo.
   ¿En qué grupo gana PayMarket un porcentaje mayor? ¿Por qué? */
   /*PayMarket gana un mayor porcentaje en el grupo de las "Mascotas"(3.61%), se puede deber a que existen comisiones
   altas en este tipo de negocios ,ya sean veterianarias o tiendas de mascotas. Por otro lado, esto se evidencia en
   el "Retail", ya que, de este se obtiene mayor comisión, pero es debido al volumen, por que sus comisiones son
   bajas debido a negociaciones*/

/* ============================================================
   ✍️ EJERCICIO 3 — Clientes y facturación por departamento del cliente
   Marketing planea campañas regionales. Con las operaciones APROBADAS
   en SOLES del primer semestre de 2026, quiere saber, por departamento
   donde VIVE EL CLIENTE, cuántos clientes distintos pagaron y cuánto
   facturaron.

   Qué lograr: una fila por departamento. Columnas:
     departamento, clientes, facturacion

   FICHA DE TRADUCCIÓN (respóndela tú)
   -- 1. ¿Qué me piden?
   -- 2. ¿Dónde está? (dibuja el camino entre tablas)
   -- 3. ¿Qué filas?
   -- 4. ¿Resumir?
   -- 5. ¿Qué muestro?
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí
SELECT
    u.departamento AS departamento,
    COUNT( DISTINCT cl.cliente_id) AS clientes,
    SUM(t.monto) AS facturacion
    --CAST( SUM(t.monto)/COUNT( DISTINCT cl.cliente_id) AS decimal(10,2)) AS ticket_promedio
INTO #respuesta
FROM core.transaccion AS t
JOIN core.cuenta AS c ON t.cuenta_id = c.cuenta_id
JOIN core.cliente AS cl ON c.cliente_id = cl.cliente_id
JOIN core.ubigeo AS u ON cl.ubigeo_id = u.ubigeo_id
WHERE
    t.estado = 'Aprobada'
    AND t.moneda = 'PEN'
    AND (t.fecha_hora >= '20260101'
    AND t.fecha_hora < '20260701')
GROUP BY
    u.departamento

EXEC chk.s07_e3;
GO
/* Para pensar: calcula la facturación por cliente de dos departamentos
   distintos. ¿Un departamento con pocos clientes puede ser tan valioso
   como uno con muchos? */
   /*Sí desde la perpestiva del valor por cliente. Ya que Moquegua cuenta con 44 cliente, pero su ticket promedio es de:
   S/ 1827.17. A comparación de Lima que abarca un mayor volumen de clientes, pero cada cliente aportó en promedio S/ 1732.40.*/

/* ============================================================
   ✍️ EJERCICIO 4 — Dólares a soles con el tipo de cambio del día
   Finanzas necesita reportar todo en soles. Con las operaciones
   APROBADAS del primer semestre de 2026 (en ambas monedas), muestra
   por moneda cuánto se facturó en la moneda original y cuánto es en
   soles, usando el tipo de cambio de COMPRA del día de cada operación.

   Qué lograr: una fila por moneda. Columnas:
     moneda, operaciones, facturacion_original, facturacion_soles

   FICHA DE TRADUCCIÓN (respóndela tú)
   -- 1. ¿Qué me piden?
   -- 2. ¿Dónde está?
   -- 3. ¿Qué filas?
   -- 4. ¿Resumir?
   -- 5. ¿Qué muestro?
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí
SELECT
    ISNULL(t.moneda,'net') AS moneda,
    COUNT(*) AS operaciones,
    SUM(t.monto) AS facturacion_original,
    SUM(CASE WHEN t.moneda = 'USD' THEN t.monto * c.compra ELSE t.monto END) AS facturacion_soles
INTO #respuesta
FROM core.transaccion AS t
JOIN core.tipo_cambio AS c ON CAST(t.fecha_hora AS DATE) = CAST(c.fecha AS DATE)
WHERE
    estado = 'Aprobada'
    AND (t.fecha_hora>= '20260101'
    AND t.fecha_hora < '20260701')
GROUP BY ROLLUP
    (t.moneda)

EXEC chk.s07_e4;
GO
/* Para pensar: ¿qué porcentaje de la facturación total en soles viene
   de operaciones en dólares? ¿Qué riesgo tiene PayMarket si el dólar
   baja mucho? */
   SELECT CAST((191187.16660 / 21274821.78660) * 100.00 AS DECIMAL(10,2)) AS pct_partic_usd_en_pen -- 0.90%
   /*El porcentaje de facturación de los soles que provienen de las operaciones en dólares(USD) no supera ni el 1%.
   El riesgo por parte de PayMarket es prácticamente mínimo. Puesto que, la mayor participación la tienen los soles peruanos(PEN)*/

/* ============================================================
   🏋️ RETO FINAL — ¿Qué rubros y departamentos facturan más?
   La pregunta del día. Con TODAS las operaciones APROBADAS del primer
   semestre de 2026 (soles y dólares, todo convertido a soles con el
   tipo de cambio de compra del día), encuentra las 10 combinaciones
   de departamento DEL CLIENTE y grupo de rubro que más facturan.
   Desempate: departamento y luego grupo, en orden alfabético.

   Qué lograr: 10 filas. Columnas:
     departamento, grupo, facturacion_soles

   FICHA DE TRADUCCIÓN (respóndela tú)
   -- 1. ¿Qué me piden?
   -- 2. ¿Dónde está?
   -- 3. ¿Qué filas?
   -- 4. ¿Resumir?
   -- 5. ¿Qué muestro y en qué orden?
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí
SELECT TOP 10
    u.departamento AS departamento,
    rubro.grupo AS grupo,
    CAST(SUM(CASE WHEN t.moneda = 'USD' THEN  t.monto * c.compra ELSE t.monto END) AS DECIMAL(10,2)) AS facturacion_soles
--INTO #respuesta
FROM core.transaccion AS t
JOIN core.tipo_cambio AS c ON CAST(t.fecha_hora AS DATE) = CAST(c.fecha AS DATE)
JOIN core.comercio AS comercio ON t.comercio_id = comercio.comercio_id
JOIN core.rubro_mcc AS rubro ON comercio.mcc = rubro.mcc
JOIN core.cuenta AS cu ON t.cuenta_id = cu.cuenta_id
JOIN core.cliente AS cl ON cu.cliente_id = cl.cliente_id
JOIN core.ubigeo AS u ON cl.ubigeo_id = u.ubigeo_id
WHERE
    t.estado = 'Aprobada'
    AND (t.fecha_hora >= '20260101'
    AND t.fecha_hora < '20260701')
GROUP BY
    u.departamento,
    rubro.grupo
ORDER BY
    facturacion_soles DESC,
    departamento ASC,
    grupo ASC
    

EXEC chk.s07_reto;
GO


/* ============================================================
   💬 PREGUNTAS DE NEGOCIO PARA REFLEXIONAR (responde aquí mismo)

   1. Mira qué departamentos aparecen en tu top 10. ¿Aparecen porque su
      gente gasta más o porque tienen más clientes? ¿Qué cálculo harías
      para saberlo?
      Respuesta:
      Aparecen principamente por volumen de clientes,la concetranción demográfica se centra en
      el departamento del Lima, y rubros masivos como el "Retail" y "Alimentos y bebidas", presentan volumen por sus operaciones.
      Por otro lado, el cálculo que haría sería el ticket promedio por transacción ( facturacion_soles / COUNT(*)).

   2. Si repites el reto con el departamento DEL COMERCIO, el resultado
      cambia mucho. ¿Por qué? ¿Cuál usarías para decidir dónde abrir
      una oficina de atención a comercios?
      Respuesta:
      Sí cambia mucho por qué no necesariamente el comercio vende en su propia región. Ya que este,
      pueden venderle a otros departamentos. Asimismo con el turismo sucede lo inverso,
      las personas viajan y compran en los comercios locales.
      Para abrir una oficiona usaría el departamento del comercio como tal.

   3. ¿Qué pasaría con tu reporte si un día faltara en core.tipo_cambio?
      (piensa en qué hace un INNER JOIN con las filas sin pareja)
      Respuesta:
      Si un día no existe en la tabla core.tipo_cambio, la condición no encuentra coincidencia y se eliminan 
      por completo todas las transacciones de ese día del resultado (incluso las operaciones en soles).
      El reporte mostraría menos dinero y menos ventas de las reales.
   Tu avance: ;
   ============================================================ */
   EXEC chk.ver_progreso 'S07'