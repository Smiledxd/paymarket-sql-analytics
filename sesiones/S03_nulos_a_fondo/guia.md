# S03 · Los nulos a fondo

> **Pregunta de negocio del día:** ¿Cuántos clientes no tienen datos de contacto?

| | |
|---|---|
| **Duración** | 60 minutos |
| **Antes de empezar** | S02: `WHERE` con `AND`, `OR`, `IN` y rangos de fecha |
| **Archivos** | Esta guía + [practica.sql](practica.sql) |

**Objetivos**
1. Explicar qué es `NULL` y por qué no se compara con `=`.
2. Aplicar la lógica de tres valores (verdadero, falso, desconocido) para predecir qué filas deja pasar un `WHERE`.
3. Evitar la trampa de `NOT IN` con nulos.
4. Reemplazar nulos con `COALESCE` cuando tiene sentido de negocio, y crearlos con `NULLIF` para dividir sin errores.
5. Saber cómo tratan los nulos `COUNT`, `SUM` y `AVG`.

**Plan de la sesión**

| Minutos | Qué haces |
|---|---|
| 0–12 | Conceptos y ejemplos de juguete |
| 12–45 | Ejercicios 1 a 4 |
| 45–55 | Reto final |
| 55–60 | Cierre y commit |

---

## 📘 Conceptos

### 1. NULL no es cero ni texto vacío: es "no sé"

`NULL` significa que el dato **falta**: el cliente no dio su correo, la fecha de nacimiento no se registró. No es `0`, ni `''` (texto vacío), ni la palabra `'NULL'`. En PayMarket pueden ser nulos, entre otros, `correo`, `celular`, `apellido_materno`, `fecha_nacimiento` y `cliente_referidor_id` (consulta el diccionario).

### 2. La lógica de tres valores

Una comparación con `NULL` no da verdadero ni falso: da **desconocido**. ¿El correo de un cliente es igual a `NULL`? No lo sé, porque no sé cuál es su correo.

| Expresión | Resultado |
|---|---|
| `NULL = NULL` | desconocido |
| `NULL <> 'a'` | desconocido |
| `NULL > 5` | desconocido |
| `desconocido AND falso` | falso |
| `desconocido OR verdadero` | verdadero |
| `NOT desconocido` | desconocido |

El `WHERE` **solo deja pasar las filas donde la condición es verdadera**. Las "desconocidas" se quedan fuera, igual que las falsas. Por eso `WHERE correo = NULL` no devuelve nada, aunque haya miles de clientes sin correo. Para preguntar por nulos existe un operador especial: `IS NULL` y `IS NOT NULL`.

### 3. La trampa silenciosa de `NOT IN`

`columna NOT IN (a, b)` equivale a `columna <> a AND columna <> b`. Si en una fila la columna es `NULL`, las dos comparaciones son desconocidas y **la fila no pasa**. Resultado: al pedir "todos menos a y b", pierdes sin aviso todas las filas que no tienen valor. Y si la **lista** contiene un `NULL`, `NOT IN` no deja pasar ninguna fila.

Pregúntate siempre: ¿las filas con `NULL` deberían entrar según el negocio? Si la respuesta es sí, tienes que incluirlas explícitamente con `OR columna IS NULL`.

### 4. Los nulos en los resúmenes

| Función | Qué hace con los `NULL` |
|---|---|
| `COUNT(*)` | Cuenta **filas**, tengan lo que tengan |
| `COUNT(columna)` | Cuenta solo las filas donde esa columna **no** es `NULL` |
| `SUM`, `AVG`, `MIN`, `MAX` | Ignoran los `NULL` |

`AVG(nota)` con una nota `NULL` promedia solo las notas que existen. Si reemplazas el `NULL` por 0 antes de promediar, el resultado cambia: estás diciendo "sacó 0", que no es lo mismo que "no rindió". Reemplazar un nulo es una **decisión de negocio**, no un truco técnico.

### 5. COALESCE: el primer valor que no falte

`COALESCE(a, b, c)` devuelve el primero de la lista que no sea `NULL`. Sirve para dar un valor de respaldo con sentido: "usa el correo; si no hay, el celular; si no hay ninguno, marca 'SIN CONTACTO'". El orden de la lista es el orden de preferencia.

`ISNULL(a, b)` hace algo parecido con solo dos valores; `COALESCE` es estándar y acepta varios.

### 6. NULLIF y la división segura

Dividir entre cero detiene la consulta con un error. `NULLIF(x, 0)` devuelve `NULL` cuando `x` vale 0, y `x` en cualquier otro caso. Como cualquier operación con `NULL` da `NULL`, `a / NULLIF(b, 0)` da `NULL` en lugar de error cuando `b` es 0.

¿Por qué `NULL` y no 0? Porque "no se puede calcular" no es lo mismo que "vale cero". Un ratio de 0 diría algo falso sobre el negocio.

---

## 💡 Pistas

### Ejercicio 1 · Clientes sin correo

<details><summary>Pista 1</summary>

Paso 3: la condición es "el correo falta". ¿Qué operador pregunta si un valor falta?
</details>

<details><summary>Pista 2</summary>

`= NULL` nunca es verdadero. Usa `IS NULL`.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT COUNT(*) AS ____
INTO #respuesta
FROM core.cliente
WHERE ____ ____;
```
</details>

### Ejercicio 2 · Clientes sin ningún dato de contacto

<details><summary>Pista 1</summary>

"Sin ningún dato de contacto" = sin correo **y** sin celular. Piensa si es `AND` u `OR`.
</details>

<details><summary>Pista 2</summary>

Dos condiciones `IS NULL`, una por columna.
</details>

<details><summary>Pista 3</summary>

```sql
WHERE ____ IS NULL ____ ____ IS NULL
```
</details>

### Ejercicio 3 · Lista de contacto para la bienvenida

<details><summary>Pista 1</summary>

Paso 5: la columna `contacto` se arma con una regla de preferencia. La función que "elige el primero que no falte" es la del concepto 5.
</details>

<details><summary>Pista 2</summary>

`COALESCE` con tres argumentos: dos columnas y un texto. Para las fechas de alta, `fecha_alta` es `DATE`: usa un rango semiabierto de todas formas.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT cliente_id, COALESCE(____, ____, ____) AS contacto
INTO #respuesta
FROM core.cliente
WHERE fecha_alta >= ____ AND fecha_alta < ____;
```
</details>

### Ejercicio 4 · Beneficio para quienes no vinieron de los embajadores

<details><summary>Pista 1</summary>

¿Qué valor tiene `cliente_referidor_id` para un cliente que llegó solo, sin que nadie lo invite? ¿Ese cliente debe recibir el beneficio?
</details>

<details><summary>Pista 2</summary>

`NOT IN` deja fuera las filas con `NULL` (concepto 3). Tienes que agregarlas de vuelta con otra condición unida por `OR`.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT COUNT(*) AS total_clientes
INTO #respuesta
FROM core.cliente
WHERE cliente_referidor_id ____ (____, ____) OR ____;
```
</details>

### 🏋️ Reto final · ¿Cuánto venden los comercios por cada sol de comisión?

<details><summary>Pista 1</summary>

Paso 4: hay que resumir **por comercio**. Paso 3: solo operaciones aprobadas en soles. Paso 5: el ratio es facturación entre comisión, y hay comercios que no pagan comisión.
</details>

<details><summary>Pista 2</summary>

`GROUP BY comercio_id`, `SUM` para facturación y comisión, y `NULLIF` en el denominador para no dividir entre cero.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT comercio_id,
       SUM(____) AS facturacion,
       SUM(____) AS comision_total,
       SUM(____) / NULLIF(____, 0) AS soles_por_sol_comision
INTO #respuesta
FROM core.transaccion
WHERE ____
GROUP BY ____;
```
</details>

---

## ⚠️ Errores comunes

1. **`Msg 8134 — Divide by zero error encountered.`**
   Algún denominador vale 0 en al menos una fila o grupo, y la consulta completa se detiene. Protege el denominador con `NULLIF(..., 0)`.

2. **Sin mensaje de error, pero el resultado es 0 o está vacío.**
   Usaste `= NULL` o `<> NULL`. Esas comparaciones son siempre desconocidas. Usa `IS NULL` o `IS NOT NULL`.

3. **Sin mensaje de error, pero faltan filas.**
   Un `NOT IN`, un `<>` o un `NOT LIKE` sobre una columna con nulos dejó fuera esas filas. Pregúntate si deberían estar y, si es así, agrégalas con `OR columna IS NULL`.

---

## 🚀 Nivel pro (opcional)

1. ¿Qué devuelven `CONCAT('Ana', NULL, 'Pérez')` y `'Ana' + NULL + 'Pérez'`? Pruébalo y piensa cuál conviene para armar nombres completos con `apellido_materno`, que puede ser nulo.
2. Calcula en una sola consulta, para toda la tabla de clientes, el porcentaje de filas con `correo`, con `celular` y con `fecha_nacimiento`, usando solo `COUNT(*)` y `COUNT(columna)`. Es tu primer "perfil de calidad de datos" (lo harás a fondo en S15).

---

## 🧱 Avance del proyecto

En [proyecto/consultas.sql](../../proyecto/consultas.sql), bajo la **pregunta 4** (clientes que se registran y no usan la billetera), escribe una consulta que cuente cuántos clientes tienen correo, cuántos tienen celular y cuántos no tienen ninguno de los dos.

En [proyecto/hallazgos.md](../../proyecto/hallazgos.md) anota los números y una reflexión de 2 líneas: si un cliente se registra y nunca paga, ¿por qué medio podría contactarlo PayMarket para reactivarlo? ¿A cuántos no podría contactar?

**Por qué lo haría un analista:** antes de proponer una campaña de reactivación, hay que saber si se puede llegar a esos clientes. Un plan sin canal de contacto no sirve.

**Cómo debe verse:** una consulta comentada y un párrafo corto con tus números.

---

## ✅ Cierre

- [x] Puedo explicar por qué `WHERE correo = NULL` no devuelve filas.
- [x] Puedo predecir qué pasa con las filas nulas en un `NOT IN` y cómo incluirlas.
- [x] Sé la diferencia entre `COUNT(*)` y `COUNT(columna)`.
- [x] Puedo usar `COALESCE` con un orden de preferencia y justificar cuándo reemplazar un nulo.
- [x] Puedo dividir sin errores con `NULLIF` y explicar por qué el resultado es `NULL` y no 0.
- [x] Superé los verificadores de la sesión (`EXEC chk.ver_progreso 'S03';`).

```bash
git add .
git commit -m "S03: nulos, datos de contacto y división segura"
```
