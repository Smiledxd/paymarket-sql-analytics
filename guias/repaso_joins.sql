/* ============================================================
   Repaso de JOIN · práctica con la academia de natación
   Hoja de apoyo: guias/repaso_joins.md

   Son 6 ejercicios cortos de juguete. Cada uno dice qué resultado
   deberías obtener, para que compruebes tú mismo si te salió.
   Tiempo sugerido: 30 minutos. No hay verificador: si tu resultado
   coincide con el esperado, está bien.
   ============================================================ */

/* Ejecuta primero este bloque: crea las dos tablas del ejemplo */
DROP TABLE IF EXISTS #alumnos;
DROP TABLE IF EXISTS #pagos;

SELECT alumno_id, nombre
INTO #alumnos
FROM (VALUES (1, 'Adriana'), (2, 'Benjamín'), (3, 'Cecilia'), (4, 'Darío')) AS v (alumno_id, nombre);

SELECT pago_id, alumno_id, mes, estado, importe
INTO #pagos
FROM (VALUES (100, 1, 'marzo', 'pagado',    150.00),
             (101, 1, 'abril', 'pagado',    150.00),
             (102, 2, 'marzo', 'pendiente', 150.00),
             (103, 3, 'marzo', 'pagado',    120.00)) AS v (pago_id, alumno_id, mes, estado, importe);

SELECT alumno_id, nombre FROM #alumnos;
SELECT pago_id, alumno_id, mes, estado, importe FROM #pagos;
GO


/* ------------------------------------------------------------
   1. Cada pago con el nombre del alumno que lo hizo.
      Esperado: 4 filas (Adriana aparece 2 veces). Darío no sale.
   ------------------------------------------------------------ */



/* ------------------------------------------------------------
   2. TODOS los alumnos con sus pagos, aunque no tengan ninguno.
      Esperado: 5 filas. Darío aparece con NULL en las columnas de pagos.
   ------------------------------------------------------------ */



/* ------------------------------------------------------------
   3. Los alumnos que NO tienen ningún pago registrado.
      Esperado: 1 fila (Darío).
   ------------------------------------------------------------ */



/* ------------------------------------------------------------
   4. Los alumnos que NO tienen ningún pago PAGADO
      (los que no tienen pagos y los que solo tienen pendientes).
      Esperado: 2 filas (Benjamín y Darío).
      Pista: ¿la condición sobre el estado va en el ON o en el WHERE?
   ------------------------------------------------------------ */



/* ------------------------------------------------------------
   5. Haz a propósito el error: escribe el ejercicio 4 con la
      condición del estado en el WHERE. ¿Cuántas filas salen?
      Escribe aquí con tus palabras por qué:
      --
   ------------------------------------------------------------ */



/* ------------------------------------------------------------
   6. Una sola fila con: total de alumnos, alumnos con al menos
      un pago pagado y alumnos sin ningún pago pagado.
      Esperado: 4, 2, 2.
      Pista: LEFT JOIN como en el ejercicio 4, y piensa qué cuenta
      cada COUNT (punto 6 de la hoja).
   ------------------------------------------------------------ */
