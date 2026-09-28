/* ============================================================
   S03 · Los nulos a fondo
   Guía: sesiones/S03_nulos_a_fondo/guia.md
   Pregunta del día: ¿Cuántos clientes no tienen datos de contacto?
   ============================================================ */
USE PayMarket_Analitica;
GO


/* ============================================================
   📘 EJEMPLO DE JUGUETE — la academia de inglés "Speak Up Huancayo"
   Algunos alumnos no rindieron el examen (nota NULL) y algunos
   no dejaron teléfono de apoderado.
   ============================================================ */
DROP TABLE IF EXISTS #alumnos;

SELECT alumno, nivel, nota, telefono_apoderado, intentos, puntos
INTO #alumnos
FROM (VALUES
    ('Andrea', 'Básico',     15,   '987111222', 3, 45),
    ('Bruno',  'Básico',     NULL, NULL,        0,  0),
    ('Carla',  'Intermedio', 11,   NULL,        2, 22),
    ('Dante',  'Intermedio', NULL, '912333444', 1,  8),
    ('Elena',  'Avanzado',   18,   '955666777', 4, 72)
) AS v (alumno, nivel, nota, telefono_apoderado, intentos, puntos);

-- 1) = NULL nunca es verdadero; IS NULL sí funciona
SELECT alumno FROM #alumnos WHERE nota = NULL;       -- 0 filas
SELECT alumno FROM #alumnos WHERE nota IS NULL;      -- Bruno y Dante

-- 2) Lógica de tres valores: ¿quién NO tiene nota 15?
SELECT alumno, nota FROM #alumnos WHERE nota <> 15;  -- Bruno y Dante no salen: su nota es desconocida

-- 3) NOT IN con un NULL dentro de la lista: no sale nadie
SELECT alumno FROM #alumnos WHERE nivel NOT IN ('Básico', NULL);

-- 4) Los resúmenes y los nulos
SELECT COUNT(*)                  AS alumnos,
       COUNT(nota)               AS con_nota,
       AVG(nota * 1.0)           AS promedio_de_los_que_rindieron,
       AVG(COALESCE(nota, 0) * 1.0) AS promedio_contando_ceros   -- ¿cuál es el correcto? depende de la pregunta
FROM #alumnos;

-- 5) COALESCE con respaldo y NULLIF para dividir sin error
SELECT alumno,
       COALESCE(telefono_apoderado, 'Llamar a secretaría') AS a_quien_llamar,
       puntos / NULLIF(intentos, 0)                      AS puntos_por_intento   -- Bruno: NULL, no error
FROM #alumnos;

-- Descomenta y ejecuta: sin NULLIF la consulta completa falla (error 8134)
-- SELECT alumno, puntos / intentos AS puntos_por_intento FROM #alumnos;
GO


/* ============================================================
   ✍️ EJERCICIO 1 — Clientes sin correo
   Marketing quiere enviar un boletín por correo a todos los
   clientes y pregunta a cuántos NO les llegará.

   Qué lograr: una fila, una columna: clientes_sin_correo

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Un número.
   -- 2. ¿Dónde está? core.cliente (una fila = un cliente).
   -- 3. ¿Qué filas? Las que no tienen correo: ______
   -- 4. ¿Resumir? Sí: contar.
   -- 5. ¿Qué muestro? clientes_sin_correo.
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí (termina tu SELECT con INTO #respuesta antes del FROM)


EXEC chk.s03_e1;
GO
/* Para pensar: ¿qué porcentaje de los clientes es? Calcúlalo a mano
   con el total de S00. ¿Es un problema para marketing? */


/* ============================================================
   ✍️ EJERCICIO 2 — Clientes sin ningún dato de contacto
   Si un cliente no tiene correo pero sí celular, todavía se le
   puede escribir por SMS. El problema son los que no tienen
   ninguno de los dos.

   Qué lograr: una fila, una columna: clientes_sin_contacto

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Un número.
   -- 2. ¿Dónde está? core.cliente.
   -- 3. ¿Qué filas? ______ (¿AND u OR?)
   -- 4. ¿Resumir? Sí: contar.
   -- 5. ¿Qué muestro? clientes_sin_contacto.
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí


EXEC chk.s03_e2;
GO
/* Para pensar: ¿cómo podría PayMarket evitar que se registren clientes
   sin ningún dato de contacto? ¿Qué costo tendría esa regla? */


/* ============================================================
   ✍️ EJERCICIO 3 — Lista de contacto para la bienvenida
   Cada semana, el equipo de bienvenida escribe a los clientes nuevos.
   Quiere una lista con UN dato de contacto por cliente: el correo
   si lo tiene; si no, el celular; y si no tiene ninguno, el texto
   'SIN CONTACTO' (exactamente así).

   Qué lograr: los clientes con fecha de alta del 1 al 7 de junio de
   2026 (ambos días incluidos). Columnas:
     cliente_id, contacto

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Una lista. Una fila = un cliente nuevo.
   -- 2. ¿Dónde está? core.cliente.
   -- 3. ¿Qué filas? ______
   -- 4. ¿Resumir? No.
   -- 5. ¿Qué muestro? cliente_id y contacto = ______ (en ese orden de preferencia)
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí


EXEC chk.s03_e3;
GO
/* Para pensar: en la columna contacto se mezclan correos y celulares.
   ¿Qué problema tendría el equipo al usar esa lista? ¿Qué columna
   le agregarías? */


/* ============================================================
   ✍️ EJERCICIO 4 — Beneficio para quienes no vinieron de los embajadores
   Los clientes 1815 y 1535 son "embajadores" de PayMarket: invitaron
   a muchas personas, y esas personas ya recibieron un regalo.
   Ahora marketing dará un beneficio a TODOS los demás clientes:
   los que llegaron invitados por otra persona y también los que
   llegaron solos (sin referidor).

   Qué lograr: una fila, una columna: total_clientes (cuántos
   clientes recibirán el beneficio).

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Un número.
   -- 2. ¿Dónde está? core.cliente; la columna clave es cliente_referidor_id.
   -- 3. ¿Qué filas? Todos menos los referidos por 1815 o 1535. ¿Y los que tienen referidor NULL? ______
   -- 4. ¿Resumir? Sí: contar.
   -- 5. ¿Qué muestro? total_clientes.
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí


EXEC chk.s03_e4;
GO
/* Para pensar: si hubieras entregado el número equivocado, ¿cuántos
   clientes se habrían quedado sin beneficio? ¿Cómo se enteraría la empresa? */


/* ============================================================
   🏋️ RETO FINAL — ¿Cuánto venden los comercios por cada sol de comisión?
   El equipo comercial quiere un indicador de eficiencia: por cada
   sol de comisión que paga un comercio, cuántos soles vende a través
   de PayMarket. Solo cuentan las operaciones APROBADAS en SOLES.
   Algunos comercios no pagan comisión: para ellos el indicador no se
   puede calcular y debe quedar como NULL (no como 0 ni como error).

   Qué lograr: una fila por comercio con al menos una operación
   aprobada en soles. Columnas:
     comercio_id,
     facturacion            (suma de montos),
     comision_total         (suma de comisiones),
     soles_por_sol_comision (facturación entre comisión)

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? ______ Una fila = ______
   -- 2. ¿Dónde está? ______
   -- 3. ¿Qué filas? ______
   -- 4. ¿Resumir? Sí, por ______
   -- 5. ¿Qué muestro? ______ (¡cuidado con el denominador!)
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí


EXEC chk.s03_reto;
GO


/* ============================================================
   💬 PREGUNTAS DE NEGOCIO PARA REFLEXIONAR (responde aquí mismo)

   1. En el reto, ¿quiénes son los comercios con NULL? Búscalos en
      core.comercio. ¿Por qué PayMarket aceptaría no cobrarles?
      Respuesta:

   2. Si un gerente te pide "pon 0 donde sale NULL para que el reporte
      se vea limpio", ¿qué le responderías?
      Respuesta:

   3. ¿Qué otras columnas de core.cliente pueden ser NULL y qué
      análisis se verían afectados por eso?
      Respuesta:

   Tu avance: EXEC chk.ver_progreso 'S03';
   ============================================================ */
