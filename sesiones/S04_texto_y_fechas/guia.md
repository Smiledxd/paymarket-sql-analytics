# S04 · Texto y fechas

> **Pregunta de negocio del día:** ¿Cuántos clientes cumplen años este mes? ¿Qué pasó la última semana?

| | |
|---|---|
| **Duración** | 60 minutos |
| **Antes de empezar** | S02 (rangos de fecha semiabiertos) y S03 (nulos) |
| **Archivos** | Esta guía + [practica.sql](practica.sql) |

**Objetivos**
1. Armar y limpiar texto con `CONCAT`, `UPPER`, `TRIM`, `LEFT`, `SUBSTRING`, `CHARINDEX` y `REPLACE`.
2. Convertir tipos con `CAST`, `CONVERT` y `TRY_CAST`, y saber cuándo usar cada uno.
3. Calcular fechas relativas a "hoy" con `DATEADD`, `DATEDIFF`, `EOMONTH` y `DATEFROMPARTS`.
4. Construir rangos semiabiertos para "la última semana" o "el mes pasado".
5. Explicar por qué `FORMAT` no se usa para analizar.

**Plan de la sesión**

| Minutos | Qué haces |
|---|---|
| 0–12 | Conceptos y ejemplos de juguete |
| 12–45 | Ejercicios 1 a 4 |
| 45–55 | Reto final |
| 55–60 | Cierre y commit |

---

## 📘 Conceptos

### 1. "Hoy" en PayMarket es el 30 de junio de 2026

Los datos terminan el 30/06/2026 (la fecha de corte). Si usaras `GETDATE()`, "la última semana" sería una semana sin datos. Por eso, en esta sesión, "hoy" se declara al inicio de cada bloque:

```sql
DECLARE @hoy DATE = '2026-06-30';
```

Una variable vive **solo dentro de su lote** (el bloque que termina en `GO`) y solo si ejecutas también la línea del `DECLARE`. Si seleccionas únicamente tu consulta y presionas F5, SQL Server no conoce `@hoy` (error 137).

### 2. Texto: armar, cortar y limpiar

| Función | Qué hace | Ejemplo | Resultado |
|---|---|---|---|
| `CONCAT(a, b, ...)` | Une textos; trata `NULL` como vacío | `CONCAT('Ana', ' ', NULL)` | `'Ana '` |
| `a + b` | También une, pero si uno es `NULL`, todo es `NULL` | `'Ana' + NULL` | `NULL` |
| `UPPER` / `LOWER` | Mayúsculas / minúsculas | `UPPER('Pérez')` | `'PÉREZ'` |
| `TRIM` / `LTRIM` / `RTRIM` | Quita espacios de los extremos | `TRIM('  hola ')` | `'hola'` |
| `LEN` | Largo del texto (sin espacios finales) | `LEN('Lima')` | `4` |
| `LEFT(t, n)` / `RIGHT(t, n)` | Primeros / últimos n caracteres | `LEFT('150132', 2)` | `'15'` |
| `CHARINDEX(buscar, t)` | Posición de un texto dentro de otro (0 si no está) | `CHARINDEX('-', 'AB-12')` | `3` |
| `SUBSTRING(t, inicio, n)` | n caracteres desde la posición `inicio` | `SUBSTRING('AB-12', 4, 2)` | `'12'` |
| `REPLACE(t, a, b)` | Reemplaza todas las apariciones de `a` por `b` | `REPLACE('12,50', ',', '.')` | `'12.50'` |

`CHARINDEX` y `SUBSTRING` juntos sirven para cortar "desde un caracter en adelante", aunque ese caracter esté en posiciones distintas en cada fila.

### 3. Convertir tipos: CAST, CONVERT y TRY_CAST

- `CAST(x AS tipo)` convierte, y **falla** si no puede: `CAST('abc' AS INT)` detiene la consulta.
- `CONVERT(tipo, x, estilo)` hace lo mismo y además acepta un **estilo** para fechas: `CONVERT(DATE, '31/12/2025', 103)` entiende el formato día/mes/año.
- `TRY_CAST(x AS tipo)` y `TRY_CONVERT` devuelven `NULL` en lugar de fallar. Son ideales para datos sucios (los usarás mucho en S16): después cuentas cuántos `NULL` salieron para saber cuántos datos no se pudieron convertir.
- `CAST(fecha_hora AS DATE)` le quita la hora a una fecha: útil para agrupar por día.

### 4. Fechas: partes, sumas y diferencias

| Función | Qué hace | Ejemplo | Resultado |
|---|---|---|---|
| `YEAR`, `MONTH`, `DAY` | Extraen una parte (como número) | `MONTH('2026-06-30')` | `6` |
| `DATEADD(parte, n, fecha)` | Suma n días, meses, años… (n puede ser negativo) | `DATEADD(month, 1, '2026-01-31')` | `2026-02-28` |
| `DATEDIFF(parte, desde, hasta)` | Cuántos **límites** de esa parte hay entre dos fechas | `DATEDIFF(day, '2026-06-01', '2026-06-30')` | `29` |
| `EOMONTH(fecha)` | Último día del mes | `EOMONTH('2026-02-10')` | `2026-02-28` |
| `DATEFROMPARTS(a, m, d)` | Arma una fecha con sus partes | `DATEFROMPARTS(2026, 5, 1)` | `2026-05-01` |

Dos detalles que causan errores:
- `DATEADD(month, 1, ...)` suma un **mes calendario**, no 30 días: del 31 de enero pasa al 28 de febrero.
- `DATEDIFF` cuenta **límites cruzados**, no periodos completos: `DATEDIFF(year, '2025-12-31', '2026-01-01')` da 1 aunque pasó un solo día. Y el orden importa: `DATEDIFF(day, desde, hasta)`; al revés da negativo.

### 5. Rangos relativos a hoy

La receta es siempre la misma: calcula el **inicio** (incluido) y el **inicio del periodo siguiente** (excluido), y usa `>=` y `<`.

- Antes de escribir, anota en un papel el primer y el último día que deben entrar, y cuéntalos con los dedos. Es muy fácil tomar un día de más o de menos.
- Si la columna tiene hora, el fin excluido es el **día siguiente** al último día que quieres, a las 00:00.
- Evita escribir las fechas a mano cuando dependen de "hoy": si mañana cambia `@hoy`, tu consulta debe seguir funcionando.

Ejemplo, "lo que va del mes" (del día 1 del mes de hoy hasta hoy, completo):

```sql
fecha_hora >= DATEFROMPARTS(YEAR(@hoy), MONTH(@hoy), 1)
AND fecha_hora < DATEADD(day, 1, @hoy)
```

### 6. FORMAT: bonito para mostrar, malo para analizar

`FORMAT(fecha_hora, 'dd/MM/yyyy')` devuelve **texto**. Eso trae tres problemas en un análisis:
1. El texto se ordena como texto: `'01/07/2025'` queda antes que `'15/01/2025'`.
2. Ya no puedes restar fechas ni usar `DATEADD`.
3. Es mucho más lento que las funciones de fecha (en 300 mil filas se nota).

Usa `FORMAT` solo al final, para presentar. Para agrupar por día usa `CAST(... AS DATE)`; por mes, `YEAR` y `MONTH` o `DATEFROMPARTS`.

---

## 💡 Pistas

### Ejercicio 1 · Etiquetas de bienvenida

<details><summary>Pista 1</summary>

Son dos columnas calculadas. Una junta tres piezas (apellido en mayúsculas, `', '`, nombres). La otra corta el correo desde la arroba.
</details>

<details><summary>Pista 2</summary>

`CONCAT` + `UPPER` para la etiqueta. Para el dominio, `CHARINDEX('@', correo)` te da la posición de la arroba y `SUBSTRING` corta desde la posición siguiente.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT cliente_id,
       CONCAT(____(apellido_paterno), ____, nombres) AS etiqueta,
       SUBSTRING(correo, CHARINDEX(____, correo) + ____, 100) AS dominio_correo
INTO #respuesta
FROM core.cliente
WHERE fecha_alta = ____;
```
</details>

### Ejercicio 2 · Cumpleañeros de Cusco este mes

<details><summary>Pista 1</summary>

Paso 3: tres condiciones: estado, departamento (el código de Cusco está en `core.ubigeo`) y mes de nacimiento igual al mes de `@hoy`.
</details>

<details><summary>Pista 2</summary>

`LEFT(ubigeo_id, 2)` da el código del departamento. `MONTH` extrae el mes de cualquier fecha, también de `@hoy`. La edad que cumplen es una resta de años.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT cliente_id, fecha_nacimiento, ____(@hoy) - ____(fecha_nacimiento) AS edad_que_cumple
INTO #respuesta
FROM core.cliente
WHERE estado = ____
  AND LEFT(____, 2) = ____
  AND MONTH(____) = MONTH(____);
```
</details>

### Ejercicio 3 · ¿Qué pasó la última semana?

<details><summary>Pista 1</summary>

Escribe en un papel los 7 días: del 24 al 30 de junio. ¿Cuántos días hay que restarle a `@hoy` para llegar al 24? ¿Y cuál es el primer instante que ya **no** entra?
</details>

<details><summary>Pista 2</summary>

Inicio: `DATEADD(day, ____, @hoy)`. Fin excluido: `DATEADD(day, 1, @hoy)`, que es el 1 de julio a las 00:00.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT COUNT(*) AS total_operaciones, SUM(monto) AS monto_total
INTO #respuesta
FROM core.transaccion
WHERE ____ AND ____
  AND fecha_hora >= DATEADD(day, ____, @hoy)
  AND fecha_hora < ____;
```
</details>

### Ejercicio 4 · Créditos del mes pasado

<details><summary>Pista 1</summary>

Primero calcula, a partir de `@hoy`, el primer día del mes pasado. Después, el primer día que ya no entra.
</details>

<details><summary>Pista 2</summary>

`DATEADD(month, -1, @hoy)` cae en el mes pasado; con `YEAR`, `MONTH` y `DATEFROMPARTS` armas su día 1. `EOMONTH` te da su último día. Las otras dos columnas son un `DATEDIFF` y un `DATEADD`.
</details>

<details><summary>Pista 3</summary>

```sql
DECLARE @inicio DATE = DATEFROMPARTS(____, ____, 1);

SELECT credito_id, fecha_desembolso,
       DATEDIFF(day, ____, ____) AS dias_desde_desembolso,
       DATEADD(____, 1, fecha_desembolso) AS fecha_primera_cuota
INTO #respuesta
FROM core.credito
WHERE fecha_desembolso >= @inicio
  AND fecha_desembolso < DATEADD(day, 1, ____);
```
</details>

### 🏋️ Reto final · La última semana, día por día

<details><summary>Pista 1</summary>

Es el ejercicio 3, pero con una fila por día (paso 4: resumir **por fecha**). La columna de fin de mes compara cada fecha con el último día de su mes.
</details>

<details><summary>Pista 2</summary>

Agrupa por `CAST(fecha_hora AS DATE)`. Para `es_fin_de_mes` usa `CASE WHEN ... = EOMONTH(...) THEN 1 ELSE 0 END`, y recuerda que todo lo que está en el `SELECT` sin función de resumen debe estar en el `GROUP BY`.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT CAST(fecha_hora AS DATE) AS fecha,
       COUNT(*) AS operaciones,
       SUM(monto) AS monto_total,
       CASE WHEN ____ = EOMONTH(____) THEN 1 ELSE 0 END AS es_fin_de_mes
INTO #respuesta
FROM core.transaccion
WHERE ____
GROUP BY ____, ____;
```
</details>

---

## ⚠️ Errores comunes

1. **`Msg 137 — Must declare the scalar variable "@hoy".`**
   Ejecutaste tu consulta sin la línea del `DECLARE`, o el `DECLARE` quedó en otro lote (antes de un `GO`). Selecciona el bloque completo, desde el `DECLARE`, y ejecuta.

2. **`Msg 537 — Invalid length parameter passed to the LEFT or SUBSTRING function.`**
   El largo que calculaste es negativo. Suele pasar cuando `CHARINDEX` no encuentra lo que busca (devuelve 0) y a eso le restas algo. Revisa si todas las filas tienen el caracter que buscas.

3. **`Msg 245 — Conversion failed when converting the varchar value '...' to data type int.`**
   Mezclaste texto y número con `+` (SQL Server intenta sumar) o convertiste un texto que no es número. Para unir textos usa `CONCAT`; para convertir datos dudosos, `TRY_CAST`.

---

## 🚀 Nivel pro (opcional)

Tu servidor es SQL Server 2022 o superior, así que puedes probar funciones nuevas:

1. `GENERATE_SERIES(0, 6)` genera los números del 0 al 6. Úsalo con `DATEADD` para producir las 7 fechas de la última semana, **aunque algún día no tuviera operaciones**. ¿Por qué eso importa en un reporte diario?
2. `DATETRUNC(month, fecha_hora)` devuelve el primer instante del mes de cada fecha. Compara el tiempo que tarda agrupar 300 mil operaciones por `DATETRUNC(month, fecha_hora)` contra agruparlas por `FORMAT(fecha_hora, 'yyyy-MM')` (activa *Include Client Statistics* en SSMS o usa `SET STATISTICS TIME ON`).

---

## 🧱 Avance del proyecto

En [proyecto/consultas.sql](../../proyecto/consultas.sql), bajo la **pregunta 1** (evolución y estacionalidad), escribe una consulta que cuente las operaciones aprobadas por **día del mes** (1 al 31) para todo el periodo, ordenadas por día.

En [proyecto/hallazgos.md](../../proyecto/hallazgos.md) anota qué días destacan y una hipótesis de por qué (piensa en cuándo cobra la gente en Perú). Ojo con el día 31: no todos los meses lo tienen, así que compararlo directamente con los demás sería injusto. Anota cómo lo corregirías más adelante.

**Por qué lo haría un analista:** si el negocio tiene días pico, operaciones y tecnología necesitan saberlo para reforzar servidores y atención al cliente.

**Cómo debe verse:** una consulta comentada, una observación con números y una hipótesis marcada como hipótesis.

---

## ✅ Cierre

- [x] Puedo armar un texto con `CONCAT` y explicar en qué se diferencia de `+` con nulos.
- [x] Puedo cortar un texto desde un caracter con `CHARINDEX` y `SUBSTRING`.
- [x] Sé cuándo usar `TRY_CAST` en lugar de `CAST`.
- [x] Puedo construir "los últimos 7 días" y "el mes pasado" como rangos semiabiertos a partir de `@hoy`.
- [x] Puedo explicar por qué `DATEADD(month, 1, ...)` no es lo mismo que sumar 30 días.
- [x] Puedo explicar por qué no uso `FORMAT` para agrupar.
- [x] Superé los verificadores de la sesión (`EXEC chk.ver_progreso 'S04';`).

Terminaste el módulo de filtros y transformaciones. Marca las sesiones en [CURRICULA.md](../../CURRICULA.md) y haz tu commit:

```bash
git add .
git commit -m "S04: funciones de texto y fechas, última semana y cumpleaños"
```
