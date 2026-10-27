# S08 · LEFT JOIN

> **Pregunta de negocio del día:** ¿Qué clientes se registraron y nunca pagaron nada?

| | |
|---|---|
| **Duración** | 60 minutos |
| **Antes de empezar** | S07: `INNER JOIN` entre varias tablas. S03: `IS NULL` |
| **Archivos** | Esta guía + [practica.sql](practica.sql) |

**Objetivos**
1. Conservar las filas que no tienen pareja con `LEFT JOIN`.
2. Encontrar "lo que falta" con un anti-join (`LEFT JOIN` + `IS NULL`).
3. Decidir si una condición va en el `ON` o en el `WHERE` de un `LEFT JOIN`.
4. Detectar la duplicación de filas al unir (fan-out) y contar bien después de un join.

**Plan de la sesión**

| Minutos | Qué haces |
|---|---|
| 0–12 | Conceptos y ejemplos de juguete |
| 12–45 | Ejercicios 1 a 4 |
| 45–55 | Reto final |
| 55–60 | Cierre y commit |

---

## 📘 Conceptos

### 1. Las preguntas sobre "lo que no pasó"

"¿Qué clientes nunca pagaron?", "¿qué comercios no vendieron?", "¿qué alumnos no se matricularon?". Con un `INNER JOIN` estas preguntas son imposibles: las filas sin pareja desaparecen justo cuando son las que te interesan.

### 2. LEFT JOIN: la tabla de la izquierda se queda completa

```sql
FROM alumnos AS a
LEFT JOIN matriculas AS m ON m.alumno_id = a.alumno_id
```

- **Todas** las filas de la tabla de la izquierda (`alumnos`) aparecen en el resultado.
- Si un alumno tiene pareja en `matriculas`, se pega igual que en un `INNER JOIN` (y si tiene tres matrículas, aparece tres veces).
- Si **no** tiene pareja, aparece una vez, con **todas las columnas de `matriculas` en `NULL`**.

La tabla de la izquierda es la que va en el `FROM`: la que no quieres perder. `RIGHT JOIN` hace lo mismo al revés y casi no se usa: basta con escribir las tablas en el otro orden.

### 3. Anti-join: quedarse solo con los que no tienen pareja

Si después del `LEFT JOIN` filtras `WHERE m.matricula_id IS NULL`, te quedas solo con los alumnos que **no** encontraron pareja. Revisa el nulo en una columna que **nunca** es nula cuando hay pareja; lo más seguro es la llave primaria de la tabla de la derecha. Revisar una columna de la tabla de la izquierda (`a.alumno_id IS NULL`) no sirve: esa nunca es nula.

### 4. ON vs WHERE en un LEFT JOIN

En un `INNER JOIN` da igual dónde pongas una condición. En un `LEFT JOIN`, **no**:

- Una condición en el **`ON`** decide **qué cuenta como pareja**. `LEFT JOIN pagos AS p ON p.alumno_id = a.alumno_id AND p.estado = 'pagado'` significa "busca solo pagos pagados; si no hay ninguno, igual conserva al alumno, con `NULL`".
- Una condición en el **`WHERE`** filtra el resultado **después** de unir. `WHERE p.estado = 'pagado'` elimina las filas donde `p.estado` es `NULL`… es decir, justo a los alumnos sin pareja. Tu `LEFT JOIN` se convirtió en `INNER JOIN` sin avisarte.

Regla práctica: **las condiciones sobre la tabla de la derecha van en el `ON`**, salvo el `IS NULL` del anti-join, que va en el `WHERE`.

### 5. Fan-out: cuando unir multiplica filas

Después de unir con la tabla "muchos", hay una fila por cada pareja. Un cliente con 50 operaciones aparece 50 veces. Consecuencias:

- `COUNT(*)` cuenta **operaciones**, no clientes. Para clientes, usa `COUNT(DISTINCT cliente_id)`.
- Si sumas una columna de la tabla "uno" (por ejemplo, el monto de un crédito) después de unirla con una tabla "muchos" (sus pagos), el monto se suma una vez por cada pago: se infla.
- `COUNT(*)` cuenta también las filas sin pareja de un `LEFT JOIN` (valen 1). Para contar parejas, cuenta una columna de la derecha: `COUNT(m.matricula_id)` ignora los `NULL`.

Cómo detectarlo: antes de resumir, cuenta las filas del resultado del join y pregúntate si coinciden con lo que representa una fila. Si esperabas una fila por cliente y tienes 300 mil, hay fan-out.

---

## 💡 Pistas

### Ejercicio 1 · Billeteras en soles que nunca se usaron

<details><summary>Pista 1</summary>

Es un anti-join: cuentas **sin pareja** en `core.transaccion`. ¿Qué tabla va a la izquierda?
</details>

<details><summary>Pista 2</summary>

`FROM core.cuenta` + `LEFT JOIN core.transaccion` por `cuenta_id`. En el `WHERE`: la moneda de la cuenta y el `IS NULL` sobre la llave de la transacción.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT COUNT(*) AS cuentas_sin_operaciones
INTO #respuesta
FROM core.cuenta AS cu
LEFT JOIN core.transaccion AS t ON ____
WHERE cu.____ = ____
  AND t.____ IS NULL;
```
</details>

### Ejercicio 2 · ¿Quiénes se registraron y nunca pagaron?

<details><summary>Pista 1</summary>

Todos los clientes deben quedarse (también los que no pagaron). Solo cuenta como "pago" una operación **aprobada**. Y después del join, cada cliente aparece muchas veces.
</details>

<details><summary>Pista 2</summary>

`cliente → cuenta` con `JOIN`, y `LEFT JOIN` a `transaccion` con la condición del estado **en el `ON`**. Para los clientes con pago: `COUNT(DISTINCT CASE WHEN <la operación existe> THEN cl.cliente_id END)`. Los sin pago son la resta.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT cl.canal_adquisicion,
       COUNT(DISTINCT ____) AS clientes,
       COUNT(DISTINCT ____) - COUNT(DISTINCT CASE WHEN t.____ IS NOT NULL THEN ____ END) AS clientes_sin_pago,
       100.0 * (____) / ____ AS pct_sin_pago
INTO #respuesta
FROM core.cliente AS cl
JOIN core.cuenta AS cu ON ____
LEFT JOIN core.transaccion AS t ON ____ AND ____
GROUP BY ____;
```
</details>

### Ejercicio 3 · Comercios afiliados que nunca vendieron

<details><summary>Pista 1</summary>

Otro anti-join, pero esta vez "vender" es tener una operación **aprobada**. ¿Dónde va esa condición?
</details>

<details><summary>Pista 2</summary>

`FROM core.comercio` + `LEFT JOIN core.transaccion` con dos condiciones en el `ON`, e `IS NULL` en el `WHERE`.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT c.comercio_id, c.nombre_comercial, c.fecha_afiliacion
INTO #respuesta
FROM core.comercio AS c
LEFT JOIN core.transaccion AS t ON ____ AND ____
WHERE ____ IS NULL;
```
</details>

### Ejercicio 4 · Clientes y facturación por sexo

<details><summary>Pista 1</summary>

Aquí basta un `INNER JOIN` (solo interesan clientes que pagaron). La trampa es el conteo: después del join hay una fila por operación.
</details>

<details><summary>Pista 2</summary>

`transaccion → cuenta → cliente`. Clientes con `COUNT(DISTINCT ...)`, operaciones con `COUNT(*)`.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT cl.sexo, COUNT(____ ____) AS clientes, COUNT(*) AS operaciones, SUM(t.monto) AS facturacion
INTO #respuesta
FROM core.transaccion AS t
JOIN ____ ON ____
JOIN ____ ON ____
WHERE ____
GROUP BY ____;
```
</details>

### 🏋️ Reto final · Tasa de contracargos por grupo de rubro

<details><summary>Pista 1</summary>

Todas las operaciones aprobadas deben quedarse (la mayoría no tiene contracargo). ¿Qué tipo de join necesitas con `core.contracargo`?
</details>

<details><summary>Pista 2</summary>

`transaccion → comercio → rubro_mcc` con `JOIN`, y `LEFT JOIN core.contracargo` por `transaccion_id`. Aprobadas: `COUNT(*)`. Contracargos: `COUNT` de una columna de `contracargo`.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT r.grupo,
       COUNT(*) AS aprobadas,
       COUNT(cb.____) AS contracargos,
       100.0 * ____ / ____ AS tasa_contracargo
INTO #respuesta
FROM core.transaccion AS t
JOIN ____ ON ____
JOIN ____ ON ____
LEFT JOIN core.contracargo AS cb ON ____
WHERE ____
GROUP BY ____;
```
</details>

---

## ⚠️ Errores comunes

1. **Sin mensaje de error, pero el anti-join devuelve 0 filas.**
   O usaste `JOIN` en lugar de `LEFT JOIN`, o pusiste en el `WHERE` una condición sobre la tabla de la derecha (concepto 4), o revisaste el `IS NULL` en una columna de la tabla de la izquierda.

2. **Sin mensaje de error, pero los conteos o sumas son demasiado grandes.**
   Fan-out (concepto 5): estás contando filas del join en lugar de entidades distintas, o sumando una columna de la tabla "uno" repetida por cada fila de la tabla "muchos".

3. **`Msg 8120` al agregar columnas de la tabla de la derecha al `SELECT`.**
   Igual que en S05: si hay `GROUP BY`, toda columna suelta debe estar agrupada. En un anti-join sin `GROUP BY` esto no pasa.

---

## 🚀 Nivel pro (opcional)

1. `FULL OUTER JOIN` conserva las filas sin pareja **de los dos lados**. Arma dos listas de juguete (clientes de una feria y clientes de la web) y úsalo para ver quién está solo en una, solo en la otra y en ambas.
2. Demuestra el fan-out en PayMarket: une `core.credito` con `core.pago_cuota` y compara `SUM(k.monto)` antes y después del join para los créditos de enero de 2026. ¿Cuánto se infla? ¿Cómo lo evitarías? (lo resolverás bien en S10 con subconsultas).

---

## 🧱 Avance del proyecto

En [proyecto/consultas.sql](../../proyecto/consultas.sql), bajo la **pregunta 4**, escribe una consulta con una fila por **mes de alta** del cliente (año y mes de `fecha_alta`): cuántos clientes se registraron y qué porcentaje nunca tuvo una operación aprobada.

En [proyecto/hallazgos.md](../../proyecto/hallazgos.md) anota el porcentaje general de clientes que nunca pagaron y si ese porcentaje cambia según el mes de alta o el canal de adquisición (ejercicio 2). Ojo: los clientes registrados en junio de 2026 tuvieron muy poco tiempo para pagar. ¿Cómo lo tendrías en cuenta?

**Por qué lo haría un analista:** captar un cliente cuesta dinero. Un cliente que se registra y nunca paga es un costo sin retorno, y saber de dónde vienen ayuda a decidir en qué campañas invertir.

**Cómo debe verse:** una consulta comentada (18 filas) y un párrafo con los números y la advertencia sobre los meses recientes.

---

## ✅ Cierre

- [x] Puedo explicar qué pasa con las filas sin pareja en un `INNER JOIN` y en un `LEFT JOIN`.
- [x] Puedo escribir un anti-join y sé en qué columna revisar el `IS NULL`.
- [x] Puedo explicar con un ejemplo por qué una condición en el `WHERE` convierte un `LEFT JOIN` en `INNER JOIN`.
- [ ] Sé detectar el fan-out y contar entidades con `COUNT(DISTINCT)` o con `COUNT(columna_de_la_derecha)`.
- [x] Superé los verificadores de la sesión (`EXEC chk.ver_progreso 'S08';`).

```bash
git add .
git commit -m "S08: left join, anti-join y clientes que nunca pagaron"
```
