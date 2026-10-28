# S09a · UNION y EXISTS

> **Pregunta de negocio del día:** ¿Qué clientes estuvieron activos este mes, y cuáles con crédito dejaron de usar la billetera?

| | |
|---|---|
| **Duración** | 60 minutos |
| **Antes de empezar** | S08. Si todavía te enredan los JOIN, haz primero (otro día) la [hoja de repaso de JOIN](../../guias/repaso_joins.md) con su práctica |
| **Archivos** | Esta guía + [practica.sql](practica.sql) |

S09 se partió en dos para que cada parte quepa en una hora. Esta es la **parte A**: dos herramientas nuevas y **3 ejercicios**. La parte B ([S09b](../S09b_self_join_y_post1/guia.md)) es el self-join, el reto del módulo y el Post 1.

**Objetivos**
1. Apilar dos resultados con `UNION ALL` y `UNION`, y elegir el correcto.
2. Preguntar "¿existe al menos uno?" con `EXISTS` y `NOT EXISTS`.

**Plan de la sesión**

| Minutos | Qué haces |
|---|---|
| 0–5 | Repaso rápido (abajo) |
| 5–20 | Los dos conceptos, cada uno con su ejemplo resuelto en `practica.sql` |
| 20–55 | Ejercicios 1, 2 y 3 |
| 55–60 | Cierre y commit |

---

## 🔁 Repaso de 5 minutos (responde mentalmente)

1. Un `JOIN` pega columnas al costado. Si un cliente tiene 10 operaciones, ¿cuántas veces aparece después del `JOIN`?
2. En un `LEFT JOIN`, ¿qué tienen las columnas de la tabla de la derecha cuando no hay pareja?
3. ¿Dónde va una condición sobre la tabla de la derecha en un `LEFT JOIN`: en el `ON` o en el `WHERE`?

<details><summary>Respuestas</summary>

1. 10 veces. 2. `NULL`. 3. En el `ON` (salvo el `IS NULL` del anti-join, que va en el `WHERE`).
</details>

---

## 📘 Concepto 1 · UNION: poner un resultado debajo del otro

`JOIN` pega columnas **al costado**. `UNION` pone filas **debajo**. Sirve cuando la misma clase de cosa está en dos tablas distintas. Por ejemplo, "movimientos de un cliente" están en dos lugares: sus pagos con la billetera (`transaccion`) y sus pagos de cuotas (`pago_cuota`).

```
SELECT ... FROM tabla_A ...      ← primera parte (aquí van el INTO y los alias)
UNION ALL
SELECT ... FROM tabla_B ...      ← segunda parte (misma cantidad de columnas, mismo orden)
```

**`UNION ALL` o `UNION`:**
- `UNION ALL` apila **todo**, tal cual.
- `UNION` apila y **borra las filas repetidas**.

La pregunta para decidir: **si salen dos filas iguales, ¿son dos cosas distintas o la misma cosa repetida?**
- Dos pagos de S/ 20 el mismo día → son dos pagos → `UNION ALL`.
- Un cliente que aparece en dos listas → es un solo cliente → `UNION`.

👉 En `practica.sql`, el **ejemplo resuelto 1** lo muestra con la ficha completa.

## 📘 Concepto 2 · EXISTS y NOT EXISTS: "¿hay al menos uno?"

A veces no necesitas **ver** los datos de otra tabla, solo saber **si existen**. "Alumnos que no pagaron en marzo" es: alumnos para los que **no existe** un pago de marzo.

```sql
SELECT a.nombre
FROM alumnos AS a
WHERE NOT EXISTS (SELECT 1
                  FROM pagos AS p
                  WHERE p.alumno_id = a.alumno_id      -- ← conecta con el alumno de afuera
                    AND p.mes = 'marzo');
```

Léelo en español: "dame los alumnos para los que NO EXISTE un pago que sea **suyo** y de marzo".

- La línea `p.alumno_id = a.alumno_id` es la que conecta la subconsulta con **cada** alumno de afuera. Si la olvidas, la pregunta pasa a ser "¿existe algún pago de marzo de **cualquier** alumno?", y la respuesta es la misma para todos.
- El `SELECT 1` da igual: `EXISTS` solo mira si hay alguna fila.
- No repite filas: cada alumno sale una vez, aunque tenga diez pagos.
- Hace lo mismo que el anti-join de S08 (`LEFT JOIN` + `IS NULL`), pero se lee casi como la pregunta. Usa el que te resulte más claro.

👉 El **ejemplo resuelto 2** de `practica.sql` lo muestra paso a paso.

---

## 💡 Pistas

### Ejercicio 1 · La línea de tiempo de un cliente

<details><summary>Pista 1</summary>

Son dos consultas apiladas: una para los pagos con la billetera y otra para los pagos de cuotas. Cada una llega al cliente 222 por su propio camino.
</details>

<details><summary>Pista 2</summary>

Parte 1: `transaccion → cuenta` (filtra por cliente, estado y fecha). Parte 2: `pago_cuota → credito` (filtra por cliente y fecha). En cada parte, una columna fija con el texto del tipo. Une con `UNION ALL`: dos pagos iguales son dos pagos.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT CAST(____ AS DATE) AS fecha, 'billetera' AS tipo_movimiento, t.monto
INTO #respuesta
FROM core.transaccion AS t
JOIN ____ ON ____
WHERE ____
UNION ALL
SELECT ____, '____', ____
FROM core.pago_cuota AS p
JOIN ____ ON ____
WHERE ____;
```
</details>

### Ejercicio 2 · Clientes con actividad en junio

<details><summary>Pista 1</summary>

Dos listas de `cliente_id`: los que pagaron con la billetera y los que pagaron una cuota. Un cliente que está en las dos cuenta una sola vez.
</details>

<details><summary>Pista 2</summary>

Cada parte devuelve **solo** `cliente_id`. Como quieres cada cliente una vez, usa el operador que borra repetidos.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT cu.cliente_id
INTO #respuesta
FROM ____
WHERE ____
____
SELECT k.cliente_id
FROM ____
WHERE ____;
```
</details>

### Ejercicio 3 · Clientes con crédito que dejaron de usar la billetera

<details><summary>Pista 1</summary>

Parte de los créditos vigentes y pregunta, para cada uno: ¿**no existe** un pago aprobado con la billetera de ese cliente en mayo? Es la misma forma del ejemplo resuelto 2.
</details>

<details><summary>Pista 2</summary>

`FROM core.credito` + `WHERE estado ... AND NOT EXISTS (...)`. Dentro: `transaccion` unida con `cuenta`, conectada con el cliente de afuera. Un cliente puede tener dos créditos: usa `DISTINCT` afuera.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT DISTINCT k.cliente_id
INTO #respuesta
FROM core.credito AS k
WHERE ____
  AND NOT EXISTS (SELECT 1
                  FROM core.transaccion AS t
                  JOIN core.cuenta AS cu ON ____
                  WHERE cu.cliente_id = ____
                    AND ____);
```
</details>

---

## ⚠️ Errores comunes

1. **`Msg 205 — All queries combined using a UNION ... must have an equal number of expressions in their target lists.`**
   Las dos partes del `UNION` tienen distinta cantidad de columnas. Cuéntalas.

2. **`Msg 156 — Incorrect syntax near the keyword 'UNION'.`**
   Casi siempre hay un `ORDER BY` o un punto y coma al final de la primera parte. El `ORDER BY` va una sola vez, al final de todo.

3. **Sin mensaje de error, pero `NOT EXISTS` devuelve 0 filas (o todas).**
   Falta la línea que conecta la subconsulta con la fila de afuera (`... = k.cliente_id`).

---

## 🧱 Avance del proyecto

Esta vez es corto. En [proyecto/hallazgos.md](../../proyecto/hallazgos.md), bajo la pregunta 4, anota cuántos clientes estuvieron activos en junio de 2026 (ejercicio 2) y qué porcentaje de los 20 mil registrados representan. Nada más: el resto lo harás en S09b.

---

## ✅ Cierre

- [ ] Puedo explicar la diferencia entre `JOIN` (al costado) y `UNION` (debajo).
- [ ] Sé elegir entre `UNION ALL` y `UNION` con la pregunta "¿son dos cosas o la misma repetida?".
- [ ] Puedo leer un `NOT EXISTS` en español y sé qué línea lo conecta con la consulta de afuera.
- [ ] Superé los verificadores `s09_e1`, `s09_e2` y `s09_e3` (`EXEC chk.ver_progreso 'S09';`).

```bash
git add .
```
```bash
git commit -m "S09a: union y exists, clientes activos y créditos sin uso de billetera"
```
