<#
.SYNOPSIS
    Instala la base PayMarket_Analitica en tu SQL Server local.

.DESCRIPTION
    Crea la base, los esquemas y las tablas, carga los CSV de base/datos con bcp
    y crea los verificadores (esquema chk). Paso a paso en SETUP.md.

.EXAMPLE
    .\instalar.ps1                             # primera instalación
    .\instalar.ps1 -Reset                      # borra la base y la deja como nueva
    .\instalar.ps1 -ActualizarVerificadores    # solo agrega los verificadores de sesiones nuevas
    .\instalar.ps1 -Servidor "localhost\SQLEXPRESS"
#>
[CmdletBinding()]
param(
    [string]$Servidor = "localhost",
    [switch]$Reset,
    [switch]$ActualizarVerificadores,
    [switch]$SinConfirmar
)

$ErrorActionPreference = "Stop"
$Base = "PayMarket_Analitica"
$CarpetaSql = Join-Path $PSScriptRoot "sql"
$CarpetaDatos = Join-Path $PSScriptRoot "datos"
$CodificacionAnterior = [Console]::OutputEncoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Mostrar-Paso([string]$texto) {
    Write-Host ""
    Write-Host "==> $texto" -ForegroundColor Cyan
}

function Detener([string]$texto) {
    Write-Host ""
    Write-Host "ERROR: $texto" -ForegroundColor Red
    [Console]::OutputEncoding = $CodificacionAnterior
    exit 1
}

# ---------------------------------------------------------------- herramientas
Mostrar-Paso "Revisando sqlcmd y bcp"
foreach ($herramienta in "sqlcmd", "bcp") {
    if (-not (Get-Command $herramienta -ErrorAction SilentlyContinue)) {
        Detener "No encuentro '$herramienta'. Revisa el paso 2 de SETUP.md."
    }
}
$ayudaSqlcmd = (& sqlcmd -? 2>&1 | Out-String)
$ayudaBcp = (& bcp -? 2>&1 | Out-String)
$ArgsConexion = @("-S", $Servidor, "-E")
if ($ayudaSqlcmd -cmatch '-C\b.*[Tt]rust') { $ArgsConexion += "-C" }
$ArgsBcpCertificado = @()
if ($ayudaBcp -cmatch '-u\b.*[Tt]rust') { $ArgsBcpCertificado = @("-u") }

function Ejecutar-Script([string]$archivo, [string]$baseDatos) {
    Write-Host "    $(Split-Path $archivo -Leaf)"
    & sqlcmd @ArgsConexion -d $baseDatos -b -I -f 65001 -m 11 -i $archivo
    if ($LASTEXITCODE -ne 0) { Detener "Falló el script $(Split-Path $archivo -Leaf)." }
}

function Consultar([string]$consulta, [string]$baseDatos = "master") {
    $salida = & sqlcmd @ArgsConexion -d $baseDatos -b -I -f 65001 -h -1 -W -Q "SET NOCOUNT ON; $consulta"
    if ($LASTEXITCODE -ne 0) {
        Detener "No pude ejecutar una consulta en el servidor '$Servidor'. ¿Está encendido SQL Server? Revisa SETUP.md."
    }
    return $salida
}

# ---------------------------------------------------------------- versión
Mostrar-Paso "Conectando a $Servidor"
$version = Consultar "SELECT CAST(SERVERPROPERTY('ProductMajorVersion') AS INT);" | Select-Object -First 1
$mayor = [int]$version
$nombreVersion = switch ($mayor) { 15 { "SQL Server 2019" } 16 { "SQL Server 2022" } 17 { "SQL Server 2025" } default { "SQL Server (versión $mayor)" } }
Write-Host "    $nombreVersion"
if ($mayor -lt 15) {
    Detener "El curso necesita SQL Server 2019 o superior."
}
if ($mayor -ge 16) {
    Write-Host "    Tienes 2022 o superior: podrás probar GENERATE_SERIES, DATE_BUCKET y GREATEST en los bloques 'Nivel pro'."
}

$existe = (Consultar "SELECT CASE WHEN DB_ID(N'$Base') IS NULL THEN 0 ELSE 1 END;" | Select-Object -First 1).Trim()

# ---------------------------------------------------------------- solo verificadores
if ($ActualizarVerificadores) {
    if ($existe -ne "1") { Detener "La base $Base no existe todavía. Ejecuta primero .\instalar.ps1" }
    Mostrar-Paso "Actualizando verificadores (no se toca core, stg, lab, dw ni rpt)"
    Ejecutar-Script (Join-Path $CarpetaSql "10_chk_infraestructura.sql") $Base
    Ejecutar-Script (Join-Path $CarpetaSql "11_chk_esperados.sql") $Base
    $n = (Consultar "SELECT COUNT(*) FROM chk.ejercicio;" $Base | Select-Object -First 1).Trim()
    Write-Host ""
    Write-Host "Listo: $n verificadores disponibles." -ForegroundColor Green
    [Console]::OutputEncoding = $CodificacionAnterior
    exit 0
}

# ---------------------------------------------------------------- reset
if ($existe -eq "1") {
    if (-not $Reset) {
        Write-Host ""
        Write-Host "La base $Base ya existe. No se cambió nada." -ForegroundColor Yellow
        Write-Host "  - Para dejarla como nueva:            .\instalar.ps1 -Reset"
        Write-Host "  - Para agregar verificadores nuevos:  .\instalar.ps1 -ActualizarVerificadores"
        [Console]::OutputEncoding = $CodificacionAnterior
        exit 0
    }
    Write-Host ""
    Write-Host "ATENCIÓN: se borrará $Base completa." -ForegroundColor Yellow
    Write-Host "Perderás todo lo que creaste en los esquemas lab, dw y rpt, y tu historial de intentos (chk.intento)." -ForegroundColor Yellow
    Write-Host "Tus archivos .sql del repositorio no se tocan." -ForegroundColor Yellow
    if (-not $SinConfirmar) {
        $respuesta = Read-Host "Escribe SI para continuar"
        if ($respuesta -ne "SI") {
            Write-Host "Cancelado. No se cambió nada."
            [Console]::OutputEncoding = $CodificacionAnterior
            exit 0
        }
    }
    Mostrar-Paso "Borrando $Base"
    Consultar "ALTER DATABASE [$Base] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [$Base];" | Out-Null
}

# ---------------------------------------------------------------- estructura
Mostrar-Paso "Creando la base, los esquemas y las tablas"
Ejecutar-Script (Join-Path $CarpetaSql "00_crear_base.sql") "master"
foreach ($archivo in "01_esquemas.sql", "02_core_tablas.sql", "03_stg_tablas.sql") {
    Ejecutar-Script (Join-Path $CarpetaSql $archivo) $Base
}

# ---------------------------------------------------------------- datos
Mostrar-Paso "Cargando los datos (tarda menos de un minuto)"
$cargas = @(
    @("core.ubigeo", "ubigeo.csv"),
    @("core.canal", "canal.csv"),
    @("core.rubro_mcc", "rubro_mcc.csv"),
    @("core.codigo_respuesta", "codigo_respuesta.csv"),
    @("core.cliente", "cliente.csv"),
    @("core.cuenta", "cuenta.csv"),
    @("core.comercio", "comercio.csv"),
    @("core.promocion", "promocion.csv"),
    @("core.tipo_cambio", "tipo_cambio.csv"),
    @("core.transaccion", "transaccion.csv"),
    @("core.contracargo", "contracargo.csv"),
    @("core.credito", "credito.csv"),
    @("core.cuota", "cuota.csv"),
    @("core.pago_cuota", "pago_cuota.csv"),
    @("stg.clientes_legado", "stg_clientes_legado.csv"),
    @("stg.liquidacion_pos", "stg_liquidacion_pos.csv")
)
$archivoErrores = Join-Path ([System.IO.Path]::GetTempPath()) "paymarket_bcp_errores.txt"
foreach ($carga in $cargas) {
    $tabla, $csv = $carga
    $ruta = Join-Path $CarpetaDatos $csv
    if (-not (Test-Path $ruta)) { Detener "No encuentro $csv en base/datos." }
    $esperadas = -1
    $lector = [System.IO.File]::OpenText($ruta)
    while ($null -ne $lector.ReadLine()) { $esperadas++ }
    $lector.Close()

    Write-Host ("    {0,-22} {1,9:N0} filas" -f $tabla, $esperadas)
    $salida = & bcp "$Base.$tabla" in $ruta -S $Servidor -T @ArgsBcpCertificado -q -c -C 65001 -t "|" -r "0x0a" -F 2 `
                   -b 50000 -m 1 -e $archivoErrores -h "CHECK_CONSTRAINTS,TABLOCK" 2>&1
    if ($LASTEXITCODE -ne 0) {
        $salida | Select-Object -Last 5 | ForEach-Object { Write-Host "      $_" }
        Detener "bcp no pudo cargar $csv. Revisa SETUP.md (problemas comunes)."
    }
    $cargadas = [int]((Consultar "SELECT COUNT(*) FROM $tabla;" $Base | Select-Object -First 1).Trim())
    if ($cargadas -ne $esperadas) {
        Detener "$tabla tiene $cargadas filas y el archivo $csv tiene $esperadas. Revisa $archivoErrores"
    }
}

Mostrar-Paso "Creando índices y verificadores"
Ejecutar-Script (Join-Path $CarpetaSql "04_core_indices.sql") $Base
Ejecutar-Script (Join-Path $CarpetaSql "10_chk_infraestructura.sql") $Base
Ejecutar-Script (Join-Path $CarpetaSql "11_chk_esperados.sql") $Base

# ---------------------------------------------------------------- control final
Mostrar-Paso "Control final"
$noConfiables = (Consultar "SELECT COUNT(*) FROM sys.foreign_keys WHERE is_not_trusted = 1 OR is_disabled = 1;" $Base | Select-Object -First 1).Trim()
if ($noConfiables -ne "0") { Detener "Hay $noConfiables llaves foráneas sin validar." }
$nChk = (Consultar "SELECT COUNT(*) FROM chk.ejercicio;" $Base | Select-Object -First 1).Trim()
& sqlcmd @ArgsConexion -d $Base -I -f 65001 -W -Q "SET NOCOUNT ON; EXEC chk.huella_datos;"

Write-Host ""
Write-Host "Listo: $Base instalada con $nChk verificadores." -ForegroundColor Green
Write-Host "Siguiente paso: abre sesiones/S00_mapa_de_la_empresa/guia.md"
[Console]::OutputEncoding = $CodificacionAnterior
