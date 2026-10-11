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
