/* ============================================================
   Proyecto · Informe para la gerencia de PayMarket
   Consultas finales que responden cada pregunta del informe.
   Los hallazgos y recomendaciones van en proyecto/hallazgos.md.

   Reglas:
   - Una sección por pregunta. Cada consulta con un comentario que
     diga qué responde y en qué sesión la escribiste o mejoraste.
   - Sin SELECT *, TOP con ORDER BY, fechas con >= y <, alias claros.
   - Datos simulados.
   ============================================================ */
USE PayMarket_Analitica;
GO


/* ------------------------------------------------------------
   1. ¿Cómo evolucionan el volumen y la facturación, y qué
      estacionalidad tiene el negocio?
   ------------------------------------------------------------ */

--Días del mes (del 1 al 31) con más operaciones aprobadas
SELECT
    DAY(fecha_hora) AS fecha_mes,
    COUNT(*) AS nro_operaciones_aprobadas
FROM core.transaccion
WHERE
    estado = 'Aprobada'
GROUP BY
    DAY(fecha_hora)
ORDER BY
    nro_operaciones_aprobadas DESC

--Evolución mensual operaciones aprobadas en soles
SELECT
    YEAR(fecha_hora) AS año,
    MONTH(fecha_hora) AS mes,
    COUNT(*) AS total_operaciones,
    SUM(monto) AS facturacion,
    CAST(AVG(monto) AS DECIMAL (10,2))AS ticket_promedio
FROM core.transaccion
WHERE
    estado = 'Aprobada'
    AND moneda = 'PEN'
GROUP BY
    YEAR(fecha_hora),
    MONTH(fecha_hora)
ORDER BY
    YEAR(fecha_hora) ASC,
    MONTH(fecha_hora) ASC


/* ------------------------------------------------------------
   2. ¿Qué comercios y rubros concentran los ingresos por comisión?
   ------------------------------------------------------------ */
SELECT TOP 10 --primero voy a ver quienes dejan poco o nada y por qué
    comercio_id,
    nombre_comercial,
    modalidad,
    fecha_afiliacion,
    mcc,
    tasa_mdr * 100 AS tasa_pct
FROM core.comercio
WHERE estado = 'Activo'
ORDER BY
    tasa_mdr ASC, fecha_afiliacion ASC --todos tienen una tasa_pct de 0 y son minimarkets o bodegas
    -- y Paymarket maneja esta estrategia por el volumen que manejan las transacciones diarias.

/* ------------------------------------------------------------
   3. ¿Dónde y por qué se rechazan pagos, y cuánto ingreso se pierde?
   ------------------------------------------------------------ */
-- total de transacciones 2025
SELECT 
    COUNT(*) AS nro_transacciones
FROM core.transaccion
WHERE
    fecha_hora >= '2025-01-01' AND fecha_hora < '2026-01-01'

-- total transacciones rechazadas
SELECT 
    COUNT(*) AS nro_transacciones_rechazadas
FROM core.transaccion
WHERE
    (fecha_hora >= '2025-01-01' AND fecha_hora < '2026-01-01')
    AND estado = 'Rechazada'

-- rechazos por fondo insuficientes:
SELECT 
    COUNT(*) AS fondos_insuficientes
FROM core.transaccion
WHERE
    (fecha_hora >= '2025-01-01' AND fecha_hora < '2026-01-01')
    AND estado = 'Rechazada'
    AND codigo_respuesta = '51'

-- intentos y las tasas de rechazo del cliente, técnico y por fraude
SELECT
    CASE canal_id WHEN 1 THEN 'App móvil' WHEN 2 THEN 'Web' WHEN 3 THEN 'POS físico' WHEN 4 THEN 'Pago con QR' END AS canal_id,
    MONTH(fecha_hora) AS mes,
    COUNT(*) AS intentos,
    100.0 * COUNT(CASE WHEN codigo_respuesta IN('57','55','54','51','14','05','61','75') THEN 1 END) AS rechazos_cliente,
    100.0 * COUNT(CASE WHEN codigo_respuesta IN('96','91','68') THEN 1 END) / COUNT(*) AS tasa_rechazo_tecnico,
    100.0 * COUNT(CASE WHEN codigo_respuesta IN('59','43','41') THEN 1 END) / COUNT(*) AS rechazos_fraude
FROM core.transaccion
WHERE
    (fecha_hora >= '20250101'
    AND fecha_hora < '20260701')
GROUP BY
    canal_id,
    MONTH(fecha_hora)
ORDER BY
    canal_id ASC,
    mes ASC

/* ------------------------------------------------------------
   4. ¿Qué clientes se registran y no usan la billetera?
      ¿Cómo retiene cada cohorte?
   ------------------------------------------------------------ */
-- clientes que tienen correo,celular y cuántos no tienen ninguno de los dos.
SELECT
    COUNT(correo) AS total_clientes_ccorreo,
    COUNT(celular) AS total_clientes_ccelular,
    COUNT(*) - COUNT(COALESCE(correo,celular)) AS total_clientes_scontacto
FROM core.cliente

    



/* ------------------------------------------------------------
   5. ¿Qué comercios muestran un nivel de contracargos anormal?
   ------------------------------------------------------------ */



/* ------------------------------------------------------------
   6. ¿Cómo se comporta la mora de los microcréditos por cosecha
      y categoría SBS?
   ------------------------------------------------------------ */



/* ------------------------------------------------------------
   7. Estimaciones de impacto para la recomendación principal
   ------------------------------------------------------------ */
