/* ============================================================
   S09c · Reto del módulo: ¿los referidos gastan más?
   Guía: sesiones/S09c_reto_y_post1/guia.md
   Palabras raras: guias/glosario_paymarket.md
   ============================================================ */
USE PayMarket_Analitica;
GO


/* ============================================================
   🔁 CALENTAMIENTO (sin pistas)
   1. En un self-join, ¿por qué necesito dos alias?:
   2. ¿Qué herramienta uso para "los clientes que nunca recibieron un crédito"?:
   ============================================================ */


/* ------------------------------------------------------------
   PREPARACIÓN: no hace falta leerlo. Selecciónalo y ejecútalo.
   ------------------------------------------------------------ */
DROP TABLE IF EXISTS #alumnos;
DROP TABLE IF EXISTS #pagos;
SELECT alumno_id, nombre INTO #alumnos
FROM (VALUES (1, 'Adriana'), (2, 'Benjamín'), (3, 'Cecilia'), (4, 'Darío')) AS v (alumno_id, nombre);
SELECT pago_id, alumno_id INTO #pagos
FROM (VALUES (100, 1), (101, 1), (102, 2), (103, 3)) AS v (pago_id, alumno_id);
GO


/* ============================================================
   📘 EJEMPLO — las tres capas, una a la vez
   Ejecuta cada paso y mira el resultado antes de pasar al siguiente.
   ============================================================ */
-- Paso 1: mira la columna del CASE sola, fila por fila.
-- Resultado: Adriana 1, Adriana 1, Benjamín 2, Cecilia 3, Darío NULL
SELECT a.nombre,
       CASE WHEN p.pago_id IS NOT NULL THEN a.alumno_id END AS alumno_con_pago
FROM #alumnos AS a
LEFT JOIN #pagos AS p ON p.alumno_id = a.alumno_id;

-- Paso 2: recién ahora la metes en el COUNT(DISTINCT ...).
-- Resultado: alumnos = 4, alumnos_con_pago = 3
SELECT COUNT(DISTINCT a.alumno_id) AS alumnos,
       COUNT(DISTINCT CASE WHEN p.pago_id IS NOT NULL THEN a.alumno_id END) AS alumnos_con_pago
FROM #alumnos AS a
LEFT JOIN #pagos AS p ON p.alumno_id = a.alumno_id;
GO


/* ============================================================
   🏋️ RETO — ¿Los clientes referidos gastan más que los orgánicos?

   Qué te piden:
     Con los clientes que se registraron en 2025, compara los tres
     canales de adquisición (cómo llegó el cliente). Solo cuentan como
     pago las operaciones aprobadas en soles, de todo el periodo.

   Cómo debería verse (valores inventados, 3 filas en total):
     canal_adquisicion | clientes | clientes_con_pago | facturacion | gasto_por_cliente_con_pago
     Orgánico          | 1000     | 800               | 400000.00   | 500.00

   clientes = todos los registrados en 2025 de ese canal, pagaran o no.
   clientes_con_pago = los que tuvieron al menos un pago.
   gasto_por_cliente_con_pago = facturacion entre clientes_con_pago.

   FICHA
   -- ¿Qué es una fila? Un canal de adquisición.
   -- ¿Qué tabla no quiero perder? ______
   -- ¿Qué condiciones van en el ON y cuál en el WHERE? ______
============================================================ */

-- ETAPA 1: solo los JOIN y un SELECT TOP (20) para MIRAR las filas (sin INTO, sin GROUP BY).
--          ¿Aparecen clientes con NULL en las columnas de la operación?


-- ETAPA 2: agrega los filtros. Vuelve a mirar: ¿siguen apareciendo los NULL?


-- ETAPA 3: agrega el GROUP BY y las columnas de resumen, de una en una.


-- ETAPA 4: tu consulta final con INTO #respuesta.
DROP TABLE IF EXISTS #respuesta;


EXEC chk.s09_reto;
GO


/* ============================================================
   💬 UNA SOLA PREGUNTA
   ¿Los referidos gastan más? Si fueras de marketing, ¿qué harías con
   ese dato?
   Respuesta:


   📋 REGISTRO (llénalo al terminar; me sirve para ajustar lo siguiente)
   Hora de inicio:
   Hora de fin:

   Ejercicio | Minutos | ¿Lo saltaste? (⏭️) | Pistas que abriste
   Reto      |         |                    |

   ¿Usaste IA? ¿Para qué?:
   ¿Qué palabra o parte del enunciado te confundió?:
   Dificultad del 1 al 5:

   Tu avance: EXEC chk.ver_progreso 'S09';
   ============================================================ */
