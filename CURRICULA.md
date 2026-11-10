# Currícula: SQL para análisis de datos con PayMarket Perú

> Curso práctico de T-SQL (SQL Server + SSMS) sobre una fintech de pagos ficticia.
> Cada sesión son dos archivos en `sesiones/SXX_nombre/`: `guia.md` (teoría, pistas y cierre) y `practica.sql` (se abre en SSMS).

---

## 0. Reglas del plan

**Meta:** resolver problemas de negocio reales con SQL sin quedarse en blanco, y terminar con un repositorio público, un dashboard en Power BI, tres publicaciones de LinkedIn y un simulacro de prueba técnica.

**Ritmo:** hasta 2 sesiones por semana, con un **techo de 1 hora** cada una. Al llegar al techo se para, aunque falte: lo demás sigue en la siguiente sesión. Terminar no es la meta; entender sí.

**Límites de cada sesión (desde R09):** máximo 2 temas nuevos, 3 ejercicios obligatorios y 1 opcional. Tiempo de referencia: 35 a 45 minutos. Si sigues trabado 15 minutos después de la pista 3, marcas ⏭️ y pasas al siguiente ejercicio. Cada sesión termina con un registro de tiempos, y si una pasa del techo, la siguiente lleva menos carga.

**Reglas**
- Tú escribes todo el código de análisis. No hay solucionario.
- Cada ejercicio se piensa con la [receta de 5 pasos](guias/receta_5_pasos.md) y se comprueba con su verificador (`EXEC chk.sXX_eN;`).
- Las pistas se abren en orden: idea → cláusula o función → estructura con huecos.
- Buenas prácticas desde el día uno: sin `SELECT *` en respuestas finales, `TOP` siempre con `ORDER BY`, rangos de fecha `>= inicio AND < fin`, alias claros, código indentado.

**La ficha de traducción se retira poco a poco**

| Sesiones | Ficha |
|---|---|
| S00–S14 | Guiada: preguntas concretas con huecos para pensar el ejercicio |
| S15–S20 | Más corta: solo las preguntas clave |
| S21–S25 | Sin ficha: se recuerda solo en el reto final, como opción |

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
| | S09a | UNION y EXISTS | `UNION` vs `UNION ALL`, `EXISTS`/`NOT EXISTS` | ¿Qué clientes estuvieron activos este mes? |
| | R09 | Repaso | Cuándo usar `JOIN`, `LEFT JOIN` o `NOT EXISTS`; `ON` vs `WHERE`; cómo se lee un `NOT EXISTS` | ¿Qué clientes dejaron de pagar? |
| | S09b | Self-join | Unir una tabla consigo misma (referidos) | ¿Quién invitó a cada cliente nuevo? |
| | S09c | Reto del módulo | `COUNT(DISTINCT CASE ...)` por capas y consulta armada por etapas | ¿Los clientes referidos gastan más que los orgánicos? → **Post 1** |
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
| 10. Nube (opcional) | AZ1 | Crear la base gratis | Qué es Azure SQL Database, servidor lógico y serverless, pausa automática, qué consume los segundos de vCore, crear la base en el nivel gratis con pausa al llegar al límite | ¿Por qué una fintech no guarda su base en la laptop del analista? |
| | AZ2 | Seguridad básica | Firewall solo con tu IP, usuario de solo lectura para las vistas de `rpt`, qué nunca subir al repositorio | ¿Quién debe poder ver qué? |
| | AZ3 | Migrar y comprobar | Cargar los datos en la base gratis ya creada, comparar conteos y totales contra la base local, respaldo `.bacpac` probado | ¿Llegó todo? ¿Cómo lo demuestro? |
| | AZ4 | Power BI en la nube | Cambiar la fuente del dashboard, Import vs DirectQuery, ver los segundos restantes y crear una alerta | ¿Qué conviene para no agotar el límite? |
| 9. Cierre | S25 | Publicación | README final con el diagrama local → Azure → Power BI, hallazgos, capturas, repositorio público, **Post 3** | — |

**Módulo de nube (opcional):** va entre S24 y S25 y se construye justo antes de hacerlo. Azure se activa recién en enero de 2027, sin tarjeta y sin pasar a pago por uso. Antes de crear la base, confirma que tu oferta no sea "Azure for Students Starter", porque esa no admite el nivel gratis. El objetivo es usar la nube, documentarla con capturas y saber explicar las decisiones; no hace falta mantenerla. Si no se puede activar o falta tiempo, el curso sigue sin él: tu base local nunca se apaga.

**Estado de construcción del curso:** las sesiones S00 a S09c están listas (fases A y B). Las sesiones de S10 en adelante se construyen con los límites de arriba, y las más pesadas se parten en dos. Al recibir sesiones nuevas ejecuta `.\base\instalar.ps1 -ActualizarVerificadores` (no borra lo que creaste).

**Hojas de apoyo:** [glosario de palabras financieras](guias/glosario_paymarket.md), [repaso de JOIN](guias/repaso_joins.md) y [receta de 5 pasos](guias/receta_5_pasos.md).

---

## 2. Hitos del proyecto y publicaciones

| Hito | Sesiones | Qué se agrega a `proyecto/` |
|---|---|---|
| P0 | S00–S04 | Tablas necesarias por pregunta y primeras consultas exploratorias (tasas, rechazos, contacto, estacionalidad por día) |
| P1 | S05–S09c | KPIs por canal y rubro, clientes que nunca pagaron, referidos vs orgánicos → 📣 **Post 1** |
| P2 | S10–S14 | Comercios sobre su rubro, evolución mensual, Pareto de comercios → 📣 **Post 2** |
| P3 | S15–S20 | Calidad de datos, conciliación POS, modelo estrella y vistas `rpt` |
| P4 | S21–S25 | Mora por cosecha, retención por cohorte, dashboard, recomendaciones → 📣 **Post 3 + repositorio público** |

Los posts los escribes tú, con un hallazgo concreto que hayas calculado y la aclaración de que los datos son simulados.

---

## 3. Progreso

Fechas propuestas: martes y jueves, con **una sola sesión por semana del 16/11 al 2/1** (entregas de GCI, cierre de ciclo en la UTP y fiestas). Python va lunes y miércoles. Las sesiones pesadas pueden partirse: hay margen hasta fines de febrero, antes de postular en marzo de 2027. Ajústalas a tu semana.

| Sesión | Fecha objetivo | Hecha | Notas |
|---|---|---|---|
| S00 | mar 29/9 | ✔  | |
| S01 | jue 1/10 | ✔ | |
| S02 | mar 6/10 | ✔ | |
| S03 | jue 8/10 | ✔ | |
| S04 | mar 13/10 | ✔ | |
| S05 | jue 15/10 | ✔ | |
| S06 | mar 20/10 | ✔ | |
| S07 | jue 22/10 | ✔ | |
| S08 | mar 27/10 | ✔ | |
| Repaso JOIN | jue 29/10 | ✔ |  |
| S09a | mar 3/11 | ✔ |  |
| R09 | jue 5/11 | ✔ |  |
| S09b | mar 10/11 | ✔ |  |
| S09c | jue 12/11 | ☐ | Post 1: otro día, cuando estés listo |
| S10 | mar 17/11 | ☐ |  |
| S11 | mar 24/11 | ☐ |  |
| S12 | mar 1/12 | ☐ |  |
| S13 | mar 8/12 | ☐ |  |
| S14 | mar 15/12 | ☐ | Post 2 |
| S15 | mar 22/12 | ☐ |  |
| S16 | mar 29/12 | ☐ |  |
| S17 | mar 5/1 | ☐ |  |
| S18 | jue 7/1 | ☐ |  |
| S19 | mar 12/1 | ☐ |  |
| S20 | jue 14/1 | ☐ |  |
| S21 | mar 19/1 | ☐ |  |
| S22 | jue 21/1 | ☐ |  |
| S23 | mar 26/1 | ☐ | Dashboard |
| S24 | jue 28/1 | ☐ | Simulacro |
| AZ1 | mar 2/2 | ☐ | Opcional |
| AZ2 | jue 4/2 | ☐ | Opcional |
| AZ3 | mar 9/2 | ☐ | Opcional; si pesa, se parte en dos |
| AZ4 | jue 11/2 | ☐ | Opcional |
| S25 | mar 16/2 | ☐ | Post 3 + repositorio público |
