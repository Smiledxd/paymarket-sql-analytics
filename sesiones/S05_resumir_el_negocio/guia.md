# S05 · Resumir el negocio

> **Pregunta de negocio del día:** ¿Cuánto factura cada canal y cuál es su ticket promedio?

| | |
|---|---|
| **Duración** | 60 minutos |
| **Antes de empezar** | S02 a S04: filtros, nulos y rangos de fecha |
| **Archivos** | Esta guía + [practica.sql](practica.sql) |

**Objetivos**
1. Diferenciar `COUNT(*)`, `COUNT(columna)` y `COUNT(DISTINCT columna)`, y elegir el correcto para cada pregunta.
2. Usar `SUM`, `AVG`, `MIN` y `MAX`, y evitar el promedio entero.
3. Resumir "por algo" con `GROUP BY`.
4. Calcular los KPIs básicos de un negocio de pagos: volumen, facturación y ticket promedio.

**Plan de la sesión**

| Minutos | Qué haces |
|---|---|
| 0–10 | Conceptos y ejemplos de juguete |
| 10–45 | Ejercicios 1 a 4 |
| 45–55 | Reto final |
| 55–60 | Cierre y commit |

---

## 📘 Conceptos

### 1. Resumir es pasar de muchas filas a pocas que respondan algo

La gerencia no lee 300 mil operaciones: lee tres o cuatro números. En un negocio de pagos, los primeros son:

| KPI | Qué es | Cómo se calcula |
|---|---|---|
| **Volumen** | Cuántas operaciones hubo | contar operaciones |
| **Facturación** | Cuánto dinero pasó por PayMarket | sumar los montos |
| **Ticket promedio** | Cuánto paga una persona en promedio por operación | facturación ÷ operaciones (o `AVG(monto)`) |

Antes de calcular, define **qué filas entran**. La facturación se mide con operaciones **aprobadas** (un rechazo no movió dinero, y una extornada se devolvió) y **en una sola moneda**: sumar soles con dólares da un número que no significa nada.

### 2. Tres formas de contar

| Expresión | Cuenta… | Ejemplo en PayMarket |
|---|---|---|
| `COUNT(*)` | filas | operaciones |
| `COUNT(columna)` | filas donde esa columna **no** es `NULL` | operaciones con promoción (`promocion_id` es `NULL` si no hubo) |
| `COUNT(DISTINCT columna)` | valores **distintos** (sin contar `NULL`) | cuántas cuentas distintas pagaron |

La pregunta que decide cuál usar: ¿**qué** estoy contando? Si una cuenta paga diez veces, `COUNT(cuenta_id)` da 10 y `COUNT(DISTINCT cuenta_id)` da 1.

### 3. SUM, AVG, MIN, MAX y el promedio entero

`SUM`, `AVG`, `MIN` y `MAX` ignoran los `NULL` (lo viste en S03).

**La trampa del promedio entero:** si la columna es entera (`INT`), SQL Server calcula el promedio **como entero** y descarta los decimales: el promedio de 1 y 2 da 1, no 1.5. Para no perderlos, convierte **antes** de promediar: `AVG(columna * 1.0)` o `AVG(CAST(columna AS DECIMAL(10,2)))`. Convertir después (`CAST(AVG(columna) AS DECIMAL)`) no sirve: los decimales ya se perdieron. `monto` es `DECIMAL`, así que no tiene este problema; `latencia_ms` sí.

### 4. GROUP BY: un resumen por cada grupo

`GROUP BY canal_id` junta las filas que tienen el mismo `canal_id` y calcula los resúmenes **dentro de cada grupo**. Resultado: una fila por canal. Es el paso 4 de la receta: "¿hay que resumir *por algo*?".

La regla de oro: **toda columna del `SELECT` que no esté dentro de una función de resumen debe estar en el `GROUP BY`**. Si pides `canal_id, moneda, SUM(monto)`, tienes que agrupar por las dos, y el resultado tendrá una fila por cada combinación de canal y moneda.

Recuerda el orden lógico: `WHERE` filtra filas **antes** de agrupar. Primero decides qué operaciones entran; después las resumes.

---

## 💡 Pistas

### Ejercicio 1 · Radiografía de 2025

<details><summary>Pista 1</summary>

Paso 1: una sola fila con cinco números. Paso 3: ¿qué operaciones sirven para hablar de facturación?
</details>

<details><summary>Pista 2</summary>

`WHERE` con estado, moneda y el año 2025 como rango semiabierto. Luego `COUNT(*)`, `SUM`, `AVG`, `MIN` y `MAX` sobre `monto`. No hace falta `GROUP BY`.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT COUNT(*) AS operaciones, ____(monto) AS facturacion, ____(monto) AS ticket_promedio,
       ____(monto) AS ticket_minimo, ____(monto) AS ticket_maximo
INTO #respuesta
FROM core.transaccion
WHERE ____ AND ____ AND fecha_hora >= ____ AND fecha_hora < ____;
```
</details>

### Ejercicio 2 · Junio 2026 en números

<details><summary>Pista 1</summary>

Cuatro formas de contar sobre las mismas filas. Para cada columna pregúntate: ¿cuento filas, valores no nulos o valores distintos?
</details>

<details><summary>Pista 2</summary>

Operaciones: `COUNT(*)`. Cuentas y comercios: `COUNT(DISTINCT ...)`. Operaciones con promoción: `COUNT` de la columna que es `NULL` cuando no hubo promoción.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT COUNT(*) AS operaciones_aprobadas,
       COUNT(____ ____) AS cuentas_distintas,
       COUNT(____ ____) AS comercios_distintos,
       COUNT(____) AS operaciones_con_promocion
INTO #respuesta
FROM core.transaccion
WHERE ____;
```
</details>

### Ejercicio 3 · Facturación y ticket promedio por canal

<details><summary>Pista 1</summary>

Paso 4: "por canal" → una fila por canal.
</details>

<details><summary>Pista 2</summary>

`GROUP BY canal_id`, y `canal_id` también en el `SELECT`. Los filtros de estado, moneda y fecha van en el `WHERE`.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT canal_id, COUNT(*) AS operaciones, SUM(____) AS facturacion, AVG(____) AS ticket_promedio
INTO #respuesta
FROM core.transaccion
WHERE ____
GROUP BY ____;
```
</details>

### Ejercicio 4 · Tiempo de respuesta del servidor por canal

<details><summary>Pista 1</summary>

`latencia_ms` es entera. Relee el concepto 3.
</details>

<details><summary>Pista 2</summary>

Convierte a decimal **dentro** del `AVG`. `MAX` no tiene ese problema.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT canal_id, AVG(____ * ____) AS latencia_promedio_ms, MAX(____) AS latencia_maxima_ms
INTO #respuesta
FROM core.transaccion
WHERE ____
GROUP BY ____;
```
</details>

### 🏋️ Reto final · Los 10 comercios que más facturaron en el segundo trimestre

<details><summary>Pista 1</summary>

Es un resumen por comercio (paso 4) seguido de un top 10 (paso 5). El segundo trimestre son abril, mayo y junio.
</details>

<details><summary>Pista 2</summary>

`GROUP BY comercio_id`, luego `TOP (10)` con `ORDER BY` por la facturación de mayor a menor y desempate por `comercio_id`. En el `ORDER BY` puedes usar el alias.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT TOP (10) comercio_id, COUNT(*) AS operaciones, COUNT(____ ____) AS cuentas_distintas,
       SUM(____) AS facturacion, AVG(____) AS ticket_promedio, SUM(____) AS comision_total
INTO #respuesta
FROM core.transaccion
WHERE ____
GROUP BY ____
ORDER BY ____ DESC, ____ ASC;
```
</details>

---

## ⚠️ Errores comunes

1. **`Msg 8120 — Column 'core.transaccion.moneda' is invalid in the select list because it is not contained in either an aggregate function or the GROUP BY clause.`**
   Pusiste en el `SELECT` una columna "suelta" que no está en el `GROUP BY`. SQL Server no sabe cuál de los muchos valores del grupo mostrar. Agrégala al `GROUP BY` o quítala del `SELECT`.

2. **`Msg 8117 — Operand data type varchar is invalid for sum operator.`**
   Intentaste sumar o promediar una columna de texto. Revisa el tipo en el diccionario.

3. **Sin mensaje de error, pero el promedio no tiene decimales.**
   Es el promedio entero (concepto 3). Convierte antes de promediar.

---

## 🚀 Nivel pro (opcional)

1. `GROUP BY ROLLUP (canal_id)` agrega una fila extra con el total de todos los canales. Pruébalo en el ejercicio 3 (fuera del verificador) y averigua qué valor toma `canal_id` en esa fila.
2. El promedio se deja arrastrar por unas pocas operaciones enormes. Busca `PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY monto) OVER ()` y compara la **mediana** del ticket de 2025 con su promedio. ¿Cuál describe mejor a un cliente típico?

---

## 🧱 Avance del proyecto

En [proyecto/consultas.sql](../../proyecto/consultas.sql), bajo la **pregunta 1**, escribe la tabla de evolución mensual: por año y mes (`YEAR` y `MONTH` de `fecha_hora`), las operaciones aprobadas en soles, su facturación y su ticket promedio, ordenadas cronológicamente.

En [proyecto/hallazgos.md](../../proyecto/hallazgos.md) anota el primer y el último mes con sus números, y qué ves en la tendencia. Si algún mes se sale del patrón, anótalo como pregunta para investigar.

**Por qué lo haría un analista:** la evolución mensual es el primer gráfico que pide cualquier gerencia. Todo lo demás se compara contra ella.

**Cómo debe verse:** 18 filas (enero 2025 a junio 2026), una consulta comentada y 2 o 3 líneas de observaciones con números.

---

## ✅ Cierre

- [x] Puedo explicar con un ejemplo la diferencia entre `COUNT(*)`, `COUNT(columna)` y `COUNT(DISTINCT columna)`.
- [x] Sé por qué la facturación se calcula solo con operaciones aprobadas y en una moneda.
- [x] Puedo evitar el promedio entero y explicar por qué convertir después no sirve.
- [x] Sé la regla del `GROUP BY` y puedo leer el error 8120.
- [x] Superé los verificadores de la sesión (`EXEC chk.ver_progreso 'S05';`).

```bash
git add .
git commit -m "S05: KPIs de volumen, facturación y ticket por canal"
```
