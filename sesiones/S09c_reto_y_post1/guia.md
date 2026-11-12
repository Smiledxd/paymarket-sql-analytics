# S09c · Reto del módulo: ¿los referidos gastan más?

> **Lo que quiero lograr hoy:** armar una consulta larga por etapas, sin escribirla de una vez.

| | |
|---|---|
| **Tiempo de referencia** | 40 a 50 minutos si sale sin trabarte |
| **Techo** | 1 hora. Si llegas, **paras**, y lo terminas la próxima sesión |
| **Hoy hay** | 1 tema (`COUNT(DISTINCT CASE ...)` por capas) y 1 reto. El Post 1 va **otro día** |
| **Archivos** | Esta guía + [practica.sql](practica.sql) + la [hoja de repaso de JOIN](../../guias/repaso_joins.md) a mano |

**Palabras de hoy:** **orgánico** es el cliente que llegó solo; **campaña digital**, el que llegó por publicidad; **referido**, el que alguien invitó. **Facturación** es la suma de lo que se pagó. Todas están en el [glosario](../../guias/glosario_paymarket.md).

**Regla de los 15 minutos:** si sigues trabado 15 minutos después de abrir la pista 3, escribe ⏭️ en el registro y lo vemos juntos.

---

## 📘 El tema: `COUNT(DISTINCT CASE ...)`, una capa a la vez

Dijiste que cuando está todo junto se te lía. Es normal: son **tres ideas una dentro de otra**. Se leen **de adentro hacia afuera**.

Volvamos a alumnos y pagos, con el `LEFT JOIN` que deja a Darío con `NULL`:

| a.alumno_id | a.nombre | p.pago_id |
|---|---|---|
| 1 | Adriana | 100 |
| 1 | Adriana | 101 |
| 2 | Benjamín | 102 |
| 3 | Cecilia | 103 |
| 4 | Darío | NULL |

**Pregunta:** ¿cuántos alumnos tienen al menos un pago? La respuesta debe ser 3.

**Capa 1, el `CASE` (fila por fila):** "si esta fila tiene pago, dame el id del alumno; si no, nada".

`CASE WHEN p.pago_id IS NOT NULL THEN a.alumno_id END`

| a.nombre | lo que devuelve el CASE |
|---|---|
| Adriana | 1 |
| Adriana | 1 |
| Benjamín | 2 |
| Cecilia | 3 |
| Darío | NULL |

**Capa 2, el `DISTINCT`:** quita los repetidos → queda 1, 2, 3 y NULL.

**Capa 3, el `COUNT`:** cuenta lo que no es `NULL` → **3**.

| Si quitas… | Lo que pasa |
|---|---|
| El `DISTINCT` | Da 4, porque cuenta a Adriana dos veces |
| El `CASE` | Da 4, porque cuenta también a Darío |

**El truco para no enredarte:** primero mira la columna del `CASE` sola, como en la tabla de arriba. Cuando veas que está bien, recién la metes dentro del `COUNT`. En `practica.sql` lo harás así.

---

## 🏋️ Cómo se arma el reto: por etapas

| Etapa | Qué escribes | Qué miras antes de seguir |
|---|---|---|
| 1 | Solo los `JOIN` y un `SELECT TOP (20)` de algunas columnas | ¿Aparecen clientes con `NULL` en las columnas de la operación? |
| 2 | Agrega los filtros: los del **pago** en el `ON`, el del **cliente** en el `WHERE` | ¿Siguen apareciendo los `NULL`? |
| 3 | Agrega el `GROUP BY` y las columnas de resumen, de una en una | ¿`clientes` es mayor que `clientes_con_pago`? |
| 4 | `INTO #respuesta` y el verificador | — |

---

## 💡 Pistas del reto

<details><summary>Pista 1 · idea</summary>

"Todos los clientes, pagaran o no": no quieres perder clientes. Esa tabla va en el `FROM`.
</details>

<details><summary>Pista 2 · herramienta</summary>

`cliente → cuenta` con `JOIN` y `LEFT JOIN` a `transaccion`. Las tres condiciones del pago van en el `ON`. Para `clientes_con_pago`, usa las tres capas de hoy.
</details>

<details><summary>Pista 3 · estructura</summary>

```sql
SELECT cl.canal_adquisicion,
       COUNT(DISTINCT ____) AS clientes,
       COUNT(DISTINCT CASE WHEN ____ THEN ____ END) AS clientes_con_pago,
       SUM(t.monto) AS facturacion,
       SUM(t.monto) / ____ AS gasto_por_cliente_con_pago
```
</details>

---

## ⚠️ Si algo sale raro

| Lo que ves | Qué revisar |
|---|---|
| `clientes` es igual a `clientes_con_pago` | Una condición del pago quedó en el `WHERE` |
| `clientes` es enorme | Usaste `COUNT(*)` en lugar de clientes distintos |
| El gasto no coincide | Se divide entre los clientes **con** pago, no entre todos |

---

## 🧱 Avance del proyecto (solo si te sobra tiempo)

En [proyecto/hallazgos.md](../../proyecto/hallazgos.md), bajo la pregunta 4, escribe en 3 líneas qué canal gasta más por cliente, con tus números. Si hoy no alcanza, déjalo para otro día.

---

## 📣 Post 1 de LinkedIn: otro día y sin apuro

**No hay fecha obligatoria.** Se publica cuando estés listo:

1. Escribe tu borrador, con tus palabras.
2. Tráemelo y **te hago preguntas sobre lo que escribiste**: qué significa cada término, cómo salió el número, qué consulta lo produjo.
3. Si puedes responderlas con tus palabras, lo publicas. Si no, lo vemos juntos primero.

**Qué debe tener:** que los datos son **simulados**, algo concreto que aprendiste, un número que calculaste tú y una captura de tu consulta. Guárdalo en `proyecto/posts/post1.md`.

---

## ✅ Cierre

Di en voz alta, sin mirar:

- [x] ¿Qué hace cada capa de `COUNT(DISTINCT CASE ...)`?
- [x] ¿Por qué las condiciones del pago no van en el `WHERE`?

**Antes de irte, llena el registro** al final de `practica.sql`.

```bash
git add .
```
```bash
git commit -m "S09c: referidos vs orgánicos, cierre del módulo de JOINs"
```
```bash
git push
```
