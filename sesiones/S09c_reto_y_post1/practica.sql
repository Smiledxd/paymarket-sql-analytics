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
   /*Necesita 2 alias la misma tabla se comporta de maneras distintas dependiendo de la llave*/
   /*not exists*/
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
   -- ¿Qué tabla no quiero perder? core.clientes
   -- ¿Qué condiciones van en el ON y cuál en el WHERE? En el ON las de pago, en el WHERE las de la tabla principal FROM
============================================================ */

-- ETAPA 1: solo los JOIN y un SELECT TOP (20) para MIRAR las filas (sin INTO, sin GROUP BY).
--          ¿Aparecen clientes con NULL en las columnas de la operación?
SELECT TOP 20 *
FROM core.cliente AS cl
JOIN core.cuenta AS cu ON cu.cliente_id = cl.cliente_id
LEFT JOIN core.transaccion AS tr ON tr.cuenta_id = cu.cuenta_id

-- ETAPA 2: agrega los filtros. Vuelve a mirar: ¿siguen apareciendo los NULL?(sí)

SELECT TOP 20 *
FROM core.cliente AS cl
JOIN core.cuenta AS cu ON cu.cliente_id = cl.cliente_id
LEFT JOIN core.transaccion AS tr
    ON tr.cuenta_id = cu.cuenta_id
    AND tr.estado = 'Aprobada'
    AND tr.moneda = 'PEN'
WHERE
    (cl.fecha_alta >= '20250101'
    AND cl.fecha_alta < '20260101')

-- ETAPA 3: agrega el GROUP BY y las columnas de resumen, de una en una.
SELECT
    cl.canal_adquisicion,
    COUNT(DISTINCT cl.numero_documento) AS clientes,
    COUNT(DISTINCT CASE WHEN tr.transaccion_id IS NOT NULL THEN cl.numero_documento END) AS clientes_con_pago,
    SUM(tr.monto) AS facturacion,
    SUM(tr.monto) / COUNT(DISTINCT CASE WHEN tr.transaccion_id IS NOT NULL THEN cl.numero_documento END) AS gasto_por_cliente_con_pago
FROM core.cliente AS cl
JOIN core.cuenta AS cu ON cu.cliente_id = cl.cliente_id
LEFT JOIN core.transaccion AS tr
    ON tr.cuenta_id = cu.cuenta_id
    AND tr.estado = 'Aprobada'
    AND tr.moneda = 'PEN'
WHERE
    (cl.fecha_alta >= '20250101'
    AND cl.fecha_alta < '20260101')
GROUP BY
    cl.canal_adquisicion
ORDER BY
    facturacion DESC
-- ETAPA 4: tu consulta final con INTO #respuesta.
DROP TABLE IF EXISTS #respuesta;
SELECT
    cl.canal_adquisicion,
    COUNT(DISTINCT cl.numero_documento) AS clientes,
    COUNT(DISTINCT CASE WHEN tr.transaccion_id IS NOT NULL THEN cl.numero_documento END) AS clientes_con_pago,
    SUM(tr.monto) AS facturacion,
    SUM(tr.monto) / COUNT(DISTINCT CASE WHEN tr.transaccion_id IS NOT NULL THEN cl.numero_documento END) AS gasto_por_cliente_con_pago
INTO #respuesta
FROM core.cliente AS cl
JOIN core.cuenta AS cu ON cu.cliente_id = cl.cliente_id
LEFT JOIN core.transaccion AS tr
    ON tr.cuenta_id = cu.cuenta_id
    AND tr.estado = 'Aprobada'
    AND tr.moneda = 'PEN'
WHERE
    (cl.fecha_alta >= '20250101'
    AND cl.fecha_alta < '20260101')
GROUP BY
    cl.canal_adquisicion
ORDER BY
    facturacion DESC

EXEC chk.s09_reto;
GO


/* ============================================================
   💬 UNA SOLA PREGUNTA
   ¿Los referidos gastan más? Si fueras de marketing, ¿qué harías con
   ese dato?
   Respuesta: Sí los clientes con pago, que son referidos gastán que los orgánicos.
   Sí fuera Marketing impulsaría el programa de referidos dando mayores beneficios a las personas que
   refieran a más personas, y estás tengan consumos constantes en la billetera


   📋 REGISTRO (llénalo al terminar; me sirve para ajustar lo siguiente)
   Hora de inicio: 4:55
   5:30 Tuve un inconveniente y me fui de clase y regresé 5:48
   Hora de fin: 5:53 (terminé de responder a la pregunta)

   Ejercicio | Minutos | ¿Lo saltaste? (⏭️) | Pistas que abriste
   Reto      |   5:02 a    5:26 aprox   |                    | 0

   ¿Usaste IA? ¿Para qué?: para recordar el join self como se escribia
   ¿Qué palabra o parte del enunciado te confundió?: ninguna, gracias a "las palabras de hoy"
   Dificultad del 1 al 5: 3

   Tu avance: ;
   ============================================================ */
   EXEC chk.ver_progreso 'S09'