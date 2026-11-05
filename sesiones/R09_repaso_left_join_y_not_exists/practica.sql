/* ============================================================
   R09 · Repaso: ¿cuándo uso LEFT JOIN y cuándo NOT EXISTS?
   Guía: sesiones/R09_repaso_left_join_y_not_exists/guia.md
   Palabras raras: guias/glosario_paymarket.md
   ============================================================ */
USE PayMarket_Analitica;
GO


/* ------------------------------------------------------------
   PREPARACIÓN: no hace falta leerlo. Selecciónalo y ejecútalo.
   Crea las mismas tablas de alumnos y pagos del repaso anterior.
   ------------------------------------------------------------ */
DROP TABLE IF EXISTS #alumnos;
DROP TABLE IF EXISTS #pagos;
SELECT alumno_id, nombre INTO #alumnos
FROM (VALUES (1, 'Adriana'), (2, 'Benjamín'), (3, 'Cecilia'), (4, 'Darío')) AS v (alumno_id, nombre);
SELECT pago_id, alumno_id, mes, estado INTO #pagos
FROM (VALUES (100, 1, 'marzo', 'pagado'), (101, 1, 'abril', 'pagado'),
             (102, 2, 'marzo', 'pendiente'), (103, 3, 'marzo', 'pagado')) AS v (pago_id, alumno_id, mes, estado);
GO


/* ============================================================
   📘 EJEMPLO 1 — "Los alumnos que NUNCA pagaron nada"
   La palabra "nunca" me dice: NOT EXISTS.

   Antes de ejecutar, adivina: ¿quién sale?
   ============================================================ */
SELECT a.nombre
FROM #alumnos AS a
WHERE NOT EXISTS (SELECT 1
                  FROM #pagos AS p
                  WHERE p.alumno_id = a.alumno_id);
/* Resultado: Darío
   Benjamín no sale, porque sí tiene un pago (aunque esté pendiente). */
GO


/* ============================================================
   📘 EJEMPLO 2 — "TODOS los alumnos con sus pagos de marzo, también
                   los que tienen 0"
   Las palabras "todos, también" me dicen: LEFT JOIN.

   Antes de ejecutar, adivina: ¿cuántos pagos de marzo tiene Darío?
   ============================================================ */
SELECT a.nombre, COUNT(p.pago_id) AS pagos_marzo
FROM #alumnos AS a
LEFT JOIN #pagos AS p
       ON p.alumno_id = a.alumno_id
      AND p.mes = 'marzo'              -- condición de la tabla de la DERECHA: va en el ON
GROUP BY a.nombre;
/* Resultado:  Adriana 1 | Benjamín 1 | Cecilia 1 | Darío 0
   Darío da 0 porque COUNT(p.pago_id) no cuenta los NULL.
   Con COUNT(*) le saldría 1, porque su fila sí existe. */
GO


/* ============================================================
   ✍️ EJERCICIO 1 — Clientes que nunca recibieron un crédito

   Qué te piden:
     Los clientes que se registraron en enero de 2025 y nunca
     recibieron un crédito. Marketing quiere ofrecérselo.

   Cómo debería verse (valores inventados):
     cliente_id | nombres
     123        | Ana María

   FICHA
   -- ¿Qué es una fila? Un cliente.
   -- ¿Qué palabra me da la pista? nunca
   -- ¿Qué herramienta uso? not exists
   -- ¿Qué tabla va afuera y en cuál busco? ______
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí (termina tu SELECT con INTO #respuesta antes del FROM)

SELECT
    c.cliente_id,
    c.nombres
INTO #respuesta
FROM core.cliente AS c
WHERE NOT EXISTS(SELECT 1
    FROM core.credito AS cr
    WHERE c.cliente_id = cr.cliente_id)
    AND ( c.fecha_alta >= '20250101'
    AND c.fecha_alta < '20250201')

EXEC chk.r09_e1;
GO


/* ============================================================
   ✍️ EJERCICIO 2 — Todas las librerías y sus ventas de junio
   Cambia de herramienta: el ejemplo 1 no sirve aquí.

   Qué te piden:
     TODAS las librerías (mcc = '5942') con cuántas operaciones
     aprobadas tuvieron en junio de 2026. Si una no vendió nada,
     debe aparecer con 0.

   Cómo debería verse (valores inventados):
     comercio_id | nombre_comercial | operaciones_aprobadas
     77          | Librería Ejemplo | 0

   FICHA
   -- ¿Qué es una fila? Una librería.
   -- ¿Qué palabras me dan la pista? Todas
   -- ¿Qué herramienta uso? Left join
   -- ¿Qué condiciones van en el ON y cuál en el WHERE? En el ON las de la tabla derecha, y where izquierda
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí
SELECT
    co.comercio_id,
    co.nombre_comercial,
    COUNT(t.transaccion_id) AS operaciones_aprobadas
INTO #respuesta
FROM core.comercio AS co
LEFT JOIN core.transaccion AS t
    ON co.comercio_id = t.comercio_id
    AND (t.fecha_hora >= '20260601'
    AND t.fecha_hora < '20260701')
    AND t.estado = 'Aprobada'
WHERE
    co.mcc = '5942'
GROUP BY 
    co.comercio_id,
    co.nombre_comercial
    
EXEC chk.r09_e2;
GO


/* ============================================================
   ✍️ EJERCICIO 3 — Clientes antiguos que dejaron de pagar
   Es como el ejercicio 1, con una sola novedad: aquí sí hace falta
   un JOIN adentro (tema 2 de la guía).

   Qué te piden:
     Los clientes con estado 'Activo', registrados en enero de 2025,
     que NO hicieron ningún pago aprobado en junio de 2026.
     Marketing quiere saber a quién recuperar.

   Cómo debería verse (valores inventados):
     cliente_id | nombres
     456        | Luis Alberto

   FICHA
   -- ¿Qué es una fila? un cliente con su código
   -- ¿Qué herramienta uso? join para conectar tablas, not exists
   -- ¿La tabla donde busco tiene cliente_id? ¿Cómo llego a él? Debo ir desde core.cuenta
   -- ¿Qué línea conecta con el cliente de afuera? ?
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí
SELECT
    cl.cliente_id,
    cl.nombres
INTO #respuesta
FROM core.cliente AS cl
WHERE
    estado = 'Activo'
    AND (fecha_alta >= '20250101'
    AND fecha_alta < '20250201')
    AND NOT EXISTS (SELECT 1
        FROM core.transaccion AS t
        JOIN core.cuenta AS cu ON t.cuenta_id = cu.cuenta_id
        WHERE cu.cliente_id = cl.cliente_id
        AND t.estado = 'Aprobada'
        AND (t.fecha_hora >= '20260601'
        AND t.fecha_hora < '20260701'))

EXEC chk.r09_e3;
GO


/* ============================================================
   💬 UNA SOLA PREGUNTA
   Esos clientes siguen con estado 'Activo', pero no pagaron nada en
   junio. ¿Qué te dice eso sobre la palabra "activo" en la base?
   Respuesta:
   Que el cliente cuenta con una cuenta o estado activado pero no se puede asegurar que use la billetera para estar en
   un estado de actividad contante con la plataforma. Ya que, se puede seguir conservando la billetera más no usarla



   📋 REGISTRO (llénalo al terminar; me sirve para ajustar lo siguiente)
   Hora de inicio: 1:00pm
   Hora de fin: 2:00pm

   Ejercicio | Minutos | ¿Lo saltaste? (⏭️) | Pistas que abriste
   1         |         |           no         | ninguna felizmente
   2         |         |         no           | ninguna felizmente
   3         |         |        no            | ninguna felizmente, pero si fui a ver la guia si habia el join dentro del not exist por que no recordaba y me forze  recodar jaja

   ¿Usaste IA? ¿Para qué?: para nada, la 2 mes costó el pensar y la 3 uff la hice solo, creo que es lo más pro que he hecho hasta hora, hasta rezaba que estuviese bien, creo que este lenguaje es más lógica y realizar la debida consulta
   ¿Qué palabra o parte del enunciado te confundió?: pago aprobado del ejercicio 3 ya hasta antes de ejecutar pensé que tal vez podría ser de pagar cuotas.
   Dificultad del 1 al 5: 4, se se sintió realizalo siento que entendí, pero no estaria mal ir a este ritmo me gusta, 1 hora creo que está bien, bueno depende de los objetivos.

   Tu avance: ;
   ============================================================ */
   EXEC chk.ver_progreso 'R09'