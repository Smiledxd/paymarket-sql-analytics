/* ============================================================
   S04 · Texto y fechas
   Guía: sesiones/S04_texto_y_fechas/guia.md
   Preguntas del día: ¿Cuántos clientes cumplen años este mes?
                      ¿Qué pasó la última semana?

   En esta sesión "hoy" es la fecha de corte de la base: 30/06/2026.
   Cada bloque declara @hoy. Ejecuta siempre el bloque completo,
   desde el DECLARE, o SQL Server no conocerá la variable.
   ============================================================ */
USE PayMarket_Analitica;
GO


/* ============================================================
   📘 EJEMPLO DE JUGUETE — pedidos de la pastelería "Dulce Misti"
   ============================================================ */
DROP TABLE IF EXISTS #pedidos;

SELECT pedido_id, cliente, codigo, CAST(pedido AS DATETIME2(0)) AS pedido, CAST(entrega AS DATE) AS entrega, total_txt
INTO #pedidos
FROM (VALUES
    (1, '  maría torres ', 'TOR-2026-0015', '2026-01-30 10:15:00', '2026-02-02', '85,50'),
    (2, 'JUAN APAZA',      'APZ-2026-0107', '2026-02-27 18:40:00', '2026-03-01', '120,00'),
    (3, 'Rosa Chambi',     'CHB-2025-1130', '2025-12-31 23:10:00', '2026-01-02', 'sin dato'),
    (4, 'luis poma',       'POM-2026-0301', '2026-03-31 08:05:00', '2026-04-03', '42,90')
) AS v (pedido_id, cliente, codigo, pedido, entrega, total_txt);

-- 1) Texto: limpiar, cambiar mayúsculas, cortar y buscar
SELECT pedido_id,
       TRIM(cliente)                                   AS cliente_limpio,
       UPPER(TRIM(cliente))                            AS cliente_mayusculas,
       LEFT(codigo, 3)                                 AS prefijo,
       SUBSTRING(codigo, 5, 4)                         AS anio_en_codigo,
       RIGHT(codigo, 4)                                AS correlativo,
       CHARINDEX('-', codigo)                          AS posicion_primer_guion,
       CONCAT('Pedido ', pedido_id, ' de ', TRIM(cliente)) AS descripcion
FROM #pedidos;

-- 2) Convertir: REPLACE + TRY_CAST no se caen con datos sucios ('sin dato' queda NULL)
SELECT pedido_id,
       total_txt,
       TRY_CAST(REPLACE(total_txt, ',', '.') AS DECIMAL(8,2)) AS total
FROM #pedidos;
-- Descomenta: CAST sí se cae (error 8114) porque 'sin dato' no es un número
-- SELECT CAST(REPLACE(total_txt, ',', '.') AS DECIMAL(8,2)) FROM #pedidos;

-- 3) Fechas: partes, días de espera y fin de mes
SELECT pedido_id,
       pedido,
       CAST(pedido AS DATE)                    AS dia_pedido,
       YEAR(pedido)                            AS anio,
       DATEDIFF(day, pedido, entrega)          AS dias_de_espera,
       EOMONTH(pedido)                         AS fin_de_mes_del_pedido,
       DATEADD(month, 1, CAST(pedido AS DATE)) AS mismo_dia_mes_siguiente   -- mira el pedido 1 y el 4
FROM #pedidos;

-- 4) DATEDIFF cuenta límites cruzados: 1 "año" entre dos fechas separadas por un día
SELECT DATEDIFF(year, '2025-12-31', '2026-01-01') AS anios,
       DATEDIFF(day,  '2025-12-31', '2026-01-01') AS dias;

-- 5) Un rango relativo a "hoy": lo que va del mes (del día 1 hasta hoy, completo)
DECLARE @hoy_pasteleria DATE = '2026-02-28';
SELECT pedido_id, pedido
FROM #pedidos
WHERE pedido >= DATEFROMPARTS(YEAR(@hoy_pasteleria), MONTH(@hoy_pasteleria), 1)   -- 1 de febrero, 00:00
  AND pedido <  DATEADD(day, 1, @hoy_pasteleria);                                 -- antes del 1 de marzo, 00:00
GO


/* ============================================================
   ✍️ EJERCICIO 1 — Etiquetas de bienvenida
   A cada cliente nuevo se le envía un kit de bienvenida. La etiqueta
   del paquete lleva el apellido paterno en MAYÚSCULAS, una coma, un
   espacio y los nombres (ejemplo de otra persona: 'QUISPE, Ana María').
   Además, marketing quiere saber el dominio del correo de cada uno
   (lo que va después de la arroba, sin la arroba; NULL si no tiene correo).

   Qué lograr: los clientes con fecha de alta igual a hoy. Columnas:
     cliente_id, etiqueta, dominio_correo

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Una lista. Una fila = un cliente que se registró hoy.
   -- 2. ¿Dónde está? core.cliente.
   -- 3. ¿Qué filas? fecha_alta = @hoy
   -- 4. ¿Resumir? No.
   -- 5. ¿Qué muestro? cliente_id, etiqueta = ______, dominio_correo = ______
============================================================ */
DROP TABLE IF EXISTS #respuesta;
DECLARE @hoy DATE = '2026-06-30';
-- Tu código aquí (termina tu SELECT con INTO #respuesta antes del FROM)


EXEC chk.s04_e1;
GO
/* Para pensar: ¿qué pasaría con la etiqueta si armaras el texto con +
   y el cliente no tuviera nombres registrados? */


/* ============================================================
   ✍️ EJERCICIO 2 — Cumpleañeros de Cusco este mes
   La oficina de Cusco quiere saludar a sus clientes ACTIVOS que
   cumplen años este mes (el mes de @hoy), con un cupón que cambia
   según la edad que cumplen.

   Qué lograr: una fila por cliente. Columnas:
     cliente_id, fecha_nacimiento,
     edad_que_cumple (la edad que cumplen este año)
   El departamento de Cusco se reconoce porque el ubigeo empieza con '08'.

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Una lista. Una fila = un cumpleañero.
   -- 2. ¿Dónde está? core.cliente.
   -- 3. ¿Qué filas? Activos, de Cusco (______) y nacidos en el mes de @hoy (______).
   -- 4. ¿Resumir? No.
   -- 5. ¿Qué muestro? cliente_id, fecha_nacimiento, edad_que_cumple = ______
============================================================ */
DROP TABLE IF EXISTS #respuesta;
DECLARE @hoy DATE = '2026-06-30';
-- Tu código aquí


EXEC chk.s04_e2;
GO
/* Para pensar: los clientes sin fecha de nacimiento no aparecen.
   ¿Por qué? ¿Cuántos clientes de Cusco se quedan sin saludo por eso? */


/* ============================================================
   ✍️ EJERCICIO 3 — ¿Qué pasó la última semana?
   El lunes, la gerenta pregunta cómo fue la semana: cuántas
   operaciones APROBADAS en SOLES hubo y por cuánto, en los últimos
   7 días incluido hoy (del 24 al 30 de junio, ambos completos).

   Qué lograr: una fila. Columnas:
     total_operaciones, monto_total

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Dos números de una semana.
   -- 2. ¿Dónde está? core.transaccion.
   -- 3. ¿Qué filas? Aprobadas, en soles, desde ______ hasta antes de ______ (calculados desde @hoy).
   -- 4. ¿Resumir? Sí: contar y sumar.
   -- 5. ¿Qué muestro? total_operaciones, monto_total.
============================================================ */
DROP TABLE IF EXISTS #respuesta;
DECLARE @hoy DATE = '2026-06-30';
-- Tu código aquí


EXEC chk.s04_e3;
GO
/* Para pensar: ¿cómo sabrías si fue una buena semana? ¿Con qué
   semana la compararías y por qué? */


/* ============================================================
   ✍️ EJERCICIO 4 — Créditos del mes pasado
   Cobranzas prepara el seguimiento de los créditos desembolsados
   el MES PASADO (el mes anterior al de @hoy, completo). Calcula el
   rango a partir de @hoy, sin escribir las fechas a mano.

   Qué lograr: una fila por crédito. Columnas:
     credito_id, fecha_desembolso,
     dias_desde_desembolso (días desde el desembolso hasta hoy, positivo),
     fecha_primera_cuota   (vence un mes calendario después del desembolso)

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Una lista. Una fila = un crédito del mes pasado.
   -- 2. ¿Dónde está? core.credito.
   -- 3. ¿Qué filas? Desde el día 1 del mes pasado (______) hasta antes del día 1 de este mes (______).
   -- 4. ¿Resumir? No.
   -- 5. ¿Qué muestro? Las 4 columnas; dos son cálculos de fecha: ______ y ______.
============================================================ */
DROP TABLE IF EXISTS #respuesta;
DECLARE @hoy DATE = '2026-06-30';
-- Tu código aquí


EXEC chk.s04_e4;
GO
/* Para pensar: al 30 de junio, ¿cuántos de estos créditos ya tuvieron
   su primera cuota vencida? ¿Por qué eso importa para medir mora? */


/* ============================================================
   🏋️ RETO FINAL — La última semana, día por día
   La gerenta quiere ver la semana del ejercicio 3 desglosada por día,
   y marcar qué días son fin de mes (sospecha que ese día se vende más).

   Qué lograr: una fila por día, del 24 al 30 de junio (7 filas),
   solo operaciones APROBADAS en SOLES. Columnas:
     fecha          (sin hora),
     operaciones    (cantidad),
     monto_total    (suma de montos),
     es_fin_de_mes  (1 si la fecha es el último día de su mes; 0 si no)

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? ______ Una fila = ______
   -- 2. ¿Dónde está? ______
   -- 3. ¿Qué filas? ______
   -- 4. ¿Resumir? Sí, por ______
   -- 5. ¿Qué muestro? ______
============================================================ */
DROP TABLE IF EXISTS #respuesta;
DECLARE @hoy DATE = '2026-06-30';
-- Tu código aquí


EXEC chk.s04_reto;
GO


/* ============================================================
   💬 PREGUNTAS DE NEGOCIO PARA REFLEXIONAR (responde aquí mismo)

   1. En el reto, ¿el fin de mes fue el día de más operaciones? ¿Con una
      sola semana puedes concluir que "a fin de mes se vende más"?
      ¿Qué consulta harías para comprobarlo?
      Respuesta:

   2. Si el reporte diario se hiciera con FORMAT(fecha_hora, 'dd/MM')
      y se ordenara por esa columna, ¿qué vería mal la gerenta en
      un reporte de varios meses?
      Respuesta:

   3. ¿Qué pasaría con "la última semana" si PayMarket tuviera clientes
      en otro país con otra zona horaria?
      Respuesta:

   Tu avance: EXEC chk.ver_progreso 'S04';
   ============================================================ */
