# Hallazgos · Informe para la gerencia de PayMarket

> Datos simulados. Cada número de este archivo debe salir de una consulta de [consultas.sql](consultas.sql). Si todavía no lo calculaste, no lo escribas.

Cómo llenar cada pregunta (lo irás completando sesión a sesión; la sección "🧱 Avance del proyecto" de cada guía te dice cuándo):
- **Tablas que necesito:** qué tablas usarás y por qué (S00).
- **Qué encontré:** números concretos, con el periodo y la unidad (soles, %, operaciones).
- **Qué recomendaría:** una acción, a quién le toca y cómo se mediría si funcionó.

---

## 1. ¿Cómo evolucionan el volumen y la facturación, y qué estacionalidad tiene el negocio?

**Tablas que necesito:** `core.cliente`, `core.transaccion`, `core.pago_cuota` 

**Qué encontré:**

**Qué recomendaría:**

---

## 2. ¿Qué comercios y rubros concentran los ingresos por comisión?

**Tablas que necesito:** `core.comercio`, `core.rubro_mcc`, `core.transaccion`

**Qué encontré:** Seleccioné 10, y todas son de la modalidad presencial, con una tasa_pct de 0% y probablemente Paymarket maneja esta estrategia por el volumen que manejan las transacciones diarias.

**Qué recomendaría:**

---

## 3. ¿Dónde y por qué se rechazan pagos, y cuánto ingreso se pierde?

**Tablas que necesito:** `core.transacciones`, `core.canal`, `core.codigo_respuesta`

**Qué encontré:**
En el año 2025 hubo un total de 129122 transacciones `nro_transacciones`.
Asimismo,  hubo un total de 9156 transacciones rechazadas `nro_transacciones_rechazadas`.
De las cuales, 4482 fueron por fondos insuficientes `fondos_insuficientes`.
De modo que, el porcentajes de rechazos por fondos insuficientes seria de 48.95%
**Qué recomendaría:**

---

## 4. ¿Qué clientes se registran y no usan la billetera? ¿Cómo retiene cada cohorte?

**Tablas que necesito:** `core.canal`, `core.cliente`, `core.transacciones`

**Qué encontré:**

`total_clientes_ccorreo :` 17907

`total_clientes_ccelular :` 18747

`total_clientes_scontacto :` 129

PayMarket podría usar su correo o celular; sin embargo,
no lograría contactar a los clientes sin ningún registro.

**Qué recomendaría:**

---

## 5. ¿Qué comercios muestran un nivel de contracargos anormal?

**Tablas que necesito:** `core.contracargo`, `core.comercio`

**Qué encontré:**

**Qué recomendaría:**

---

## 6. ¿Cómo se comporta la mora de los microcréditos por cosecha y categoría SBS?

**Tablas que necesito:** `core.credito`, `core.cuota`, `pago.cuota`

**Qué encontré:**

**Qué recomendaría:**

---

## 7. Si fueras analista de PayMarket: ¿qué harías primero y con qué impacto estimado?

Escribe los supuestos de forma explícita (por ejemplo: "si se recupera la mitad de los rechazos técnicos…").

**Supuestos:**
Si se recuperan o salvan las compras que no se logran con éxito por fallas de conexión o por la plataforma al menos la mitad de ellas, cada una compra que salvemos son 50 soles en promedio
**Qué haría primero y por qué:**

**Impacto estimado:**
