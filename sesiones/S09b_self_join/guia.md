# S09b · Self-join: una tabla que se apunta a sí misma

> **Lo que quiero lograr hoy:** ver en una misma fila a un cliente y a quien lo invitó.

| | |
|---|---|
| **Tiempo de referencia** | 30 a 40 minutos si sale sin trabarte |
| **Techo** | 1 hora. Si llegas, **paras**, aunque falte |
| **Hoy hay** | 1 tema nuevo y 1 ejercicio. Sin opcionales |
| **Archivos** | Esta guía + [practica.sql](practica.sql) + el [glosario](../../guias/glosario_paymarket.md) a mano |

**Palabras de hoy:** un **referido** es el cliente que llegó porque alguien lo invitó. El **referidor** es quien lo invitó. El **alta** es el día en que se registró.

**Regla de los 15 minutos:** si sigues trabado 15 minutos después de abrir la pista 3, escribe ⏭️ en el registro y termina por hoy.

---

## 🔁 Calentamiento (3 minutos, sin pistas)

Lo responderás en `practica.sql`, antes de ver el tema nuevo. Sirve para que lo de R09 se te quede.

---

## 📘 El tema: self-join

En `core.cliente`, la columna `cliente_referidor_id` guarda el `cliente_id` de **otro cliente**: el que lo invitó. La relación está **dentro de la misma tabla**.

| cliente_id | nombres | cliente_referidor_id |
|---|---|---|
| 50 | Ana | NULL |
| 90 | Luis | 50 |

Luis fue invitado por el cliente 50, que es Ana. Para ver "Luis, invitado por Ana" en una sola fila, necesitas leer la tabla **dos veces**: una para Luis y otra para Ana. Se hace con dos alias, como si fueran dos tablas:

```sql
FROM empleados AS e                                  -- el empleado
JOIN empleados AS j ON j.empleado_id = e.jefe_id     -- su jefe
```

**Cómo leer el `ON`:** "busca en la copia `j` a la persona cuyo id es el `jefe_id` de `e`". O sea: **la columna que apunta** (`e.jefe_id`) contra **la llave de la otra copia** (`j.empleado_id`).

| Si escribes… | Obtienes… |
|---|---|
| `j.empleado_id = e.jefe_id` | Cada empleado con **su jefe** |
| `j.jefe_id = e.empleado_id` | Cada jefe con **sus subordinados** |

Usa alias con significado: `n` de nuevo y `r` de referidor. Con eso es difícil confundirse.

---

## 💡 Pistas del ejercicio

<details><summary>Pista 1 · idea</summary>

Necesitas dos copias de `core.cliente`: una para el cliente nuevo y otra para quien lo invitó.
</details>

<details><summary>Pista 2 · herramienta</summary>

Un `JOIN` normal, porque solo quieres a los que sí tienen referidor. El `ON` une la columna que apunta (la del cliente nuevo) con la llave de la otra copia. Los días salen de `DATEDIFF` entre las dos fechas de alta.
</details>

<details><summary>Pista 3 · estructura</summary>

```sql
FROM core.cliente AS n
JOIN core.cliente AS r ON r.____ = n.____
WHERE ____
```
</details>

---

## ⚠️ Si algo sale raro

| Lo que ves | Qué revisar |
|---|---|
| `Msg 1013 — ... have the same exposed names` | Cada copia necesita su propio alias |
| Te salen muy pocas filas | El `ON` está al revés (concepto de arriba) |
| Días negativos | El orden en `DATEDIFF` es `desde, hasta` |
| El nombre es el del cliente y no el del referidor | Revisa el alias de esa columna |

---

## ✅ Cierre

Di en voz alta, sin mirar:

- [ ] ¿Por qué un self-join necesita dos alias?
- [ ] En el `ON`, ¿qué columna va contra cuál?

**Antes de irte, llena el registro** al final de `practica.sql`.

```bash
git add .
```
```bash
git commit -m "S09b: self-join, quién invitó a cada cliente"
```
```bash
git push
```
