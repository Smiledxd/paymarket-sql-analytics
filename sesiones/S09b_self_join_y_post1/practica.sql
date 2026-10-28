/* ============================================================
   S09b · Self-join, reto del módulo y Post 1
   Guía: sesiones/S09b_self_join_y_post1/guia.md
   Pregunta del día: ¿Los clientes referidos gastan más que los orgánicos?
   ============================================================ */
USE PayMarket_Analitica;
GO


/* ============================================================
   📘 EJEMPLO RESUELTO — self-join
   En la tienda "Conecta Tacna" cada empleado tiene un jefe, que
   también es empleado: la tabla se apunta a sí misma.

   FICHA DE TRADUCCIÓN (resuelta)
   -- 1. ¿Qué me piden? Una fila por empleado con el nombre de su jefe.
   -- 2. ¿Dónde está? Las dos cosas en #empleados → dos copias: e (empleado) y j (jefe).
   --    ON: el jefe_id del empleado = el empleado_id de la copia "jefe".
   -- 3. ¿Qué filas? Todas las que tienen jefe (JOIN normal: la gerente no tiene jefe).
   -- 4. ¿Resumir? No.
   -- 5. ¿Qué muestro? empleado, jefe.
   ============================================================ */
DROP TABLE IF EXISTS #empleados;

SELECT empleado_id, nombre, jefe_id
INTO #empleados
FROM (VALUES (1, 'Gerente Rosa', NULL), (2, 'Supervisor Iván', 1),
             (3, 'Vendedora Luz', 2), (4, 'Vendedor Omar', 2)) AS v (empleado_id, nombre, jefe_id);

-- La respuesta
SELECT e.nombre AS empleado, j.nombre AS jefe
FROM #empleados AS e
JOIN #empleados AS j ON j.empleado_id = e.jefe_id;

-- Si inviertes el ON, la pregunta cambia: cada jefe con cada uno de sus subordinados
SELECT e.nombre AS jefe, j.nombre AS subordinado
FROM #empleados AS e
JOIN #empleados AS j ON j.jefe_id = e.empleado_id;
GO


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
-- Tu código aquí (termina tu SELECT con INTO #respuesta antes del FROM)


EXEC chk.s09_e4;
GO
/* Para pensar: ¿los referidores suelen ser clientes antiguos o nuevos?
   ¿Qué te dice eso sobre quién recomienda PayMarket? */


/* ============================================================
   🏋️ RETO FINAL — ¿Los clientes referidos gastan más que los orgánicos?
   Con los clientes registrados en 2025, compara los canales de
   adquisición. Solo cuentan como pago las operaciones APROBADAS en
   SOLES, de todo el periodo.

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

-- ETAPA 1: solo los JOIN y un SELECT TOP (20) para MIRAR las filas (sin INTO, sin GROUP BY).
--          ¿Aparecen clientes con NULL en las columnas de la operación?


-- ETAPA 2: agrega los filtros. Las condiciones del pago van en el ON; la del cliente, en el WHERE.
--          Vuelve a mirar: ¿siguen apareciendo los NULL?


-- ETAPA 3: agrega el GROUP BY, los conteos y el INTO #respuesta.
DROP TABLE IF EXISTS #respuesta;


EXEC chk.s09_reto;
GO


/* ============================================================
   💬 PARA REFLEXIONAR (responde aquí mismo)

   1. Con tu resultado, ¿los referidos gastan más? ¿Es por gastar más
      por operación, por usar más la billetera o por quedarse más tiempo?
      Respuesta:

   2. Si un referido vale más que un cliente de campaña digital, ¿cuánto
      podría pagar PayMarket como premio al referidor sin perder dinero?
      Escribe tus supuestos.
      Respuesta:

   Tu avance: EXEC chk.ver_progreso 'S09';
   ============================================================ */
