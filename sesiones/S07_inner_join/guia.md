# S07 · INNER JOIN

> **Pregunta de negocio del día:** ¿Qué rubros y departamentos facturan más?

| | |
|---|---|
| **Duración** | 60 minutos |
| **Antes de empezar** | S05 y S06: `GROUP BY`, `COUNT(DISTINCT)` y `CASE`. Tener a mano el diagrama de [base/diccionario_datos.md](../../base/diccionario_datos.md) |
| **Archivos** | Esta guía + [practica.sql](practica.sql) |

**Objetivos**
1. Explicar por qué los datos se guardan separados en varias tablas.
2. Unir 2, 3 y 4 tablas con `INNER JOIN` siguiendo las llaves del diagrama.
3. Usar alias de tabla para escribir y leer joins sin confusión.
4. Unir por algo que no es una llave foránea: la fecha con `tipo_cambio`, para pasar dólares a soles.

**Desde esta sesión la ficha de traducción viene vacía:** solo están las 5 preguntas y tú las respondes en comentarios antes de escribir la consulta. No te la saltes: es tu herramienta para no quedarte en blanco.

**Plan de la sesión**

| Minutos | Qué haces |
|---|---|
| 0–12 | Conceptos y ejemplos de juguete |
| 12–45 | Ejercicios 1 a 4 |
| 45–55 | Reto final |
| 55–60 | Cierre y commit |

---

## 📘 Conceptos

### 1. Por qué los datos viven en tablas separadas

Si cada operación guardara el nombre del comercio, su rubro, su distrito y su departamento, esos textos se repetirían cientos de miles de veces. Y si un comercio cambia de nombre, habría que corregirlo en todas sus operaciones (y alguna quedaría sin corregir). Por eso cada cosa se guarda **una sola vez** en su tabla, y las demás tablas la **referencian** con su llave (S00). El precio es que, para responder preguntas, hay que volver a juntar las tablas: eso es un `JOIN`.

### 2. INNER JOIN: juntar filas que tienen pareja

```sql
SELECT l.titulo, a.nombre
FROM libros AS l
JOIN autores AS a ON a.autor_id = l.autor_id;
```

- `JOIN` (o `INNER JOIN`, es lo mismo) pega a cada fila de `libros` la fila de `autores` cuyo `autor_id` coincide.
- `ON` dice **por qué columnas** se emparejan. Casi siempre es la llave foránea de una tabla contra la llave primaria de la otra: en el diagrama, es la línea que las une.
- Las filas **sin pareja** desaparecen del resultado. En `core` eso casi no pasa, porque las llaves foráneas garantizan que cada operación tiene su cuenta y su comercio. En S08 verás qué hacer cuando sí importa.
- Después del `JOIN`, la tabla resultante tiene **una fila por cada fila de la tabla "muchos"**: si unes operaciones con comercios, sigues teniendo una fila por operación, ahora con los datos de su comercio al lado.

### 3. Alias de tabla y columnas ambiguas

`FROM core.transaccion AS t` te deja escribir `t.monto` en lugar de `core.transaccion.monto`. Cuando dos tablas tienen una columna con el mismo nombre (`estado` está en `transaccion`, `cliente`, `cuenta` y `comercio`), **tienes que** decir de cuál hablas: `t.estado`. Buena práctica: prefija **todas** las columnas con su alias, aunque no sean ambiguas. Así quien lee sabe de dónde sale cada dato.

### 4. Unir 3 o 4 tablas: seguir el camino del diagrama

Cada `JOIN` agrega un salto. Para llegar desde una operación hasta el departamento del cliente, el camino es `transaccion → cuenta → cliente → ubigeo`: tres `JOIN`, cada uno con su `ON`. Antes de escribir, **dibuja el camino** con flechas en el paso 2 de la ficha. Si te saltas una tabla (por ejemplo, unir `transaccion` directo con `cliente`), no hay columna común correcta, y cualquier `ON` que inventes dará un resultado sin sentido, sin mensaje de error.

Hay dos caminos distintos hacia `ubigeo`: por el cliente (dónde vive quien paga) y por el comercio (dónde está registrado quien cobra). Responden preguntas distintas: elige según lo que pida el enunciado.

### 5. Unir por fecha: dólares a soles

`tipo_cambio` no tiene llave foránea hacia `transaccion`: se une por la **fecha**. Como `fecha_hora` tiene hora y `tipo_cambio.fecha` no, hay que quitarle la hora: `ON tc.fecha = CAST(t.fecha_hora AS DATE)`.

Regla de negocio (diccionario, regla 5): un monto en dólares se pasa a soles multiplicándolo por el tipo de cambio de **compra** del día. Los montos en soles ya están en soles: si los multiplicas también, los inflas. Un `CASE` decide qué hacer según la moneda de cada fila.

---

## 💡 Pistas

### Ejercicio 1 · Facturación presencial y online

<details><summary>Pista 1</summary>

La modalidad no está en `transaccion`: está en `comercio`. ¿Qué columna tienen en común?
</details>

<details><summary>Pista 2</summary>

`JOIN core.comercio` con `ON` por `comercio_id`, filtros en el `WHERE` y `GROUP BY` por la modalidad.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT c.____, COUNT(*) AS operaciones, SUM(t.____) AS facturacion
INTO #respuesta
FROM core.transaccion AS t
JOIN core.comercio AS c ON c.____ = t.____
WHERE ____
GROUP BY ____;
```
</details>

### Ejercicio 2 · Facturación y comisión por grupo de rubro

<details><summary>Pista 1</summary>

El grupo está dos saltos más allá de la operación: `transaccion → comercio → rubro_mcc`.
</details>

<details><summary>Pista 2</summary>

Dos `JOIN`: el primero por `comercio_id`, el segundo por `mcc`. Agrupa por `grupo` (no por `descripcion`: esa es más detallada).
</details>

<details><summary>Pista 3</summary>

```sql
FROM core.transaccion AS t
JOIN core.comercio AS c ON ____
JOIN core.rubro_mcc AS r ON ____
WHERE ____
GROUP BY ____
```
</details>

### Ejercicio 3 · Clientes y facturación por departamento del cliente

<details><summary>Pista 1</summary>

Camino: `transaccion → cuenta → cliente → ubigeo`. Y recuerda que después de unir hay una fila por operación, no por cliente.
</details>

<details><summary>Pista 2</summary>

Tres `JOIN`. Para contar clientes usa `COUNT(DISTINCT ...)` sobre el identificador del cliente.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT u.departamento, COUNT(____ cl.cliente_id) AS clientes, SUM(t.monto) AS facturacion
INTO #respuesta
FROM core.transaccion AS t
JOIN core.cuenta AS cu ON ____
JOIN core.cliente AS cl ON ____
JOIN core.ubigeo AS u ON ____
WHERE ____
GROUP BY ____;
```
</details>

### Ejercicio 4 · Dólares a soles con el tipo de cambio del día

<details><summary>Pista 1</summary>

Une cada operación con el tipo de cambio **de su día**. Solo las operaciones en dólares se convierten.
</details>

<details><summary>Pista 2</summary>

`JOIN core.tipo_cambio` con `ON` entre `fecha` y la fecha sin hora de la operación. Dentro del `SUM`, un `CASE` según la moneda.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT t.moneda, COUNT(*) AS operaciones, SUM(t.monto) AS facturacion_original,
       SUM(CASE WHEN ____ THEN t.monto * tc.____ ELSE ____ END) AS facturacion_soles
INTO #respuesta
FROM core.transaccion AS t
JOIN core.tipo_cambio AS tc ON tc.fecha = ____(t.fecha_hora AS DATE)
WHERE ____
GROUP BY ____;
```
</details>

### 🏋️ Reto final · ¿Qué rubros y departamentos facturan más?

<details><summary>Pista 1</summary>

Junta los tres caminos de hoy en una consulta: hacia el rubro (por el comercio), hacia el departamento (por el cliente) y hacia el tipo de cambio (por la fecha).
</details>

<details><summary>Pista 2</summary>

Seis `JOIN` a partir de `transaccion`. Agrupa por dos columnas y termina con `TOP (10)` y un `ORDER BY` con desempate por las dos.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT TOP (10) u.departamento, r.grupo,
       SUM(CASE WHEN ____ THEN ____ ELSE ____ END) AS facturacion_soles
INTO #respuesta
FROM core.transaccion AS t
JOIN core.tipo_cambio AS tc ON ____
JOIN core.comercio AS c ON ____
JOIN core.rubro_mcc AS r ON ____
JOIN core.cuenta AS cu ON ____
JOIN core.cliente AS cl ON ____
JOIN core.ubigeo AS u ON ____
WHERE ____
GROUP BY ____, ____
ORDER BY ____ DESC, ____, ____;
```
</details>

---

## ⚠️ Errores comunes

1. **`Msg 209 — Ambiguous column name 'estado'.`**
   Esa columna existe en dos de las tablas que uniste. Escribe el alias delante: `t.estado`.

2. **`Msg 4104 — The multi-part identifier "c.mcc" could not be bound.`**
   Usaste un alias que no existe en el `FROM` (o está mal escrito), o usaste el nombre completo de la tabla después de ponerle alias. Revisa que cada alias esté definido una vez en un `JOIN`.

3. **Sin mensaje de error, pero los números son absurdos (demasiado grandes, o casi nada).**
   Casi siempre es un `ON` equivocado: unir `cliente_id` con `cuenta_id`, o saltarse una tabla del camino. Revisa cada `ON` contra el diagrama: debe unir una llave foránea con la llave primaria a la que apunta.

---

## 🚀 Nivel pro (opcional)

1. Cuenta las filas de `core.transaccion` del primer semestre de 2026 antes y después de agregar cada `JOIN` del reto. Si el conteo cambia, algo anda mal. ¿Por qué con estas tablas no debería cambiar nunca?
2. El orden de los `JOIN` no cambia el resultado de un `INNER JOIN`. Reordénalos en el reto y compruébalo. Luego activa el plan de ejecución (`Ctrl+M` en SSMS) y mira si SQL Server los ejecuta en el orden en que los escribiste.

---

## 🧱 Avance del proyecto

En [proyecto/consultas.sql](../../proyecto/consultas.sql), bajo la **pregunta 2**, escribe una consulta con la **comisión** (no la facturación) de todo el periodo por grupo de rubro, **convertida a soles**, con el porcentaje que representa cada grupo del total (puedes calcular el total a mano por ahora; en S14 lo harás dentro de la consulta).

En [proyecto/hallazgos.md](../../proyecto/hallazgos.md) anota los tres grupos que más comisión dejan y qué porcentaje suman entre los tres.

**Por qué lo haría un analista:** la facturación dice cuánto dinero pasa por PayMarket; la comisión dice cuánto se queda. Un rubro que factura mucho con tasa baja puede dejar menos que uno más pequeño.

**Cómo debe verse:** una consulta comentada (12 filas) y 2 líneas con los números.

---

## ✅ Cierre

- [x] Puedo explicar por qué los datos se separan en tablas y qué hace un `JOIN`.
- [x] Puedo escribir el camino de joins entre dos tablas mirando el diagrama.
- [x] Uso alias en todas las columnas y sé leer el error de columna ambigua.
- [x] Sé unir por fecha con `tipo_cambio` y convertir solo los montos en dólares.
- [ ] Respondí la ficha de traducción en comentarios antes de escribir cada consulta.
- [x] Superé los verificadores de la sesión (`EXEC chk.ver_progreso 'S07';`).

```bash
git add .
git commit -m "S07: joins, facturación por rubro y departamento en soles"
```
