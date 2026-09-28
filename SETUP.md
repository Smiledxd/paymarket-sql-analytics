# SETUP · Instalar la base en Windows

Tiempo estimado: 15 minutos la primera vez. La instalación en sí tarda menos de un minuto.

## 1. Comprobar la versión de SQL Server

Abre SSMS, conéctate a tu servidor (normalmente `localhost` o `.` con *Windows Authentication*) y ejecuta:

```sql
SELECT @@VERSION;
```

| Si la primera línea dice | Versión | ¿Sirve? |
|---|---|---|
| `Microsoft SQL Server 2019` | 15.x | Sí |
| `Microsoft SQL Server 2022` | 16.x | Sí, y podrás probar las funciones nuevas de los bloques "Nivel pro" |
| `Microsoft SQL Server 2025` | 17.x | Sí, igual que 2022 |
| 2017 o anterior | 14.x o menos | No: instala SQL Server 2022 Developer (gratis) |

Si usas **SQL Server Express**, tu servidor probablemente se llama `localhost\SQLEXPRESS`: lo verás en la ventana de conexión de SSMS.

## 2. Comprobar `sqlcmd` y `bcp`

El instalador usa dos herramientas de línea de comandos que vienen con SQL Server. Abre **PowerShell** y ejecuta:

```powershell
sqlcmd -?
```

```powershell
bcp -v
```

Si alguno responde "no se reconoce como nombre de un cmdlet":

1. Instala las **Microsoft Command Line Utilities for SQL Server** (búscalas en el sitio de Microsoft Learn como *sqlcmd utility* y *bcp utility*; necesitan también el *ODBC Driver for SQL Server*).
2. Cierra y vuelve a abrir PowerShell.
3. Si aún no las encuentra, agrega a la variable de entorno `PATH` la carpeta donde quedaron, normalmente `C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\180\Tools\Binn\` (o `...\170\...`).

## 3. Clonar el repositorio

```bash
git clone https://github.com/<tu-usuario>/paymarket-sql-analytics.git
```

Los datos vienen en `base/datos/` como archivos CSV (unos 30 MB). No necesitas generarlos.

## 4. Ejecutar el instalador

En PowerShell, entra a la carpeta `base` del repositorio y ejecuta:

```powershell
.\instalar.ps1
```

Si tu servidor no es `localhost`:

```powershell
.\instalar.ps1 -Servidor "localhost\SQLEXPRESS"
```

**Si PowerShell dice que la ejecución de scripts está deshabilitada** (`running scripts is disabled on this system`), permite los scripts solo para esa ventana y vuelve a intentarlo:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

Ese cambio dura hasta que cierres la ventana; no modifica la configuración del equipo.

El instalador:
1. Comprueba la versión de SQL Server.
2. Crea la base `PayMarket_Analitica` con sus esquemas y tablas.
3. Carga los CSV con `bcp` y valida todas las llaves y reglas mientras carga.
4. Compara las filas cargadas con las de cada archivo.
5. Crea los verificadores (`chk`) y muestra la **huella** de cada tabla.

Al final debe decir `Listo: PayMarket_Analitica instalada con N verificadores.`

## 5. Sobre los permisos de lectura de los CSV

El instalador carga los datos con `bcp`, que lee los archivos **con tu usuario de Windows**, así que no necesitas dar permisos especiales.

Si más adelante quieres cargar archivos con `BULK INSERT` desde SSMS (por ejemplo, en S17), ten en cuenta que ese comando lee el archivo **con la cuenta del servicio de SQL Server** (normalmente `NT Service\MSSQLSERVER`), no con la tuya. Si el archivo está dentro de tu carpeta de usuario, fallará con `Operating system error code 5 (Access is denied)`. La solución más simple es copiar el archivo a una carpeta como `C:\datos_sql\` y darle permiso de lectura a esa cuenta: clic derecho en la carpeta → *Propiedades* → *Seguridad* → *Editar* → *Agregar* → escribe `NT Service\MSSQLSERVER` → marca *Lectura*.

## 6. Abrir los archivos en SSMS

1. En SSMS: *File → Open → File...* y elige `sesiones/S00_mapa_de_la_empresa/practica.sql`.
2. Comprueba arriba a la izquierda que la base activa sea `PayMarket_Analitica` (la primera línea `USE` del archivo lo hace por ti).
3. Lee la `guia.md` de la misma carpeta en VS Code (`Ctrl+Shift+V` para la vista previa) o en GitHub.
4. Selecciona un bloque y presiona `F5` para ejecutar solo ese bloque.

## 7. Reinstalar o actualizar

| Situación | Comando | ¿Qué se pierde? |
|---|---|---|
| Recibiste sesiones nuevas (nuevos verificadores) | `.\instalar.ps1 -ActualizarVerificadores` | Nada |
| Quieres dejar la base como nueva | `.\instalar.ps1 -Reset` | Todo lo que creaste en `lab`, `dw` y `rpt`, y tu historial de intentos |

`-Reset` pide que escribas `SI` para confirmar. Tus archivos `.sql` del repositorio nunca se tocan.

Para comprobar que tu base es idéntica a la original, ejecuta en SSMS `EXEC chk.huella_datos;` y compara la columna `huella` con la que mostró el instalador: cualquier reinstalación produce exactamente los mismos valores.

## 8. Problemas comunes

| Síntoma | Causa probable | Solución |
|---|---|---|
| `Login failed` o `A network-related or instance-specific error` | El nombre del servidor no es `localhost` o el servicio está apagado | Usa `-Servidor` con el nombre que ves en SSMS. Revisa en *Servicios de Windows* que *SQL Server (MSSQLSERVER)* esté en ejecución |
| `SSL Provider: The certificate chain was issued by an authority that is not trusted` | Las herramientas nuevas exigen cifrado | El instalador ya agrega la opción para confiar en el certificado local; si usas otra herramienta, agrega `-C` a `sqlcmd` |
| `CREATE DATABASE permission denied` | Tu usuario de Windows no es administrador de SQL Server | Abre SSMS como administrador o pide que te agreguen al rol `sysadmin` en tu instalación local |
| `La base PayMarket_Analitica ya existe. No se cambió nada.` | Ya la instalaste | Usa `-Reset` (se pierde lo tuyo) o `-ActualizarVerificadores` |
| Las tildes se ven como `Ã³` en SSMS | El archivo se abrió con otra codificación | Ciérralo y vuelve a abrirlo con *File → Open*; los `.sql` del curso están en UTF-8 con BOM |
| `Could not find stored procedure 'chk.s05_e1'` | Tienes una versión anterior de los verificadores | `.\instalar.ps1 -ActualizarVerificadores` |
| `Msg 208 — Invalid object name 'core.cliente'` en SSMS | Estás conectado a otra base (por ejemplo `master`) | Ejecuta `USE PayMarket_Analitica;` o elígela en la lista desplegable de SSMS |

Si ves una base llamada `PayMarket_Peru`, es de otro material: el curso no la usa ni la modifica.
