/* ============================================================
   S08 · LEFT JOIN
   Guía: sesiones/S08_left_join/guia.md
   Pregunta del día: ¿Qué clientes se registraron y nunca pagaron nada?
   ============================================================ */
USE PayMarket_Analitica;
GO


/* ============================================================
   📘 EJEMPLO DE JUGUETE — la academia de natación "Olas de Chorrillos"
   ============================================================ */
DROP TABLE IF EXISTS #alumnos;
DROP TABLE IF EXISTS #mensualidades;

SELECT alumno_id, nombre, turno
INTO #alumnos
FROM (VALUES (1, 'Adriana', 'mañana'), (2, 'Benjamín', 'tarde'), (3, 'Cecilia', 'tarde'),
             (4, 'Darío', 'mañana')) AS v (alumno_id, nombre, turno);

SELECT mensualidad_id, alumno_id, mes, estado, importe
INTO #mensualidades
FROM (VALUES (100, 1, 'marzo', 'pagado',    150.00),
             (101, 1, 'abril', 'pagado',    150.00),
             (102, 2, 'marzo', 'pendiente', 150.00),
             (103, 3, 'marzo', 'pagado',    120.00)) AS v (mensualidad_id, alumno_id, mes, estado, importe);

-- 1) INNER vs LEFT: Darío no tiene mensualidades
SELECT a.nombre, m.mes, m.estado
FROM #alumnos AS a
JOIN #mensualidades AS m ON m.alumno_id = a.alumno_id;          -- Darío desaparece

SELECT a.nombre, m.mes, m.estado
FROM #alumnos AS a
LEFT JOIN #mensualidades AS m ON m.alumno_id = a.alumno_id;     -- Darío aparece con NULL

-- 2) Anti-join: alumnos sin ninguna mensualidad registrada
SELECT a.nombre
FROM #alumnos AS a
LEFT JOIN #mensualidades AS m ON m.alumno_id = a.alumno_id
WHERE m.mensualidad_id IS NULL;

-- 3) ON vs WHERE: "cada alumno con sus mensualidades pagadas, aunque no tenga ninguna"
SELECT a.nombre, m.mes
FROM #alumnos AS a
LEFT JOIN #mensualidades AS m ON m.alumno_id = a.alumno_id AND m.estado = 'pagado';   -- 5 filas: Benjamín y Darío con NULL

SELECT a.nombre, m.mes
FROM #alumnos AS a
LEFT JOIN #mensualidades AS m ON m.alumno_id = a.alumno_id
WHERE m.estado = 'pagado';                                                            -- 3 filas: se volvió INNER JOIN

-- 4) Fan-out: Adriana aparece dos veces después de unir
SELECT a.turno,
       COUNT(*)                     AS filas_del_join,     -- cuenta a Darío como 1
       COUNT(m.mensualidad_id)      AS mensualidades,      -- solo parejas reales
       COUNT(DISTINCT a.alumno_id)  AS alumnos
FROM #alumnos AS a
LEFT JOIN #mensualidades AS m ON m.alumno_id = a.alumno_id
GROUP BY a.turno;
GO


/* ============================================================
   ✍️ EJERCICIO 1 — Billeteras en soles que nunca se usaron
   Producto quiere saber cuántas billeteras en SOLES se abrieron y no
   registran NINGUNA operación (ni aprobada ni rechazada).

   Qué lograr: una fila, una columna: cuentas_sin_operaciones

   FICHA DE TRADUCCIÓN (respóndela tú)
   -- 1. ¿Qué me piden?
   -- 2. ¿Dónde está? (¿qué tabla va a la izquierda?)
   -- 3. ¿Qué filas?
   -- 4. ¿Resumir?
   -- 5. ¿Qué muestro?
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí (termina tu SELECT con INTO #respuesta antes del FROM)


EXEC chk.s08_e1;
GO
/* Para pensar: compara con el total de cuentas en soles. ¿Qué porcentaje
   de las billeteras nunca se usó? */


/* ============================================================
   ✍️ EJERCICIO 2 — ¿Quiénes se registraron y nunca pagaron?
   La pregunta del día. Para cada canal de adquisición, marketing
   quiere saber cuántos clientes tiene, cuántos NUNCA tuvieron una
   operación APROBADA (en ninguna de sus cuentas, en todo el periodo)
   y qué porcentaje representan.

   Qué lograr: una fila por canal de adquisición. Columnas:
     canal_adquisicion,
     clientes           (todos los del canal),
     clientes_sin_pago,
     pct_sin_pago       (porcentaje con decimales)

   FICHA DE TRADUCCIÓN (respóndela tú)
   -- 1. ¿Qué me piden?
   -- 2. ¿Dónde está?
   -- 3. ¿Qué filas? (¿la condición del estado va en el ON o en el WHERE?)
   -- 4. ¿Resumir?
   -- 5. ¿Qué muestro?
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí


EXEC chk.s08_e2;
GO
/* Para pensar: ¿qué canal trae más clientes que nunca pagan? Si cada
   cliente captado cuesta lo mismo, ¿qué canal es el más caro? */


/* ============================================================
   ✍️ EJERCICIO 3 — Comercios afiliados que nunca vendieron
   El equipo de afiliaciones quiere llamar a los comercios que se
   afiliaron y nunca tuvieron una venta APROBADA.

   Qué lograr: una fila por comercio. Columnas:
     comercio_id, nombre_comercial, fecha_afiliacion

   FICHA DE TRADUCCIÓN (respóndela tú)
   -- 1. ¿Qué me piden?
   -- 2. ¿Dónde está?
   -- 3. ¿Qué filas?
   -- 4. ¿Resumir?
   -- 5. ¿Qué muestro?
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí


EXEC chk.s08_e3;
GO
/* Para pensar: ordena el resultado por fecha de afiliación. ¿Son todos
   comercios recién afiliados? Si hay antiguos, ¿qué pudo haber pasado? */


/* ============================================================
   ✍️ EJERCICIO 4 — Clientes y facturación por sexo
   Con las operaciones APROBADAS en SOLES del primer semestre de 2026,
   compara por sexo del cliente cuántos clientes distintos pagaron,
   cuántas operaciones hicieron y cuánto facturaron.

   Qué lograr: una fila por sexo. Columnas:
     sexo, clientes, operaciones, facturacion

   FICHA DE TRADUCCIÓN (respóndela tú)
   -- 1. ¿Qué me piden?
   -- 2. ¿Dónde está?
   -- 3. ¿Qué filas?
   -- 4. ¿Resumir? (¿qué representa una fila después del join?)
   -- 5. ¿Qué muestro?
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí


EXEC chk.s08_e4;
GO
/* Para pensar: calcula operaciones por cliente para cada sexo. ¿Hay
   diferencia? ¿Usarías este dato para una campaña? ¿Qué cuidado
   tendrías al comunicarlo? */


/* ============================================================
   🏋️ RETO FINAL — Tasa de contracargos por grupo de rubro
   Riesgos quiere saber qué rubros generan más reclamos. Con TODAS las
   operaciones con estado 'Aprobada' del periodo (cualquier moneda),
   calcula por grupo de rubro cuántas hubo, cuántas tuvieron
   contracargo y qué porcentaje representan.

   Qué lograr: una fila por grupo. Columnas:
     grupo, aprobadas, contracargos,
     tasa_contracargo (porcentaje con decimales)

   FICHA DE TRADUCCIÓN (respóndela tú)
   -- 1. ¿Qué me piden?
   -- 2. ¿Dónde está?
   -- 3. ¿Qué filas?
   -- 4. ¿Resumir?
   -- 5. ¿Qué muestro?
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí


EXEC chk.s08_reto;
GO


/* ============================================================
   💬 PREGUNTAS DE NEGOCIO PARA REFLEXIONAR (responde aquí mismo)

   1. ¿Qué grupo tiene la tasa de contracargos más alta? ¿Todos los
      comercios de ese grupo serán iguales, o podría haber uno que
      "arrastre" al resto? ¿Qué consulta harías para averiguarlo?
      Respuesta:

   2. Un cliente que se registró y nunca pagó, ¿es un cliente perdido
      o una oportunidad? ¿Qué acción propondrías y cómo medirías si
      funcionó?
      Respuesta:

   3. ¿En qué otras preguntas de PayMarket te imaginas que un INNER
      JOIN escondería justo lo más importante?
      Respuesta:

   Tu avance: EXEC chk.ver_progreso 'S08';
   ============================================================ */
