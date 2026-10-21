# S06 · Segmentar

> **Pregunta de negocio del día:** ¿Qué canal tiene la mejor tasa de aprobación?

| | |
|---|---|
| **Duración** | 60 minutos |
| **Antes de empezar** | S05: `COUNT`, `SUM`, `AVG` y `GROUP BY` |
| **Archivos** | Esta guía + [practica.sql](practica.sql) |

**Objetivos**
1. Elegir entre `WHERE` y `HAVING` según si filtras filas o grupos.
2. Crear segmentos con `CASE` (simple y buscado) y entender por qué importa el orden de los `WHEN`.
3. Contar y sumar "solo los que cumplen algo" con `SUM(CASE ...)`.
4. Calcular tasas sin caer en la división entera.
5. Armar una tabla cruzada (una columna por categoría).

**Plan de la sesión**

| Minutos | Qué haces |
|---|---|
| 0–12 | Conceptos y ejemplos de juguete |
| 12–45 | Ejercicios 1 a 4 |
| 45–55 | Reto final |
| 55–60 | Cierre y commit |

---

## 📘 Conceptos

### 1. WHERE filtra filas; HAVING filtra grupos

Recuerda el orden lógico: `FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY`.

- `WHERE` trabaja **antes** de agrupar: decide qué filas entran al resumen. No puede usar `COUNT` ni `SUM`, porque todavía no hay grupos.
- `HAVING` trabaja **después** de agrupar: decide qué grupos se quedan, según sus resúmenes.

"Comercios con más de 100 ventas" es una condición sobre el grupo → `HAVING COUNT(*) > 100`. "Ventas mayores a S/ 50" es una condición sobre cada operación → `WHERE monto > 50`. Parecen iguales, pero responden preguntas distintas: "comercios cuyo ticket **promedio** supera 50" no es lo mismo que "comercios, contando solo sus ventas de más de 50".

### 2. CASE: crear una columna a partir de reglas

```sql
-- CASE buscado: cada WHEN tiene su propia condición
CASE WHEN nota >= 17 THEN 'excelente'
     WHEN nota >= 11 THEN 'aprobado'
     ELSE 'desaprobado' END

-- CASE simple: compara una columna contra valores
CASE canal_id WHEN 1 THEN 'App' WHEN 2 THEN 'Web' ELSE 'Otro' END
```

SQL Server revisa los `WHEN` **en orden** y se queda con el primero que se cumple. Si en el ejemplo pusieras primero `nota >= 11`, un 18 caería en "aprobado" y nunca llegaría a "excelente". Si ninguno se cumple y no hay `ELSE`, el resultado es `NULL`.

Para agrupar por un segmento hecho con `CASE`, repite la expresión completa en el `GROUP BY` (no puedes usar el alias: el `GROUP BY` se procesa antes que el `SELECT`).

### 3. SUM(CASE ...): contar solo lo que cumple algo

`SUM(CASE WHEN condición THEN 1 ELSE 0 END)` suma 1 por cada fila que cumple y 0 por las demás: es un **conteo condicional**. Con él puedes calcular, en una sola consulta y por grupo, cuántas operaciones fueron aprobadas y cuántas no. Cambiando el `1` por una columna (`THEN monto ELSE 0`), obtienes una **suma condicional**.

Cuidado con `COUNT(CASE WHEN ... THEN 1 ELSE 0 END)`: `COUNT` cuenta todo lo que no es `NULL`, y el `0` no es `NULL`, así que cuenta **todas** las filas. Con `COUNT` tendrías que dejar el `ELSE` fuera (así los que no cumplen quedan en `NULL`).

### 4. Tasas: parte entre total, con decimales

Una tasa es `parte / total × 100`. Si la parte y el total son enteros (como los conteos), la división es entera: 95 / 100 da 0. Por eso se escribe `100.0 * parte / total`: el `100.0` convierte la operación en decimal desde el principio.

Una tasa siempre necesita una definición clara de la parte y del total. En PayMarket, una operación se considera **aprobada** si su `codigo_respuesta` es `'00'`. Eso incluye a las extornadas, que se aprobaron y se revirtieron después. Para medir la calidad del sistema de pagos importa si se aprobó; para medir ventas, importa si se quedó aprobada.

### 5. Tabla cruzada: una columna por categoría

Poner varios `SUM(CASE ...)` en el mismo `SELECT` convierte categorías en columnas: una fila por canal y una columna por tipo de rechazo. Es la forma más legible de comparar segmentos de un vistazo, y es lo que después hará un gráfico de barras agrupadas en Power BI.

---

## 💡 Pistas

### Ejercicio 1 · Tasa de aprobación por canal

<details><summary>Pista 1</summary>

Paso 3: esta vez entran **todos** los intentos del semestre, aprobados o no. La tasa compara los aprobados contra todos.
</details>

<details><summary>Pista 2</summary>

`COUNT(*)` para los intentos, `SUM(CASE WHEN ... THEN 1 ELSE 0 END)` para los aprobados según el código de respuesta, y `100.0 *` en la tasa.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT canal_id,
       COUNT(*) AS intentos,
       SUM(CASE WHEN ____ THEN 1 ELSE 0 END) AS aprobadas,
       100.0 * ____ / ____ AS tasa_aprobacion
INTO #respuesta
FROM core.transaccion
WHERE ____
GROUP BY ____;
```
</details>

### Ejercicio 2 · Operaciones por tramo de monto

<details><summary>Pista 1</summary>

Paso 4: el "por algo" es un segmento que no existe como columna. Lo creas con `CASE`.
</details>

<details><summary>Pista 2</summary>

`CASE WHEN ... THEN 'bajo' WHEN ... THEN 'medio' ELSE 'alto' END`. Piensa el orden de los `WHEN` y los límites (`<` o `<=`). Repite el `CASE` completo en el `GROUP BY`.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT CASE WHEN monto ____ THEN 'bajo' WHEN monto ____ THEN 'medio' ELSE 'alto' END AS tramo,
       COUNT(*) AS operaciones, SUM(monto) AS facturacion
INTO #respuesta
FROM core.transaccion
WHERE ____
GROUP BY CASE WHEN ____ END;
```
</details>

### Ejercicio 3 · Comercios grandes con ticket alto

<details><summary>Pista 1</summary>

Las dos condiciones ("más de 500 operaciones" y "ticket promedio mayor a 80") hablan del comercio completo, no de cada operación.
</details>

<details><summary>Pista 2</summary>

Estado, moneda y fechas en el `WHERE`; las dos condiciones del comercio en el `HAVING`, unidas con `AND`.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT comercio_id, COUNT(*) AS operaciones, AVG(monto) AS ticket_promedio
INTO #respuesta
FROM core.transaccion
WHERE ____
GROUP BY ____
HAVING ____ AND ____;
```
</details>

### Ejercicio 4 · Tabla cruzada de rechazos por canal

<details><summary>Pista 1</summary>

Primero consulta `core.codigo_respuesta` y anota qué códigos son de cada tipo. Luego, una columna por tipo.
</details>

<details><summary>Pista 2</summary>

Tres `SUM(CASE WHEN codigo_respuesta IN (...) THEN 1 ELSE 0 END)`, uno por tipo de rechazo. No uses `COUNT` con `ELSE 0` (concepto 3).
</details>

<details><summary>Pista 3</summary>

```sql
SELECT canal_id,
       SUM(CASE WHEN codigo_respuesta IN (____) THEN 1 ELSE 0 END) AS rechazos_cliente,
       SUM(CASE WHEN codigo_respuesta IN (____) THEN 1 ELSE 0 END) AS rechazos_tecnicos,
       SUM(CASE WHEN codigo_respuesta IN (____) THEN 1 ELSE 0 END) AS rechazos_fraude
INTO #respuesta
FROM core.transaccion
WHERE ____
GROUP BY ____;
```
</details>

### 🏋️ Reto final · Tablero mensual del primer semestre

<details><summary>Pista 1</summary>

Una fila por mes. Cada columna es un conteo, una tasa o una suma condicional sobre los mismos intentos del mes.
</details>

<details><summary>Pista 2</summary>

`GROUP BY MONTH(fecha_hora)`. Tasas con `100.0 * SUM(CASE ...) / COUNT(*)`. Para la facturación: `SUM(CASE WHEN ... THEN monto ELSE 0 END)` con dos condiciones dentro del `WHEN`.
</details>

<details><summary>Pista 3</summary>

```sql
SELECT MONTH(fecha_hora) AS mes,
       COUNT(*) AS intentos,
       100.0 * SUM(CASE WHEN ____ THEN 1 ELSE 0 END) / COUNT(*) AS tasa_aprobacion,
       100.0 * SUM(CASE WHEN ____ THEN 1 ELSE 0 END) / COUNT(*) AS tasa_rechazo_tecnico,
       SUM(CASE WHEN ____ AND ____ THEN ____ ELSE 0 END) AS facturacion_pen
INTO #respuesta
FROM core.transaccion
WHERE ____
GROUP BY ____;
```
</details>

---

## ⚠️ Errores comunes

1. **`Msg 147 — An aggregate may not appear in the WHERE clause unless it is in a subquery contained in a HAVING clause or a select list...`**
   Pusiste `COUNT`, `SUM` o `AVG` en el `WHERE`. Una condición sobre un resumen va en el `HAVING`.

2. **`Msg 207 — Invalid column name 'tramo'.`** (en el `GROUP BY` o el `HAVING`)
   Usaste el alias del `SELECT` en una cláusula que se procesa antes. Repite la expresión completa.

3. **Sin mensaje de error, pero todas las tasas salen 0 o números redondos.**
   División entera. Revisa que la multiplicación por `100.0` (con punto) vaya **antes** de dividir.

---

## 🚀 Nivel pro (opcional)

1. T-SQL tiene el operador `PIVOT`, que hace tablas cruzadas con otra sintaxis. Reescribe el ejercicio 4 con `PIVOT` (necesitarás una tabla derivada; lo verás en S10) y decide cuál te parece más legible.
2. `IIF(condición, valor_si, valor_no)` es un atajo para un `CASE` de dos ramas. ¿En qué ejercicio de hoy lo usarías?

---

## 🧱 Avance del proyecto

En [proyecto/consultas.sql](../../proyecto/consultas.sql), bajo la **pregunta 3**, escribe una tabla cruzada con una fila **por canal y por mes** de todo el periodo (enero 2025 a junio 2026), con los intentos y las tasas de rechazo del cliente, técnico y por fraude.

En [proyecto/hallazgos.md](../../proyecto/hallazgos.md) anota qué canal rechaza más por cada tipo. Mira también si algún mes se sale de lo normal en algún canal: si encuentras algo, descríbelo con sus números y déjalo marcado para investigarlo mejor en S13.

**Por qué lo haría un analista:** una tasa promedio de todo el periodo puede esconder un problema de pocas semanas. Separar por canal y por mes es la forma más simple de encontrarlo.

**Cómo debe verse:** una consulta comentada (72 filas) y un párrafo con lo que observas.

---

## ✅ Cierre

- [x] Puedo explicar con un ejemplo cuándo una condición va en `WHERE` y cuándo en `HAVING`.
- [x] Puedo escribir un `CASE` buscado y explicar por qué importa el orden de los `WHEN`.
- [x] Sé contar con `SUM(CASE ...)` y por qué `COUNT(... ELSE 0)` cuenta todo.
- [x] Puedo calcular una tasa con decimales y definir claramente la parte y el total.
- [x] Superé los verificadores de la sesión (`EXEC chk.ver_progreso 'S06';`).

```bash
git add .
git commit -m "S06: segmentos con CASE, tasas de aprobación y tabla cruzada de rechazos"
```
