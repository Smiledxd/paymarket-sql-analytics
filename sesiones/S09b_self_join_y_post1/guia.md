# S09b · Self-join, reto del módulo y Post 1

> **Pregunta de negocio del día:** ¿Los clientes referidos gastan más que los orgánicos?

| | |
|---|---|
| **Duración** | 60 minutos (el Post 1 lo escribes aparte, otro día) |
| **Antes de empezar** | [S09a](../S09a_union_y_exists/guia.md). Ten a mano la [hoja de repaso de JOIN](../../guias/repaso_joins.md): el reto usa sus puntos 5, 6 y 7 |
| **Archivos** | Esta guía + [practica.sql](practica.sql) |

Esta es la **parte B** de S09: un concepto nuevo (self-join), **un ejercicio** y el **reto final** del módulo de JOINs, armado por etapas para que no tengas que escribirlo todo de una vez.

**Objetivos**
1. Unir una tabla consigo misma para seguir una relación dentro de la misma tabla.
2. Construir una consulta con `LEFT JOIN` por etapas, mirando el resultado en cada paso.
3. Cerrar el módulo con un hallazgo propio y escribir el Post 1.

**Plan de la sesión**

| Minutos | Qué haces |
|---|---|
| 0–10 | El concepto, con su ejemplo resuelto en `practica.sql` |
| 10–25 | Ejercicio 4 |
| 25–55 | Reto final, por etapas |
| 55–60 | Cierre y commit |

---

## 📘 Concepto · Self-join: una tabla que se apunta a sí misma

En `core.cliente`, la columna `cliente_referidor_id` guarda el `cliente_id` de **otro cliente**: el que lo invitó. La relación está **dentro de la misma tabla**.

Para ver al cliente nuevo y a su referidor en la misma fila, usas la tabla **dos veces**, con dos alias distintos, como si fueran dos tablas:

```
core.cliente AS n   →  el cliente nuevo         (tiene cliente_referidor_id)
core.cliente AS r   →  el que lo invitó          (otra copia de la misma tabla)
```

El `ON` une "la columna que apunta" con "la llave de la otra copia":

```sql
FROM empleados AS e                                  -- el empleado
JOIN empleados AS j ON j.empleado_id = e.jefe_id     -- su jefe
```

Léelo así: "busca en la copia `j` al empleado cuyo id es el `jefe_id` de `e`". Si lo inviertes (`j.jefe_id = e.empleado_id`), obtienes los **subordinados** en lugar del jefe. Usar alias con significado (`n` de nuevo, `r` de referidor) evita confundirse.

👉 En `practica.sql`, el **ejemplo resuelto** lo muestra con la ficha completa.

---

## 🏋️ Cómo se arma el reto: por etapas

El reto se parece al ejercicio 2 de S08: **todos** los clientes deben quedarse, pagaran o no. No lo escribas de una vez: en `practica.sql` tienes tres etapas con un espacio para cada una.

| Etapa | Qué escribes | Qué revisas antes de seguir |
|---|---|---|
| 1 | Solo los `JOIN` (`cliente → cuenta`, `LEFT JOIN` con `transaccion`) y un `SELECT TOP (20)` de algunas columnas | ¿Aparecen clientes con `NULL` en las columnas de la operación? Si no, el `LEFT JOIN` se rompió |
| 2 | Agrega los filtros: las condiciones del **pago** van en el `ON`; la del **cliente** (alta en 2025), en el `WHERE` | ¿Siguen apareciendo los `NULL`? |
| 3 | Agrega el `GROUP BY` y los conteos (punto 6 de la hoja de repaso), luego `INTO #respuesta` | ¿`clientes` es mayor que `clientes_con_pago`? |

---

## 💡 Pistas

### Ejercicio 4 · ¿Quién trajo a cada cliente nuevo?

<details><summary>Pista 1</summary>

Necesitas dos copias de `core.cliente`: una para el cliente nuevo y otra para su referidor. Es la misma forma del ejemplo resuelto.
</details>

<details><summary>Pista 2</summary>

El `ON` une la columna que apunta (`cliente_referidor_id` del nuevo) con la llave de la otra copia. Un `JOIN` normal deja fuera a los que no tienen referidor, que es lo que quieres. Los días se calculan con `DATEDIFF` entre las dos fechas de alta.
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

Sigue las tres etapas. La tabla que no quieres perder (los clientes) va en el `FROM`.
</details>

<details><summary>Pista 2</summary>

Las tres condiciones del pago (que sea de esa cuenta, aprobado y en soles) van en el `ON` del `LEFT JOIN`. Para contar clientes con pago, mira la última fila de la tabla del punto 6 de la hoja de repaso. `SUM(t.monto)` ignora los `NULL`. El gasto se divide entre los clientes **con** pago.
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

1. **`Msg 1013 — The objects "core.cliente" and "core.cliente" in the FROM clause have the same exposed names.`**
   En un self-join, cada copia necesita su propio alias.

2. **Sin mensaje de error, pero `clientes` es igual a `clientes_con_pago`.**
   Una condición sobre la operación quedó en el `WHERE` y el `LEFT JOIN` se volvió `JOIN` (punto 5 de la hoja de repaso).

3. **Sin mensaje de error, pero `clientes` es enorme.**
   Contaste filas (`COUNT(*)`) en lugar de clientes distintos (punto 6 de la hoja de repaso).

---

## 🧱 Avance del proyecto

En [proyecto/hallazgos.md](../../proyecto/hallazgos.md), bajo la pregunta 4, escribe tu hallazgo del reto: qué canal gasta más por cliente (con números), qué le recomendarías a marketing y cómo medirías si funcionó. Si te queda energía, copia tu consulta del reto en [proyecto/consultas.sql](../../proyecto/consultas.sql), bajo la misma pregunta.

**Cómo debe verse:** 4 a 6 líneas con tus números.

---

## 📣 Post 1 de LinkedIn (otro día, sin apuro)

Terminaste el módulo de JOINs. Escribe **tú** un post corto. Si quieres, pásame el borrador y lo reviso.

**Qué debe tener:**
1. Qué estás haciendo: un proyecto de SQL sobre una fintech **simulada**, con datos inventados (dilo explícitamente).
2. Qué aprendiste: una cosa concreta, por ejemplo cómo una condición en el `WHERE` cambia un `LEFT JOIN`.
3. Un hallazgo con su número, calculado por ti (por ejemplo, el de este reto).
4. Una captura de tu consulta en SSMS con su resultado.
5. Un cierre honesto: qué viene después o una pregunta para quien lee.

**Qué evitar:** "dominé SQL", "experto", cifras que no calculaste o presentar los datos como reales. "Me costó…", "me sorprendió que…" o "me equivoqué en… y aprendí que…" funcionan mejor.

**Largo:** 8 a 12 líneas. Guarda el texto en `proyecto/posts/post1.md` y la captura en `proyecto/posts/`.

---

## ✅ Cierre

- [ ] Puedo escribir un self-join con alias claros y leer en qué dirección va la relación.
- [ ] Armé el reto por etapas y revisé el resultado en cada una.
- [ ] Escribí mi hallazgo en `hallazgos.md`.
- [ ] Superé `s09_e4` y `s09_reto` (`EXEC chk.ver_progreso 'S09';`).
- [ ] Dejé anotada la fecha en que escribiré el Post 1.

Terminaste el módulo 3 (relacionar tablas). Marca S09a y S09b en [CURRICULA.md](../../CURRICULA.md):

```bash
git add .
```
```bash
git commit -m "S09b: self-join, referidos vs orgánicos y cierre del módulo de JOINs"
```
