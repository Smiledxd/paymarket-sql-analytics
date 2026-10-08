# S02 · Filtrar las filas correctas

> **Pregunta de negocio del día:** ¿Qué rechazos son por fondos insuficientes y cuáles técnicos?

| | |
|---|---|
| **Duración** | 60 minutos |
| **Antes de empezar** | S01: alias, columnas calculadas y `TOP` con `ORDER BY` |
| **Archivos** | Esta guía + [practica.sql](practica.sql) |

**Objetivos**
1. Escribir condiciones con comparaciones, texto y fechas.
2. Combinar condiciones con `AND`, `OR` y `NOT` usando paréntesis para no cambiar la lógica sin querer.
3. Usar `IN`, `BETWEEN` y `LIKE` en el lugar correcto.
4. Filtrar un día o un mes completo en una columna con hora (rango semiabierto).
5. Consultar una tabla de catálogo antes de filtrar, en vez de adivinar los códigos.

**Plan de la sesión**

| Minutos | Qué haces |
|---|---|
| 0–10 | Conceptos y ejemplos de juguete |
| 10–45 | Ejercicios 1 a 4 |
| 45–55 | Reto final |
| 55–60 | Cierre y commit |

---

## 📘 Conceptos

### 1. El WHERE es un portero

El `WHERE` revisa **cada fila** de la tabla y deja pasar solo las que cumplen la condición. Recuerda el paso 3 de la receta: primero decides qué filas sirven; después, qué muestras.

- Números sin comillas: `monto > 3000`.
- Texto entre comillas simples: `estado = 'Aprobada'`. Sin comillas, SQL Server cree que `Aprobada` es el nombre de una columna.
- Los códigos que son texto van entre comillas aunque parezcan números: `codigo_respuesta = '51'`, `mcc = '5912'`.
- Distinto de: `<>`.

### 2. AND, OR, NOT y los paréntesis

`AND` exige que se cumplan las dos condiciones; `OR`, que se cumpla al menos una; `NOT` invierte.

La trampa: **`AND` se evalúa antes que `OR`**, igual que la multiplicación antes que la suma. Imagina que quieres "los libros de poesía que cuestan menos de 30 o más de 50". Si escribes:

```
categoria = 'Poesía' AND precio < 30 OR precio > 50
```

SQL Server lo lee así:

```
(categoria = 'Poesía' AND precio < 30) OR (precio > 50)
```

La segunda mitad deja pasar **cualquier** libro de más de 50, sea o no de poesía. No hay mensaje de error: solo un resultado equivocado. Lo correcto era `categoria = 'Poesía' AND (precio < 30 OR precio > 50)`. Regla práctica: **cada vez que mezcles `AND` y `OR`, pon paréntesis**, aunque creas que no hacen falta.

### 3. IN, BETWEEN y LIKE

| Operador | Qué hace | Ejemplo |
|---|---|---|
| `IN (a, b, c)` | Igual a cualquiera de la lista. Más corto y claro que varios `OR` | `canal_id IN (1, 2)` |
| `NOT IN (...)` | Distinto de todos los de la lista | `codigo_respuesta NOT IN ('00')` |
| `BETWEEN a AND b` | Entre `a` y `b`, **incluidos los dos extremos** | `monto BETWEEN 200 AND 2000` |
| `LIKE 'patrón'` | Texto que calza con un patrón. `%` = cualquier cantidad de caracteres; `_` = exactamente uno | `ruc LIKE '10%'` |

Con `LIKE`, la posición del `%` importa: `'10%'` significa "empieza con 10"; `'%10%'` significa "contiene 10 en cualquier parte", y un RUC `20510...` también contiene 10.

### 4. Fechas con hora: rangos semiabiertos

`fecha_hora` guarda fecha **y hora**: `2026-03-15 14:32:10`. Por eso:

- `fecha_hora = '2025-08-20'` busca operaciones hechas **exactamente a las 00:00:00** de ese día. Casi ninguna.
- `fecha_hora BETWEEN '2025-08-01' AND '2025-08-31'` deja fuera todo lo que pasó el 31 después de medianoche.

La forma correcta de pedir un periodo es un **rango semiabierto**: desde el inicio (incluido) hasta el inicio del periodo siguiente (excluido).

```
fecha_hora >= '2025-08-20' AND fecha_hora < '2025-08-21'   -- todo el 20 de agosto
fecha_hora >= '2025-08-01' AND fecha_hora < '2025-09-01'   -- todo agosto
```

Funciona igual si la columna tiene hora o no, y nunca te obliga a saber si el mes tiene 30 o 31 días. Escribe las fechas como `'AAAA-MM-DD'`: es el único formato que SQL Server entiende igual en cualquier configuración.

### 5. Primero el catálogo, después el filtro

¿Qué códigos son "rechazo técnico"? No los adivines ni los recuerdes: están en `core.codigo_respuesta`. Un analista primero consulta el catálogo y después usa esos valores en el filtro. En S07 aprenderás a hacerlo en una sola consulta con `JOIN`; por ahora son dos pasos.

---

## 💡 Pistas

### Ejercicio 1 · Fondos insuficientes en POS un día de quincena

<details><summary>Pista 1</summary>

Paso 3: son tres condiciones que deben cumplirse a la vez: el código, el canal y el día.
</details>

<details><summary>Pista 2</summary>

El código de fondos insuficientes y el número del canal POS están en los catálogos (`core.codigo_respuesta`, `core.canal`). Para el día, usa un rango semiabierto.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT transaccion_id, fecha_hora, monto
INTO #respuesta
FROM core.transaccion
WHERE codigo_respuesta = ____
  AND canal_id = ____
  AND fecha_hora >= ____ AND fecha_hora < ____;
```
</details>

### Ejercicio 2 · Rechazos técnicos en la web

<details><summary>Pista 1</summary>

Son dos pasos: primero descubre cuáles son los códigos de tipo `Rechazo técnico`; después cuenta.
</details>

<details><summary>Pista 2</summary>

Paso A: `SELECT` sobre `core.codigo_respuesta` filtrando por `tipo_respuesta`. Paso B: `COUNT(*)` en `core.transaccion` con `IN` para los códigos y un rango semiabierto para diciembre 2025.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT COUNT(*) AS rechazos_tecnicos
INTO #respuesta
FROM core.transaccion
WHERE codigo_respuesta IN (____)
  AND canal_id = ____
  AND fecha_hora >= ____ AND fecha_hora < ____;
```
</details>

### Ejercicio 3 · Operaciones grandes en junio

<details><summary>Pista 1</summary>

Escribe la condición en español primero: "aprobada, **y** de junio, **y** (en soles con más de 3000 **o** en dólares con más de 800)". Los paréntesis de esa frase son los de tu consulta.
</details>

<details><summary>Pista 2</summary>

La parte del "o" tiene dos condiciones compuestas: cada una va entre paréntesis, y el `OR` entero va dentro de otro par de paréntesis.
</details>

<details><summary>Pista 3</summary>

```sql
WHERE estado = ____
  AND fecha_hora >= ____ AND fecha_hora < ____
  AND ( (____ AND ____) OR (____ AND ____) )
```
</details>

### Ejercicio 4 · Pequeños negocios de salud y alimentos que no son bodegas

<details><summary>Pista 1</summary>

Tres condiciones: el RUC (persona natural), el rubro (tres posibles) y el nombre (que no sea bodega).
</details>

<details><summary>Pista 2</summary>

`LIKE` para "empieza con", `IN` para la lista de rubros, `NOT LIKE` para "no empieza con".
</details>

<details><summary>Pista 3</summary>

```sql
WHERE ruc LIKE ____
  AND mcc IN (____, ____, ____)
  AND nombre_comercial NOT LIKE ____
```
</details>

### 🏋️ Reto final · Rechazos por sospecha de fraude en canales digitales

<details><summary>Pista 1</summary>

Primero consulta los catálogos: qué códigos son `Sospecha de fraude` y qué `canal_id` tienen App y Web.
</details>

<details><summary>Pista 2</summary>

Cinco condiciones unidas con `AND`: `IN` para los códigos, `IN` para los canales, igualdad para la moneda, `BETWEEN` para el monto y un rango semiabierto para el semestre.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT transaccion_id, canal_id, codigo_respuesta, monto
INTO #respuesta
FROM core.transaccion
WHERE codigo_respuesta IN (____)
  AND canal_id IN (____)
  AND moneda = ____
  AND monto BETWEEN ____ AND ____
  AND fecha_hora >= ____ AND fecha_hora < ____;
```
</details>

---

## ⚠️ Errores comunes

1. **`Msg 207 — Invalid column name 'Aprobada'.`**
   Escribiste un texto sin comillas simples. SQL Server cree que `Aprobada` es una columna. Escribe `'Aprobada'`.

2. **`Msg 241 — Conversion failed when converting date and/or time from character string.`**
   La fecha tiene un formato que SQL Server no entiende o no existe (por ejemplo `'15/03/2026'` o `'2026-02-30'`). Usa `'AAAA-MM-DD'` y revisa que la fecha exista.

3. **Sin mensaje de error, pero con filas que no deberían estar.**
   Casi siempre es un `OR` sin paréntesis (concepto 2) o un `LIKE` con el `%` en el lugar equivocado. El verificador te avisará con "Tu resultado tiene X filas; se esperaban Y". Revisa tu `WHERE` leyéndolo en voz alta.

---

## 🚀 Nivel pro (opcional)

1. `LIKE` acepta clases de caracteres: `'[0-9]%'` significa "empieza con un dígito" y `'%[^0-9]%'` "contiene algo que no es dígito". Averigua cuántos comercios tienen un nombre comercial que contiene un dígito.
2. ¿Qué devuelve `NOT (canal_id = 1 OR canal_id = 2)`? Escríbelo de otras dos formas equivalentes y comprueba que dan lo mismo.

---

## 🧱 Avance del proyecto

En [proyecto/consultas.sql](../../proyecto/consultas.sql), bajo la **pregunta 3** (dónde y por qué se rechazan pagos), escribe tres conteos para todo 2025: cuántas operaciones hubo en total, cuántas fueron rechazadas y cuántas de esas fueron por fondos insuficientes.

En [proyecto/hallazgos.md](../../proyecto/hallazgos.md) anota los tres números y qué porcentaje de los rechazos es por fondos insuficientes (puedes hacer la división a mano por ahora).

**Por qué lo haría un analista:** un rechazo por falta de fondos es un problema del cliente; uno técnico es un problema de PayMarket. Antes de proponer soluciones hay que saber cuál pesa más.

**Cómo debe verse:** tres consultas cortas y comentadas, y un párrafo de 2 o 3 líneas con los números que obtuviste.

---

## ✅ Cierre

- [x] Puedo explicar por qué `AND` y `OR` juntos necesitan paréntesis.
- [x] Sé cuándo usar `IN`, `BETWEEN` y `LIKE`, y qué significa la posición del `%`.
- [x] Puedo filtrar un día o un mes completo en una columna con hora usando `>=` y `<`.
- [x] Consulto los catálogos (`codigo_respuesta`, `canal`) en vez de adivinar códigos.
- [x] Superé los verificadores de la sesión (`EXEC chk.ver_progreso 'S02';`).

```bash
git add .
git commit -m "S02: filtros, rechazos por tipo y rangos de fecha"
```
