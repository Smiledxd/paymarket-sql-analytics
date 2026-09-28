/* ============================================================
   S02 · Filtrar las filas correctas
   Guía: sesiones/S02_filtrar_filas/guia.md
   Pregunta del día: ¿Qué rechazos son por fondos insuficientes y cuáles técnicos?
   ============================================================ */
USE PayMarket_Analitica;
GO


/* ============================================================
   📘 EJEMPLO DE JUGUETE — notas de un colegio
   Ejecuta cada consulta y observa el resultado.
   ============================================================ */
DROP TABLE IF EXISTS #notas;

SELECT alumno, seccion, curso, nota, CAST(entregado AS DATETIME2(0)) AS entregado
INTO #notas
FROM (VALUES
    ('Camila Rojas',   'A', 'Matemática', 17, '2026-05-10 08:15:00'),
    ('Diego Huamán',   'A', 'Matemática', 10, '2026-05-10 23:40:00'),
    ('Lucía Condori',  'B', 'Historia',   14, '2026-05-11 09:05:00'),
    ('Mateo Flores',   'B', 'Matemática', 08, '2026-05-11 00:00:00'),
    ('Sofía Quispe',   'C', 'Historia',   19, '2026-05-12 16:20:00'),
    ('Renzo Salas',    'C', 'Arte',       12, '2026-05-12 10:00:00')
) AS v (alumno, seccion, curso, nota, entregado);

-- 1) AND antes que OR: ¿quién sale aquí? Léelo en voz alta antes de ejecutar.
SELECT alumno, seccion, curso, nota
FROM #notas
WHERE seccion = 'A' AND nota >= 11 OR curso = 'Historia';

-- Con paréntesis la intención queda clara (y el resultado cambia):
SELECT alumno, seccion, curso, nota
FROM #notas
WHERE seccion = 'A' AND (nota >= 11 OR curso = 'Historia');

-- 2) IN, NOT IN y BETWEEN (BETWEEN incluye los dos extremos: 12 y 17 entran)
SELECT alumno, curso FROM #notas WHERE curso IN ('Historia', 'Arte');
SELECT alumno, curso FROM #notas WHERE seccion NOT IN ('A');
SELECT alumno, nota  FROM #notas WHERE nota BETWEEN 12 AND 17;

-- 3) LIKE: la posición del % importa
SELECT alumno FROM #notas WHERE alumno LIKE 'S%';     -- empieza con S
SELECT alumno FROM #notas WHERE alumno LIKE '%s';     -- termina en s
SELECT alumno FROM #notas WHERE alumno LIKE '_a%';    -- la segunda letra es a

-- 4) Una columna con hora: ¿qué entregaron el 11 de mayo?
SELECT alumno, entregado FROM #notas WHERE entregado = '2026-05-11';          -- solo lo de las 00:00:00
SELECT alumno, entregado FROM #notas
WHERE entregado >= '2026-05-11' AND entregado < '2026-05-12';                 -- el día completo
GO


/* ============================================================
   ✍️ EJERCICIO 1 — Fondos insuficientes en POS un día de quincena
   El 15 de marzo de 2026 (día de pago) varios clientes se quejaron
   en tiendas físicas porque su pago no pasó. El área de experiencia
   del cliente quiere ver esos rechazos.

   Qué lograr: las operaciones rechazadas por FONDOS INSUFICIENTES,
   hechas en POS FÍSICO, durante todo el 15/03/2026. Columnas:
     transaccion_id, fecha_hora, monto

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Una lista. Una fila = un rechazo.
   -- 2. ¿Dónde está? core.transaccion; los códigos en core.codigo_respuesta y los canales en core.canal.
   -- 3. ¿Qué filas? Código de fondos insuficientes = ______; canal POS = ______; día = ______
   -- 4. ¿Resumir? No.
   -- 5. ¿Qué muestro? transaccion_id, fecha_hora, monto.
============================================================ */
-- Consultas a los catálogos (sin INTO):


DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí (termina tu SELECT con INTO #respuesta antes del FROM)


EXEC chk.s02_e1;
GO
/* Para pensar: ¿por qué habría más rechazos por fondos insuficientes
   justo antes del día de pago que el mismo día de pago? */


/* ============================================================
   ✍️ EJERCICIO 2 — Rechazos técnicos en la web
   El equipo de tecnología dice que diciembre de 2025 fue tranquilo
   para el canal Web. Tu jefe quiere comprobarlo con un número.

   Qué lograr: cuántas operaciones del canal WEB fueron rechazadas
   por un motivo TÉCNICO durante todo diciembre de 2025. Una fila,
   una columna: rechazos_tecnicos

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Un número. 1 fila, 1 columna.
   -- 2. ¿Dónde está? core.transaccion (y el catálogo core.codigo_respuesta para saber qué es "técnico").
   -- 3. ¿Qué filas? ______
   -- 4. ¿Resumir? Sí: contar.
   -- 5. ¿Qué muestro? rechazos_tecnicos.
============================================================ */
-- Paso A: ¿qué códigos son de tipo 'Rechazo técnico'?


DROP TABLE IF EXISTS #respuesta;
-- Paso B: tu respuesta


EXEC chk.s02_e2;
GO
/* Para pensar: un número solo no dice si es "mucho" o "poco".
   ¿Contra qué lo compararías para responderle a tu jefe? */


/* ============================================================
   ✍️ EJERCICIO 3 — Operaciones grandes en junio
   Cumplimiento (el área que vigila el lavado de activos) revisa cada
   mes las operaciones grandes. En junio de 2026 quiere ver las
   operaciones APROBADAS que superaron S/ 3,000 si eran en soles, o
   US$ 800 si eran en dólares.

   Qué lograr: una fila por operación. Columnas:
     transaccion_id, moneda, monto

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Una lista de operaciones grandes de junio.
   -- 2. ¿Dónde está? core.transaccion.
   -- 3. ¿Qué filas? Aprobadas, de junio 2026, y (______ o ______). ¡Paréntesis!
   -- 4. ¿Resumir? No.
   -- 5. ¿Qué muestro? transaccion_id, moneda, monto.
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí


EXEC chk.s02_e3;
GO
/* Para pensar: ¿por qué el umbral en dólares es más bajo que en soles?
   ¿Te parece una regla razonable? */


/* ============================================================
   ✍️ EJERCICIO 4 — Pequeños negocios de salud y alimentos que no son bodegas
   Marketing prepara una campaña para emprendedores (personas
   naturales con negocio, cuyo RUC empieza con 10) de los rubros
   Farmacias y boticas (5912), Bodegas y minimarkets (5499) y
   Panaderías (5462). Las bodegas ya recibieron otra campaña, así que
   quedan fuera los comercios cuyo nombre comercial empieza con 'Bodega'.

   Qué lograr: una fila por comercio. Columnas:
     comercio_id, nombre_comercial, mcc

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Una lista. Una fila = un comercio.
   -- 2. ¿Dónde está? core.comercio.
   -- 3. ¿Qué filas? RUC que empieza con 10, rubro en ______, nombre que ______
   -- 4. ¿Resumir? No.
   -- 5. ¿Qué muestro? comercio_id, nombre_comercial, mcc.
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí


EXEC chk.s02_e4;
GO
/* Para pensar: algunos negocios del rubro 5499 no se llaman "Bodega..."
   (por ejemplo "Minimarket..." o "Abarrotes..."). ¿Excluir por nombre
   es una buena regla de negocio? ¿Qué columna usarías en su lugar? */


/* ============================================================
   🏋️ RETO FINAL — Rechazos por sospecha de fraude en canales digitales
   El área de prevención de fraude quiere revisar los rechazos por
   SOSPECHA DE FRAUDE en los canales APP MÓVIL y WEB, de montos EN
   SOLES entre S/ 200 y S/ 2,000 (ambos incluidos), durante el primer
   semestre de 2026 (enero a junio).

   Qué lograr: una fila por operación. Columnas:
     transaccion_id, canal_id, codigo_respuesta, monto

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? ______
   -- 2. ¿Dónde está? ______ (y los catálogos que necesites)
   -- 3. ¿Qué filas? Cinco condiciones: ______
   -- 4. ¿Resumir? No.
   -- 5. ¿Qué muestro? ______
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí


EXEC chk.s02_reto;
GO


/* ============================================================
   💬 PREGUNTAS DE NEGOCIO PARA REFLEXIONAR (responde aquí mismo)

   1. Un rechazo por fondos insuficientes y uno técnico hacen perder
      la misma venta. ¿Cuál debería preocupar más a PayMarket y por qué?
      Respuesta:

   2. Rechazar por sospecha de fraude una compra legítima también tiene
      un costo. ¿Cuál? ¿Cómo lo medirías con los datos que hay?
      Respuesta:

   3. En el ejercicio 4 filtraste por el texto del nombre. ¿Qué riesgo
      tiene tomar decisiones de negocio con filtros de texto libre?
      Respuesta:

   Tu avance: EXEC chk.ver_progreso 'S02';
   ============================================================ */
