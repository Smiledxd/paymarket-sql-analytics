/* ============================================================
   S06 · Segmentar
   Guía: sesiones/S06_segmentar/guia.md
   Pregunta del día: ¿Qué canal tiene la mejor tasa de aprobación?
   ============================================================ */
USE PayMarket_Analitica;
GO


/* ============================================================
   📘 EJEMPLO DE JUGUETE — pedidos de la pollería "La Brasa de Oro"
   Una fila = un pedido.
   ============================================================ */
DROP TABLE IF EXISTS #pedidos;

SELECT pedido_id, local, tipo, total, entregado
INTO #pedidos
FROM (VALUES
    (1, 'Surco',  'delivery', 62.00, 'sí'),
    (2, 'Surco',  'salón',    38.50, 'sí'),
    (3, 'Surco',  'delivery', 95.00, 'no'),
    (4, 'Comas',  'salón',    24.00, 'sí'),
    (5, 'Comas',  'delivery', 45.00, 'sí'),
    (6, 'Comas',  'delivery', 45.00, 'no'),
    (7, 'Comas',  'salón',    120.00,'sí'),
    (8, 'Callao', 'salón',    30.00, 'sí')
) AS v (pedido_id, local, tipo, total, entregado);

-- 1) WHERE (antes de agrupar) vs HAVING (después de agrupar)
SELECT local, COUNT(*) AS pedidos
FROM #pedidos
WHERE total > 40            -- filtra pedidos
GROUP BY local;

SELECT local, COUNT(*) AS pedidos
FROM #pedidos
GROUP BY local
HAVING COUNT(*) >= 3;       -- filtra locales

-- 2) CASE buscado y el orden de los WHEN
SELECT pedido_id, total,
       CASE WHEN total >= 100 THEN 'familiar'
            WHEN total >= 40  THEN 'para dos'
            ELSE 'personal' END AS tamano_bien,
       CASE WHEN total >= 40  THEN 'para dos'        -- orden equivocado:
            WHEN total >= 100 THEN 'familiar'        -- el pedido 7 nunca llega aquí
            ELSE 'personal' END AS tamano_mal
FROM #pedidos;

-- 3) Conteo y suma condicionales en una tabla cruzada (una columna por tipo)
SELECT local,
       SUM(CASE WHEN tipo = 'delivery' THEN 1 ELSE 0 END)     AS pedidos_delivery,
       SUM(CASE WHEN tipo = 'salón' THEN total ELSE 0 END)     AS venta_salon,
       COUNT(CASE WHEN tipo = 'delivery' THEN 1 ELSE 0 END)   AS cuidado_cuenta_todo
FROM #pedidos
GROUP BY local;

-- 4) Una tasa: entregados entre pedidos de delivery, con y sin división entera
SELECT local,
       100 * SUM(CASE WHEN entregado = 'sí' THEN 1 ELSE 0 END) / COUNT(*)   AS tasa_entera,
       100.0 * SUM(CASE WHEN entregado = 'sí' THEN 1 ELSE 0 END) / COUNT(*) AS tasa_decimal
FROM #pedidos
WHERE tipo = 'delivery'
GROUP BY local;
GO


/* ============================================================
   ✍️ EJERCICIO 1 — Tasa de aprobación por canal
   La pregunta del día. Con TODOS los intentos de pago del primer
   semestre de 2026 (enero a junio), calcula por canal cuántos hubo,
   cuántos se aprobaron y qué porcentaje representa.
   Una operación cuenta como aprobada si su codigo_respuesta es '00'
   (las extornadas también se aprobaron en su momento).

   Qué lograr: una fila por canal. Columnas:
     canal_id, intentos, aprobadas,
     tasa_aprobacion (porcentaje con decimales: 92.35, no 0.9235)

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Una fila por canal con dos conteos y una tasa.
   -- 2. ¿Dónde está? core.transaccion.
   -- 3. ¿Qué filas? Todos los intentos del semestre (¡no filtres las aprobadas!).
   -- 4. ¿Resumir? Sí, por canal. Aprobadas = ______
   -- 5. ¿Qué muestro? ______
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí (termina tu SELECT con INTO #respuesta antes del FROM)


EXEC chk.s06_e1;
GO
/* Para pensar: las diferencias entre canales son de pocos puntos. Con
   unos 175 mil intentos en el semestre, ¿cuántas ventas representa un punto
   de diferencia? */


/* ============================================================
   ✍️ EJERCICIO 2 — Operaciones por tramo de monto
   Marketing quiere saber si la billetera se usa más para compras
   chicas o grandes. Con las operaciones APROBADAS en SOLES de junio
   2026, clasifica cada operación por su monto:
     'bajo'  → menos de S/ 50
     'medio' → de S/ 50 a menos de S/ 200
     'alto'  → S/ 200 o más
   (los nombres exactamente así, en minúsculas)

   Qué lograr: una fila por tramo. Columnas:
     tramo, operaciones, facturacion

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? 3 filas, una por tramo.
   -- 2. ¿Dónde está? core.transaccion.
   -- 3. ¿Qué filas? ______
   -- 4. ¿Resumir? Sí, por un segmento que hay que crear: ______
   -- 5. ¿Qué muestro? tramo, operaciones, facturacion.
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí


EXEC chk.s06_e2;
GO
/* Para pensar: ¿qué tramo tiene más operaciones y cuál más facturación?
   Si PayMarket cobra un porcentaje, ¿qué tramo le conviene cuidar? */


/* ============================================================
   ✍️ EJERCICIO 3 — Comercios grandes con ticket alto
   El área comercial busca comercios para un programa "Premium": los
   que en el primer semestre de 2026 tuvieron MÁS DE 500 operaciones
   aprobadas en soles y un ticket promedio MAYOR A S/ 80.

   Qué lograr: una fila por comercio que cumpla. Columnas:
     comercio_id, operaciones, ticket_promedio

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Una lista de comercios.
   -- 2. ¿Dónde está? core.transaccion.
   -- 3. ¿Qué filas? (antes de agrupar) ______
   -- 4. ¿Resumir? Sí, por comercio. ¿Qué grupos se quedan? (después de agrupar) ______
   -- 5. ¿Qué muestro? comercio_id, operaciones, ticket_promedio.
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí


EXEC chk.s06_e3;
GO
/* Para pensar: un comercio con 400 operaciones de S/ 300 no entra al
   programa. ¿Está bien diseñada la regla? ¿Qué criterio propondrías? */


/* ============================================================
   ✍️ EJERCICIO 4 — Tabla cruzada de rechazos por canal
   Con los intentos del primer semestre de 2026, arma una tabla con
   una fila por canal y una columna por tipo de rechazo (según
   core.codigo_respuesta): del cliente, técnico y por sospecha de fraude.

   Qué lograr: una fila por canal. Columnas:
     canal_id, rechazos_cliente, rechazos_tecnicos, rechazos_fraude

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Una tabla cruzada: filas = canales, columnas = tipos.
   -- 2. ¿Dónde está? core.transaccion + el catálogo core.codigo_respuesta (para anotar los códigos).
   -- 3. ¿Qué filas? Los intentos del semestre.
   -- 4. ¿Resumir? Sí, por canal, con un conteo condicional por cada tipo: ______
   -- 5. ¿Qué muestro? canal_id y los tres conteos.
============================================================ */
-- Consulta al catálogo (sin INTO):


DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí


EXEC chk.s06_e4;
GO
/* Para pensar: ¿qué canal tiene más rechazos técnicos? ¿Es justo
   compararlos en número o deberías compararlos en tasa? ¿Por qué? */


/* ============================================================
   🏋️ RETO FINAL — Tablero mensual del primer semestre
   La gerencia quiere un tablero con una fila por mes de enero a junio
   de 2026, usando todos los intentos de cada mes:
     mes                   (número del mes, 1 a 6)
     intentos
     tasa_aprobacion       (% de intentos con código '00')
     tasa_rechazo_tecnico  (% de intentos con código de tipo 'Rechazo técnico')
     facturacion_pen       (suma de montos de las operaciones con estado
                            'Aprobada' en soles; el resto no suma)

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? ______ Una fila = ______
   -- 2. ¿Dónde está? ______
   -- 3. ¿Qué filas? ______
   -- 4. ¿Resumir? Sí, por ______
   -- 5. ¿Qué muestro? ______
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí


EXEC chk.s06_reto;
GO


/* ============================================================
   💬 PREGUNTAS DE NEGOCIO PARA REFLEXIONAR (responde aquí mismo)

   1. ¿Qué canal tiene la mejor tasa de aprobación? ¿Le recomendarías a
      la gerencia empujar a los clientes hacia ese canal? ¿Qué más
      tendrías que saber antes?
      Respuesta:

   2. En el tablero mensual, ¿la facturación crece mes a mes? ¿La tasa
      de aprobación se mantiene? ¿Qué pasaría si la facturación crece
      pero la aprobación cae?
      Respuesta:

   3. ¿Por qué medir la aprobación con el código '00' y la facturación
      con el estado 'Aprobada'? ¿No debería ser lo mismo?
      Respuesta:

   Tu avance: EXEC chk.ver_progreso 'S06';
   ============================================================ */
