# Repaso de JOIN · la hoja para cuando te enredes

> Léela con calma, sin apuro. Todo está explicado con **un solo ejemplo de juguete**, siempre el mismo, para que no tengas que entender datos nuevos a la vez que la idea.
> Practica con [repaso_joins.sql](repaso_joins.sql): son ejercicios cortos con el resultado esperado escrito, para que compruebes tú mismo si te salió.

---

## El ejemplo: una academia de natación

**Tabla `alumnos`** (una fila = un alumno)

| alumno_id | nombre |
|---|---|
| 1 | Adriana |
| 2 | Benjamín |
| 3 | Cecilia |
| 4 | Darío |

**Tabla `pagos`** (una fila = un pago de una mensualidad)

| pago_id | alumno_id | mes | estado |
|---|---|---|---|
| 100 | 1 | marzo | pagado |
| 101 | 1 | abril | pagado |
| 102 | 2 | marzo | pendiente |
| 103 | 3 | marzo | pagado |

Fíjate: Adriana tiene **dos** pagos, Benjamín tiene uno **pendiente**, Cecilia uno pagado y **Darío no tiene ninguno**.

---

## 1. Qué hace un JOIN: pegar columnas al costado

Un `JOIN` no "alarga hacia abajo": **pega columnas al costado**. Toma cada fila de la tabla del `FROM` y le pone al lado la fila de la otra tabla que le corresponde. El `ON` dice cómo saber cuál le corresponde (aquí, que el `alumno_id` sea el mismo).

```sql
FROM alumnos AS a
JOIN pagos AS p ON p.alumno_id = a.alumno_id
```

| a.nombre | p.mes | p.estado |
|---|---|---|
| Adriana | marzo | pagado |
| Adriana | abril | pagado |
| Benjamín | marzo | pendiente |
| Cecilia | marzo | pagado |

Dos cosas que pasaron (y que son la fuente de casi todas las confusiones):

1. **Adriana sale dos veces.** Tiene dos pagos, así que tiene dos "parejas". El JOIN no inventa ni pierde datos: repite a Adriana una vez por cada pago. Por eso, después de un JOIN, para contar alumnos se usa `COUNT(DISTINCT a.alumno_id)`: `COUNT(*)` contaría pagos.
2. **Darío desapareció.** No tiene ninguna pareja en `pagos`, y el `JOIN` normal (`INNER JOIN`) solo muestra a quien tiene pareja.

---

## 2. LEFT JOIN: nadie de la tabla del FROM se queda fuera

```sql
FROM alumnos AS a
LEFT JOIN pagos AS p ON p.alumno_id = a.alumno_id
```

| a.nombre | p.pago_id | p.mes | p.estado |
|---|---|---|---|
| Adriana | 100 | marzo | pagado |
| Adriana | 101 | abril | pagado |
| Benjamín | 102 | marzo | pendiente |
| Cecilia | 103 | marzo | pagado |
| **Darío** | **NULL** | **NULL** | **NULL** |

La única diferencia: **Darío sigue ahí**, y como no tiene pareja, las columnas de `pagos` le salen vacías (`NULL`).

La palabra `LEFT` significa "la tabla de la izquierda manda": la del `FROM`. **Todas** sus filas aparecen, tengan pareja o no.

---

## 3. ¿JOIN o LEFT JOIN? Una sola pregunta

> **¿Necesito ver (o contar) a alguien que NO tiene pareja?**

| Si la pregunta habla de… | Usa | Por qué |
|---|---|---|
| "los que pagaron", "facturación por…", "clientes que compraron" | `JOIN` | Solo te interesan los que **sí** tienen pareja |
| "los que **nunca**…", "**sin** ventas", "que **no** usaron", "**todos** los clientes, hayan pagado o no" | `LEFT JOIN` | Necesitas que los que **no** tienen pareja sigan en el resultado |

Truco: si en el enunciado aparecen las palabras **nunca, sin, ninguno, todos (aunque no…)**, piensa en `LEFT JOIN`.

¿Y qué tabla va en el `FROM`? **La de las cosas que no quieres perder.** Si preguntas por alumnos sin pagos, no quieres perder alumnos: `FROM alumnos`.

---

## 4. IS NULL e IS NOT NULL después de un LEFT JOIN

Mira otra vez la tabla del punto 2. La fila de Darío es la única con `NULL` en `p.pago_id`. Entonces:

| Agregas… | Te quedas con… | Pregunta que responde |
|---|---|---|
| `WHERE p.pago_id IS NULL` | solo Darío | "¿Quién **no** tiene ningún pago?" (esto se llama **anti-join**) |
| `WHERE p.pago_id IS NOT NULL` | Adriana, Adriana, Benjamín, Cecilia | "¿Quién **sí** tiene pagos?" (igual que un JOIN normal) |

Revisa el `NULL` en una columna de la tabla de la **derecha** que nunca esté vacía cuando hay pareja: su llave (`p.pago_id`). Revisarlo en `a.alumno_id` no sirve, porque los alumnos siempre existen.

---

## 5. El ON y el WHERE: dos momentos distintos

Esta es la parte más difícil, y es normal que cueste. Piénsalo como **dos momentos**:

1. **Momento 1, el `ON`: se buscan las parejas.** El `ON` es la regla para decidir **quién es pareja de quién**.
2. **Momento 2, el `WHERE`: se revisa el resultado.** Ya armadas las filas, el `WHERE` decide **quién se queda**.

Pregunta: *"cada alumno con sus pagos **pagados**, y que aparezcan también los que no tienen ninguno pagado"*.

**Opción A: la condición en el ON (correcto)**

```sql
FROM alumnos AS a
LEFT JOIN pagos AS p ON p.alumno_id = a.alumno_id AND p.estado = 'pagado'
```

En el momento 1, el pago pendiente de Benjamín **no cuenta como pareja**. Pero como es `LEFT JOIN`, Benjamín se queda igual, sin pareja:

| a.nombre | p.mes |
|---|---|
| Adriana | marzo |
| Adriana | abril |
| Benjamín | NULL |
| Cecilia | marzo |
| Darío | NULL |

**Opción B: la condición en el WHERE (el error típico)**

```sql
FROM alumnos AS a
LEFT JOIN pagos AS p ON p.alumno_id = a.alumno_id
WHERE p.estado = 'pagado'
```

En el momento 1 se arman las 5 filas del punto 2. En el momento 2, el `WHERE` pide `p.estado = 'pagado'`. La fila de Benjamín dice `pendiente` y la de Darío dice `NULL`, así que **los dos se van**:

| a.nombre | p.mes |
|---|---|
| Adriana | marzo |
| Adriana | abril |
| Cecilia | marzo |

Justo se perdieron los que querías ver. El `LEFT JOIN` se comportó como un `JOIN` normal, sin avisarte.

**La regla para recordar:**
> En un `LEFT JOIN`, las condiciones sobre la tabla de la **derecha** van en el **`ON`**.
> La única excepción es el `IS NULL` del anti-join, que va en el **`WHERE`** (porque quieres revisar el resultado ya armado).

En un `JOIN` normal da igual dónde pongas la condición: el resultado es el mismo.

---

## 6. Contar bien después de un JOIN

Con la tabla del punto 2 (5 filas):

| Expresión | Resultado | Qué cuenta |
|---|---|---|
| `COUNT(*)` | 5 | filas (Darío cuenta como 1 aunque no tenga pago) |
| `COUNT(p.pago_id)` | 4 | pagos reales (ignora el `NULL` de Darío) |
| `COUNT(DISTINCT a.alumno_id)` | 4 | alumnos distintos |
| `COUNT(DISTINCT CASE WHEN p.pago_id IS NOT NULL THEN a.alumno_id END)` | 3 | alumnos que tienen al menos un pago |

Antes de escribir el `COUNT`, pregúntate: **¿qué estoy contando: filas, parejas o personas?**

---

## 7. Cómo armar una consulta con JOIN sin perderte: por etapas

No escribas todo de una vez. Hazlo en etapas y **mira el resultado en cada una**:

1. **Etapa 1:** solo el `FROM` y los `JOIN`, con un `SELECT` de las columnas que te ayudan a entender, y un `TOP (20)` para mirar. ¿Cada fila es lo que esperabas? ¿Aparecen los que no tienen pareja (con `NULL`)?
2. **Etapa 2:** agrega el `WHERE`. ¿Se fue alguien que no debía irse?
3. **Etapa 3:** agrega el `GROUP BY` y los `COUNT` o `SUM`.
4. **Etapa 4:** recién ahí, `INTO #respuesta` y el verificador.

Mirar las filas antes de resumir es lo que hacen los analistas con experiencia. No es "hacer trampa": es la forma de no adivinar.

---

## Resumen en 5 líneas

1. `JOIN` pega columnas al costado; una fila se repite si tiene varias parejas.
2. `JOIN` normal = solo los que tienen pareja. `LEFT JOIN` = todos los del `FROM`, con `NULL` si no tienen pareja.
3. "Nunca, sin, ninguno, todos aunque…" → `LEFT JOIN`, con la tabla que no quieres perder en el `FROM`.
4. `IS NULL` después de un `LEFT JOIN` = "los que no tienen pareja".
5. En un `LEFT JOIN`, las condiciones de la tabla de la derecha van en el `ON`; en el `WHERE`, solo el `IS NULL`.
