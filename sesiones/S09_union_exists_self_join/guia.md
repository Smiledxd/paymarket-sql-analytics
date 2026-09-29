# S09 · UNION, EXISTS y self-join

> **Pregunta de negocio del día:** ¿Los clientes referidos gastan más que los orgánicos?

| | |
|---|---|
| **Duración** | 60 minutos (el Post 1 lo escribes aparte, en otro momento de la semana) |
| **Antes de empezar** | S07 y S08: `JOIN`, `LEFT JOIN`, `ON` vs `WHERE` y `COUNT(DISTINCT)` |
| **Archivos** | Esta guía + [practica.sql](practica.sql) |

**Objetivos**
1. Apilar resultados con `UNION ALL` y `UNION`, y saber cuál elegir.
2. Preguntar "¿existe al menos una fila que…?" con `EXISTS` y `NOT EXISTS`.
3. Unir una tabla consigo misma (self-join) para seguir relaciones dentro de la misma tabla.
4. Cerrar el primer bloque del proyecto con un hallazgo propio y escribir el **Post 1**.

**Plan de la sesión**

| Minutos | Qué haces |
|---|---|
| 0–12 | Conceptos y ejemplos de juguete |
| 12–45 | Ejercicios 1 a 4 |
| 45–55 | Reto final |
| 55–60 | Cierre y commit |

---

## 📘 Conceptos

### 1. JOIN pega columnas; UNION apila filas

Un `JOIN` pone datos **al lado** (más columnas). Un `UNION` pone resultados **uno debajo del otro** (más filas). Sirve cuando la misma clase de cosa está en dos lugares: pagos con la billetera en `transaccion` y pagos de cuotas en `pago_cuota`, por ejemplo.

Reglas:
- Las consultas deben tener **la misma cantidad de columnas**, en el mismo orden y con tipos compatibles.
- Los nombres de las columnas del resultado salen de la **primera** consulta. Ahí van los alias.
- `INTO #tabla` va en la primera consulta; `ORDER BY`, si lo necesitas, va una sola vez al final.
- Puedes agregar columnas fijas para saber de dónde vino cada fila: `'tienda' AS origen`.

### 2. UNION ALL vs UNION

- `UNION ALL` apila todo, tal cual.
- `UNION` apila y además **elimina las filas repetidas** (es como un `DISTINCT` sobre el resultado completo), y por eso es más lento.

¿Cuál usar? Pregúntate si dos filas iguales son **dos cosas distintas** o **la misma cosa repetida**. Dos pagos de S/ 20 el mismo día en el mismo comercio son dos pagos: `UNION ALL`. Un cliente que aparece en las dos listas es un solo cliente: `UNION`.

### 3. EXISTS y NOT EXISTS: "¿hay al menos uno?"

```sql
SELECT a.nombre
FROM alumnos AS a
WHERE NOT EXISTS (SELECT 1
                  FROM pagos AS p
                  WHERE p.alumno_id = a.alumno_id
                    AND p.mes = 'marzo');
```

- La subconsulta se evalúa **para cada fila** de afuera: fíjate en `p.alumno_id = a.alumno_id`, que conecta la subconsulta con el alumno de afuera (se llama subconsulta **correlacionada**). Sin esa condición, la pregunta sería "¿existe algún pago de marzo de cualquier alumno?", y la respuesta sería la misma para todos.
- A `EXISTS` no le importa qué columnas devuelve la subconsulta, solo si devuelve **alguna fila**. Por costumbre se escribe `SELECT 1`.
- `NOT EXISTS` responde lo mismo que el anti-join de S08, pero se lee casi como la pregunta en español. Y, a diferencia de `NOT IN` (S03), no se rompe con los nulos.
- No multiplica filas: el alumno aparece una vez aunque tenga diez pagos.

### 4. Self-join: una tabla que se apunta a sí misma

`core.cliente.cliente_referidor_id` apunta a otra fila de `core.cliente`: el cliente que invitó. Para ver al referido y a su referidor en la misma fila, usas la tabla **dos veces** con dos alias distintos, como si fueran dos tablas:

```sql
FROM empleados AS e                -- el empleado
JOIN empleados AS j ON j.empleado_id = e.jefe_id   -- su jefe (otra copia de la misma tabla)
```

La clave es leer bien el `ON`: la columna "que apunta" (`e.jefe_id`) va contra la llave de la otra copia (`j.empleado_id`). Si lo inviertes, obtienes la relación al revés (los subordinados en lugar del jefe). Los alias con significado (`nuevo`/`referidor`, `e`/`j`) te salvan de confundirte.

---

## 💡 Pistas

### Ejercicio 1 · La línea de tiempo de un cliente

<details><summary>Pista 1</summary>

Son dos consultas apiladas: una para los pagos con la billetera y otra para los pagos de cuotas. Cada una necesita llegar hasta el cliente 222 por su propio camino.
</details>

<details><summary>Pista 2</summary>

Parte 1: `transaccion → cuenta` (filtra por cliente, estado y fecha). Parte 2: `pago_cuota → credito` (filtra por cliente y fecha). Una columna fija con el texto del tipo en cada parte. Une con `UNION ALL`.
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

Dos listas de `cliente_id` (los que pagaron con la billetera y los que pagaron una cuota). Un cliente que está en las dos cuenta una vez.
</details>

<details><summary>Pista 2</summary>

Cada parte devuelve solo `cliente_id`. Como quieres cada cliente una sola vez, usa el operador que elimina repetidos.
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

Parte de los créditos vigentes y pregunta, para cada uno: ¿**no existe** un pago aprobado con la billetera de ese cliente en mayo?
</details>

<details><summary>Pista 2</summary>

`FROM core.credito` + `WHERE estado ... AND NOT EXISTS (...)`. Dentro: `transaccion` unida con `cuenta`, correlacionada por el cliente. Como un cliente puede tener más de un crédito, usa `DISTINCT` en el `SELECT` de afuera.
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

### Ejercicio 4 · ¿Quién trajo a cada cliente nuevo?

<details><summary>Pista 1</summary>

Necesitas dos copias de `core.cliente`: una para el cliente nuevo y otra para su referidor.
</details>

<details><summary>Pista 2</summary>

El `ON` une la columna que apunta (`cliente_referidor_id` del nuevo) con la llave de la otra copia. El `JOIN` deja fuera a los que no tienen referidor, que es justo lo que quieres.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT n.cliente_id, r.____ AS referidor_id, r.____ AS nombre_referidor,
       DATEDIFF(day, ____, ____) AS dias_desde_alta_referidor
INTO #respuesta
FROM core.cliente AS n
JOIN core.cliente AS r ON r.____ = n.____
WHERE ____;
```
</details>

### 🏋️ Reto final · ¿Los clientes referidos gastan más que los orgánicos?

<details><summary>Pista 1</summary>

Es como el ejercicio 2 de S08: todos los clientes deben quedarse, pagaran o no. Además necesitas la facturación de los que sí pagaron.
</details>

<details><summary>Pista 2</summary>

`cliente → cuenta` con `JOIN`, y `LEFT JOIN` a `transaccion` con las condiciones del pago en el `ON`. `SUM(t.monto)` ignora los `NULL`. El gasto por cliente se divide entre los clientes **con** pago.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT cl.canal_adquisicion,
       COUNT(DISTINCT ____) AS clientes,
       COUNT(DISTINCT CASE WHEN ____ THEN ____ END) AS clientes_con_pago,
       SUM(t.monto) AS facturacion,
       SUM(t.monto) / ____ AS gasto_por_cliente_con_pago
INTO #respuesta
FROM core.cliente AS cl
JOIN ____ ON ____
LEFT JOIN core.transaccion AS t ON ____ AND ____ AND ____
WHERE ____
GROUP BY ____;
```
</details>

---

## ⚠️ Errores comunes

1. **`Msg 205 — All queries combined using a UNION, INTERSECT or EXCEPT operator must have an equal number of expressions in their target lists.`**
   Las dos partes del `UNION` tienen distinta cantidad de columnas. Cuéntalas.

2. **`Msg 156 — Incorrect syntax near the keyword 'UNION'.`**
   Casi siempre hay un `ORDER BY` (o un punto y coma) en la primera parte. El `ORDER BY` va una sola vez, al final de todo.

3. **`Msg 1013 — The objects "core.cliente" and "core.cliente" in the FROM clause have the same exposed names. Use correlation names to distinguish them.`**
   En un self-join cada copia necesita su propio alias.

---

## 🚀 Nivel pro (opcional)

1. `INTERSECT` devuelve las filas que están en las dos consultas y `EXCEPT` las que están en la primera y no en la segunda. Reescribe el ejercicio 3 con `EXCEPT` y comprueba que da lo mismo. ¿Cuál se entiende mejor?
2. Con un self-join, encuentra a los referidores que a su vez fueron referidos por otro cliente: una "cadena" de tres personas. ¿Cuántas cadenas hay?

---

## 🧱 Avance del proyecto

En [proyecto/consultas.sql](../../proyecto/consultas.sql), bajo la **pregunta 4**, agrega tu versión del reto, ampliada con una comparación en el tiempo: para cada canal de adquisición, qué porcentaje de los clientes registrados en 2025 **todavía** tuvo una operación aprobada en el primer semestre de 2026.

En [proyecto/hallazgos.md](../../proyecto/hallazgos.md), bajo la pregunta 4, escribe tu primer hallazgo completo: qué encontraste (con números), qué recomendarías a marketing y cómo medirías si la recomendación funcionó.

**Por qué lo haría un analista:** la pregunta "¿qué canal de adquisición funciona mejor?" decide en qué se gasta el presupuesto de marketing. Responderla con datos es exactamente el trabajo que se espera de un practicante.

**Cómo debe verse:** una consulta comentada y un hallazgo de 4 a 6 líneas con sus números.

---

## 📣 Post 1 de LinkedIn

Terminaste el primer bloque del curso. Escribe **tú** un post corto (no se lo pidas a una IA: tiene que sonar a ti). Puedes pedirme que revise la redacción cuando lo tengas.

**Qué debe tener:**
1. **Qué estás haciendo:** un proyecto de SQL sobre una fintech de pagos **simulada**, con datos inventados (dilo explícitamente).
2. **Qué aprendiste en esta etapa:** una o dos cosas concretas, por ejemplo la diferencia entre `INNER JOIN` y `LEFT JOIN`, o por qué una condición en el `WHERE` cambia el resultado de un `LEFT JOIN`.
3. **Un hallazgo con su número:** el de tu reto o tu proyecto, por ejemplo cómo se compara el gasto de los clientes referidos con el de los orgánicos. Solo cifras que calculaste tú.
4. **Una captura:** tu consulta en SSMS con su resultado, o una tabla limpia.
5. **Un cierre honesto:** qué viene después (subconsultas y funciones de ventana) o una pregunta para quien lee.

**Qué evitar:** "dominé SQL", "soy experto", "análisis de alto impacto", cifras que no calculaste, o presentar los datos como si fueran reales. Frases como "estoy aprendiendo", "me sorprendió que…" o "me equivoqué en… y aprendí que…" funcionan mejor.

**Largo sugerido:** 8 a 12 líneas. Guarda el texto final en `proyecto/posts/post1.md` y la captura en `proyecto/posts/`.

---

## ✅ Cierre

- [ ] Puedo explicar la diferencia entre `JOIN` y `UNION`, y entre `UNION` y `UNION ALL`.
- [ ] Puedo escribir un `NOT EXISTS` correlacionado y explicar qué hace la condición que lo conecta con la consulta de afuera.
- [ ] Puedo escribir un self-join con alias claros y leer en qué dirección va la relación.
- [ ] Escribí mi primer hallazgo completo en `hallazgos.md`.
- [ ] Superé los verificadores de la sesión (`EXEC chk.ver_progreso 'S09';`).
- [ ] Publiqué (o dejé listo) el Post 1.

Terminaste el módulo 3. Marca las sesiones en [CURRICULA.md](../../CURRICULA.md) y haz tu commit:

```bash
git add .
git commit -m "S09: union, exists y self-join; referidos vs orgánicos y Post 1"
```
