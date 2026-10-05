# S00 · El mapa de la empresa

> **Pregunta de negocio del día:** ¿Qué información tiene PayMarket y cómo se conecta?

| | |
|---|---|
| **Duración** | 60 minutos |
| **Antes de empezar** | Haber instalado la base siguiendo [SETUP.md](../../SETUP.md). Saber escribir un `SELECT ... FROM ... WHERE` sencillo |
| **Archivos** | Esta guía + [practica.sql](practica.sql) (ábrelo en SSMS) |

**Objetivos**
1. Explicar qué es una base de datos relacional y qué representa "una fila" en cada tabla.
2. Reconocer las capas de PayMarket (`stg`, `core`, `lab`, `dw`, `rpt`, `chk`) y para qué sirve cada una.
3. Identificar llaves primarias y foráneas, y seguir una relación uno a muchos de una tabla a otra.
4. Explorar la base en SSMS sin perderte.
5. Usar la receta de 5 pasos y entender por qué el orden en que se piensa no es el orden en que se escribe.

**Plan de la sesión**

| Minutos | Qué haces |
|---|---|
| 0–15 | Lees los conceptos y ejecutas los ejemplos de juguete |
| 15–25 | Recorres la base en SSMS (concepto 6) |
| 25–45 | Ejercicios 1, 2 y 3 |
| 45–55 | Reto final |
| 55–60 | Cierre y commit |

---

## 📘 Conceptos

### 1. Una base de datos relacional es un conjunto de tablas que se hablan

Piensa en el cuaderno de una bodega: una página para los productos, otra para las ventas del día. En la página de ventas no vuelves a escribir el precio y la descripción de cada producto: escribes "producto 3" y, si necesitas el detalle, vas a la página de productos. Una base relacional hace lo mismo: guarda cada cosa **una sola vez** y la conecta con números de referencia.

La pregunta más importante frente a cualquier tabla es: **¿qué representa una fila?** En PayMarket:

| Tabla | Una fila = |
|---|---|
| `core.cliente` | una persona registrada |
| `core.cuenta` | una billetera (en soles o en dólares) |
| `core.transaccion` | un **intento** de pago, aprobado o no |
| `core.comercio` | un negocio afiliado |

Si no sabes qué es una fila, no sabes qué estás contando. Contar filas de `transaccion` no es contar clientes.

### 2. Capas: de lo crudo a lo listo para decidir

| Esquema | Qué guarda | Tú… |
|---|---|---|
| `stg` | Archivos tal como llegan de sistemas antiguos, sucios a propósito | los limpiarás en S15–S17 |
| `core` | Datos limpios del negocio, con reglas | los consultarás casi siempre |
| `lab` | Tu zona de pruebas | puedes crear y borrar lo que quieras |
| `dw` y `rpt` | Modelo de análisis y vistas para Power BI | los construirás en S18–S20 |
| `chk` | Verificadores | solo los llamarás con `EXEC` |

El nombre completo de una tabla es `esquema.tabla`: `core.cliente`. Si escribes solo `cliente`, SQL Server busca en el esquema por defecto (`dbo`) y no la encuentra.

Esta organización es la misma idea de **bronze, silver y gold** que usan Databricks y Spark: `stg` es bronze (crudo), `core` es silver (limpio), `dw`/`rpt` es gold (listo para el negocio). Lo que aprendas aquí te servirá cuando llegues a esas herramientas.

### 3. Tipos de dato: cada columna guarda una sola clase de cosa

| Tipo | Para qué | Ejemplo en PayMarket |
|---|---|---|
| `INT`, `TINYINT` | Números enteros, identificadores | `cliente_id`, `plazo_meses` |
| `DECIMAL(12,2)` | **Dinero**: 12 dígitos, 2 decimales, sin errores de redondeo | `monto`, `comision` |
| `VARCHAR(n)` / `CHAR(n)` | Texto de largo variable / fijo | `nombres`, `ubigeo_id` |
| `DATE` | Solo fecha | `fecha_alta` |
| `DATETIME2(0)` | Fecha **y hora** | `fecha_hora` de la transacción |

Dos decisiones que parecen raras y no lo son:
- **El dinero nunca va en `FLOAT`.** `FLOAT` guarda aproximaciones: `0.1 + 0.2` puede dar `0.30000000000000004`. En un banco, un céntimo que aparece de la nada es un problema de auditoría.
- **El DNI y el ubigeo son texto, no números.** No se suman ni se promedian, y pueden empezar con cero (`070101` es el Callao). Si fueran números, ese cero desaparecería.

### 4. Llave primaria, llave foránea y relación uno a muchos

- La **llave primaria (PK)** identifica cada fila sin repetirse: `cliente_id` en `core.cliente`.
- La **llave foránea (FK)** es una columna que apunta a la PK de otra tabla: `cliente_id` en `core.cuenta` dice de quién es cada billetera.

Un cliente puede tener varias cuentas, pero cada cuenta tiene un solo dueño: eso es una relación **uno a muchos**. La FK siempre vive en el lado "muchos". Por eso `core.cuenta` tiene `cliente_id` y `core.cliente` no tiene `cuenta_id`: si lo tuviera, ¿dónde pondrías la segunda cuenta?

La FK además **protege** los datos: SQL Server no te deja registrar una venta de un producto que no existe. Lo verás en el ejemplo de juguete.

Un caso especial: `core.cliente.cliente_referidor_id` apunta a la misma tabla `core.cliente` (un cliente invita a otro). Lo usarás en S09.

### 5. Leer el diagrama

Abre [base/diccionario_datos.md](../../base/diccionario_datos.md) en VS Code (vista previa con `Ctrl+Shift+V`) o en GitHub: ahí está el diagrama entidad-relación y la descripción de cada columna. En el diagrama:

- Cada caja es una tabla; `PK` y `FK` marcan las llaves.
- `||--o{` se lee "uno a muchos". El lado con la "patita de gallo" `{` es el lado "muchos".

Ubica el camino de una transacción: `transaccion` → `cuenta` → `cliente` → `ubigeo`. Y el otro lado: `transaccion` → `comercio` → `rubro_mcc`. Lo recorrerás en el reto final.

### 6. Explorar en SSMS (10 minutos, con las manos)

1. En el **Explorador de objetos** (panel izquierdo), abre *Databases → PayMarket_Analitica → Tables*. Verás las tablas con su esquema delante: `core.cliente`, `stg.clientes_legado`…
2. Despliega `core.cuenta → Columns`: cada columna muestra su tipo y si acepta nulos (`null` / `not null`). Las llaves aparecen con un ícono de llave.
3. Despliega `core.cuenta → Keys`: `pk_cuenta` es la primaria; `fk_cuenta_cliente` es la foránea hacia `cliente`.
4. Clic derecho en `core.canal → Select Top 1000 Rows`: SSMS escribe la consulta por ti. Útil para mirar, no para responder.
5. En una ventana de consulta, escribe `core.transaccion`, selecciónalo y presiona `Alt+F1`: verás columnas, tipos y llaves de un solo golpe.
6. Recuerda: `F5` ejecuta **lo que tengas seleccionado**, o todo el archivo si no hay selección. En `practica.sql` selecciona siempre el bloque que quieres ejecutar.

### 7. La receta de 5 pasos y el orden lógico

Cuando te quedes en blanco frente a una pregunta, usa la receta ([guias/receta_5_pasos.md](../../guias/receta_5_pasos.md)):

1. **¿Qué me piden?** Reformúlalo y dibuja la tabla de respuesta: columnas y qué es cada fila.
2. **¿Dónde está la información?** → `FROM`
3. **¿Qué filas sirven?** → `WHERE`
4. **¿Hay que resumir "por algo"?** → `GROUP BY` (y `HAVING` para filtrar el resumen)
5. **¿Qué muestro y en qué orden?** → `SELECT` / `ORDER BY`

El orden de la receta no es casual: **se escribe `SELECT` primero, pero SQL Server procesa primero el `FROM`**. El orden lógico es `FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY`. Quien empieza por el `SELECT` intenta decidir qué mostrar antes de saber de dónde salen los datos, y por eso se queda en blanco.

Una prueba de que ese orden es real: un alias creado en el `SELECT` **no** se puede usar en el `WHERE` (todavía no existe), pero **sí** en el `ORDER BY`. Lo verás en el ejemplo de juguete 3.

### 8. Cómo funcionan los verificadores

Cada ejercicio termina así:

```sql
DROP TABLE IF EXISTS #respuesta;
-- tu consulta, con INTO #respuesta justo antes del FROM
EXEC chk.s00_e1;
```

- `INTO #respuesta` guarda tu resultado en una **tabla temporal** (el `#` indica que es temporal: vive mientras tengas abierta esa ventana de SSMS).
- `EXEC chk.s00_e1` compara tu `#respuesta` con el resultado esperado **sin mostrártelo**: te dice ✅ o ❌ y por qué (faltan columnas, sobran filas, una columna no coincide…).
- Los nombres de las columnas importan: usa exactamente los alias que pide el enunciado. El orden de las filas y de las columnas no importa.
- Si te equivocas, corrige y vuelve a ejecutar el bloque completo, desde el `DROP`.
- Para ver tu avance: `EXEC chk.ver_progreso 'S00';`

---

## 💡 Pistas

Ábrelas en orden y solo si las necesitas. Intenta primero con la ficha de traducción del ejercicio.

### Ejercicio 1 · Clientes registrados

<details><summary>Pista 1</summary>

Paso 1 de la receta: la respuesta es **un solo número**. Una fila, una columna. ¿Qué representa una fila de `core.cliente`?
</details>

<details><summary>Pista 2</summary>

Contar filas es `COUNT(*)`. No hace falta `WHERE`: la gerente quiere a **todos** los registrados, sin importar su estado.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT ____(*) AS ____
INTO #respuesta
FROM ____;
```
</details>

### Ejercicio 2 · Las billeteras de un cliente

<details><summary>Pista 1</summary>

Paso 2: la información de las billeteras está en `core.cuenta`, no en `core.cliente`. ¿Qué columna de `core.cuenta` te dice de quién es cada billetera?
</details>

<details><summary>Pista 2</summary>

Es la llave foránea hacia `cliente`. Filtra con `WHERE` por esa columna, no por `cuenta_id`.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT ____, ____, ____, ____
INTO #respuesta
FROM core.cuenta
WHERE ____ = 876;
```
</details>

### Ejercicio 3 · ¿De quién es esta cuenta?

<details><summary>Pista 1</summary>

Son **dos pasos**. Primero averigua a qué cliente pertenece la cuenta 12345. Después busca a ese cliente.
</details>

<details><summary>Pista 2</summary>

Paso A: una consulta a `core.cuenta` filtrando por `cuenta_id` te da el `cliente_id`. Paso B: una consulta a `core.cliente` filtrando por ese `cliente_id`, con `INTO #respuesta`.
</details>

<details><summary>Pista 3</summary>

```sql
-- Paso A (solo para mirar)
SELECT ____ FROM core.cuenta WHERE ____ = 12345;

-- Paso B (tu respuesta)
SELECT cliente_id, ____, ____, ____
INTO #respuesta
FROM core.cliente
WHERE cliente_id = ____;   -- el número que encontraste en el paso A
```
</details>

### 🏋️ Reto final · Sigue el rastro de una transacción

<details><summary>Pista 1</summary>

Dibuja el camino en el diagrama antes de escribir: desde `transaccion` salen dos ramas. Una va al comercio (y de ahí al rubro); otra va a la cuenta (y de ahí al cliente y a su distrito). Además, el canal está en otra tabla.
</details>

<details><summary>Pista 2</summary>

Haz una consulta pequeña por cada salto, anota el valor que encuentras y úsalo en la siguiente: `transaccion` → `canal`; `transaccion` → `comercio` → `rubro_mcc`; `transaccion` → `cuenta` → `cliente` → `ubigeo`. Aún no necesitas `JOIN` (lo verás en S07).
</details>

<details><summary>Pista 3</summary>

Al final arma una fila con los valores encontrados. Puedes copiarlos de la grilla de resultados:

```sql
SELECT 237390 AS transaccion_id,
       '____' AS nombre_canal,
       '____' AS nombre_comercial,
       '____' AS descripcion_rubro,
       '____' AS distrito_cliente
INTO #respuesta;
```
</details>

---

## ⚠️ Errores comunes

1. **`Msg 208 — Invalid object name 'cliente'.`**
   SQL Server no encuentra la tabla. Casi siempre falta el esquema (`core.`) o estás conectado a otra base: mira la lista desplegable de bases arriba a la izquierda en SSMS, o ejecuta la línea `USE PayMarket_Analitica;` del inicio del archivo.

2. **`Msg 2714 — There is already an object named '#respuesta' in the database.`**
   Ya existe una `#respuesta` de un intento anterior en esa ventana. Ejecuta el bloque completo, incluido el `DROP TABLE IF EXISTS #respuesta;` que va antes de tu consulta.

3. **`Msg 547 — The INSERT statement conflicted with the FOREIGN KEY constraint ...`**
   Intentaste guardar una fila que apunta a algo que no existe (por ejemplo, una venta de un producto que no está registrado). No es un fallo de SQL Server: es la llave foránea protegiendo los datos. Lo provocarás a propósito en el ejemplo de juguete 1.

---

## 🚀 Nivel pro (opcional)

1. Las vistas del sistema `INFORMATION_SCHEMA.COLUMNS` y `sys.foreign_keys` describen la propia base: columnas, tipos y llaves. Busca en la documentación de Microsoft qué columnas tiene cada una y averigua, con una consulta, qué tablas de `core` tienen una llave foránea que apunta a `core.cliente`.
2. Ejecuta `EXEC sp_help 'core.transaccion';` y compara lo que muestra con el diccionario de datos. ¿Qué información da SSMS que el diccionario no da?

---

## 🧱 Avance del proyecto

Abre [proyecto/hallazgos.md](../../proyecto/hallazgos.md) y lee las 7 preguntas del informe para la gerencia. Debajo de cada pregunta, en la línea **Tablas que necesito**, escribe con tus palabras qué tablas de `core` crees que harán falta y por qué (sin código). Por ejemplo, para una pregunta sobre créditos: "credito, cuota y pago_cuota, porque la mora sale de comparar lo que vencía con lo que se pagó".

**Por qué lo haría un analista:** antes de escribir una sola consulta, un analista se asegura de que los datos existen para responder la pregunta. Si falta información, es mejor saberlo el primer día.

**Cómo debe verse:** 7 preguntas, cada una con 1 o 2 líneas de tablas y su razón. Lo revisarás y corregirás a medida que avances.

---

## ✅ Cierre

Marca lo que puedes hacer sin mirar la guía:

- [x] Puedo decir qué representa una fila en `cliente`, `cuenta`, `transaccion` y `comercio`.
- [x] Puedo explicar para qué sirven `stg`, `core` y `lab`, y cómo se parecen a bronze/silver/gold.
- [x] Puedo explicar por qué el dinero va en `DECIMAL` y el DNI en `VARCHAR`.
- [x] Puedo explicar qué es una llave foránea y en qué lado de una relación uno a muchos vive.
- [ ] Puedo recitar la receta de 5 pasos y el orden lógico `FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY`.
- [x] Superé los verificadores de la sesión (`EXEC chk.ver_progreso 'S00';`).

Marca la sesión en [CURRICULA.md](../../CURRICULA.md) y haz tu commit:

```bash
git add .
git commit -m "S00: mapa de la empresa y primeras consultas de exploración"
```
