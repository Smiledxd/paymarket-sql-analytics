/* ============================================================
   S09a · UNION y EXISTS
   Guía: sesiones/S09a_union_y_exists/guia.md
   Pregunta del día: ¿Qué clientes estuvieron activos este mes, y
   cuáles con crédito dejaron de usar la billetera?
   ============================================================ */
USE PayMarket_Analitica;
GO


/* ============================================================
   📘 EJEMPLO RESUELTO 1 — UNION ALL y UNION
   La tienda de celulares "Conecta Tacna" vende en local y por web.
   El dueño quiere UNA lista con todas las ventas, diciendo de dónde
   vino cada una.

   FICHA DE TRADUCCIÓN (resuelta, para que veas cómo se piensa)
   -- 1. ¿Qué me piden? Una lista. Una fila = una venta. Columnas: canal, cliente, fecha, importe.
   -- 2. ¿Dónde está? En DOS tablas que guardan lo mismo: #ventas_tienda y #ventas_web → UNION.
   -- 3. ¿Qué filas? Todas.
   -- 4. ¿Resumir? No.
   -- 5. ¿Qué muestro? Las 4 columnas. ¿UNION ALL o UNION? Dos ventas iguales son dos
   --    ventas reales → UNION ALL.
   ============================================================ */
DROP TABLE IF EXISTS #ventas_tienda;
DROP TABLE IF EXISTS #ventas_web;

SELECT cliente, CAST(fecha AS DATE) AS fecha, importe
INTO #ventas_tienda
FROM (VALUES ('Ana', '2026-04-02', 899.00), ('Beto', '2026-04-02', 59.90), ('Ana', '2026-04-05', 59.90)) AS v (cliente, fecha, importe);

SELECT cliente, CAST(fecha AS DATE) AS fecha, importe
INTO #ventas_web
FROM (VALUES ('Beto', '2026-04-02', 59.90), ('Carla', '2026-04-03', 1299.00)) AS v (cliente, fecha, importe);

-- La respuesta: la columna fija 'tienda'/'web' dice de dónde vino cada fila
SELECT 'tienda' AS canal, cliente, fecha, importe FROM #ventas_tienda
UNION ALL
SELECT 'web', cliente, fecha, importe FROM #ventas_web
ORDER BY fecha, cliente;                      -- 5 filas; el ORDER BY va una sola vez, al final

-- Mira la diferencia: sin la columna canal, Beto tiene dos ventas idénticas
SELECT cliente, fecha, importe FROM #ventas_tienda
UNION ALL
SELECT cliente, fecha, importe FROM #ventas_web;     -- 5 filas

SELECT cliente, fecha, importe FROM #ventas_tienda
UNION
SELECT cliente, fecha, importe FROM #ventas_web;     -- 4 filas: UNION borró una venta real de Beto

-- Y cuando SÍ conviene UNION: la lista de clientes distintos de los dos canales
SELECT cliente FROM #ventas_tienda
UNION
SELECT cliente FROM #ventas_web;                     -- Ana, Beto, Carla: cada uno una vez
GO


/* ============================================================
   📘 EJEMPLO RESUELTO 2 — NOT EXISTS
   La academia "Olas de Chorrillos" quiere llamar a los alumnos que
   NO pagaron marzo.

   FICHA DE TRADUCCIÓN (resuelta)
   -- 1. ¿Qué me piden? Una lista. Una fila = un alumno que no pagó marzo.
   -- 2. ¿Dónde está? #alumnos (los que quiero listar) y #pagos (lo que debe NO existir).
   -- 3. ¿Qué filas? Alumnos para los que NO EXISTE un pago suyo, de marzo, pagado.
   -- 4. ¿Resumir? No.
   -- 5. ¿Qué muestro? El nombre.
   ============================================================ */
DROP TABLE IF EXISTS #alumnos;
DROP TABLE IF EXISTS #pagos;

SELECT alumno_id, nombre
INTO #alumnos
FROM (VALUES (1, 'Adriana'), (2, 'Benjamín'), (3, 'Cecilia'), (4, 'Darío')) AS v (alumno_id, nombre);

SELECT pago_id, alumno_id, mes, estado
INTO #pagos
FROM (VALUES (100, 1, 'marzo', 'pagado'), (101, 1, 'abril', 'pagado'),
             (102, 2, 'marzo', 'pendiente'), (103, 3, 'marzo', 'pagado')) AS v (pago_id, alumno_id, mes, estado);

-- La respuesta: Benjamín (su pago está pendiente) y Darío (no tiene pagos)
SELECT a.nombre
FROM #alumnos AS a
WHERE NOT EXISTS (SELECT 1
                  FROM #pagos AS p
                  WHERE p.alumno_id = a.alumno_id      -- conecta el pago con ESTE alumno
                    AND p.mes = 'marzo'
                    AND p.estado = 'pagado');

-- El error típico: sin la línea que conecta, la pregunta cambia a "¿existe algún pago de
-- marzo de cualquier alumno?". Como sí existe, NOT EXISTS es falso para todos: 0 filas.
SELECT a.nombre
FROM #alumnos AS a
WHERE NOT EXISTS (SELECT 1 FROM #pagos AS p WHERE p.mes = 'marzo' AND p.estado = 'pagado');
GO


/* ============================================================
   ✍️ EJERCICIO 1 — La línea de tiempo de un cliente
   El cliente 222 llamó para revisar sus movimientos de junio de 2026.
   El asesor quiere ver en una sola lista sus pagos APROBADOS con la
   billetera y sus pagos de cuotas del crédito.

   Qué lograr: una fila por movimiento. Columnas:
     fecha            (sin hora),
     tipo_movimiento  ('billetera' o 'cuota', exactamente así),
     monto

   FICHA DE TRADUCCIÓN (respóndela tú)
   -- 1. ¿Qué me piden?
   -- 2. ¿Dónde está? (son dos lugares distintos)
   -- 3. ¿Qué filas?
   -- 4. ¿Resumir?
   -- 5. ¿Qué muestro? (¿UNION o UNION ALL?)
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí (el INTO #respuesta va en la PRIMERA parte del UNION)


EXEC chk.s09_e1;
GO
/* Para pensar: si este cliente usa la billetera casi a diario, ¿qué
   producto adicional le ofrecerías? */


/* ============================================================
   ✍️ EJERCICIO 2 — Clientes con actividad en junio
   La gerencia considera "activo del mes" a quien en junio de 2026
   hizo al menos un pago APROBADO con la billetera O pagó al menos una
   cuota de crédito.

   Qué lograr: una fila por cliente activo (cada uno una sola vez).
   Columna: cliente_id

   FICHA DE TRADUCCIÓN (respóndela tú)
   -- 1. ¿Qué me piden?
   -- 2. ¿Dónde está?
   -- 3. ¿Qué filas?
   -- 4. ¿Resumir?
   -- 5. ¿Qué muestro?
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí


EXEC chk.s09_e2;
GO
/* Para pensar: ¿qué porcentaje de los clientes registrados estuvo activo
   en junio? ¿Te parece una buena definición de "activo"? */


/* ============================================================
   ✍️ EJERCICIO 3 — Clientes con crédito que dejaron de usar la billetera
   Riesgos sospecha que un cliente que deja de usar la billetera podría
   dejar de pagar su crédito. Quiere la lista de clientes que tienen al
   menos un crédito 'Vigente' y NO hicieron ningún pago APROBADO con la
   billetera en mayo de 2026.

   Qué lograr: una fila por cliente (cada uno una sola vez).
   Columna: cliente_id

   FICHA DE TRADUCCIÓN (respóndela tú)
   -- 1. ¿Qué me piden?
   -- 2. ¿Dónde está?
   -- 3. ¿Qué filas? (¿qué debe NO existir?)
   -- 4. ¿Resumir?
   -- 5. ¿Qué muestro?
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí


EXEC chk.s09_e3;
GO


/* ============================================================
   💬 PARA REFLEXIONAR (una sola pregunta hoy)

   El ejercicio 3 dio una lista de clientes. Si fueras de riesgos,
   ¿qué harías con ella? ¿Cómo comprobarías después si la sospecha
   era cierta?
   Respuesta:

   Tu avance: EXEC chk.ver_progreso 'S09';
   ============================================================ */
