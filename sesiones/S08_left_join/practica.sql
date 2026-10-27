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
SELECT a.nombre, m.mes, m.estado
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
SELECT
     COUNT(DISTINCT c.cuenta_id) AS cuentas_sin_operaciones
     --COUNT(c.cuenta_id) AS total_cuentas_pen
INTO #respuesta
FROM core.cuenta AS c
--WHERE c.moneda = 'PEN'
LEFT JOIN core.transaccion AS t ON t.cuenta_id = c.cuenta_id 
WHERE 
    t.cuenta_id IS NULL
    AND c.moneda = 'PEN'
   
EXEC chk.s08_e1;
GO
/* Para pensar: compara con el total de cuentas en soles. ¿Qué porcentaje
   de las billeteras nunca se usó? */
   /*Existen 5908 cuentas sin operaciones.Por otra parte, hay 20000 cuentas en soles. De modo qué, esto
   representa el 29.54% de billeteras no se están usando en PayMarket*/
   SELECT (5908/20000.00) * 100 AS pct_bill_no_uso
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
SELECT
    canal_adquisicion,
    COUNT( DISTINCT cl.cliente_id) AS clientes,
    COUNT( DISTINCT cl.cliente_id) - COUNT( DISTINCT CASE WHEN t.transaccion_id IS NOT NULL THEN cl.cliente_id END) AS clientes_sin_pago,
    CAST(100.00 * (COUNT( DISTINCT cl.cliente_id) - COUNT( DISTINCT CASE WHEN t.transaccion_id IS NOT NULL THEN cl.cliente_id END)) / COUNT( DISTINCT cl.cliente_id) AS DECIMAL(10,2)) AS pct_sin_pago
INTO #respuesta
FROM core.cliente AS cl
LEFT JOIN core.cuenta AS cu ON cu.cliente_id = cl.cliente_id
LEFT JOIN core.transaccion AS t ON cu.cuenta_id = t.cuenta_id AND t.estado = 'Aprobada'
GROUP BY
    canal_adquisicion

EXEC chk.s08_e2;
GO
/* Para pensar: ¿qué canal trae más clientes que nunca pagan? Si cada
   cliente captado cuesta lo mismo, ¿qué canal es el más caro? */
   /* El canal que trae más clientes que no pagan es Campaña digital (3,006 clientes, 45.34%). 
   Si cada cliente cuesta lo mismo captarlo, Campaña digital es el canal más caro de los 3,
   ya que, casi la mitad de la inversión se pierde en clientes que nunca llegan a usar el servicio. */

/* ============================================================
   ✍️ EJERCICIO 3 — Comercios afiliados que nunca vendieron
   El equipo de afiliaciones quiere llamar a los comercios que se
   afiliaron y nunca tuvieron una venta APROBADA.

   Qué lograr: una fila por comercio. Columnas:
     comercio_id, nombre_comercial, fecha_afiliacion

   FICHA DE TRADUCCIÓN (respóndela tú)
   -- 1. ¿Qué me piden? una lista
   -- 2. ¿Dónde está? core.comercio
   -- 3. ¿Qué filas?
   -- 4. ¿Resumir?
   -- 5. ¿Qué muestro?
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí
SELECT 
    c.comercio_id,
    c.nombre_comercial,
    c.fecha_afiliacion
--INTO #respuesta
FROM core.comercio AS c
LEFT JOIN core.transaccion AS t ON c.comercio_id = t.comercio_id
WHERE t.transaccion_id IS NULL
ORDER BY fecha_afiliacion ASC

EXEC chk.s08_e3;
GO
/* Para pensar: ordena el resultado por fecha de afiliación. ¿Son todos
   comercios recién afiliados? Si hay antiguos, ¿qué pudo haber pasado? */
   /* No todos son recién afiliados, aunque hay comercios de junio de 2026 que acaban de entrar y aún están en curva de activación, 
   existen comercios afiliados desde inicios de 2025 (como Spa La Arequipeña del 2025-01-30) 
   que llevan casi año y medio con 0 ventas. De modo que, en los comercios pudo aver pasado un
   abandono en el onboarding,de igual forma, un cierre del negocio, empresa fantasma agregada por el vendedor, desiciones del
   comercio referentes a la tasa.*/

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
SELECT
    sexo,
    COUNT(DISTINCT cl.cliente_id) AS clientes,
    COUNT( DISTINCT t.transaccion_id) AS operaciones,
    SUM(t.monto) AS facturacion
INTO #respuesta
FROM core.cliente AS cl
JOIN core.cuenta AS cu ON cu.cliente_id = cl.cliente_id
JOIN core.transaccion AS t ON t.cuenta_id = cu.cuenta_id
WHERE
    (t.fecha_hora >= '20260101'
    AND t.fecha_hora < '20260701')
    AND t.moneda = 'PEN'
    AND t.estado = 'Aprobada'
GROUP BY
    sexo

EXEC chk.s08_e4;
GO
/* Para pensar: calcula operaciones por cliente para cada sexo. ¿Hay
   diferencia? ¿Usarías este dato para una campaña? ¿Qué cuidado
   tendrías al comunicarlo? */
   /* La diferencia del promedio de operaciones para cada cliente por sexo es minimo, no llega a una operación completa (0.62)
   Este dato sería irrelevante para una campaña. Por otro lado, el cuidado a presentarlo es no presentar los totales brutos aislados sin mostrar el promedio con decimales, 
      para evitar que el equipo tome decisiones basadas en falsos sesgos de género o diferencias aparentes.*/
--comprobación rápida
   --SELECT 81386/5655.00 AS clientes_f_por_oper /*14.39*/ 
   --SELECT 80270/5829.00 AS clientes_m_por_oper /*13.77*/ 

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
SELECT
    r.grupo,
    COUNT(t.transaccion_id) AS aprobadas,
    COUNT(co.contracargo_id) AS contracargos,
    CAST(100.00 * COUNT(co.contracargo_id) / COUNT(t.transaccion_id) AS DECIMAL(10,2)) AS tasa_contracargo
--INTO #respuesta
FROM core.transaccion AS t
JOIN core.comercio AS comercio  ON comercio.comercio_id = t.comercio_id
JOIN core.rubro_mcc AS r ON comercio.mcc = r.mcc
LEFT JOIN core.contracargo AS co ON t.transaccion_id = co.transaccion_id
WHERE
    t.estado = 'Aprobada'
GROUP BY
    r.grupo
ORDER BY
    tasa_contracargo DESC

EXEC chk.s08_reto;
GO

/* ============================================================
   💬 PREGUNTAS DE NEGOCIO PARA REFLEXIONAR (responde aquí mismo)

   1. ¿Qué grupo tiene la tasa de contracargos más alta? ¿Todos los
      comercios de ese grupo serán iguales, o podría haber uno que
      "arrastre" al resto? ¿Qué consulta harías para averiguarlo?
      Respuesta:
      
      La tasa más alta la tiene "Viajes" (0.51%), seguida de cerca por "Retail" (0.47%).
      No todos los comercios son iguales; puede haber uno o dos con muchos reclamos que "arrastren" el promedio del grupo.
      Para averiguarlo, haría la misma consulta del reto final pero agregando r.descripcion o comercio.nombre_comercial en el SELECT y el GROUP BY.

   2. Un cliente que se registró y nunca pagó, ¿es un cliente perdido
      o una oportunidad? ¿Qué acción propondrías y cómo medirías si
      funcionó?
      Respuesta:

      Es una oportunidad, ya que la mitad del trabajo está hecha porque ya se registró dentro de PayMarket.
      Propondría enviarles una campaña con un beneficio en su primer pago y mediría cuántos de ellos realizan su primera compra aprobada.

   3. ¿En qué otras preguntas de PayMarket te imaginas que un INNER
      JOIN escondería justo lo más importante?
      Respuesta:

      Cuando queremos buscar clientes inactivos (que nunca pagaron), comercios afiliados con 0 ventas.
      En todos esos casos, un INNER JOIN borraría las filas que no tienen cruce y esconde el problema.

   Tu avance: ;
   ============================================================ */
   EXEC chk.ver_progreso 'S08'