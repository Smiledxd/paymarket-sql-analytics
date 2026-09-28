/* ============================================================
   04 · Índices de apoyo en core
   Solo los mínimos para que los JOIN más comunes respondan rápido.
   En S20 crearás y compararás otros índices tú mismo.
   ============================================================ */
USE PayMarket_Analitica;
GO
CREATE INDEX ix_cuenta_cliente          ON core.cuenta (cliente_id);
CREATE INDEX ix_transaccion_cuenta      ON core.transaccion (cuenta_id);
CREATE INDEX ix_transaccion_comercio    ON core.transaccion (comercio_id);
CREATE INDEX ix_credito_cliente         ON core.credito (cliente_id);
CREATE INDEX ix_pago_cuota_cuota        ON core.pago_cuota (credito_id, numero_cuota);
GO
