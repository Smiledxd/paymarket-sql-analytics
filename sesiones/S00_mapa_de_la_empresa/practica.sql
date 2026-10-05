/* ============================================================
   S00 · El mapa de la empresa
   Guía: sesiones/S00_mapa_de_la_empresa/guia.md
   Pregunta del día: ¿Qué información tiene PayMarket y cómo se conecta?

   Cómo usar este archivo:
   - Selecciona un bloque y presiona F5 para ejecutar solo ese bloque.
   - En cada ejercicio escribe tu consulta entre el DROP y el EXEC.
   - Termina tu SELECT con INTO #respuesta justo antes del FROM.
   ============================================================ */
USE PayMarket_Analitica;
GO


/* ============================================================
   📘 EJEMPLO DE JUGUETE 1 — llaves en el cuaderno de la bodega
   Ejecútalo y observa el resultado. Crea dos tablas pequeñas en
   tu zona de pruebas (lab): productos y ventas.
   ============================================================ */
DROP TABLE IF EXISTS lab.bodega_venta;
DROP TABLE IF EXISTS lab.bodega_producto;

CREATE TABLE lab.bodega_producto (
    producto_id  INT          NOT NULL PRIMARY KEY,   -- llave primaria: no se repite
    nombre       VARCHAR(40)  NOT NULL,
    precio       DECIMAL(6,2) NOT NULL                -- dinero: DECIMAL, nunca FLOAT
);

CREATE TABLE lab.bodega_venta (
    venta_id     INT  NOT NULL PRIMARY KEY,
    producto_id  INT  NOT NULL REFERENCES lab.bodega_producto (producto_id),  -- llave foránea
    cantidad     INT  NOT NULL
);

INSERT INTO lab.bodega_producto (producto_id, nombre, precio)
VALUES (1, 'Pan francés', 0.30), (2, 'Leche evaporada', 4.20), (3, 'Gaseosa 500 ml', 2.50);

INSERT INTO lab.bodega_venta (venta_id, producto_id, cantidad)
VALUES (1, 1, 10), (2, 3, 2), (3, 1, 6), (4, 2, 1);

-- Un producto puede aparecer en muchas ventas; cada venta es de un solo producto.
SELECT venta_id, producto_id, cantidad
FROM lab.bodega_venta
ORDER BY producto_id, venta_id;

-- Descomenta la siguiente línea y ejecútala: el producto 99 no existe.
-- Verás el error 547: la llave foránea protege los datos.
-- INSERT INTO lab.bodega_venta (venta_id, producto_id, cantidad) VALUES (5, 99, 1);
GO


/* ============================================================
   📘 EJEMPLO DE JUGUETE 2 — cómo guardar un resultado en #respuesta
   ============================================================ */
DROP TABLE IF EXISTS #respuesta;

SELECT nombre, precio * 12 AS precio_docena
INTO #respuesta                      -- INTO va justo antes del FROM
FROM lab.bodega_producto
WHERE precio < 1;

SELECT nombre, precio_docena FROM #respuesta;   -- #respuesta vive mientras esta ventana esté abierta
GO


/* ============================================================
   📘 EJEMPLO DE JUGUETE 3 — el orden lógico en acción
   ============================================================ */
-- Esto funciona: ORDER BY se procesa DESPUÉS del SELECT, así que ya conoce el alias.
SELECT nombre, precio * 12 AS precio_docena
FROM lab.bodega_producto
ORDER BY precio_docena DESC;

-- Descomenta y ejecuta: falla con "Invalid column name 'precio_docena'",
-- porque WHERE se procesa ANTES del SELECT y el alias todavía no existe.
SELECT nombre, precio * 12 AS precio_docena
FROM lab.bodega_producto
WHERE precio_docena > 10;
GO


/* ============================================================
   ✍️ EJERCICIO 1 — Clientes registrados
   La gerente general va a presentar PayMarket a un inversionista
   y te pide un solo dato: cuántos clientes se han registrado en la
   billetera desde el lanzamiento, sin importar su estado actual.

   Qué lograr: una fila con una columna llamada total_clientes.

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Un número. Tabla de respuesta: 1 fila, 1 columna (total_clientes).
   -- 2. ¿Dónde está? Tabla core.cliente (una fila = un cliente registrado).
   -- 3. ¿Qué filas? ______
   -- 4. ¿Resumir? Sí: contar filas.
   -- 5. ¿Qué muestro? ______
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí (termina tu SELECT con INTO #respuesta antes del FROM)
SELECT top 10 *
--INTO #respuesta
FROM core.cliente

EXEC chk.s00_e1;   -- ✅ o ❌ con el motivo
GO
/* Para pensar: ¿ese número es la cantidad de clientes que usan PayMarket?
   ¿Qué le dirías al inversionista si te pregunta cuántos están activos? */


/* ============================================================
   ✍️ EJERCICIO 2 — Las billeteras de un cliente
   El cliente 876 llamó a la central porque no ve su billetera en
   dólares. Antes de responderle, el asesor necesita ver todas sus
   billeteras y en qué estado están.

   Qué lograr: una fila por billetera del cliente 876, con las
   columnas cuenta_id, moneda, fecha_apertura y estado.

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Las billeteras de un cliente. Una fila = una billetera.
   -- 2. ¿Dónde está? ______ (pista: no es core.cliente)
   -- 3. ¿Qué filas? Solo las del cliente 876. ¿Qué columna guarda al dueño? ______
   -- 4. ¿Resumir? No.
   -- 5. ¿Qué muestro? cuenta_id, moneda, fecha_apertura, estado.
============================================================ */
DROP TABLE IF EXISTS #respuesta;
-- Tu código aquí (termina tu SELECT con INTO #respuesta antes del FROM)
SELECT 
    cuenta_id,
    moneda,
    fecha_apertura,
    estado
--INTO #respuesta
FROM
    core.cuenta
WHERE
    cliente_id = 876
    

EXEC chk.s00_e2;
GO
/* Para pensar: ¿qué le dice el asesor al cliente? ¿Por qué core.cuenta
   tiene la columna cliente_id y core.cliente no tiene cuenta_id? */


/* ============================================================
   ✍️ EJERCICIO 3 — ¿De quién es esta cuenta?
   El área de prevención de fraude vio movimientos raros en la
   cuenta 12345 y quiere saber quién es el titular y dónde vive.

   Qué lograr: una fila con los datos del DUEÑO de la cuenta 12345:
   cliente_id, nombres, apellido_paterno y ubigeo_id.

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Los datos de una persona. 1 fila = el titular.
   -- 2. ¿Dónde está? Primero core.cuenta (para saber quién es) y luego ______
   -- 3. ¿Qué filas? si
   -- 4. ¿Resumir? No.
   -- 5. ¿Qué muestro? cliente_id, nombres, apellido_paterno, ubigeo_id.
============================================================ */
-- Paso A: consulta para averiguar quién es el dueño (no necesita INTO)
SELECT
    *
FROM
    core.cuenta
WHERE
    cuenta_id = 12345

DROP TABLE IF EXISTS #respuesta;
-- Paso B: tu respuesta (termina tu SELECT con INTO #respuesta antes del FROM)
SELECT
    cliente_id,
    nombres,
    apellido_paterno,
    ubigeo_id
--INTO #respuesta
FROM
    core.cliente
WHERE
    cliente_id = 11645

EXEC chk.s00_e3;
GO
/* Para pensar: el número de cuenta y el número de cliente son distintos.
   ¿Qué pasaría en fraude si alguien los confunde? */


/* ============================================================
   🏋️ RETO FINAL — Sigue el rastro de una transacción
   Un cliente reclama por la operación 237390. Para atenderlo, el
   equipo necesita reconstruir la historia completa: por qué canal
   pagó, a qué comercio, de qué rubro es ese comercio y en qué
   distrito vive el cliente.

   Qué lograr: UNA fila con estas columnas:
     transaccion_id, nombre_canal, nombre_comercial,
     descripcion_rubro (la descripción del MCC), distrito_cliente

   FICHA DE TRADUCCIÓN
   -- 1. ¿Qué me piden? Una fila con 5 datos de 5 tablas distintas.
   -- 2. ¿Dónde está? Empieza en core.transaccion. Rama 1: canal.
   --    Rama 2: comercio → ______. Rama 3: cuenta → ______ → ______.
   -- 3. ¿Qué filas? En cada tabla, la fila que corresponde al id que encontraste.
   -- 4. ¿Resumir? No.
   -- 5. ¿Qué muestro? Los 5 valores, con los alias pedidos.
============================================================ */
-- Consultas de exploración (una por salto, sin INTO):
SELECT
      top 1 *
FROM
    core.ubigeo
WHERE
    ubigeo_id = 220910
-- comercio_id = 502 | canal_id = 4** | cuenta_id = 2863 | mcc = 5812 | cliente = 2760 | ubigeo_id = 220901
DROP TABLE IF EXISTS #respuesta;
-- Tu respuesta final (INTO #respuesta)
SELECT
      237390 AS transaccion_id,
      'Pago con QR' AS nombre_canal,
      'Pollería Santa Cruz' AS nombre_comercial,
      'Restaurantes' AS descripcion_rubro,
      'Tarapoto' AS distrito_cliente
INTO #respuesta

EXEC chk.s00_reto;
GO


/* ============================================================
   💬 PREGUNTAS DE NEGOCIO PARA REFLEXIONAR (responde aquí mismo)

   1. El cliente vive en un distrito y pagó en un comercio de otro
      distrito. Si quisieras saber "en qué departamento se vende más",
      ¿usarías el distrito del cliente o el del comercio? ¿Por qué?
      Respuesta:
        del comercio, por la misma pregunta, donde se vende más, además allí compran

   2. La tabla transaccion guarda intentos de pago, no solo pagos
      exitosos. ¿Qué error cometería alguien que cuente todas sus
      filas para reportar "ventas del mes"?
      Respuesta:
        cometeria el error de contar transacciones no concretadas, rechazadas o devueltas

   3. ¿Qué pregunta del negocio NO podrías responder con las tablas
      de core? (piensa en algo que no se guarda)
      Respuesta:
        no lo se

   Tu avance: EXEC chk.ver_progreso 'S00';
   ============================================================ */
   EXEC chk.ver_progreso 'S00'
