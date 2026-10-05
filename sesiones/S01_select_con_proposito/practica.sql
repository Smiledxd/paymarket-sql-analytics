/* ============================================================
   S01 · SELECT con propósito
   Guía: sesiones/S01_select_con_proposito/guia.md
   Pregunta del día: ¿Cuánto ganamos por comisión en las operaciones más grandes?
   ============================================================ */
USE PayMarket_Analitica;
GO


/* ============================================================
   📘 EJEMPLO DE JUGUETE — la librería "El Lector Andino"
   Ejecuta cada consulta y observa el resultado.
   ============================================================ */
DROP TABLE IF EXISTS #libros;

SELECT titulo, autor, categoria, precio, stock
INTO #libros
FROM (VALUES
    ('Cuentos del río',      'Rosa Paredes', 'Cuentos',  35.00, 12),
    ('Poemas de la puna',    'Luis Ccori',   'Poesía',   28.50,  4),
    ('Historias de Tarapoto','Rosa Paredes', 'Cuentos',  35.00,  7),
    ('Cocina de la abuela',  'Ana Salazar',  'Cocina',   59.90,  3),
    ('Versos del mar',       'Luis Ccori',   'Poesía',   22.00, 15),
    ('Pachamanca y más',     'Ana Salazar',  'Cocina',   59.90,  9)
) AS v (titulo, autor, categoria, precio, stock);

-- 1) Columnas elegidas, alias y cálculo: valor del inventario y precio con 10 % de descuento
SELECT titulo,
       precio * stock  AS valor_inventario,
       precio * 0.90   AS precio_con_descuento
FROM #libros;

-- 2) DISTINCT se aplica a la combinación completa de columnas
SELECT DISTINCT categoria FROM #libros;           -- 3 filas
SELECT DISTINCT categoria, autor FROM #libros;    -- 3 filas: cada categoría tiene un solo autor
SELECT DISTINCT autor, precio FROM #libros;       -- ¿cuántas? cuéntalas antes de ejecutar

-- 3) TOP con ORDER BY: hay dos libros de 59.90 y dos de 35.00
SELECT TOP (3) titulo, precio
FROM #libros
ORDER BY precio DESC;                 -- el tercer puesto está empatado: ¿cuál entra?

SELECT TOP (3) titulo, precio
FROM #libros
ORDER BY precio DESC, titulo ASC;     -- con desempate, el resultado siempre es el mismo

-- 4) Varias columnas de orden, cada una con su dirección
SELECT categoria, titulo, stock
FROM #libros
ORDER BY categoria ASC, stock DESC;
GO


/* ============================================================
   ✍️ EJERCICIO 1 — Combinaciones de estado y código de respuesta
   El nuevo jefe de operaciones quiere entender cómo se registran
   los pagos: qué combinaciones de estado y código de respuesta
   existen en la tabla de transacciones.

   Qué lograr: una fila por cada combinación distinta, con las
   columnas estado y codigo_respuesta.

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Una lista. Una fila = una combinación distinta (estado, código).
   -- 2. ¿Dónde está? Tabla core.transaccion (una fila = un intento de pago).
   -- 3. ¿Qué filas? Todas.
   -- 4. ¿Resumir? No se cuenta nada, pero hay que quitar repetidos: ______
   -- 5. ¿Qué muestro? ______
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí (termina tu SELECT con INTO #respuesta antes del FROM)
SELECT DISTINCT
    estado,
    codigo_respuesta
INTO #respuesta
FROM core.transaccion

ORDER BY estado ASC, codigo_respuesta DESC

EXEC chk.s01_e1;
GO
/* Para pensar: hay operaciones "Extornada" con código 00. ¿Por qué una
   operación revertida tendría el código de "aprobada"? (mira el diccionario) */


/* ============================================================
   ✍️ EJERCICIO 2 — Los 10 comercios con la tasa más alta
   El equipo comercial revisa qué comercios pagan la comisión más
   alta, porque son los primeros que podría perder frente a la
   competencia.

   Qué lograr: los 10 comercios con mayor tasa_mdr. Si hay empate
   en la tasa, entra primero el de nombre_comercial alfabéticamente
   menor (A→Z). Columnas:
     comercio_id, nombre_comercial, tasa_pct (la tasa en porcentaje: 4.50, no 0.0450)

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Un top 10. Una fila = un comercio.
   -- 2. ¿Dónde está? Tabla core.comercio (una fila = un comercio).
   -- 3. ¿Qué filas? Todas compiten.
   -- 4. ¿Resumir? No.
   -- 5. ¿Qué muestro y en qué orden? ______ (no olvides el desempate)
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí
SELECT
    TOP 10
    comercio_id,
    nombre_comercial,
    tasa_mdr * 100 AS tasa_pct
--INTO #respuesta
FROM core.comercio
ORDER BY tasa_pct DESC, nombre_comercial ASC

EXEC chk.s01_e2;
GO
/* Para pensar: ¿qué tipo de comercios pagan la tasa más alta? ¿Por qué
   un comercio pequeño pagaría más que una cadena grande? */


/* ============================================================
   ✍️ EJERCICIO 3 — Comisión e IGV de las operaciones más grandes
   Finanzas quiere ver cuánto nos dejan las operaciones más grandes
   en soles, y cuánto de eso es IGV que hay que pagar a SUNAT.

   Qué lograr: las 20 operaciones APROBADAS en SOLES de mayor monto
   (si empatan en monto, primero el transaccion_id menor). Columnas:
     transaccion_id, monto, comision,
     igv_comision      (18 % de la comisión),
     comision_con_igv  (comisión + su IGV)

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Un top 20. Una fila = una operación.
   -- 2. ¿Dónde está? Tabla core.transaccion.
   -- 3. ¿Qué filas? ______
   -- 4. ¿Resumir? No.
   -- 5. ¿Qué muestro y en qué orden? ______
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí
SELECT
    TOP 20
    transaccion_id,
    monto,
    comision,
    comision * 0.18 AS igv_comision,
    comision + (comision * 0.18) AS comision_con_igv
--INTO #respuesta
FROM core.transaccion
WHERE
    moneda = 'PEN' AND estado = 'Aprobada'
ORDER BY monto DESC, transaccion_id ASC
EXEC chk.s01_e3;
GO
/* Para pensar: dos operaciones de casi el mismo monto pueden dejar
   comisiones muy distintas. ¿De qué depende? */


/* ============================================================
   ✍️ EJERCICIO 4 — Los créditos más grandes
   El comité de riesgos revisa los microcréditos de mayor monto.

   Qué lograr: los 15 créditos de mayor monto (si empatan en monto,
   primero el credito_id menor). Columnas:
     credito_id, monto, plazo_meses,
     tea_pct          (la TEA en porcentaje: 65.00, no 0.6500),
     capital_por_mes  (monto dividido entre el número de cuotas)

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Un top 15. Una fila = un crédito.
   -- 2. ¿Dónde está? ______
   -- 3. ¿Qué filas? Todos compiten.
   -- 4. ¿Resumir? No.
   -- 5. ¿Qué muestro y en qué orden? ______
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí
SELECT TOP 15
    credito_id,
    monto,
    plazo_meses,
    tea * 100 AS tea_pct,
    monto / plazo_meses AS capital_por_mes
--INTO #respuesta
FROM core.credito
ORDER BY
    monto DESC,
    credito_id ASC
EXEC chk.s01_e4;
GO
/* Para pensar: capital_por_mes no es la cuota que paga el cliente.
   ¿Qué le falta? (mira la tabla core.cuota en el diccionario) */


/* ============================================================
   🏋️ RETO FINAL — ¿Cuánto ganamos en las operaciones en dólares más grandes?
   La gerencia quiere comparar: además de las operaciones en soles,
   quiere ver las 10 operaciones APROBADAS en DÓLARES de mayor monto
   (si empatan, primero el transaccion_id menor). Columnas:
     transaccion_id, comercio_id, monto, comision,
     igv_comision  (18 % de la comisión),
     pct_comision  (la comisión como porcentaje del monto: 3.25, no 0.0325)

   FICHA DE TRADUCCIÓN (esta vez con más huecos)
   -- 1. ¿Qué me piden? las 10 filas operaciones APROBADAS EN DOLARES, de mayor monto
   -- 2. ¿Dónde está? core.transaccion
   -- 3. ¿Qué filas? ______
   -- 4. ¿Resumir? No.
   -- 5. ¿Qué muestro y en qué orden? ______
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí
SELECT TOP 10
    transaccion_id,
    comercio_id,
    monto,
    comision,
    comision * 0.18 AS igv_comision,
    (comision/ monto) *100 AS pct_comision
--INTO #respuesta
FROM core.transaccion
WHERE
    moneda != 'PEN' AND estado = 'Aprobada'
ORDER BY
    monto DESC,
    transaccion_id ASC

EXEC chk.s01_reto;
GO


/* ============================================================
   💬 PREGUNTAS DE NEGOCIO PARA REFLEXIONAR (responde aquí mismo)

   1. En el reto, ¿pct_comision es igual en las 10 operaciones?
      ¿Qué te dice eso sobre dónde gana más PayMarket?
      Respuesta:
      No son iguales, el pct_comision es una parte del monto.
      gana más dependiendo del pct_comision que en ves de ver el numero de comision

   2. Las operaciones más grandes, ¿son las que más comisión dejan?
      ¿Qué otra lista le mostrarías a finanzas?
      Respuesta:
      si al parecer, la lista de soles
   3. Esos montos están en dólares. ¿Qué te faltaría para sumarlos
      con los de soles en un solo reporte?
      Respuesta:
      una conversion de dolares a soles o viceversa
   Tu avance: ;
   ============================================================ */
   EXEC chk.ver_progreso 'S01'