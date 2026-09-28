/* ============================================================
   01 · Esquemas de PayMarket_Analitica
   Lo ejecuta base/instalar.ps1. No hace falta abrirlo en SSMS.
   ============================================================ */
USE PayMarket_Analitica;
GO
CREATE SCHEMA stg AUTHORIZATION dbo;   -- datos crudos, sucios a propósito (bronze)
GO
CREATE SCHEMA core AUTHORIZATION dbo;  -- datos transaccionales limpios (silver)
GO
CREATE SCHEMA lab AUTHORIZATION dbo;   -- tu zona de pruebas: crea, inserta y actualiza aquí
GO
CREATE SCHEMA dw AUTHORIZATION dbo;    -- modelo estrella que construirás en S18 y S19 (gold)
GO
CREATE SCHEMA rpt AUTHORIZATION dbo;   -- vistas para Power BI que crearás en S20
GO
CREATE SCHEMA chk AUTHORIZATION dbo;   -- verificadores de los ejercicios
GO
