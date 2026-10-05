# S01 · SELECT con propósito

> **Pregunta de negocio del día:** ¿Cuánto ganamos por comisión en las operaciones más grandes?

| | |
|---|---|
| **Duración** | 60 minutos |
| **Antes de empezar** | Haber terminado S00: saber qué es una fila en `transaccion`, `comercio` y `credito`, y cómo funciona `INTO #respuesta` |
| **Archivos** | Esta guía + [practica.sql](practica.sql) |

**Objetivos**
1. Elegir columnas con intención y ponerles alias claros.
2. Calcular columnas nuevas: porcentajes, comisión, IGV de la comisión.
3. Quitar repetidos con `DISTINCT` (y entender qué hace con varias columnas).
4. Obtener un "top N" correcto con `TOP` + `ORDER BY` + desempate.
5. Ordenar por varias columnas.

**Plan de la sesión**

| Minutos | Qué haces |
|---|---|
| 0–10 | Conceptos y ejemplos de juguete |
| 10–45 | Ejercicios 1 a 4 |
| 45–55 | Reto final |
| 55–60 | Cierre y commit |

---

## 📘 Conceptos

### 1. Cada columna del SELECT es una decisión

Un analista no pide "todo": pide lo que responde la pregunta. `SELECT *` sirve para mirar una tabla por primera vez, pero en una respuesta final trae columnas que nadie pidió, se rompe si alguien agrega una columna a la tabla y esconde qué dato usaste. **En este curso, ninguna respuesta final lleva `SELECT *`.**

### 2. Alias: el nombre que verá quien lea tu resultado

`AS` le pone nombre a una columna: `precio * cantidad AS venta_total`. Usa nombres en minúsculas y con guion bajo (`snake_case`), que digan qué es el dato. Una columna calculada **sin alias** no tiene nombre, y `SELECT ... INTO` no puede crear una tabla con una columna sin nombre (error 1038).

### 3. Columnas calculadas: la tabla no tiene todo, pero tiene con qué calcularlo

Puedes sumar, restar, multiplicar y dividir columnas y números en el `SELECT`. En PayMarket:

- `tasa_mdr` está guardada como **fracción**: `0.0350`. Para leerla como porcentaje (3.50 %), multiplícala por 100.
- La `comision` se guarda **sin IGV**. El IGV peruano es el 18 %, así que el IGV de la comisión es la comisión por `0.18`. Escribir `* 18` en lugar de `* 0.18` es un error clásico: multiplica por dieciocho, no por el dieciocho por ciento.

Cuidado con el tipo de dato: si divides dos **enteros**, SQL Server devuelve un entero (`7 / 2` da `3`). Si uno de los dos es decimal, el resultado es decimal (`7 / 2.0` da `3.5`). Lo verás a fondo en S05.

### 4. DISTINCT: quita filas repetidas, no valores repetidos

`DISTINCT` se aplica a la **fila completa** del `SELECT`, no a la primera columna. `SELECT DISTINCT categoria, autor` devuelve cada **combinación** distinta de categoría y autor. Es útil para conocer los valores posibles de una columna antes de filtrar ("¿qué estados existen?").

### 5. TOP con ORDER BY, y siempre con desempate

`TOP (10)` corta el resultado después de 10 filas. Sin `ORDER BY`, esas 10 filas son **las que SQL Server encuentre primero**, que no tienen por qué ser las más grandes, y pueden cambiar de una ejecución a otra.

Aun con `ORDER BY`, si hay **empates** en el límite (el décimo y el undécimo tienen el mismo valor), cuál entra también es arbitrario. La solución es un **desempate**: una segunda columna en el `ORDER BY` que decida. Regla del curso: **`TOP` siempre con `ORDER BY`, y con desempate si puede haber empates.**

### 6. Ordenar por varias columnas

`ORDER BY categoria ASC, precio DESC` ordena primero por categoría (A→Z) y, **dentro** de cada categoría, por precio de mayor a menor. `ASC` es el valor por defecto; `DESC` invierte el orden. Cada columna lleva su propia dirección.

---

## 💡 Pistas

### Ejercicio 1 · Combinaciones de estado y código de respuesta

<details><summary>Pista 1</summary>

Paso 1: una fila = una **combinación** distinta de estado y código. No te piden contar nada, solo listar.
</details>

<details><summary>Pista 2</summary>

`DISTINCT` con las dos columnas en el mismo `SELECT`.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT ____ estado, ____
INTO #respuesta
FROM ____;
```
</details>

### Ejercicio 2 · Los 10 comercios con la tasa más alta

<details><summary>Pista 1</summary>

Paso 5: es un "top 10", así que necesitas ordenar de mayor a menor tasa. Y hay muchos comercios con la misma tasa: el enunciado dice cómo desempatar.
</details>

<details><summary>Pista 2</summary>

`TOP (10)` + `ORDER BY` con dos columnas: la tasa (descendente) y el nombre (ascendente). La tasa en porcentaje es una columna calculada con alias.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT TOP (10) comercio_id, nombre_comercial, ____ AS tasa_pct
INTO #respuesta
FROM core.comercio
ORDER BY ____ DESC, ____ ASC;
```
</details>

### Ejercicio 3 · Comisión e IGV de las operaciones más grandes

<details><summary>Pista 1</summary>

Paso 3: no todas las operaciones sirven. ¿Una operación rechazada o extornada nos dejó comisión? ¿Y el enunciado habla de soles o de dólares?
</details>

<details><summary>Pista 2</summary>

Filtra con `WHERE` por `estado` y por `moneda`. Luego `TOP (20)` con `ORDER BY` por monto y desempate. El IGV y la comisión con IGV son dos columnas calculadas a partir de `comision`.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT TOP (20) transaccion_id, monto, comision,
       comision * ____ AS igv_comision,
       ____ AS comision_con_igv
INTO #respuesta
FROM core.transaccion
WHERE ____ AND ____
ORDER BY ____, ____;
```
</details>

### Ejercicio 4 · Los créditos más grandes

<details><summary>Pista 1</summary>

Muchos créditos tienen exactamente el mismo monto (son montos redondos). El desempate decide quién entra al top 15.
</details>

<details><summary>Pista 2</summary>

`tea` es una fracción, igual que la tasa del ejercicio 2. `capital_por_mes` es el monto dividido entre el número de cuotas (`plazo_meses`).
</details>

<details><summary>Pista 3</summary>

```sql
SELECT TOP (15) credito_id, monto, plazo_meses,
       ____ AS tea_pct,
       ____ / ____ AS capital_por_mes
INTO #respuesta
FROM core.credito
ORDER BY ____;
```
</details>

### 🏋️ Reto final · Operaciones en dólares más grandes

<details><summary>Pista 1</summary>

Es parecido al ejercicio 3, pero cambian la moneda, el tamaño del top y una columna nueva: la comisión como porcentaje del monto.
</details>

<details><summary>Pista 2</summary>

Porcentaje de A sobre B = A dividido entre B, por 100. Aquí A es la comisión y B el monto.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT TOP (10) transaccion_id, comercio_id, monto, comision,
       ____ AS igv_comision,
       ____ AS pct_comision
INTO #respuesta
FROM core.transaccion
WHERE ____
ORDER BY ____;
```
</details>

---

## ⚠️ Errores comunes

1. **`Msg 1038 — An object or column name is missing or empty. For SELECT INTO statements, verify each column has a name.`**
   Tienes una columna calculada sin alias (`comision * 0.18` sin `AS ...`). Con `INTO`, cada columna necesita nombre.

2. **`Msg 207 — Invalid column name 'tasa_pct'.`**
   Usaste un alias en el `WHERE` (que se procesa antes del `SELECT`) o escribiste mal el nombre de una columna. Revisa el orden lógico de S00 y el diccionario de datos.

3. **`Msg 156 — Incorrect syntax near the keyword 'FROM'.`** (o `'INTO'`)
   Casi siempre es una coma de más al final de la lista de columnas, justo antes de `INTO` o `FROM`.

---

## 🚀 Nivel pro (opcional)

1. `TOP (10) WITH TIES` devuelve las 10 primeras **más todas las que empaten con la décima**. Pruébalo en el ejemplo de juguete de la librería y piensa: ¿en qué pregunta de negocio sería más justo que un desempate arbitrario?
2. `OFFSET ... ROWS FETCH NEXT ... ROWS ONLY` permite pedir "la página 2" de un resultado ordenado. Busca la sintaxis y úsala para ver los comercios del puesto 11 al 20 por tasa.

---

## 🧱 Avance del proyecto

En [proyecto/consultas.sql](../../proyecto/consultas.sql), bajo la **pregunta 2** (qué comercios concentran los ingresos por comisión), escribe una primera consulta exploratoria: los 10 comercios con la **tasa más baja** (los que negociaron las mejores condiciones), con su modalidad y fecha de afiliación.

En [proyecto/hallazgos.md](../../proyecto/hallazgos.md), bajo la misma pregunta, anota en 2 líneas qué observas: ¿qué tienen en común esos comercios? ¿Tiene sentido que paguen menos?

**Por qué lo haría un analista:** la tasa es el "precio" que cobra PayMarket. Antes de medir cuánto deja cada comercio, conviene saber quién paga poco y por qué.

**Cómo debe verse:** una consulta ordenada y comentada, y una observación escrita con tus palabras, sin conclusiones definitivas todavía.

---

## ✅ Cierre

- [x] Puedo explicar por qué no uso `SELECT *` en una respuesta final.
- [x] Puedo calcular un porcentaje y el IGV de una comisión sin confundir `18` con `0.18`.
- [x] Puedo explicar qué hace `DISTINCT` cuando hay dos columnas en el `SELECT`.
- [x] Puedo explicar por qué un `TOP` sin desempate puede dar resultados distintos.
- [x] Puedo ordenar por dos columnas con direcciones distintas.
- [x] Superé los verificadores de la sesión (`EXEC chk.ver_progreso 'S01';`).

```bash
git add .
git commit -m "S01: SELECT con propósito, top de operaciones y comisiones"
```
