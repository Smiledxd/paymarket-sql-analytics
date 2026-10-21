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
SELECT
    canal_id,
    --CASE canal_id WHEN 1 THEN 'App móvil' WHEN 2 THEN 'Web' WHEN 3 THEN 'POS físico' WHEN 4 THEN 'Pago con QR' END AS canal_id,
    COUNT(*) AS intentos,
    SUM(CASE WHEN codigo_respuesta = '00' THEN 1 ELSE 0 END) AS aprobadas,
    100.0 *SUM(CASE WHEN codigo_respuesta = '00' THEN 1 ELSE 0 END) / COUNT(*) AS tasa_aprobacion
--INTO #respuesta
FROM core.transaccion
WHERE
    (fecha_hora >= '20260101'
    AND fecha_hora < '20260701')
GROUP BY
    canal_id

EXEC chk.s06_e1;
GO
/* Para pensar: las diferencias entre canales son de pocos puntos. Con
   unos 175 mil intentos en el semestre, ¿cuántas ventas representa un punto
   de diferencia? */
   /*Un punto de diferencia en la tasa de aprobación representa 1,750 ventas aprox. en el semestre.*/

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
SELECT
    CASE
        WHEN monto >= 200 THEN 'alto'
        WHEN monto >= 50 THEN 'medio'
        ELSE 'bajo'
    END AS tramo,
    COUNT(*) AS operaciones,
    SUM(monto) AS facturacion
INTO #respuesta
FROM core.transaccion
WHERE
    fecha_hora >= '20260601' AND fecha_hora < '20260701'
    AND moneda = 'PEN'
    AND estado = 'Aprobada'
GROUP BY
    CASE
        WHEN monto >= 200 THEN 'alto'
        WHEN monto >= 50 THEN 'medio'
        ELSE 'bajo'
    END
ORDER BY
    operaciones DESC
EXEC chk.s06_e2;
GO
/* Para pensar: ¿qué tramo tiene más operaciones y cuál más facturación?
   Si PayMarket cobra un porcentaje, ¿qué tramo le conviene cuidar? */
   /*El tramo bajo tiene más operaciones. Sin embargo, el tramo alto es el que tiene más facturación
   Bajo el porcentaje por comisión conviene cuidar el tramo alto*/

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
SELECT
    comercio_id,
    COUNT(*) AS operaciones,
    AVG(monto) AS ticket_promedio
INTO #respuesta
FROM core.transaccion
WHERE
    (fecha_hora >= '20260101'
    AND fecha_hora < '20260701')
    AND moneda = 'PEN'
    AND estado = 'Aprobada'
GROUP BY
    comercio_id
HAVING
    COUNT(*) > 500
    AND AVG(monto) > 80
ORDER BY
    operaciones DESC
    
EXEC chk.s06_e3;
GO
/* Para pensar: un comercio con 400 operaciones de S/ 300 no entra al
   programa. ¿Está bien diseñada la regla? ¿Qué criterio propondrías? */
   /*No esta bien diseñada, porque 400 ventas de S/ 300 suman S/ 120,000,que es mucho más que el
   mínimo de la regla actual (500 x S/ 80 = S/ 40,000).
   De modo que, estamos dejando fuera a un cliente grande. Lo ideal sería evaluar la suma total de ventas
   (SUM(monto)) en lugar de exigir tantas operaciones.*/

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
SELECT TOP 100 *
FROM core.codigo_respuesta
ORDER BY tipo_respuesta ASC
/*
codigo_respuesta	descripcion	tipo_respuesta
00	Aprobada	Aprobada

57	Operación no permitida al titular	Rechazo del cliente
55	Clave incorrecta	Rechazo del cliente
54	Tarjeta vencida	Rechazo del cliente
51	Fondos insuficientes	Rechazo del cliente
14	Número de tarjeta inválido	Rechazo del cliente
05	No autorizada por el emisor	Rechazo del cliente
61	Excede el límite de monto	Rechazo del cliente
75	Excedió los intentos de clave	Rechazo del cliente

96	Falla del sistema	Rechazo técnico
91	Emisor no disponible	Rechazo técnico
68	Respuesta tardía (tiempo agotado)	Rechazo técnico

59	Sospecha de fraude	Sospecha de fraude
43	Tarjeta reportada como robada	Sospecha de fraude
41	Tarjeta reportada como perdida	Sospecha de fraude
*/
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí
SELECT
    canal_id,
    COUNT(CASE WHEN codigo_respuesta IN('57','55','54','51','14','05','61','75') THEN 1 END) AS rechazos_cliente,
    COUNT(CASE WHEN codigo_respuesta IN('96','91','68') THEN 1 END) AS rechazos_tecnicos,
    COUNT(CASE WHEN codigo_respuesta IN('59','43','41') THEN 1 END) AS rechazos_fraude
INTO #respuesta
FROM core.transaccion
WHERE
    (fecha_hora >= '20260101'
    AND fecha_hora < '20260701')
GROUP BY
    canal_id

EXEC chk.s06_e4;
GO
/* Para pensar: ¿qué canal tiene más rechazos técnicos? ¿Es justo
   compararlos en número o deberías compararlos en tasa? ¿Por qué? */
   /*El Canal 3 (POS físico) es el que tiene más rechazos. Pero lo justo es compararlos en tasa (%),
   porque el número suelto no nos dice qué proporción representan del total de operaciones*/

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
SELECT
    MONTH(fecha_hora) AS mes,
    COUNT(*) AS intentos,
    100.0 * COUNT(CASE WHEN codigo_respuesta = '00' THEN 1 END) / COUNT(*) AS tasa_aprobacion,
    100.0 * COUNT(CASE WHEN codigo_respuesta IN('96','91','68') THEN 1 END) / COUNT(*) AS tasa_rechazo_tecnico,
    SUM(CASE WHEN estado = 'Aprobada' AND moneda = 'PEN' THEN monto END) AS facturacion_pen
--INTO #respuesta
FROM
    core.transaccion
WHERE
    fecha_hora >= '20260101'
    AND fecha_hora < '20260701'
GROUP BY
    MONTH(fecha_hora)
ORDER BY
    mes ASC

EXEC chk.s06_reto;
GO


/* ============================================================
   💬 PREGUNTAS DE NEGOCIO PARA REFLEXIONAR (responde aquí mismo)

   1. ¿Qué canal tiene la mejor tasa de aprobación? ¿Le recomendarías a
      la gerencia empujar a los clientes hacia ese canal? ¿Qué más
      tendrías que saber antes?
      Respuesta:

      El canal 1 (App Móvil) tiene la mejor tasa de aprobación con 93.69%. Sin embargo, 
      NO recomendaría empujar a los clientes hacia ese canal porque las tasas de todos los canales son muy similares (entre 92.2% y 93.6%),
      así que la ganancia sería mínima. Además, sería incómodo para el usuario forzarlo a cambiar su forma de pago.
      Por otro lado, se necesitaría saber qué canal mueve más dinero en total

   2. En el tablero mensual, ¿la facturación crece mes a mes? ¿La tasa
      de aprobación se mantiene? ¿Qué pasaría si la facturación crece
      pero la aprobación cae?
      Respuesta:
      
      Con relación a la facturación, sí en el tablero mensual esta crece mes a mes pasando de S/ 2,881,181.58 a S/ 4,135,223.37 en el lapso de 6 meses.
      De igual forma, la tasa de aprobación se mantiene (entre 93.1% y 93.4%). De modo que, si la facturación crece y la aprobación cae, estaríamos en una situación
      donde el negocio factura más por puro volumen de tráfico, pero se vuelve menos eficiente, 
      perdiendo muchas ventas que ya estaban listas para pagarse (costo de oportunidad) y generando mala experiencia en los clientes.

   3. ¿Por qué medir la aprobación con el código '00' y la facturación
      con el estado 'Aprobada'? ¿No debería ser lo mismo?
      Respuesta:

      No es igual porque una compra con código '00' después puede ser extornada.Ya que, con '00' 
      medimos que el pago pasó sin fallas, y con estado 'Aprobada' sumamos solo el dinero que de verdad se quedó en el negocio (sin devoluciones).

   Tu avance: ;
   ============================================================ */
   EXEC chk.ver_progreso 'S06'