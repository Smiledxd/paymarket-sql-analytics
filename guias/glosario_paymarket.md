# Glosario de PayMarket: las palabras de los enunciados, en simple

> Si una palabra de un enunciado te traba, búscala aquí con `Ctrl+F`. No hace falta memorizarla: a fuerza de verla, se queda.
> PayMarket es inventada, pero estas palabras son las que se usan de verdad en bancos y fintech peruanas.

## La idea general

**PayMarket es una empresa (una fintech).** Tiene una app de pagos en el celular, con la que una persona paga en tiendas. Gana dinero cobrándole una comisión a la tienda por cada pago, y prestando dinero a sus clientes.

| Quién | Qué es | Tabla |
|---|---|---|
| **Fintech** | Empresa que da servicios financieros usando tecnología | — |
| **Cliente** | La persona que paga | `core.cliente` |
| **Billetera** | El "monedero digital" del cliente **dentro de PayMarket**, en soles o en dólares. **Es una cuenta**, no un canal | `core.cuenta` |
| **Comercio** | La tienda que cobra: bodega, farmacia, grifo… | `core.comercio` |

**Billetera y canal son cosas distintas:**
- La **billetera** es **de dónde sale** la plata.
- El **canal** es **por dónde se hizo** el pago. Solo hay 4: App móvil, Web, POS físico y Pago con QR.

Ejemplo: Ana paga S/ 20 en una bodega escaneando un QR. La plata sale de su **billetera** en soles; el **canal** es Pago con QR.

## Los pagos

| Palabra | Qué significa, en simple |
|---|---|
| **POS** | La maquinita donde pasas la tarjeta en la tienda |
| **QR** | El código cuadrado que escaneas con el celular para pagar |
| **Operación / transacción** | Un **intento** de pago. Puede aprobarse o no |
| **Pago con la billetera** | El cliente le paga a una tienda: es una operación aprobada (`core.transaccion`). No es lo mismo que pagar una cuota |
| **Pago de cuota** | El cliente devuelve parte de su crédito (`core.pago_cuota`) |
| **Aprobada** | El pago pasó y la tienda recibió el dinero |
| **Rechazada** | El pago no pasó. No se movió dinero |
| **Extornada** | El pago se aprobó, pero después **se devolvió** (como anular una compra) |
| **Extorno** | La acción de devolver ese pago |
| **Código de respuesta** | El número que explica qué pasó con el pago: `00` aprobada, `51` sin fondos, `91` sistema caído… |
| **Fondos insuficientes** | No tenía saldo suficiente |
| **Rechazo técnico** | Falló el sistema, no el cliente |
| **Sospecha de fraude** | El sistema lo bloqueó porque le pareció raro |
| **Contracargo** | El cliente **reclama** un pago que sí se aprobó ("yo no compré eso") y pide que le devuelvan el dinero. No es lo mismo que un rechazo |
| **Latencia** | Lo que tardó el **servidor** en responder, en milisegundos |

## El dinero del negocio

| Palabra | Qué significa, en simple |
|---|---|
| **Facturación** | La suma de lo que se vendió: el dinero que **pasó** por PayMarket. No es lo que PayMarket gana |
| **Comisión** | Lo que PayMarket **sí gana**: un pedacito de cada pago aprobado, que paga la tienda |
| **MDR / `tasa_mdr`** | El porcentaje de esa comisión. `0.0350` = 3,5 %: en una venta de S/ 100, la comisión es S/ 3,50 |
| **IGV** | El impuesto del 18 %. La comisión se guarda sin IGV |
| **Volumen** | Cuántas operaciones hubo |
| **Ticket promedio** | Cuánto se paga en promedio por operación: facturación ÷ operaciones |
| **KPI** | Un número clave que la gerencia mira para saber cómo va el negocio |
| **Tasa de aprobación** | De cada 100 intentos, cuántos se aprobaron |
| **Quincena / fin de mes** | Cuando la gente suele cobrar su sueldo en Perú |
| **Tipo de cambio** | Cuántos soles vale un dólar ese día. **Compra** es el que se usa aquí para pasar dólares a soles |

## Los comercios

| Palabra | Qué significa, en simple |
|---|---|
| **Rubro** | A qué se dedica la tienda: farmacia, restaurante… |
| **MCC** | El código de 4 dígitos de ese rubro. `5912` = farmacias |
| **RUC** | El número de la empresa ante SUNAT. Empieza con `20` (empresa) o `10` (persona con negocio) |
| **Razón social / nombre comercial** | El nombre legal / el nombre que ves en el letrero |
| **Afiliarse** | Que la tienda se inscriba para cobrar con PayMarket |
| **Ubigeo** | El código de un distrito peruano |

## Cómo llegan y se quedan los clientes

| Palabra | Qué significa, en simple |
|---|---|
| **Alta** | El día en que el cliente se registró |
| **Canal de adquisición** | Cómo llegó el cliente. Ojo: no es el canal de pago |
| **Orgánico** | Llegó solo, sin publicidad |
| **Campaña digital** | Llegó por publicidad en internet |
| **Referido / referidor** | Llegó porque alguien lo invitó / la persona que lo invitó |
| **Activo (estado)** | Su cuenta está habilitada. **No significa que la use** |
| **Bloqueado / cerrado** | Su cuenta fue suspendida / dada de baja |
| **Retención** | Cuántos clientes siguen usando el producto con el tiempo |
| **Cohorte** | Un grupo de clientes que se registró el mismo mes, para compararlo con otros |
| **Cashback** | Te devuelven parte de lo que gastaste |
| **Promoción / campaña** | Una oferta por tiempo limitado, como el CyberWow |

## Los créditos

| Palabra | Qué significa, en simple |
|---|---|
| **Microcrédito** | Un préstamo pequeño. En PayMarket se llama "PayMarket Adelanto" |
| **Desembolso** | El momento en que le entregan el dinero al cliente |
| **Cuota** | Lo que se paga cada mes |
| **Capital / interés** | La parte de la cuota que devuelve el préstamo / lo que se cobra por prestar |
| **Plazo** | En cuántos meses se paga |
| **TEA** | La tasa de interés anual. `0.6500` = 65 % al año |
| **Vigente / cancelado** | Todavía debe / ya pagó todo |
| **Vencimiento** | La fecha límite para pagar una cuota |
| **Mora** | Atraso: se pasó la fecha y no pagó. **Mora 30+** significa más de 30 días de atraso |
| **Cosecha** | Todos los créditos entregados en un mismo mes, para ver cómo se portan |
| **SBS** | La entidad que supervisa a los bancos en Perú. Clasifica a los deudores: Normal, CPP, Deficiente, Dudoso y Pérdida |

## Las áreas que aparecen en los enunciados

| Área | Qué hace |
|---|---|
| **Riesgos** | Cuida que no se pierda dinero por créditos impagos o fraude |
| **Cumplimiento** | Vigila el lavado de activos y que se cumplan las normas |
| **Prevención de fraude** | Detecta pagos sospechosos |
| **Cobranzas** | Busca que los deudores paguen |
| **Comercial** | Consigue y cuida a los comercios |
| **Marketing** | Consigue clientes y hace campañas |

---

¿Falta una palabra? Pregúntame, y la agregamos.
