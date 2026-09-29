/* ============================================================
   S09 · UNION, EXISTS y self-join
   Guía: sesiones/S09_union_exists_self_join/guia.md
   Pregunta del día: ¿Los clientes referidos gastan más que los orgánicos?
   ============================================================ */
USE PayMarket_Analitica;
GO


/* ============================================================
   📘 EJEMPLO DE JUGUETE — la tienda de celulares "Conecta Tacna"
   ============================================================ */
DROP TABLE IF EXISTS #ventas_tienda;
DROP TABLE IF EXISTS #ventas_web;
DROP TABLE IF EXISTS #empleados;

SELECT cliente, CAST(fecha AS DATE) AS fecha, importe
INTO #ventas_tienda
FROM (VALUES ('Ana', '2026-04-02', 899.00), ('Beto', '2026-04-02', 59.90), ('Ana', '2026-04-05', 59.90)) AS v (cliente, fecha, importe);

SELECT cliente, CAST(fecha AS DATE) AS fecha, importe
INTO #ventas_web
FROM (VALUES ('Beto', '2026-04-02', 59.90), ('Carla', '2026-04-03', 1299.00)) AS v (cliente, fecha, importe);

SELECT empleado_id, nombre, jefe_id
INTO #empleados
FROM (VALUES (1, 'Gerente Rosa', NULL), (2, 'Supervisor Iván', 1), (3, 'Vendedora Luz', 2), (4, 'Vendedor Omar', 2)) AS v (empleado_id, nombre, jefe_id);

-- 1) UNION ALL apila todo; con una columna fija sabes de dónde vino cada fila
SELECT 'tienda' AS canal, cliente, fecha, importe FROM #ventas_tienda
UNION ALL
SELECT 'web', cliente, fecha, importe FROM #ventas_web
ORDER BY fecha, cliente;

-- 2) UNION elimina filas repetidas: Beto compró lo mismo el mismo día en tienda y web
SELECT cliente, fecha, importe FROM #ventas_tienda
UNION ALL
SELECT cliente, fecha, importe FROM #ventas_web;     -- 5 filas: dos ventas de Beto

SELECT cliente, fecha, importe FROM #ventas_tienda
UNION
SELECT cliente, fecha, importe FROM #ventas_web;     -- 4 filas: ¿se perdió una venta real?

-- 3) EXISTS: clientes de tienda que también compraron por la web (cada uno una vez)
SELECT DISTINCT t.cliente
FROM #ventas_tienda AS t
WHERE EXISTS (SELECT 1 FROM #ventas_web AS w WHERE w.cliente = t.cliente);

-- 4) Self-join: cada empleado con el nombre de su jefe (dos copias de la misma tabla)
SELECT e.nombre AS empleado, j.nombre AS jefe
FROM #empleados AS e
JOIN #empleados AS j ON j.empleado_id = e.jefe_id;   -- la gerente no sale: no tiene jefe

-- Descomenta y ejecuta: error 205, las partes tienen distinta cantidad de columnas
-- SELECT cliente, fecha FROM #ventas_tienda UNION SELECT cliente, fecha, importe FROM #ventas_web;
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
   Para medir los "clientes activos del mes", la gerencia considera
   activo a quien en junio de 2026 hizo al menos un pago APROBADO con
   la billetera O pagó al menos una cuota de crédito.

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
/* Para pensar: ¿cuántos clientes activos hubo en junio? ¿Qué porcentaje
   de todos los registrados? ¿Es una buena definición de "activo"? */


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
/* Para pensar: ¿cómo comprobarías si la sospecha de riesgos es cierta?
   (piensa en qué datos de pago_cuota necesitarías; lo harás en S21) */


/* ============================================================
   ✍️ EJERCICIO 4 — ¿Quién trajo a cada cliente nuevo?
   El programa de referidos premia a quien invita. Para cada cliente
   registrado en junio de 2026 que llegó referido, se necesita saber
   quién lo invitó y cuánto tiempo llevaba ese referidor en PayMarket.

   Qué lograr: una fila por cliente nuevo referido. Columnas:
     cliente_id,
     referidor_id,
     nombre_referidor           (nombres del referidor),
     dias_desde_alta_referidor  (días entre el alta del referidor y el del cliente nuevo)

   FICHA DE TRADUCCIÓN (respóndela tú)
   -- 1. ¿Qué me piden?
   -- 2. ¿Dónde está? (¿cuántas copias de la tabla necesitas?)
   -- 3. ¿Qué filas?
   -- 4. ¿Resumir?
   -- 5. ¿Qué muestro?
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí


EXEC chk.s09_e4;
GO
/* Para pensar: ¿los referidores suelen ser clientes antiguos o nuevos?
   ¿Qué te dice eso sobre quién recomienda PayMarket? */


/* ============================================================
   🏋️ RETO FINAL — ¿Los clientes referidos gastan más que los orgánicos?
   La pregunta del día. Con los clientes registrados en 2025, compara
   los canales de adquisición. Solo cuentan como pago las operaciones
   APROBADAS en SOLES, de todo el periodo.

   Qué lograr: una fila por canal de adquisición. Columnas:
     canal_adquisicion,
     clientes                    (todos los registrados en 2025 de ese canal),
     clientes_con_pago           (los que tuvieron al menos un pago),
     facturacion,
     gasto_por_cliente_con_pago  (facturación entre clientes con pago)

   FICHA DE TRADUCCIÓN (respóndela tú)
   -- 1. ¿Qué me piden?
   -- 2. ¿Dónde está?
   -- 3. ¿Qué filas?
   -- 4. ¿Resumir?
   -- 5. ¿Qué muestro?
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí


EXEC chk.s09_reto;
GO


/* ============================================================
   💬 PREGUNTAS DE NEGOCIO PARA REFLEXIONAR (responde aquí mismo)

   1. Con tu resultado, ¿los referidos gastan más? ¿Es por gastar más
      por operación, por usar más la billetera o por quedarse más
      tiempo? ¿Qué consulta harías para separar esas explicaciones?
      Respuesta:

   2. Si un referido vale más que un cliente de campaña digital, ¿cuánto
      podría pagar PayMarket como premio al referidor sin perder dinero?
      Escribe tus supuestos.
      Respuesta:

   3. Los clientes registrados en diciembre de 2025 tuvieron menos
      tiempo para gastar que los de enero de 2025. ¿Cómo afecta eso a
      tu comparación y cómo lo corregirías?
      Respuesta:

   Tu avance: EXEC chk.ver_progreso 'S09';
   ============================================================ */
