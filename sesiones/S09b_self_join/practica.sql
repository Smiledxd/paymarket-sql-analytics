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
   -- ¿Cuántas copias de core.cliente necesito? ______
   -- ¿Qué columna apunta y contra qué llave va? ______
   -- ¿Qué fecha de alta se filtra: la del nuevo o la del referidor? ______
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí (termina tu SELECT con INTO #respuesta antes del FROM)


EXEC chk.s09_e4;
GO


/* ============================================================
   💬 UNA SOLA PREGUNTA
   ¿Los que invitan suelen llevar mucho o poco tiempo en PayMarket?
   Mira tu columna de días. ¿Qué te dice eso?
   Respuesta:


   📋 REGISTRO (llénalo al terminar; me sirve para ajustar lo siguiente)
   Hora de inicio:
   Hora de fin:

   Ejercicio | Minutos | ¿Lo saltaste? (⏭️) | Pistas que abriste
   1         |         |                    |

   ¿Usaste IA? ¿Para qué?:
   ¿Qué palabra o parte del enunciado te confundió?:
   Dificultad del 1 al 5:

   Tu avance: EXEC chk.ver_progreso 'S09';
   ============================================================ */
