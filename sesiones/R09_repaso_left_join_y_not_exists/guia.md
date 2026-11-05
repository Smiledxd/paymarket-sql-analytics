# R09 · Repaso: ¿cuándo uso LEFT JOIN y cuándo NOT EXISTS?

> **Lo que quiero lograr hoy:** leer una pregunta y saber qué herramienta usar, sin depender de las pistas.

| | |
|---|---|
| **Tiempo de referencia** | 35 a 45 minutos si sale sin trabarte |
| **Techo** | 1 hora. Si llegas, **paras**, aunque falte. Lo demás sigue en la próxima sesión |
| **Hoy hay** | 2 temas (ninguno nuevo) y 3 ejercicios. Sin proyecto y sin opcionales |
| **Archivos** | Esta guía + [practica.sql](practica.sql) + el [glosario](../../guias/glosario_paymarket.md) a mano |

**Regla de los 15 minutos:** si sigues trabado 15 minutos después de abrir la pista 3, escribe ⏭️ en el registro y pasa al siguiente ejercicio. No es fallar: me dice qué debo explicar mejor.

---

## 🔁 Calentamiento (3 minutos, sin abrir nada)

¿Qué herramienta usarías? Solo piénsalo; no escribas SQL.

1. Quiero **todos** los comercios con su número de ventas, también los que vendieron 0.
2. Quiero los clientes que **nunca** tuvieron un crédito.
3. A cada operación quiero ponerle al lado el nombre de su comercio.

<details><summary>Respuestas</summary>

1. `LEFT JOIN`: no quiero perder a los que vendieron 0.
2. `NOT EXISTS` (o `LEFT JOIN` + `IS NULL`): busco a quienes no tienen pareja.
3. `JOIN`: toda operación tiene su comercio.
</details>

---

## 📘 Tema 1 · Cuándo uso qué

**Antes de escribir, busca estas palabras en el enunciado:**

| Si la pregunta dice… | Lo que pasa | Uso |
|---|---|---|
| "con su…", "por rubro", "de cada venta" | Solo importan los que **sí** tienen pareja | `JOIN` |
| "**todos**, también los que no…", "**aunque** tengan 0" | Quiero a todos: con pareja y sin pareja | `LEFT JOIN` |
| "**nunca**", "**sin**", "**ninguno**", "no hizo" | Quiero **solo** a los que no tienen pareja | `NOT EXISTS` o `LEFT JOIN` + `IS NULL` |
| Lo mismo en dos tablas, para ponerlo en una lista | Una lista debajo de la otra | `UNION` / `UNION ALL` |

### ¿`NOT EXISTS` o anti-join?

Viste en internet que `NOT EXISTS` es "más limpio", y para leerlo es cierto: se parece a la pregunta en español. Los dos dan el mismo resultado, y por lo general rinden parecido. **Usa `NOT EXISTS` cuando solo quieras a los que no tienen pareja.** Usa `LEFT JOIN` cuando además necesites contar o ver datos de la otra tabla.

### Tu regla del `ON` y el `WHERE`, afinada

Dijiste "`ON` para `LEFT JOIN` y `WHERE` para `JOIN`, salvo el anti-join". Vas muy bien; solo le falta un detalle. En un `LEFT JOIN`, **depende de a qué tabla pertenece la condición**:

| La condición es sobre… | Va en… | Ejemplo con alumnos y pagos |
|---|---|---|
| La tabla de la **izquierda** (la del `FROM`) | `WHERE` | `a.turno = 'mañana'` |
| La tabla de la **derecha** (la del `LEFT JOIN`) | `ON` | `p.estado = 'pagado'` |
| "No encontró pareja" | `WHERE` | `p.pago_id IS NULL` |

En un `JOIN` normal da lo mismo dónde la pongas.

---

## 📘 Tema 2 · Cómo se lee un `NOT EXISTS`

Te dejó loco la línea rara que iguala dentro del `WHERE`, y con razón: **en S09a el ejercicio agregó un `JOIN` adentro que el ejemplo no tenía.** Eso fue un salto mío. Hoy vamos paso a paso.

SQL Server revisa la lista de afuera **fila por fila**:

```sql
SELECT a.nombre
FROM alumnos AS a                                -- 1. Toma un alumno, por ejemplo Darío
WHERE NOT EXISTS (SELECT 1
                  FROM pagos AS p                -- 2. Busca en pagos…
                  WHERE p.alumno_id = a.alumno_id);  -- 3. …solo los de ESTE alumno
                                                 -- 4. ¿No encontró ninguno? Darío se queda.
                                                 -- 5. Pasa al siguiente alumno.
```

**La línea `p.alumno_id = a.alumno_id` es la que dice "de ESTE alumno".** Sin ella, buscaría pagos de cualquiera. Como sí hay pagos, nadie se quedaría y saldrían 0 filas.

**¿Y si hay un `JOIN` adentro?** Tiene otro trabajo. Solo aparece cuando la tabla donde buscas **no tiene la columna** que necesitas para conectar:

| Dentro de la subconsulta | Su trabajo |
|---|---|
| El `JOIN` (`ON`) | Une las tablas de adentro para **llegar** a la columna que falta |
| La línea del `WHERE` | **Conecta** lo de adentro con la fila de afuera |

Por eso `transaccion` necesita un `JOIN` con `cuenta`: la operación no sabe de qué cliente es; solo sabe de qué cuenta. `credito` sí tiene `cliente_id`, así que no lo necesita.

---

## 💡 Pistas

Ábrelas solo si hace falta. Antes prueba con la ficha del ejercicio.

### Ejercicio 1

<details><summary>Pista 1 · idea</summary>

La pregunta dice "nunca". Quieres a los clientes sin pareja en `core.credito`.
</details>

<details><summary>Pista 2 · herramienta</summary>

`NOT EXISTS`, como en el ejemplo 1. ¿`credito` tiene `cliente_id`? Entonces no hace falta `JOIN` adentro. El filtro de la fecha de alta va afuera.
</details>

<details><summary>Pista 3 · estructura</summary>

```sql
WHERE c.fecha_alta >= ____ AND c.fecha_alta < ____
  AND NOT EXISTS (SELECT 1 FROM ____ AS k WHERE ____ = ____)
```
</details>

### Ejercicio 2

<details><summary>Pista 1 · idea</summary>

"Todas, también las que no vendieron": no quieres perder comercios. ¿Qué tabla va en el `FROM`?
</details>

<details><summary>Pista 2 · herramienta</summary>

`LEFT JOIN`. Mira la tabla del tema 1 para decidir dónde va cada condición. Para que salga 0, cuenta una columna de la tabla de la derecha.
</details>

<details><summary>Pista 3 · estructura</summary>

```sql
FROM core.comercio AS c
LEFT JOIN core.transaccion AS t
       ON t.comercio_id = c.comercio_id AND ____ AND ____
WHERE ____
GROUP BY ____, ____
```
</details>

### Ejercicio 3

<details><summary>Pista 1 · idea</summary>

Es el ejercicio 1 con un solo cambio: la tabla donde buscas no tiene `cliente_id`.
</details>

<details><summary>Pista 2 · herramienta</summary>

Dentro del `NOT EXISTS`, une `transaccion` con `cuenta`. Luego conecta `cuenta` con el cliente de afuera.
</details>

<details><summary>Pista 3 · estructura</summary>

```sql
AND NOT EXISTS (SELECT 1
                FROM core.transaccion AS t
                JOIN core.cuenta AS cu ON ____ = ____
                WHERE ____ = c.cliente_id
                  AND ____)
```
</details>

---

## ⚠️ Si algo sale raro

| Lo que ves | Qué revisar |
|---|---|
| El `NOT EXISTS` da 0 filas | Falta la línea que conecta con la fila de afuera |
| Te faltan filas en un `LEFT JOIN` | Una condición de la tabla de la derecha quedó en el `WHERE` |
| Sale 1 donde debería salir 0 | Usaste `COUNT(*)`: cuenta una columna de la tabla de la derecha |

---

## ✅ Cierre

Di en voz alta, sin mirar:

- [x] Una palabra del enunciado que me hace pensar en `LEFT JOIN`, y otra en `NOT EXISTS`.
- [x] Para qué sirve la línea que iguala dentro del `NOT EXISTS`.
- [x] Cuándo hace falta un `JOIN` adentro.

**Antes de irte, llena el registro** al final de `practica.sql`: es lo que usaré para ajustar la siguiente sesión. Si la de hoy pasa de 1 hora, la próxima llevará menos carga.

```bash
git add .
```
```bash
git commit -m "R09: repaso de LEFT JOIN y NOT EXISTS"
```
```bash
git push
```
