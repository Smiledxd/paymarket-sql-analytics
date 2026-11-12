/* ============================================================
   S09b · Self-join: una tabla que se apunta a sí misma
   Guía: sesiones/S09b_self_join/guia.md
   Palabras raras: guias/glosario_paymarket.md
   ============================================================ */
USE PayMarket_Analitica;
GO

/* ============================================================
   🔁 CALENTAMIENTO (sin pistas, sin mirar R09)
   ¿Qué herramienta usarías? Escribe solo la palabra.
   1. Quiero los comercios que NUNCA vendieron:
   2. Quiero TODOS los clientes con cuántos créditos tienen, también los que tienen 0:
   3. En un LEFT JOIN, ¿dónde va la condición t.estado = 'Aprobada'?:

   1. not exists
   2. left join
   3. depende a que tabla pertenece la condición
   Compara después con la tabla del tema 1 de R09.
   ============================================================ */


/* ------------------------------------------------------------
   PREPARACIÓN: no hace falta leerlo. Selecciónalo y ejecútalo.
   ------------------------------------------------------------ */
DROP TABLE IF EXISTS #empleados;
SELECT empleado_id, nombre, jefe_id INTO #empleados
FROM (VALUES (1, 'Rosa', NULL), (2, 'Iván', 1), (3, 'Luz', 2), (4, 'Omar', 2)) AS v (empleado_id, nombre, jefe_id);
GO


/* ============================================================
   📘 EJEMPLO — "Cada empleado con el nombre de su jefe"
   La tabla tiene empleados y jefes juntos: la uso dos veces.

   Antes de ejecutar, adivina: ¿cuántas filas salen? ¿Sale Rosa?
   ============================================================ */
SELECT e.nombre AS empleado, j.nombre AS jefe
FROM #empleados AS e
JOIN #empleados AS j ON j.empleado_id = e.jefe_id;
/* Resultado:
   empleado | jefe
   Iván     | Rosa
   Luz      | Iván
   Omar     | Iván
   Rosa no sale: no tiene jefe, y un JOIN normal solo deja a los que tienen pareja. */
GO


/* ============================================================
   ✍️ EJERCICIO — ¿Quién trajo a cada cliente nuevo?

   Qué te piden:
     Para cada cliente que se registró en junio de 2026 y llegó
     invitado por otro cliente: quién lo invitó y cuántos días antes
     se había registrado esa persona. Sirve para premiar a quien invita.

   Cómo debería verse (valores inventados):
     cliente_id | referidor_id | nombre_referidor | dias_desde_alta_referidor
     900        | 50           | Ana María        | 120

   nombre_referidor = la columna nombres del que invitó.
   dias_desde_alta_referidor = días entre el alta del que invitó y el
   alta del cliente nuevo (número positivo).

   FICHA
   -- ¿Qué es una fila? Un cliente nuevo que llegó invitado.
   -- ¿Cuántas copias de core.cliente necesito? 1?
   -- ¿Qué columna apunta y contra qué llave va?  cliente_id y referido_id
   -- ¿Qué fecha de alta se filtra: la del nuevo o la del referidor? referido
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí (termina tu SELECT con INTO #respuesta antes del FROM)
SELECT
    n.cliente_id,
    r.cliente_id AS referidor_id,
    r.nombres AS nombre_referidor,
    DATEDIFF(DAY,r.fecha_alta,n.fecha_alta) AS dias_desde_alta_referidor
INTO #respuesta
FROM core.cliente AS n
JOIN core.cliente AS r ON n.cliente_referidor_id= r.cliente_id
WHERE
    (n.fecha_alta >= '20260601'
    AND n.fecha_alta < '20260701')
ORDER BY dias_desde_alta_referidor DESC

EXEC chk.s09_e4;
GO


/* ============================================================
   💬 UNA SOLA PREGUNTA
   ¿Los que invitan suelen llevar mucho o poco tiempo en PayMarket?
   Mira tu columna de días. ¿Qué te dice eso?
   Respuesta:
   La gran mayoría de los que invitan sí llevan mucho tiempo en Paymarket, aunque, hay presencia de clientes referidos que llevan poco tiempo
   en la billetera digital

   📋 REGISTRO (llénalo al terminar; me sirve para ajustar lo siguiente)
   Hora de inicio: 13:00 p.m.
   Hora de fin: 13:44 p.m.

   Ejercicio | Minutos | ¿Lo saltaste? (⏭️) | Pistas que abriste
   1         |    25     |                    |p1,p2,p3

   ¿Usaste IA? ¿Para qué?: sí, Lo que no entendía es: por qué en el ON mezclaba el ID del nuevo con el referidor. Y le pregunté a Gemini y me dijo: el nuevo guarda en cliente_referidor_id el código de quien lo invitó; con ese número vas a la tabla r y buscas su ficha usando su cliente_id principal para sacar su nombre. Todo el rato lo estaba haciendo al revéz
   ¿Qué palabra o parte del enunciado te confundió?: días entre el alta del que invitó y el
   alta del cliente nuevo (entiendo la intención y la palabra "alta", más no, la selección de palabras para decirlo de esa manera, entiendo que es para saber cuantos días va con la billetera el referidor al momento que refirió)
   Dificultad del 1 al 5: 3, más que todo el ejemplo de empleado y jefe fue lo que me confundió creo, por estar haciendo la mención, pensaba que era cliente(empleado) y referidor(jefe)
   lo hubiera puesto así :
   FROM empleados AS e                                  -- el empleado
   JOIN empleados AS j ON  e.jefe_id  = j.empleado_id   -- su jefe
   De esa manera lo hubiera relacionado bien creo yo por eso mencionó que lo hice al revéz lol.
   ⚠️ Si algo sale raro , apenas me percato que existe eso en la guía que existe esa sección, debería de estar en pistas mejor o integrase de otra manera pero mejor, es la primera vez que lo veo

   Tu avance: ;
   ============================================================ */
   EXEC chk.ver_progreso 'S09'