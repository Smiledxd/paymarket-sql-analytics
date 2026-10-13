/* ============================================================
   S05 · Resumir el negocio
   Guía: sesiones/S05_resumir_el_negocio/guia.md
   Pregunta del día: ¿Cuánto factura cada canal y cuál es su ticket promedio?
   ============================================================ */
USE PayMarket_Analitica;
GO

/* ============================================================
   📘 EJEMPLO DE JUGUETE — la juguería "Frutos del Valle"
   Una fila = un producto vendido en una boleta.
   ============================================================ */
DROP TABLE IF EXISTS #ventas;

SELECT boleta, vendedor, producto, cantidad, precio, propina
INTO #ventas
FROM (VALUES
    (1, 'Rosa',  'Jugo de papaya', 2,  7.00, NULL),
    (1, 'Rosa',  'Sándwich mixto', 1,  8.50, NULL),
    (2, 'Pedro', 'Jugo surtido',   1,  9.00, 1.00),
    (3, 'Rosa',  'Jugo de papaya', 1,  7.00, 2.00),
    (4, 'Pedro', 'Jugo surtido',   3,  9.00, NULL),
    (4, 'Pedro', 'Sándwich mixto', 2,  8.50, NULL)
) AS v (boleta, vendedor, producto, cantidad, precio, propina);

-- 1) Tres formas de contar: filas, valores no nulos y valores distintos
SELECT COUNT(*)                 AS filas,
       COUNT(propina)           AS filas_con_propina,
       COUNT(DISTINCT boleta)   AS boletas,
       COUNT(DISTINCT vendedor) AS vendedores
FROM #ventas;

-- 2) El promedio entero: cantidad es INT
SELECT AVG(cantidad)                       AS promedio_entero,      -- 1: se perdieron los decimales
       AVG(cantidad * 1.0)                 AS promedio_con_decimales,
       CAST(AVG(cantidad) AS DECIMAL(5,2)) AS convertido_tarde      -- 1.00: ya era tarde
FROM #ventas;

-- 3) GROUP BY: un resumen por vendedor
SELECT vendedor,
       COUNT(DISTINCT boleta)   AS boletas,
       SUM(cantidad * precio)   AS venta_total,
       MAX(precio)              AS precio_mas_alto
FROM #ventas
GROUP BY vendedor;

-- 4) Por dos columnas: una fila por cada combinación de vendedor y producto
SELECT vendedor, producto, SUM(cantidad) AS unidades
FROM #ventas
GROUP BY vendedor, producto
ORDER BY vendedor, producto;

-- Descomenta y ejecuta: error 8120, producto no está en el GROUP BY
SELECT vendedor, producto, SUM(cantidad) FROM #ventas GROUP BY vendedor;
GO


/* ============================================================
   ✍️ EJERCICIO 1 — Radiografía de 2025
   El directorio quiere cerrar el primer año de PayMarket con cinco
   números sobre las operaciones APROBADAS en SOLES de todo 2025.

   Qué lograr: una fila. Columnas:
     operaciones, facturacion, ticket_promedio, ticket_minimo, ticket_maximo

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Cinco números en una fila.
   -- 2. ¿Dónde está? core.transaccion (una fila = un intento de pago).
   -- 3. ¿Qué filas? ______
   -- 4. ¿Resumir? Sí, todo junto (sin "por algo").
   -- 5. ¿Qué muestro? ______
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí (termina tu SELECT con INTO #respuesta antes del FROM)
SELECT
    COUNT(*) AS operaciones,
    SUM(monto) AS facturacion,
    SUM(monto) / COUNT(*) AS ticket_promedio,
    MIN(monto) AS ticket_minimo,
    MAX(monto) AS ticket_maximo
INTO #respuesta
FROM core.transaccion
WHERE
    estado = 'Aprobada'
    AND moneda = 'PEN'
    AND (fecha_hora >= '20250101'
    AND fecha_hora < '20260101')
EXEC chk.s05_e1;
GO
/* Para pensar: el ticket máximo está muy lejos del promedio. ¿Qué tipo
   de comercio crees que explica esas operaciones tan grandes?
   Es un comercio mayorista o bien sus productos como tal cuestan mucho por ende
   sus tickets son altos*/
   

/* ============================================================
   ✍️ EJERCICIO 2 — Junio 2026 en números
   Para el reporte mensual, operaciones quiere saber, sobre las
   operaciones APROBADAS de junio 2026 (en cualquier moneda):
   cuántas hubo, cuántas cuentas distintas pagaron, en cuántos
   comercios distintos, y cuántas de esas operaciones tuvieron una
   promoción aplicada.

   Qué lograr: una fila. Columnas:
     operaciones_aprobadas, cuentas_distintas, comercios_distintos,
     operaciones_con_promocion

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Cuatro conteos distintos sobre las mismas filas.
   -- 2. ¿Dónde está? core.transaccion.
   -- 3. ¿Qué filas? Aprobadas de junio 2026.
   -- 4. ¿Resumir? Sí. Para cada columna: ¿cuento filas, no nulos o distintos? ______
   -- 5. ¿Qué muestro? Los cuatro conteos con sus alias.
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí
SELECT
    COUNT(*) AS operaciones_aprobadas,
    COUNT(DISTINCT cuenta_id) cuentas_distintas,
    COUNT(DISTINCT comercio_id) comercios_distintos,
    COUNT(promocion_id) AS operaciones_con_promocion
INTO #respuesta
FROM core.transaccion
WHERE
    estado = 'Aprobada'
    AND (fecha_hora >= '20260601'
    AND fecha_hora < '20260701')
EXEC chk.s05_e2;
GO
/* Para pensar: divide operaciones entre cuentas distintas. ¿Qué te dice
   ese número sobre cómo usan la billetera los clientes? 
   4.25 es el promedio de operaciones por cuenta*/
   SELECT 31865 / 7496.0 AS promedio_operaciones_xcuenta

/* ============================================================
   ✍️ EJERCICIO 3 — Facturación y ticket promedio por canal
   La pregunta del día: ¿cuánto factura cada canal y cuál es su ticket
   promedio? Usa las operaciones APROBADAS en SOLES del primer
   semestre de 2026 (enero a junio).

   Qué lograr: una fila por canal. Columnas:
     canal_id, operaciones, facturacion, ticket_promedio

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Una tabla con una fila por canal.
   -- 2. ¿Dónde está? core.transaccion.
   -- 3. ¿Qué filas? ______
   -- 4. ¿Resumir? Sí, por ______
   -- 5. ¿Qué muestro? canal_id y tres resúmenes.
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí
SELECT
    canal_id,
    COUNT(*) AS operaciones,
    SUM(monto) AS facturacion,
    AVG(monto) AS ticket_promedio
INTO #respuesta
FROM core.transaccion
WHERE
    estado = 'Aprobada'
    AND moneda = 'PEN'
    AND (fecha_hora >= '20260101'
    AND fecha_hora < '20260701')
GROUP BY
    canal_id
EXEC chk.s05_e3;
GO
/* Para pensar: ¿qué canal tiene más operaciones y cuál el ticket más
   alto? ¿Son el mismo? ¿Qué te dice eso sobre para qué usa la gente
   cada canal?
   El canal con más operaciones es el 3(pos fisico), y el ticket promedio más alto corresponde al 2(web).
   Indica que el canal 3 es el de más flujo y movimientos al día a día, por otro lado el web se maneja
   por la planificación y seguridad que este puede traer*/
   
/* ============================================================
   ✍️ EJERCICIO 4 — Tiempo de respuesta del servidor por canal
   Tecnología revisa cuánto tarda el servidor en responder cada pago
   (latencia_ms, en milisegundos) según el canal, en las operaciones
   APROBADAS de mayo de 2026 (cualquier moneda).

   Qué lograr: una fila por canal. Columnas:
     canal_id,
     latencia_promedio_ms (con decimales),
     latencia_maxima_ms

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Una fila por canal con dos resúmenes de latencia.
   -- 2. ¿Dónde está? core.transaccion.
   -- 3. ¿Qué filas? ______
   -- 4. ¿Resumir? Sí, por canal.
   -- 5. ¿Qué muestro? ______ (ojo: latencia_ms es entera)
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí
SELECT
    canal_id,
    AVG(CAST(latencia_ms AS DECIMAL (7,2))) AS latencia_promedio_ms,
    MAX(latencia_ms) AS latencia_maxima_ms
INTO #respuesta
FROM core.transaccion
WHERE
    estado = 'Aprobada'
    AND (fecha_hora >= '20260501'
    AND fecha_hora < '20260601')
GROUP BY
    canal_id

EXEC chk.s05_e4;
GO
/* Para pensar: la latencia es tiempo del servidor, no de la persona.
   Si un canal responde más lento, ¿qué efecto podría tener en las
   ventas? ¿Con qué datos lo comprobarías?
   Si un canal responde más lento genera desconecto en el servicio por parte de cliente.
   Con los codigos de respuesta, para validar si cierran sesión o hay otros problemas*/

/* ============================================================
   🏋️ RETO FINAL — Los 10 comercios que más facturaron en el segundo trimestre
   El equipo comercial prepara reuniones con los comercios más
   importantes. Con las operaciones APROBADAS en SOLES del segundo
   trimestre de 2026 (abril, mayo y junio), quiere los 10 comercios
   con mayor facturación (desempate: comercio_id menor primero).

   Qué lograr: 10 filas. Columnas:
     comercio_id, operaciones, cuentas_distintas, facturacion,
     ticket_promedio, comision_total

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? ______ Una fila = ______
   -- 2. ¿Dónde está? ______
   -- 3. ¿Qué filas? ______
   -- 4. ¿Resumir? Sí, por ______
   -- 5. ¿Qué muestro y en qué orden? ______
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí
SELECT TOP 10
     comercio_id,
     COUNT(*) AS operaciones,
     COUNT(DISTINCT cuenta_id) AS cuentas_distintas,
     SUM(monto) AS facturacion,
     AVG(CAST((monto*1.0) AS DECIMAL (10,2))) AS ticket_promedio,
     SUM(comision) AS comision_total
FROM core.transaccion
WHERE
    estado = 'Aprobada'
    AND moneda = 'PEN'
    AND (fecha_hora >= '20260401'
    AND fecha_hora < '20260701')
GROUP BY
    comercio_id
ORDER BY
    facturacion DESC

EXEC chk.s05_reto;
GO


/* ============================================================
   💬 PREGUNTAS DE NEGOCIO PARA REFLEXIONAR (responde aquí mismo)

   1. En el reto, ¿el comercio que más factura es el que más comisión
      deja? ¿Por qué podrían no coincidir?
      Respuesta:
      En el primer lugar sí es el caso. Pero en lo demás no tanto esto se puede deber al rubro
      o al mismo contrato distinto.
   2. Un comercio con muchas operaciones pero pocas cuentas distintas,
      ¿qué te sugiere? ¿Es bueno o riesgoso para PayMarket?
      Respuesta:
      Indica que pocos usuario hacen compras repetitivas. Aunque para el negocio puede ser fieles,
      para PayMarket como tal es muy riesgoso. Ya que, puede indicar autofinanciamiento o si esos pocos
      clientes se van, las ventas caen de golpe.
   3. Si la gerencia te pide "la facturación total de PayMarket",
      ¿qué le preguntarías antes de calcularla?
      Respuesta:
      1. Se refieren al monto total vendido por los comerciantes a la ganancia en comisiones?
      2. En que rango de fechas?
      3. En que moneda ?
      4. montos brutos o netos con igv ?
   Tu avance: ;
   ============================================================ */
   EXEC chk.ver_progreso 'S05'