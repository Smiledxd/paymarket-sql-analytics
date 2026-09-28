# Currícula: SQL para análisis de datos con PayMarket Perú

> Curso práctico de T-SQL (SQL Server + SSMS) sobre una fintech de pagos ficticia.
> Cada sesión son dos archivos en `sesiones/SXX_nombre/`: `guia.md` (teoría, pistas y cierre) y `practica.sql` (se abre en SSMS).

---

## 0. Reglas del plan

**Meta:** resolver problemas de negocio reales con SQL sin quedarse en blanco, y terminar con un repositorio público, un dashboard en Power BI, tres publicaciones de LinkedIn y un simulacro de prueba técnica.

**Ritmo:** 2 sesiones por semana de 60 minutos exactos. Si una sesión se alarga, se termina en la siguiente antes de avanzar.

**Reglas**
- Tú escribes todo el código de análisis. No hay solucionario.
- Cada ejercicio se piensa con la [receta de 5 pasos](guias/receta_5_pasos.md) y se comprueba con su verificador (`EXEC chk.sXX_eN;`).
- Las pistas se abren en orden: idea → cláusula o función → estructura con huecos.
- Buenas prácticas desde el día uno: sin `SELECT *` en respuestas finales, `TOP` siempre con `ORDER BY`, rangos de fecha `>= inicio AND < fin`, alias claros, código indentado.

**La ficha de traducción se retira poco a poco**

| Sesiones | Ficha |
|---|---|
| S00–S06 | Guiada: algunos pasos vienen respondidos y otros con huecos |
| S07–S14 | Vacía: solo las 5 preguntas; las respondes tú en comentarios |
| S15–S25 | Sin ficha: se recuerda solo en el reto final, como opción |

---

## 1. Temario

| Módulo | # | Sesión | Contenido | Pregunta de negocio |
|---|---|---|---|---|
| 0. Bases | S00 | El mapa de la empresa | Base relacional, capas y esquemas, tablas y tipos, llave primaria y foránea, relaciones uno a muchos, leer el diagrama, explorar en SSMS, la receta y el orden lógico | ¿Qué información tiene PayMarket y cómo se conecta? |
| | S01 | SELECT con propósito | Columnas, alias, cálculos (comisión, IGV de la comisión), `DISTINCT`, `TOP` con `ORDER BY`, orden por varias columnas | ¿Cuánto ganamos por comisión en las operaciones más grandes? |
| 1. Filtrar y transformar | S02 | Filtrar las filas correctas | Comparaciones, `AND`/`OR`/`NOT` y paréntesis, `IN`, `BETWEEN`, `LIKE` | ¿Qué rechazos son por fondos insuficientes y cuáles técnicos? |
| | S03 | Los nulos a fondo | Lógica de tres valores, `IS NULL`, nulos en comparaciones y en `NOT IN`, `COALESCE`, `NULLIF`, división segura | ¿Cuántos clientes no tienen datos de contacto? |
| | S04 | Texto y fechas | `CONCAT`, `TRIM`, `UPPER`, `LEFT`, `SUBSTRING`, `REPLACE`, `CAST`/`CONVERT`/`TRY_CAST`; `DATEADD`, `DATEDIFF`, `EOMONTH`, `DATEFROMPARTS`, rangos semiabiertos; por qué evitar `FORMAT` | ¿Cuántos clientes cumplen años este mes? ¿Qué pasó la última semana? |
| 2. Resumir | S05 | Resumir el negocio | `COUNT(*)` vs `COUNT(col)` vs `COUNT(DISTINCT)`, `SUM`, `AVG` (y el promedio entero), `MIN`/`MAX`, `GROUP BY`; KPIs: volumen, facturación, ticket promedio | ¿Cuánto factura cada canal y cuál es su ticket promedio? |
| | S06 | Segmentar | `WHERE` vs `HAVING`, `CASE` simple y buscado, conteo condicional con `SUM(CASE ...)`, tasas, tablas cruzadas | ¿Qué canal tiene la mejor tasa de aprobación? |
| 3. Relacionar tablas | S07 | INNER JOIN | Por qué los datos se separan en tablas, unir 2, 3 y 4 tablas, alias de tabla, convertir dólares a soles con `tipo_cambio` | ¿Qué rubros y departamentos facturan más? |
| | S08 | LEFT JOIN | Filas sin pareja, anti-join, `ON` vs `WHERE` en un `LEFT JOIN`, duplicación de filas al unir (fan-out) y cómo detectarla | ¿Qué clientes se registraron y nunca pagaron nada? |
| | S09 | UNION, EXISTS y self-join | `UNION` vs `UNION ALL`, `EXISTS`/`NOT EXISTS`, unir una tabla consigo misma (referidos) | ¿Los clientes referidos gastan más que los orgánicos? → **Post 1** |
| 4. Pensar en pasos | S10 | Subconsultas | Escalares, en `WHERE` con `IN`/`EXISTS`, correlacionadas, tablas derivadas | ¿Qué comercios venden por encima del promedio de su rubro? |
| | S11 | CTEs | `WITH`, encadenar pasos, legibilidad, construir un análisis por etapas | Pipeline: actividad por cliente → segmento → resumen |
| 5. Funciones de ventana | S12 | Rankings | `OVER`, `PARTITION BY`, `ROW_NUMBER`, `RANK`, `DENSE_RANK`, top N por grupo | ¿Cuáles son los 3 comercios líderes de cada departamento? |
| | S13 | Comparar en el tiempo | `LAG`, `LEAD`, variación mes a mes y año contra año, días entre operaciones de un cliente | ¿Cómo cambió la facturación mes a mes? |
| | S14 | Acumulados y participación | `SUM() OVER`, `ROWS BETWEEN`, promedio móvil, porcentaje del total, curva de Pareto | ¿Qué porcentaje de comercios genera el 80 % de los ingresos? → **Post 2** |
| 6. Calidad de datos | S15 | Diagnosticar | Perfilar `stg`: nulos por columna, duplicados, formatos inválidos, valores fuera de rango, huérfanos | ¿Podemos confiar en la exportación del sistema antiguo? |
| | S16 | Limpiar | Estandarizar texto, `TRY_CONVERT` de fechas y decimales, deduplicar con `ROW_NUMBER`, reglas de validación, tabla de cuarentena | ¿Qué registros se pueden rescatar y cuáles no? |
| | S17 | Cargar y cuadrar | `INSERT ... SELECT` en `lab`, `UPDATE`/`DELETE` seguros, `BEGIN TRAN`/`COMMIT`/`ROLLBACK`, `TRY...CATCH`, conciliación de totales contra `core` | ¿Cuadran los totales del archivo POS con los del sistema? |
| 7. Modelado | S18 | Modelado dimensional | Transaccional vs analítico, hechos y dimensiones, grano, llaves sustitutas, estrella vs copo de nieve; `CREATE TABLE` con restricciones | ¿Cómo organizamos los datos para que gerencia los consulte fácil? |
| | S19 | Construir la estrella | Dimensión fecha, poblar dimensiones y la tabla de hechos desde `core`, validar conteos y totales | ¿El modelo cuadra con el sistema de origen? |
| | S20 | Reporte y rendimiento | `CREATE VIEW` en `rpt`, índices explicados con intuición, plan de ejecución, filtros que usan índices y filtros que no | ¿Por qué esta consulta tarda y cómo se acelera? |
| 8. Casos y BI | S21 | Caso créditos | Días de atraso, clasificación SBS, mora 30+, análisis por cosecha (mes de desembolso) | ¿Qué cosechas de crédito se portan peor y desde cuándo? |
| | S22 | Caso clientes | Cohortes de retención mensual, segmentación RFM con `NTILE`, clientes en riesgo de abandono | ¿Qué clientes debemos intentar retener primero? |
| | S23 | Dashboard en Power BI | Conectar a las vistas de `rpt`, relaciones, 3 o 4 medidas DAX simples (`SUM`, `DIVIDE`, `CALCULATE` básico), tablero de una página | ¿Qué ve la gerencia cada lunes? |
| 9. Cierre | S24 | Simulacro | Prueba técnica de 60 minutos con preguntas nuevas, sobre 20 puntos, calificada por `chk.simulacro_resultado` | — |
| | S25 | Publicación | README final, hallazgos, capturas, repositorio público, **Post 3** | — |

**Estado de construcción del curso:** las sesiones S00 a S04 están listas (fase A). Las siguientes se agregan por fases; al recibir sesiones nuevas ejecuta `.\base\instalar.ps1 -ActualizarVerificadores` (no borra lo que creaste).

---

## 2. Hitos del proyecto y publicaciones

| Hito | Sesiones | Qué se agrega a `proyecto/` |
|---|---|---|
| P0 | S00–S04 | Tablas necesarias por pregunta y primeras consultas exploratorias (tasas, rechazos, contacto, estacionalidad por día) |
| P1 | S05–S09 | KPIs por canal y rubro, clientes que nunca pagaron, referidos vs orgánicos → 📣 **Post 1** |
| P2 | S10–S14 | Comercios sobre su rubro, evolución mensual, Pareto de comercios → 📣 **Post 2** |
| P3 | S15–S20 | Calidad de datos, conciliación POS, modelo estrella y vistas `rpt` |
| P4 | S21–S25 | Mora por cosecha, retención por cohorte, dashboard, recomendaciones → 📣 **Post 3 + repositorio público** |

Los posts los escribes tú, con un hallazgo concreto que hayas calculado y la aclaración de que los datos son simulados.

---

## 3. Progreso

Fechas propuestas: martes y jueves. Ajústalas a tu semana.

| Sesión | Fecha objetivo | Hecha | Notas |
|---|---|---|---|
| S00 | mar 29/9 | ☐ | |
| S01 | jue 1/10 | ☐ | |
| S02 | mar 6/10 | ☐ | |
| S03 | jue 8/10 | ☐ | |
| S04 | mar 13/10 | ☐ | |
| S05 | jue 15/10 | ☐ | |
| S06 | mar 20/10 | ☐ | |
| S07 | jue 22/10 | ☐ | |
| S08 | mar 27/10 | ☐ | |
| S09 | jue 29/10 | ☐ | Post 1 |
| S10 | mar 3/11 | ☐ | |
| S11 | jue 5/11 | ☐ | |
| S12 | mar 10/11 | ☐ | |
| S13 | jue 12/11 | ☐ | |
| S14 | mar 17/11 | ☐ | Post 2 |
| S15 | jue 19/11 | ☐ | |
| S16 | mar 24/11 | ☐ | |
| S17 | jue 26/11 | ☐ | |
| S18 | mar 1/12 | ☐ | |
| S19 | jue 3/12 | ☐ | |
| S20 | mar 8/12 | ☐ | |
| S21 | jue 10/12 | ☐ | |
| S22 | mar 15/12 | ☐ | |
| S23 | jue 17/12 | ☐ | Dashboard |
| S24 | mar 22/12 | ☐ | Simulacro |
| S25 | jue 24/12 | ☐ | Post 3 + repositorio público |
