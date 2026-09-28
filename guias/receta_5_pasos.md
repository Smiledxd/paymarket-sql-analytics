# La receta de 5 pasos

> Imprime esta hoja y tenla al lado cuando practiques. Cuando te quedes en blanco, no empieces por el `SELECT`: empieza por el paso 1.

## Los pasos

| # | Pregunta | Qué escribes | Cláusula |
|---|---|---|---|
| 1 | **¿Qué me piden?** | Reformula la pregunta en una frase y **dibuja la tabla de respuesta**: qué columnas tiene y qué representa cada fila | — |
| 2 | **¿Dónde está la información?** | Qué tablas necesitas y cómo se conectan | `FROM` / `JOIN` |
| 3 | **¿Qué filas sirven?** | Las condiciones que debe cumplir cada fila **antes** de resumir | `WHERE` |
| 4 | **¿Hay que resumir "por algo"?** | Por cliente, por mes, por comercio… ¿Y hay que filtrar ese resumen? | `GROUP BY` / `HAVING` |
| 5 | **¿Qué muestro y en qué orden?** | Las columnas finales, sus alias y el orden | `SELECT` / `ORDER BY` |

## Por qué funciona

SQL Server no lee tu consulta en el orden en que la escribes. La procesa en este **orden lógico**:

```
1. FROM / JOIN   →  2. WHERE  →  3. GROUP BY  →  4. HAVING  →  5. SELECT  →  6. ORDER BY
```

Escribes el `SELECT` primero, pero SQL Server lo resuelve casi al final. Si tú también empiezas por el `SELECT`, intentas decidir qué mostrar antes de saber de dónde salen los datos, y ahí es donde uno se queda en blanco. La receta sigue el orden de SQL Server.

Dos consecuencias prácticas del orden lógico:

- En el `WHERE` **no** puedes usar un alias que definiste en el `SELECT` (el `SELECT` todavía no ocurrió).
- En el `ORDER BY` **sí** puedes usarlo (ocurre después del `SELECT`).

## Señales en el enunciado

| Si el enunciado dice… | Piensa en… |
|---|---|
| "por cada…", "por mes", "por canal", "según…" | `GROUP BY` |
| "cuántos", "total", "promedio", "el mayor" | `COUNT`, `SUM`, `AVG`, `MAX` |
| "solo los que…", "de junio", "aprobadas" | `WHERE` |
| "grupos que tengan más de…" | `HAVING` |
| "los 10 más…", "el top" | `TOP (n)` + `ORDER BY` con desempate |
| "tasa", "porcentaje", "participación" | una división: cuidado con la división entera y con dividir entre 0 |
| datos en dos tablas distintas | `JOIN` (desde S07) |

---

## Ejemplo resuelto (de juguete)

La bodega **Don Lucho** guarda sus ventas en una tabla. Una fila = un producto vendido en una boleta.

| boleta | fecha | producto | categoria | cantidad | precio_unitario |
|---|---|---|---|---|---|
| 1 | 2026-03-02 | Gaseosa 500 ml | Bebidas | 3 | 2.50 |
| 1 | 2026-03-02 | Pan francés | Panadería | 10 | 0.30 |
| 2 | 2026-03-02 | Agua 625 ml | Bebidas | 2 | 1.50 |
| … | … | … | … | … | … |

**Pregunta de Don Lucho:** "¿Qué bebidas me dejaron más de 20 soles en marzo? Quiero ver cuánto vendí de cada una, de la que más vendió a la que menos."

**Paso 1 · ¿Qué me piden?**
"Una lista de bebidas con su venta total de marzo, solo las que pasan de S/ 20, ordenadas de mayor a menor."
Tabla de respuesta, **una fila = una bebida**:

| producto | venta_total |
|---|---|
| Gaseosa 500 ml | 45.00 |
| … | … |

**Paso 2 · ¿Dónde está?** En la tabla de ventas (una fila = un producto en una boleta). → `FROM ventas`

**Paso 3 · ¿Qué filas sirven?** Solo bebidas y solo de marzo 2026 (rango semiabierto). → `WHERE categoria = 'Bebidas' AND fecha >= '2026-03-01' AND fecha < '2026-04-01'`

**Paso 4 · ¿Resumir por algo?** Sí, **por producto**: la venta de cada uno es `SUM(cantidad * precio_unitario)`. Y hay que filtrar el resumen: solo los que pasan de 20. → `GROUP BY producto` y `HAVING SUM(cantidad * precio_unitario) > 20`

**Paso 5 · ¿Qué muestro y en qué orden?** El producto y su venta; de mayor a menor. → `SELECT producto, SUM(...) AS venta_total` y `ORDER BY venta_total DESC`

**Consulta final** (se escribe en el orden de SQL, pero la pensaste en el orden de la receta):

```sql
SELECT producto,
       SUM(cantidad * precio_unitario) AS venta_total
FROM ventas
WHERE categoria = 'Bebidas'
  AND fecha >= '2026-03-01' AND fecha < '2026-04-01'
GROUP BY producto
HAVING SUM(cantidad * precio_unitario) > 20
ORDER BY venta_total DESC;
```

**Y ahora la pregunta de negocio:** si la gaseosa vende el triple que el agua, ¿le conviene a Don Lucho tener más gaseosa en stock, o depende de cuánto gana por cada una? El resultado de la consulta es solo el comienzo de la respuesta.

---

## Buenas prácticas desde el día uno

- Nada de `SELECT *` en tus respuestas finales: elige las columnas.
- `TOP` siempre con `ORDER BY`, y con un **desempate** si puede haber empates.
- Fechas con rangos semiabiertos: `>= inicio AND < fin`.
- Alias claros en `snake_case`: `venta_total`, no `Expr1` ni `x`.
- Una cláusula por línea e indentación: el código se lee más de lo que se escribe.
