/* ============================================================
   11 · Resultados esperados de los ejercicios
   Archivo generado automáticamente: no lo edites a mano.
   Solo contiene hashes (huellas) de los resultados: no incluye
   las consultas de referencia ni los resultados en sí.
   ============================================================ */
USE PayMarket_Analitica;
GO
SET NOCOUNT ON;
DELETE FROM chk.ejercicio_columna;
DELETE FROM chk.ejercicio;

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s00_e1', 'S00', N'Clientes registrados', 1, NULL, 0x908F0E362820E785953986888128FA1BA8EF94E5C34EE48E237C80B09B399DA2);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s00_e1', 1, N'total_clientes', 'numero', 0x908F0E362820E785953986888128FA1BA8EF94E5C34EE48E237C80B09B399DA2, N'Revisa qué filas estás contando: la pregunta es por todos los clientes registrados, sin importar su estado.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s00_e2', 'S00', N'Las billeteras de un cliente', 2, N'¿Estás filtrando por la columna que identifica al cliente dentro de core.cuenta?', 0x11D6E3B8D63C47E4D064D357B28995831A8F823567ADFE547E38D2E0AF879657);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s00_e2', 1, N'cuenta_id', 'numero', 0x2DC5B10DA6F0AD46952481CBED5F391233310DFE6E0EA79F38E27BB7BD3A8919, NULL),
    ('s00_e2', 2, N'moneda', 'texto', 0x30ADF9EF81907AD39DD412DCF8EBF29E1BB19365612DBB203DE472D5AF13D69A, NULL),
    ('s00_e2', 3, N'fecha_apertura', 'fecha', 0x6F00FBC1A62D83F4C48B7E801763A4C3FD3AF933E4C527DF7A250CA3D4DE6DCB, NULL),
    ('s00_e2', 4, N'estado', 'texto', 0x04E3F0F1925A6848A8E91857D9A44FC54A36B321487EF8A9D6736AACA99B14CE, NULL);

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s00_e3', 'S00', N'¿De quién es esta cuenta?', 1, NULL, 0x158F692A76D6BDF55812154B88692CE99D2E1AD5789D356AE5DDE891CC6F448D);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s00_e3', 1, N'cliente_id', 'numero', 0x15AC26F697F4875B9559BFE02F38428620E6271F5613FAFC50B22865AC391A1B, N'¿Buscaste primero en core.cuenta a qué cliente pertenece la cuenta 12345? El número de cuenta no es el número de cliente.'),
    ('s00_e3', 2, N'nombres', 'texto', 0xC7072D93E5912E01184B65F098DBE141CB849AF03F0326A423B4E008FBAEB0E2, NULL),
    ('s00_e3', 3, N'apellido_paterno', 'texto', 0x95620BF9F1BC1E0729EEDC9BA3335641DDA05469A86DB4CD058B4661D36258ED, NULL),
    ('s00_e3', 4, N'ubigeo_id', 'texto', 0x5B7290FE3485A0265437D2A35C649518FD12FDABD1A2443B218F9C38BB327B56, NULL);

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s00_reto', 'S00', N'Sigue el rastro de una transacción', 1, NULL, 0xCFAFE1CCD9BB2B375BFBC88FA945CDC8C727642A1C1B2D9A6D8C388956EC7010);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s00_reto', 1, N'transaccion_id', 'numero', 0x21024836892D8D1949544D93AFABE2FD042DF6B08B16CD4AC5E36BCB45CB112F, NULL),
    ('s00_reto', 2, N'nombre_canal', 'texto', 0xA5EF295521736DE923833DB27FC0CAC57258EB3A4FA065235600EDE76783CD83, N'Busca en core.canal el nombre que corresponde al canal_id de la transacción.'),
    ('s00_reto', 3, N'nombre_comercial', 'texto', 0x6A6AD2188485E28B7154C4B0AA3B6EE6BFE73163BE8694FB9ED1BE7C73544C6F, NULL),
    ('s00_reto', 4, N'descripcion_rubro', 'texto', 0xCB5D4215D89AFF5CD3ABD46655FD35E024BA39D1A29AE69261A8F0C7301B78B3, NULL),
    ('s00_reto', 5, N'distrito_cliente', 'texto', 0xAA245BBAEC81463088E81F9EA1542A703EEE3785B026A2E720ADBD12666334EA, N'El distrito que se pide es el del cliente (el dueño de la cuenta), no el del comercio.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s01_e1', 'S01', N'Combinaciones de estado y código de respuesta', 16, N'Si ves muchísimas filas, cada operación está saliendo por separado: revisa cómo quitar las combinaciones repetidas.', 0xDC17D905383DC940B281C3FB52EA956FD9790BB04B1A997970437FB9A597C8C1);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s01_e1', 1, N'estado', 'texto', 0xD912DD83B161DFA08FC5CF0FE0A572F07CBB21A8D4B739130159670C597723BA, NULL),
    ('s01_e1', 2, N'codigo_respuesta', 'texto', 0xD0C0B1AECE86D7E767B43894354F5FF81BB4534DB9987597E1154164C87A62A9, NULL);

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s01_e2', 'S01', N'Los 10 comercios con la tasa más alta', 10, NULL, 0x59FF1AD213DB9E769E16E3B7556CCB9999E9CC9D6197372F70E781D0458607A8);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s01_e2', 1, N'comercio_id', 'numero', 0x2BE238A7BC0C29F3A6B8FEC10BE9E608A7CFC9F5F1EFC9F37354130190F9157D, N'Hay varios comercios empatados con la misma tasa. Revisa el criterio de desempate del enunciado en tu ORDER BY.'),
    ('s01_e2', 2, N'nombre_comercial', 'texto', 0xDBD4F2F2BC4FEEDD2687A9E8BBB4CC7C652130D5225A10EA0CDF2FF24197345F, NULL),
    ('s01_e2', 3, N'tasa_pct', 'numero', 0xB7EF730FC7214180EF30C5B344B76FA79C02B6E68AB8FA1E82D9F088FA163DCB, N'La tasa está guardada como fracción (0.0350). El enunciado la pide en porcentaje (3.50).');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s01_e3', 'S01', N'Comisión e IGV de las operaciones más grandes', 20, N'El enunciado pide exactamente las 20 operaciones más grandes.', 0x196A0CCCD93670C016B912F11D365AF65715F7FDEE855BBC0FC79B35D9BEE4CD);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s01_e3', 1, N'transaccion_id', 'numero', 0x7A0D249698EB4D65C2259D014C289DAC2CCD362CC8CF499BDD71E6B77DF4446C, N'¿Estás dejando solo las operaciones aprobadas en soles? Una operación rechazada o extornada no nos dejó comisión.'),
    ('s01_e3', 2, N'monto', 'numero', 0xDAEC0B37327CFEEE058CEA28D18FD380FFAEEDE3C12F2F997FEDD107D6B4E704, NULL),
    ('s01_e3', 3, N'comision', 'numero', 0x3210B7BFD4AD956A03DECBA1C4657A1F15068A4827E04334A744001CC53EE71A, NULL),
    ('s01_e3', 4, N'igv_comision', 'numero', 0x16005DBD99A53EEA3FC2A9BEF93AE56F28D519E57ED98642851122B9C26C8A11, N'El IGV es el 18 % de la comisión. Revisa cómo escribes ese 18 % en el cálculo.'),
    ('s01_e3', 5, N'comision_con_igv', 'numero', 0x5A5F30F7AA763E2375A27938F6D209FF40475260DF1759D5C2F0EFAB2CD70BD1, NULL);

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s01_e4', 'S01', N'Los créditos más grandes', 15, NULL, 0xB9F178FB74A8A65E1FCD462337D34739E0EA732C509586C0BA1A027AFFBC6C4C);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s01_e4', 1, N'credito_id', 'numero', 0x1EC0EE8E0B83B8EF392D7CA7160D5092E0502C699471D0D1CF8C0186EFCD24FB, N'Muchos créditos tienen el mismo monto. Revisa el desempate que pide el enunciado.'),
    ('s01_e4', 2, N'monto', 'numero', 0x502EA20FC66BCD2F9AFC3319DA711CADAC88CCBE3F1675704B3463B4E40D7736, NULL),
    ('s01_e4', 3, N'plazo_meses', 'numero', 0xE750FFA75C83C7E4C2F7923F788B2C082DAEB95A9BF0EC1670A8634A9F30AFDA, NULL),
    ('s01_e4', 4, N'tea_pct', 'numero', 0xE2224F16823339E6DABBB0E5373BACB761FCA623B17AFB72C667D9F9DC7FAE1C, N'La TEA está guardada como fracción (0.6500). El enunciado la pide en porcentaje.'),
    ('s01_e4', 5, N'capital_por_mes', 'numero', 0xC8C71A617674CAF69D98350C2A4DC8FC45661C4A960C0E480C81351ABCB9E6AD, NULL);

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s01_reto', 'S01', N'¿Cuánto ganamos en las operaciones en dólares más grandes?', 10, NULL, 0xD9398876D235452170502504236EC1BD6C31C232DF50FBBA1E758AF69795131C);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s01_reto', 1, N'transaccion_id', 'numero', 0x54388E96C25CAAEBEF9F4CBC92910A12907BA8B2203CE415E11C02656DB60333, N'Revisa que solo entren operaciones aprobadas y en dólares.'),
    ('s01_reto', 2, N'comercio_id', 'numero', 0xFE6E7A57A61EC09B7C73AE7249969876E25C1196CED0843ECA683105FBB79445, NULL),
    ('s01_reto', 3, N'monto', 'numero', 0xC8B965AC24B7234C9689B6B245CF446B03D5C7A280C998419451010F878A8C03, NULL),
    ('s01_reto', 4, N'comision', 'numero', 0x2B376E4552B8DC61033BDD9FC373F50C6B22D58FAA24A36E0724B0DDCFBDAF30, NULL),
    ('s01_reto', 5, N'igv_comision', 'numero', 0xD72D8CEE75904F16F9A4F724BF7DCDECC1A7D9D37439003EBD9B6223F2C0431F, NULL),
    ('s01_reto', 6, N'pct_comision', 'numero', 0x6965A81A5F7D3C4FDE3792E74E8EAB5D81F7713E736D1B8E071D309DF1C85562, N'Es la comisión como porcentaje del monto: una división y luego por 100.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s02_e1', 'S02', N'Fondos insuficientes en POS un día de quincena', 11, N'Revisa el filtro de fecha: fecha_hora tiene hora, así que un día completo es un rango desde las 00:00 de ese día hasta antes de las 00:00 del día siguiente.', 0x88ED98FBDF2777DDFDE0326D25AB13E3CC64528740D395BB36AE477FC39F20E6);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s02_e1', 1, N'transaccion_id', 'numero', 0x332B1E011F21BFC204930FB0165EDCA2267A138B6BF2F21C5F2E45A5CB71C768, NULL),
    ('s02_e1', 2, N'fecha_hora', 'fecha', 0x6F7AF9D8D44F5A2D835E92410920334132400D11FAA61DC61997378F89D63769, NULL),
    ('s02_e1', 3, N'monto', 'numero', 0x14485173A32CACAFD8685F12A475859A469750C93FD6FF407202D29CBBAA1AB2, NULL);

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s02_e2', 'S02', N'Rechazos técnicos en la web', 1, NULL, 0xADDA166D07B2CF339F654FFB9DF08CBE5B59D205E5A10B77F63F917669B4C2AB);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s02_e2', 1, N'rechazos_tecnicos', 'numero', 0xADDA166D07B2CF339F654FFB9DF08CBE5B59D205E5A10B77F63F917669B4C2AB, N'¿Revisaste en core.codigo_respuesta cuáles son TODOS los códigos de tipo ''Rechazo técnico''? ¿Tu rango incluye el 31 de diciembre completo?');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s02_e3', 'S02', N'Operaciones grandes en junio', 58, N'Mira los paréntesis: AND se evalúa antes que OR. ¿Todas tus filas son de junio y aprobadas?', 0x379723E662B082C5EBB4D13C5AB14828D6B98B402EA88DAB6AEF238BE7D25622);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s02_e3', 1, N'transaccion_id', 'numero', 0xCDF496F00CFAC79A16EB612D11C609AB485E48365057AD36749FDEE03D33DD24, NULL),
    ('s02_e3', 2, N'moneda', 'texto', 0xCFBD394CC3D677341FFE2EBECF399E9022599B8B085483B48C0284F992E83BC5, NULL),
    ('s02_e3', 3, N'monto', 'numero', 0x8D76DD9F349C5C04AF4D15DB4BAA6BEE8240968CC74DF6C82ED301D83444E8C6, NULL);

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s02_e4', 'S02', N'Pequeños negocios de salud y alimentos que no son bodegas', 60, N'Revisa el patrón del RUC (debe EMPEZAR con 10), la lista de rubros y la condición sobre el nombre comercial.', 0xA8E1D1E87E6B265941B6DE29A5482194B1BDC711D84F07CA1457A7E0C3AB9859);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s02_e4', 1, N'comercio_id', 'numero', 0xB658DE3635B4290A645774E3B4D22FDC9437A3E7CD446034343769ED143CC280, NULL),
    ('s02_e4', 2, N'nombre_comercial', 'texto', 0xF05587031D9B779B760B8C958399D784720694FE3884EACAE5F189B16052E58E, NULL),
    ('s02_e4', 3, N'mcc', 'texto', 0xB146AE923E37BB19156B30610C2AD2943C73397BBFFDE38F855EB8D6A33E1201, NULL);

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s02_reto', 'S02', N'Rechazos por sospecha de fraude en canales digitales', 11, N'Revisa cada condición: los tres códigos de fraude, solo App o Web, montos en soles entre 200 y 2000, y todo el primer semestre de 2026.', 0x2A4B8D7A15769E8AB14676F21E25F89F1F977CEC83BFE9E697C952D993A0C39A);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s02_reto', 1, N'transaccion_id', 'numero', 0x9639264F0A85B13969AA0B25CF9EDC7888D49C5DB0C7EAC987C9635F19FC2995, NULL),
    ('s02_reto', 2, N'canal_id', 'numero', 0x26050DD5E3818FA6B43B8A7D180634CCED3E21A69872FB90870F4A91118E3BBB, NULL),
    ('s02_reto', 3, N'codigo_respuesta', 'texto', 0xE76CB9185A0C26B29782D24BE718FF3C9611DB4CA8D6DA3B6A909D5B72724D08, NULL),
    ('s02_reto', 4, N'monto', 'numero', 0xB308069AF51CFC7493A81F67C5E2D9A167B7C44982BAC8C2382536D4D7302DF6, NULL);

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s03_e1', 'S03', N'Clientes sin correo', 1, NULL, 0x1A454A2AC554FDEFFDDAEA078CE06CB0A6BEA1C05B4D198E3C4827598C793B07);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s03_e1', 1, N'clientes_sin_correo', 'numero', 0x1A454A2AC554FDEFFDDAEA078CE06CB0A6BEA1C05B4D198E3C4827598C793B07, N'Un dato que falta no es igual a nada, ni siquiera a otro dato que falta. Revisa cómo preguntas si el correo está vacío (NULL).');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s03_e2', 'S03', N'Clientes sin ningún dato de contacto', 1, NULL, 0x75828FB01C1396E521199B4F16F10F4B432A6913993A4136F185AFC2D9D4F121);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s03_e2', 1, N'clientes_sin_contacto', 'numero', 0x75828FB01C1396E521199B4F16F10F4B432A6913993A4136F185AFC2D9D4F121, N'"Sin ningún dato de contacto" significa que faltan los dos a la vez. ¿Usaste AND u OR?');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s03_e3', 'S03', N'Lista de contacto para la bienvenida', 321, N'Son los clientes con fecha de alta del 1 al 7 de junio de 2026, ambos días incluidos.', 0x109435C4F6768B1EABECA0A4E710CD5F7200FF1FBE80C4EC607072A088BF6C8A);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s03_e3', 1, N'cliente_id', 'numero', 0x788579E262612827AB35D9E482212C0E15D6FF26B9E9A87ED2C85239EC7FF84F, NULL),
    ('s03_e3', 2, N'contacto', 'texto', 0xEA94184C16253D52207E918DD90CC237D5A8F3EF3CCEBED373A061EAC3CE79FF, N'El orden de preferencia es: correo, si no hay correo el celular, y si no hay ninguno el texto ''SIN CONTACTO''.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s03_e4', 'S03', N'Beneficio para quienes no vinieron de los embajadores', 1, NULL, 0x69DE5D47EC8BB291C2DB55D81E2BD152C0EA2BFA716B506088F0EB7828F99830);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s03_e4', 1, N'total_clientes', 'numero', 0x69DE5D47EC8BB291C2DB55D81E2BD152C0EA2BFA716B506088F0EB7828F99830, N'¿Qué pasa con los clientes que no tienen referidor (cliente_referidor_id es NULL) cuando usas NOT IN? ¿Deberían recibir el beneficio?');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s03_reto', 'S03', N'¿Cuánto venden los comercios por cada sol de comisión?', 568, N'Una fila por comercio que tenga al menos una operación aprobada en soles.', 0x37DBE5B0030B56717E824DD65EDEB8291895780EDA3752051BF8B1CA5775D86D);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s03_reto', 1, N'comercio_id', 'numero', 0x376FA5A0964EE5470EAB460F09F0B9F47D9C43FAF1771ACAEA8600C658FA83C5, NULL),
    ('s03_reto', 2, N'facturacion', 'numero', 0x8B5F44AFB5D80ECB3B84B9DAB1F94CAF05456B39BB7B3EFA57831CD4A1547E22, N'Solo cuentan las operaciones aprobadas en soles.'),
    ('s03_reto', 3, N'comision_total', 'numero', 0x4EA0BAD1F57E987479375E51DA96BE6E6FFF56F8E48E7E4CF4010646E51F2EEC, NULL),
    ('s03_reto', 4, N'soles_por_sol_comision', 'numero', 0x2BD0452E360F21BBB636E7172CB88E333FC3109C33D801E59F6AB3DF0809E7AE, N'Es facturación entre comisión. Cuando la comisión es 0 la división no tiene sentido: el resultado debe quedar como NULL, no como 0.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s04_e1', 'S04', N'Etiquetas de bienvenida', 55, NULL, 0x40891F521E31880A0DE24E42BE2CD967E6228B3E0AC82316AC3A07A81E514DF4);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s04_e1', 1, N'cliente_id', 'numero', 0xFB3F1821FC3B87CD6F8096A58F7C97433340A5BDB43E2EA86E99E9B49833B76F, NULL),
    ('s04_e1', 2, N'etiqueta', 'texto', 0xF6B9CAF84867C65A57DA92FE22132B3D29CE3440564DB19B09E123CDCD20AF16, N'El formato exacto es: apellido paterno en mayúsculas, una coma, un espacio y los nombres. Ejemplo de otra persona: ''QUISPE, Ana María''.'),
    ('s04_e1', 3, N'dominio_correo', 'texto', 0xB7F679671361333C6580BAB9264DEE289FD8A1781606A4B53D99007104482B00, N'Es lo que va después de la arroba, sin incluir la arroba. Si el cliente no tiene correo, queda NULL.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s04_e2', 'S04', N'Cumpleañeros de Cusco este mes', 50, N'Revisa las tres condiciones: clientes activos, departamento de Cusco (el ubigeo empieza con ''08'') y nacidos en el mes de "hoy".', 0x9B843DA32B74F009F5409C64E8FD4E4F99E291E4F36D9F3B572B2B8C7CAB9E85);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s04_e2', 1, N'cliente_id', 'numero', 0x510ADB416199C174BBACA5CC900A0D4BF997CBA63900AB370B1CCCEFE4C8CAFD, NULL),
    ('s04_e2', 2, N'fecha_nacimiento', 'fecha', 0x244A2F511086DDD92FD963635F1E466F3FF58FD8D4C8818C71B8B60F6AED51EF, NULL),
    ('s04_e2', 3, N'edad_que_cumple', 'numero', 0x24F84552DCAE7F3D524E9D9BF80F5FF057C1937E7B7F62639AB3E38D4FE1BA9D, N'Es la edad que cumplen este año: la diferencia entre el año de hoy y el año de nacimiento.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s04_e3', 'S04', N'¿Qué pasó la última semana?', 1, NULL, 0xE965083A1B040EC6D2D7F9671C09DB5143B7D6EE1EC1EBF505A856D1B784C756);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s04_e3', 1, N'total_operaciones', 'numero', 0xAC093D3447F7A1810744B1F5C3997BC4796EA400FBFA3E7BC8AA20BA16B9FE53, N'La semana son 7 días: del 24 al 30 de junio, ambos incluidos, con sus horas completas. Revisa el inicio y el fin de tu rango.'),
    ('s04_e3', 2, N'monto_total', 'numero', 0xD7B781B7B20AB30D89E633C6E5A6EE8021A54ACD521F4DD2A65D843102AF4BA6, NULL);

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s04_e4', 'S04', N'Créditos del mes pasado', 458, N'El mes pasado va del primer día al último día de mayo de 2026, completo.', 0xE772C51479D135AE954E10B81F6FE7C8CE8690692FE4B517D7449AC8237F8C7C);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s04_e4', 1, N'credito_id', 'numero', 0xAFC0B680D2F31B12ACE0BB4C6D13E253B7EEA3F39669E2FCBEB68D40998A97B8, NULL),
    ('s04_e4', 2, N'fecha_desembolso', 'fecha', 0xFBD0E0BC8527E68D41F2AD79958CA090C3C50FED760CA9A9876D83692DEF1164, NULL),
    ('s04_e4', 3, N'dias_desde_desembolso', 'numero', 0x149F17E448CD4F8E9F8E59825F8A1088C0557E649EC3CB4E8D206B9EB5DCE659, N'Son los días que pasaron desde el desembolso hasta hoy: debe ser un número positivo.'),
    ('s04_e4', 4, N'fecha_primera_cuota', 'fecha', 0x008A4931A1A57B3A8AF05D6583AB02433B4388C57FD0905B89CEE6796E948A01, N'La primera cuota vence un mes calendario después del desembolso, no 30 días después.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s04_reto', 'S04', N'La última semana, día por día', 7, N'Debe salir una fila por día (7 filas). Agrupa por la fecha sin la hora.', 0x300FEAC89D854AC7448E145046905C7AE10AE1C769645D3278744E716DD657F2);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s04_reto', 1, N'fecha', 'fecha', 0x36D642B8CBA173E4FBEEBAE605419E706B6506AE7C6712BD52CD557DAF7005B9, NULL),
    ('s04_reto', 2, N'operaciones', 'numero', 0xF3AEACBE900A605E14951254711C8413D9DE770661876D0C26011273B1A7A9D2, NULL),
    ('s04_reto', 3, N'monto_total', 'numero', 0x738F699D13082F05444683B7F1A0546F5A026ED880E7152EC34C316BBBDA7C36, NULL),
    ('s04_reto', 4, N'es_fin_de_mes', 'numero', 0xC189DAF72036A99BCB01ECDDC87DFC5552BFBA4794D3222E01F028AC91F50E93, N'Vale 1 si la fecha es el último día de su mes y 0 si no.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s05_e1', 'S05', N'Radiografía de 2025', 1, NULL, 0x78CAC9DA0896DFC426FF3A53489A259201C5C644A501BC838EE94BCD6D950E56);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s05_e1', 1, N'operaciones', 'numero', 0x74ED2F525A3400B19DF33B3A1F88BD6F1ED8924DC3995C46AE6881F7A84F2830, N'¿Tus filas son solo las operaciones aprobadas, en soles y de todo 2025?'),
    ('s05_e1', 2, N'facturacion', 'numero', 0x3E87C0B38D6649BADB6FA5BAD1653E190C3C8D42484CF29DEEFD421D8B3F91A9, NULL),
    ('s05_e1', 3, N'ticket_promedio', 'numero', 0x3A5F912A21F4FB422611BDD672248788C5950C32FC2CBE4619432B717DF0724C, N'El ticket promedio es el monto promedio de las operaciones que cuentas: revisa que sean solo las aprobadas en soles.'),
    ('s05_e1', 4, N'ticket_minimo', 'numero', 0x26733E6BE55B5CC1BC02047DCAC99D1D0FC6B2BC4F50AF4685F59439642A9977, NULL),
    ('s05_e1', 5, N'ticket_maximo', 'numero', 0xBCDF89CA42D26D37A8840A6CA5AA3358245FCEE408C590F9D9502370F355EE4C, NULL);

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s05_e2', 'S05', N'Junio 2026 en números', 1, NULL, 0x96018ACF38D62D29342CD8C2E987670ADF9DBD3A2B7414277BAB136D9C91D1D0);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s05_e2', 1, N'operaciones_aprobadas', 'numero', 0xB8FBF17FAE208DAB0BBE8D29F0A469C0B83F9A79954E558B3A9412AB7CF82C51, NULL),
    ('s05_e2', 2, N'cuentas_distintas', 'numero', 0x605D8A049098BA29D1E0DA09ABB848A094D2DE1113BAE536D7BD40311553DB49, N'Una misma cuenta paga muchas veces. ¿Estás contando cuentas o filas?'),
    ('s05_e2', 3, N'comercios_distintos', 'numero', 0xB40131C3CF3CD830048CA0A6AE3DD3AE7BDC8DCA91478EA1A1168D9116000373, N'Un mismo comercio cobra muchas veces. ¿Estás contando comercios distintos o filas?'),
    ('s05_e2', 4, N'operaciones_con_promocion', 'numero', 0x44D4C76B176C54F3F7F0C92B593F0F2A82DAE4F5294087318A81E398BDBAB649, N'Cuenta las operaciones que tienen una promoción aplicada, no cuántas promociones distintas hubo.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s05_e3', 'S05', N'Facturación y ticket promedio por canal', 4, N'Debe salir una fila por canal.', 0x4C9DC4C24DC8EC93CE7BA90FAC74BCDD5ED1F48D9EC16F776DB606D8271608D4);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s05_e3', 1, N'canal_id', 'numero', 0xAD25A219F00CCF8526FADCB96CEED4F9A285600F232BD1B8898F56C29FD55E94, NULL),
    ('s05_e3', 2, N'operaciones', 'numero', 0xBFBF69590D8D2CBDA5FB2F021DDEDEC34A6C26579A63C6C9E99FDE7D25808CC7, NULL),
    ('s05_e3', 3, N'facturacion', 'numero', 0xC628E1792A299A38DE8A794538CDEE207FACBAC53EAE5DDA3B4CC762B391DD36, N'Solo cuentan las operaciones aprobadas en soles del primer semestre de 2026.'),
    ('s05_e3', 4, N'ticket_promedio', 'numero', 0x368A3BA4127D451A9C851D2B74CF6486CE6E62EF41217E46C4AD7FDE04BC31F7, NULL);

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s05_e4', 'S05', N'Tiempo de respuesta del servidor por canal', 4, NULL, 0x1DD3B4434E2D73E1706B181F76BC2BD9CB0D1194B5BCA1F92F1EA994EFBED59F);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s05_e4', 1, N'canal_id', 'numero', 0xAD25A219F00CCF8526FADCB96CEED4F9A285600F232BD1B8898F56C29FD55E94, NULL),
    ('s05_e4', 2, N'latencia_promedio_ms', 'numero', 0x094E75059881FF94EF6DC933A8E0FD1E5F38404DEDD26EA95F643CAE7F58B2AF, N'latencia_ms es un número entero, y el promedio de enteros en SQL Server también sale entero (se pierden los decimales). Convierte antes de promediar.'),
    ('s05_e4', 3, N'latencia_maxima_ms', 'numero', 0xE5C4260DA249A932612DAA2A44AD5E673BA593F2691AEC7647F2C6C0270CAFD0, N'Revisa que solo entren las operaciones aprobadas de mayo de 2026.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s05_reto', 'S05', N'Los 10 comercios que más facturaron en el segundo trimestre', 10, NULL, 0x88547B7F8796B1403242CBECD171F2F3F05A8E6EAEFCD2213F5BECDD77C8E903);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s05_reto', 1, N'comercio_id', 'numero', 0xDA040C345637BD32D2A920D40EA10D010BD5661C0E2CFCF9DA69412D6C3EB86E, N'El top es por facturación (de mayor a menor), con desempate por comercio_id menor.'),
    ('s05_reto', 2, N'operaciones', 'numero', 0x8A22EA95FBD83337A67738A7FE4A2C1C7EE3D59ED3D10E0DFBFD90D1ED0A95C1, NULL),
    ('s05_reto', 3, N'cuentas_distintas', 'numero', 0xD458BC0679E6B7DF93DC94A4BFD4A69787882B41EF3F733B6F751C21B43EFB96, N'Una cuenta que paga varias veces en el mismo comercio cuenta una sola vez.'),
    ('s05_reto', 4, N'facturacion', 'numero', 0x548A986793908F85F3B7DD419D7FA7704BF38642C130AD9E96522764810696DD, NULL),
    ('s05_reto', 5, N'ticket_promedio', 'numero', 0x2E841824063C8ACED45BBF33B32E3D671E768057012223E4EE167376D9593B43, NULL),
    ('s05_reto', 6, N'comision_total', 'numero', 0xCE2B47B6B3EEB50930491D4CCEB9D30EC922549C0A94EC2FD110FE3A53744E1B, NULL);

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s06_e1', 'S06', N'Tasa de aprobación por canal', 4, NULL, 0x691E063F18D324F85C324686059DA3A0E77775704DEE4CA686AEC8342A3449EC);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s06_e1', 1, N'canal_id', 'numero', 0xAD25A219F00CCF8526FADCB96CEED4F9A285600F232BD1B8898F56C29FD55E94, NULL),
    ('s06_e1', 2, N'intentos', 'numero', 0x61144054E243C96B2B2D22E31E63115F61F20496C80341B3DB0557E4CD48C24E, NULL),
    ('s06_e1', 3, N'aprobadas', 'numero', 0xFA66C5E696B76DDE1B7257E842EAB9E0752D91105C93C5410EE547CB011F91CB, N'Una operación cuenta como aprobada si su codigo_respuesta es ''00''. Las extornadas también fueron aprobadas en su momento.'),
    ('s06_e1', 4, N'tasa_aprobacion', 'numero', 0xEEAE5E5B06CD9D0BE35A15A05FBDD78923AD67E066669D06B6C0A7F389FF2D31, N'Es aprobadas entre intentos, por 100. Si divides dos enteros, SQL Server devuelve un entero: revisa los decimales.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s06_e2', 'S06', N'Operaciones por tramo de monto', 3, N'Deben salir 3 filas, una por tramo.', 0x109219E3F14C79B7E45BD7864AFE738B5472F0EFB7136314A55253496D30F0B0);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s06_e2', 1, N'tramo', 'texto', 0x4360975010549522A174B8D18F2D46AB2F6BAD9D5381F3DF60CC38900B95B743, N'Los nombres de los tramos son exactamente ''bajo'', ''medio'' y ''alto'', en minúsculas.'),
    ('s06_e2', 2, N'operaciones', 'numero', 0x095A8557E696E1478B6B3DEA7E9030478F397F45DA2D23A76BDA3E200AB5D716, N'Revisa los límites: 50 exacto va en ''medio'' y 200 exacto va en ''alto''.'),
    ('s06_e2', 3, N'facturacion', 'numero', 0xC5C59F61807CCAA83012B6391382B88FC086A546949FD7863F8788F730E9504A, NULL);

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s06_e3', 'S06', N'Comercios grandes con ticket alto', 30, N'Las dos condiciones son sobre el resumen de cada comercio (cuántas operaciones tuvo y su ticket promedio), no sobre cada operación. ¿Están en el HAVING?', 0xB4D368587633280D660F3DFF2976238E8F1CE337656D660E73FFE55B4F5656E2);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s06_e3', 1, N'comercio_id', 'numero', 0x39BE773B47C4097029E6953B309D9A4771437E409CBBFE787F281025F1984EAD, NULL),
    ('s06_e3', 2, N'operaciones', 'numero', 0xB2D7E0B888DD05C665FF9697A739E52EC285F3E6246CA8D96377F1C6535378A1, NULL),
    ('s06_e3', 3, N'ticket_promedio', 'numero', 0xE0A3992F050463AEF067051C371D7627CFF846F8B9BC2BE16E6C3505FE186601, NULL);

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s06_e4', 'S06', N'Tabla cruzada de rechazos por canal', 4, NULL, 0x01ABCD2E7D08E5D0D738EF6ADD43FFC7750A5CF86D6E6AB564E3BB3EA7D1593B);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s06_e4', 1, N'canal_id', 'numero', 0xAD25A219F00CCF8526FADCB96CEED4F9A285600F232BD1B8898F56C29FD55E94, NULL),
    ('s06_e4', 2, N'rechazos_cliente', 'numero', 0x1C85E010E9D9D96289C4A0CE11D0C637DCADA3EDF72631061854A1DF46955FB9, N'Revisa en core.codigo_respuesta TODOS los códigos de tipo ''Rechazo del cliente''.'),
    ('s06_e4', 3, N'rechazos_tecnicos', 'numero', 0x34D0D80ED8A8E1046969EB7E83799864C632C3968405F8CD13B7B2CE498E5B96, N'Revisa en core.codigo_respuesta TODOS los códigos de tipo ''Rechazo técnico''.'),
    ('s06_e4', 4, N'rechazos_fraude', 'numero', 0xDF757411FE06FE30D2A434F610F95F8563939E3955CD1355C9B380AB3C4F643C, N'Revisa en core.codigo_respuesta TODOS los códigos de tipo ''Sospecha de fraude''.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s06_reto', 'S06', N'Tablero mensual del primer semestre', 6, N'Debe salir una fila por mes, de enero a junio de 2026.', 0x31B610E7F48FCC349A08C385C30A8DAB487CE7F9D2FF9BD532C41555756898EC);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s06_reto', 1, N'mes', 'numero', 0xEB00841473A576A4C61B4D9621F1D70DF1466FA4FD0094561FCD2C543FE4FFC6, NULL),
    ('s06_reto', 2, N'intentos', 'numero', 0x394D8853BB0B4B6E7AF58B1C49EDB0D9DD0AD684321B30633B7FC84C702F991E, NULL),
    ('s06_reto', 3, N'tasa_aprobacion', 'numero', 0x1A3C76822D01F2A7E9D667736FA1787F41B87AE993066F2AADE7BFC2FD4568B5, N'Aprobadas (código ''00'') entre intentos, por 100, con decimales.'),
    ('s06_reto', 4, N'tasa_rechazo_tecnico', 'numero', 0x139D3B71FFBF305517E4A3B493651325DB2F175FC947412BD0351C67A27ED0D7, N'Rechazos técnicos entre intentos (todos los intentos del mes), por 100, con decimales.'),
    ('s06_reto', 5, N'facturacion_pen', 'numero', 0xCD56422DA269A9F42D546DA66EA2B8191C1F0ABC3FEF09F00BEF572A889BD2C1, N'Solo suma el monto de las operaciones aprobadas (estado ''Aprobada'') en soles; el resto suma 0.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s07_e1', 'S07', N'Facturación presencial y online', 2, N'Debe salir una fila por modalidad (Presencial y Online).', 0x4C5F897586B5771802277951D1D32F7FAD616144C992796488195F0D5302BF1E);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s07_e1', 1, N'modalidad', 'texto', 0x3B1F239734068E36E1DC0B8870B023BFAD2743354CB8794B1426DD099A70BCC2, NULL),
    ('s07_e1', 2, N'operaciones', 'numero', 0xDF9FB5D9DB49885C8763B0DCBDCEA417E836FB224E538B856322E8CF5626C338, NULL),
    ('s07_e1', 3, N'facturacion', 'numero', 0xC7572ECF1F717A4A5F6588028E5B53084C30E3BBA54942F0F44574ECE985B71E, N'Solo operaciones aprobadas en soles del primer semestre de 2026.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s07_e2', 'S07', N'Facturación y comisión por grupo de rubro', 12, N'Debe salir una fila por grupo de rubro (la columna grupo de core.rubro_mcc), no por MCC.', 0x3A8A159CA23042D21F8FA17B57B2D596F74D7879C3CF6CE47FAA137EC664273B);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s07_e2', 1, N'grupo', 'texto', 0x8FC05C7EEFC891BF817D7E7ED95C7747FD135A1BB9715B5449AD4008980A6A7E, NULL),
    ('s07_e2', 2, N'operaciones', 'numero', 0x7F0C0E24712CC3A533B6B4C1C8779299D116BAFD022D664FB416C2E92E7E55C7, NULL),
    ('s07_e2', 3, N'facturacion', 'numero', 0x3A2EFCC684CD76F38B900D9723CE0AB4B8B9D46ADB2F8E49B51C705583F2316E, NULL),
    ('s07_e2', 4, N'comision_total', 'numero', 0x06BC7A41EE308EA32450A783EAE0736C968F5CCB4F649CD80AAFC4DB603F7582, N'Revisa que solo entren operaciones aprobadas en soles.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s07_e3', 'S07', N'Clientes y facturación por departamento del cliente', 23, NULL, 0x66532070D22242DF54A7AA67098FB7DA41A23078FBE573C4883A93980BE7B07F);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s07_e3', 1, N'departamento', 'texto', 0x091BCECC80E884275596B15E2735D3EE664A0966A22FE8746B8B4A7EAA194389, N'El departamento es el de donde vive el cliente (cuenta → cliente → ubigeo), no el del comercio.'),
    ('s07_e3', 2, N'clientes', 'numero', 0xB4A08E75D2789252058B97670568DD7B488E13CF8E04F86C3B3BD910DDCC2A5F, N'Un cliente hace muchas operaciones. ¿Estás contando clientes distintos o filas?'),
    ('s07_e3', 3, N'facturacion', 'numero', 0x04D34612D5AF60DB39BA551780D1E387E47861DBF582D4EE0624973586550628, N'El departamento es el de donde vive el cliente (cuenta → cliente → ubigeo), no el del comercio.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s07_e4', 'S07', N'Dólares a soles con el tipo de cambio del día', 2, NULL, 0x412A50C97EFA9CCB5ECB7FA665B4B760613925ABBE0731A211732C812BE9631D);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s07_e4', 1, N'moneda', 'texto', 0x30ADF9EF81907AD39DD412DCF8EBF29E1BB19365612DBB203DE472D5AF13D69A, NULL),
    ('s07_e4', 2, N'operaciones', 'numero', 0x21A7A7D1F63790E9302A18FDD0D37A067B6E486DBF16CCBEE7DF9F28EA38AF2F, NULL),
    ('s07_e4', 3, N'facturacion_original', 'numero', 0x70672784C85E69949032075D5E03A7D90A0DDF6B6B633B9833029DE8724D5CE0, NULL),
    ('s07_e4', 4, N'facturacion_soles', 'numero', 0x5359513D151BEDB54354994AC63EB133A1336844AC032CEF5CBAB9F522655E8B, N'Solo los montos en dólares se multiplican por el tipo de cambio de COMPRA del día de la operación; los montos en soles quedan igual.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s07_reto', 'S07', N'¿Qué rubros y departamentos facturan más?', 10, NULL, 0xBE44A71A0990456BAA22A2301510DBC1DA2ECEF79DD1191F4F22C77678109D64);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s07_reto', 1, N'departamento', 'texto', 0xDAE84B2348A05F4A544E4D9D42FA63A9F3EE93B4489223DFD8D7F739A9378F29, N'El departamento es el del cliente (donde vive), no el del comercio.'),
    ('s07_reto', 2, N'grupo', 'texto', 0x7DA95D148385E6DB0130E18F152C2EFDF5AB8BF74764C747252F08969CAE8764, N'El grupo es la columna grupo de core.rubro_mcc.'),
    ('s07_reto', 3, N'facturacion_soles', 'numero', 0xE03833AD6E9E0AFAA421AB388CC926CE8F06D9570753AFB33671AFDCD000A779, N'Las operaciones en dólares se convierten con el tipo de cambio de compra del día; las de soles quedan igual. Solo aprobadas del primer semestre de 2026.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s08_e1', 'S08', N'Billeteras en soles que nunca se usaron', 1, NULL, 0xC275FBF33DB01D946828B214CC199C0FC6D984FBAF0448EAF2925E597CBEE025);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s08_e1', 1, N'cuentas_sin_operaciones', 'numero', 0xC275FBF33DB01D946828B214CC199C0FC6D984FBAF0448EAF2925E597CBEE025, N'Busca las cuentas en soles que no tienen pareja en core.transaccion (ninguna operación, aprobada o no). Con INNER JOIN esas cuentas desaparecen antes de que puedas contarlas.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s08_e2', 'S08', N'¿Quiénes se registraron y nunca pagaron?', 3, N'Debe salir una fila por canal de adquisición.', 0x8F4B2CF66DC4DEE979AE6395EF5AA20BBBE92CFF8A4C47EFEF0DCB59FB91FF7E);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s08_e2', 1, N'canal_adquisicion', 'texto', 0x81A0996FE36A78BB74B5898FE790210E3A754B8A9994D6A65280BE5F3154D1C2, NULL),
    ('s08_e2', 2, N'clientes', 'numero', 0x82BA0F8752730AC7ED0700CBEAEC3B5012256021674DF1BE03A4F090B1A3541C, N'Son TODOS los clientes del canal, hayan pagado o no. Si te salen menos, alguna condición en el WHERE está eliminando a los que no pagaron; si te salen más, estás contando filas en vez de clientes distintos.'),
    ('s08_e2', 3, N'clientes_sin_pago', 'numero', 0x3F6FBFB0ACBE6C1C3F873AD16940455E40F7012EEAEEBBC8525CD4B8B41C740C, N'Solo cuenta como ''con pago'' quien tiene al menos una operación APROBADA. Esa condición va en el ON del LEFT JOIN: en el WHERE, el LEFT JOIN se comporta como un INNER JOIN y los clientes sin pagos desaparecen.'),
    ('s08_e2', 4, N'pct_sin_pago', 'numero', 0xA026F310374CDF154BA3C7B247E10297BD5DCD0832E967A2C24E3C77A9B738D9, N'Es clientes sin pago entre clientes, por 100, con decimales.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s08_e3', 'S08', N'Comercios afiliados que nunca vendieron', 32, N'Son los comercios sin ninguna operación aprobada. Con un LEFT JOIN, ¿cómo reconoces las filas que no encontraron pareja?', 0x39B840C7630B80FF8EB8FCD4C8825E4161FD56CB3F2E2893AC22D58BAD82D574);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s08_e3', 1, N'comercio_id', 'numero', 0x7C09CCF1FCE89ADCCF3D19D6EB78BED4DE62FD9A9457781D252CDE894B3CCEFB, NULL),
    ('s08_e3', 2, N'nombre_comercial', 'texto', 0xD81571CBFC067ABE7FBD55038B2E60E49837C5373F8657A57F3F7ED076B5EAE8, NULL),
    ('s08_e3', 3, N'fecha_afiliacion', 'fecha', 0xDE0AC06AA126AB13C846C123FCAE43233B3E2FAED58988F128B673C907FFC15C, NULL);

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s08_e4', 'S08', N'Clientes y facturación por sexo', 2, NULL, 0x7B81DD850DBE3DFEDD4925201C3B785B117E9EA2A000E98FD3A374F2086A3A82);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s08_e4', 1, N'sexo', 'texto', 0x1B75908F5BF851487065D00565ED4B73444FD122E27911AF41208BAC666FB2B2, NULL),
    ('s08_e4', 2, N'clientes', 'numero', 0xE63A59129BB9726AF4B86279F7A8A6A0F71D768505018DCF8085E9D42D515144, N'Después del JOIN hay una fila por operación, no por cliente. ¿Estás contando clientes distintos?'),
    ('s08_e4', 3, N'operaciones', 'numero', 0x7C1DFB9FD18CDACA992F4C3A5B2D713C6E92647B641EFE0A56E242C871E94DB7, NULL),
    ('s08_e4', 4, N'facturacion', 'numero', 0xA4C042826D962740EA0042762C3693856D50628E48CACF59748B56466A298D29, NULL);

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s08_reto', 'S08', N'Tasa de contracargos por grupo de rubro', 12, N'Debe salir una fila por grupo de rubro.', 0x2A6D0C17CB198E4A3C0DF9B274919079B26467BB7A628300C332D36626ACD261);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s08_reto', 1, N'grupo', 'texto', 0x8FC05C7EEFC891BF817D7E7ED95C7747FD135A1BB9715B5449AD4008980A6A7E, NULL),
    ('s08_reto', 2, N'aprobadas', 'numero', 0x848E9832916EC1F71CD65B5734780991D17BB62719DA1866FA575916B8997251, NULL),
    ('s08_reto', 3, N'contracargos', 'numero', 0xB059FAEE10983484507B09F0BE2760E598128D784554A2F8723A247001E39E0E, N'Las operaciones sin contracargo también deben quedarse en el resultado (para contarlas como aprobadas). Cuenta una columna de core.contracargo, no las filas.'),
    ('s08_reto', 4, N'tasa_contracargo', 'numero', 0x578E9254FDBD03FE3FF59F583BE82C6AA640F5F82329502764A8F9889AFED0E0, N'Es contracargos entre aprobadas, por 100, con decimales.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s09_e1', 'S09', N'La línea de tiempo de un cliente', 12, N'Son los pagos APROBADOS con la billetera más los pagos de cuotas del cliente 222 en junio de 2026. Si te sobran filas, revisa el estado; si te faltan, revisa cómo ubicas los créditos del cliente y si usaste UNION (que borra filas repetidas) en lugar de UNION ALL.', 0x23A987947EDE1E9A89D62F2694CCEAA1C43CF140AD79843261F10C2843953D4C);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s09_e1', 1, N'fecha', 'fecha', 0xE6A8EF860597A1FAA14605875C333D73323586C16909B2231E435A2233BA5FD8, N'La fecha va sin hora (tipo DATE).'),
    ('s09_e1', 2, N'tipo_movimiento', 'texto', 0x8785FF13807B6D738B87DFA1A43BB1D7CBA805BCF04B2BB5B4AE126BA4FBBE87, N'Los textos son exactamente ''billetera'' y ''cuota'', en minúsculas.'),
    ('s09_e1', 3, N'monto', 'numero', 0x20F7572A984F83B9A220C53ACDAE9BCEA3A641E4DB85FFB81725947FB70274A2, N'En la parte de la billetera solo van los pagos aprobados.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s09_e2', 'S09', N'Clientes con actividad en junio', 8174, N'Cada cliente debe aparecer una sola vez, aunque haya pagado con la billetera y además pagado una cuota. ¿UNION o UNION ALL?', 0x9E8D516466DA7D8A7A99671AB3D74EC53D6C0E23421A09027FEF2F4CED54C910);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s09_e2', 1, N'cliente_id', 'numero', 0x9E8D516466DA7D8A7A99671AB3D74EC53D6C0E23421A09027FEF2F4CED54C910, NULL);

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s09_e3', 'S09', N'Clientes con crédito que dejaron de usar la billetera', 794, N'Son clientes con al menos un crédito en estado ''Vigente'' para los que NO EXISTE ningún pago aprobado con la billetera en mayo de 2026. Cada cliente una sola vez.', 0x0FA4F3ECA2263A95355DB541C3091B594D00AF1E659AA762805C93501280FC1D);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s09_e3', 1, N'cliente_id', 'numero', 0x0FA4F3ECA2263A95355DB541C3091B594D00AF1E659AA762805C93501280FC1D, NULL);

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s09_e4', 'S09', N'¿Quién trajo a cada cliente nuevo?', 329, NULL, 0xD970E3A9A97E9002204B44C33441573DED6BFA7F8543BC2027B8A9E1F96A6EC6);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s09_e4', 1, N'cliente_id', 'numero', 0xAE7CB643C99156F4E62F44B1029988A9A38D363E8CF938CA218487A64E0428FE, NULL),
    ('s09_e4', 2, N'referidor_id', 'numero', 0x2A505444752F0DE8D1504D9FEF35D8764B3A0A35AA67374FC29BBFB962ECB448, NULL),
    ('s09_e4', 3, N'nombre_referidor', 'texto', 0xF69FC28BBE45DB664ADBA51DB1FA9576B4CE29295668983FF25004CC42C2F4A5, N'Es el nombre del REFERIDOR (la segunda copia de core.cliente), no del cliente nuevo.'),
    ('s09_e4', 4, N'dias_desde_alta_referidor', 'numero', 0xC075FC6E608D25C5218A06FE94A3ACC710C97A63CF91720057059E2C695D6334, N'Son los días entre el alta del referidor y el alta del cliente nuevo: debe ser positivo.');

INSERT INTO chk.ejercicio (ejercicio_id, sesion, titulo, num_filas, pista_filas, hash_total) VALUES
    ('s09_reto', 'S09', N'¿Los clientes referidos gastan más que los orgánicos?', 3, N'Debe salir una fila por canal de adquisición, solo con clientes que se registraron en 2025.', 0x5B303FD616E4702854FD0A4EB2BD3602A7C4029E3062615545F2CC2521CF5C74);
INSERT INTO chk.ejercicio_columna (ejercicio_id, orden, nombre, familia, hash_columna, pista) VALUES
    ('s09_reto', 1, N'canal_adquisicion', 'texto', 0x81A0996FE36A78BB74B5898FE790210E3A754B8A9994D6A65280BE5F3154D1C2, NULL),
    ('s09_reto', 2, N'clientes', 'numero', 0xA6FEA90FFBE3662DAC18442EC674EAE8037B14695829180D560D45BC47D2BC4A, N'Son todos los clientes registrados en 2025 de ese canal, hayan pagado o no.'),
    ('s09_reto', 3, N'clientes_con_pago', 'numero', 0x584A34BA93FF0838F451F383BE19455CACE08328F11D64B21AD6CFE3356FAD27, N'Son los clientes con al menos un pago aprobado en soles. La condición sobre el pago no puede ir en el WHERE si quieres conservar a los que no pagaron.'),
    ('s09_reto', 4, N'facturacion', 'numero', 0xF6CE1F1F09D4731135194AAE031081E15AA4B10C6A7C868749FB269688BBC5A5, NULL),
    ('s09_reto', 5, N'gasto_por_cliente_con_pago', 'numero', 0xF7DC07F6B1C15437C7A673D111D80BC3D567895B22E3FAE390D49FA3CA186FB6, N'Es la facturación dividida entre los clientes que sí pagaron, no entre todos.');

GO
CREATE OR ALTER PROCEDURE chk.s00_e1 AS EXEC chk.verificar 's00_e1';
GO
CREATE OR ALTER PROCEDURE chk.s00_e2 AS EXEC chk.verificar 's00_e2';
GO
CREATE OR ALTER PROCEDURE chk.s00_e3 AS EXEC chk.verificar 's00_e3';
GO
CREATE OR ALTER PROCEDURE chk.s00_reto AS EXEC chk.verificar 's00_reto';
GO
CREATE OR ALTER PROCEDURE chk.s01_e1 AS EXEC chk.verificar 's01_e1';
GO
CREATE OR ALTER PROCEDURE chk.s01_e2 AS EXEC chk.verificar 's01_e2';
GO
CREATE OR ALTER PROCEDURE chk.s01_e3 AS EXEC chk.verificar 's01_e3';
GO
CREATE OR ALTER PROCEDURE chk.s01_e4 AS EXEC chk.verificar 's01_e4';
GO
CREATE OR ALTER PROCEDURE chk.s01_reto AS EXEC chk.verificar 's01_reto';
GO
CREATE OR ALTER PROCEDURE chk.s02_e1 AS EXEC chk.verificar 's02_e1';
GO
CREATE OR ALTER PROCEDURE chk.s02_e2 AS EXEC chk.verificar 's02_e2';
GO
CREATE OR ALTER PROCEDURE chk.s02_e3 AS EXEC chk.verificar 's02_e3';
GO
CREATE OR ALTER PROCEDURE chk.s02_e4 AS EXEC chk.verificar 's02_e4';
GO
CREATE OR ALTER PROCEDURE chk.s02_reto AS EXEC chk.verificar 's02_reto';
GO
CREATE OR ALTER PROCEDURE chk.s03_e1 AS EXEC chk.verificar 's03_e1';
GO
CREATE OR ALTER PROCEDURE chk.s03_e2 AS EXEC chk.verificar 's03_e2';
GO
CREATE OR ALTER PROCEDURE chk.s03_e3 AS EXEC chk.verificar 's03_e3';
GO
CREATE OR ALTER PROCEDURE chk.s03_e4 AS EXEC chk.verificar 's03_e4';
GO
CREATE OR ALTER PROCEDURE chk.s03_reto AS EXEC chk.verificar 's03_reto';
GO
CREATE OR ALTER PROCEDURE chk.s04_e1 AS EXEC chk.verificar 's04_e1';
GO
CREATE OR ALTER PROCEDURE chk.s04_e2 AS EXEC chk.verificar 's04_e2';
GO
CREATE OR ALTER PROCEDURE chk.s04_e3 AS EXEC chk.verificar 's04_e3';
GO
CREATE OR ALTER PROCEDURE chk.s04_e4 AS EXEC chk.verificar 's04_e4';
GO
CREATE OR ALTER PROCEDURE chk.s04_reto AS EXEC chk.verificar 's04_reto';
GO
CREATE OR ALTER PROCEDURE chk.s05_e1 AS EXEC chk.verificar 's05_e1';
GO
CREATE OR ALTER PROCEDURE chk.s05_e2 AS EXEC chk.verificar 's05_e2';
GO
CREATE OR ALTER PROCEDURE chk.s05_e3 AS EXEC chk.verificar 's05_e3';
GO
CREATE OR ALTER PROCEDURE chk.s05_e4 AS EXEC chk.verificar 's05_e4';
GO
CREATE OR ALTER PROCEDURE chk.s05_reto AS EXEC chk.verificar 's05_reto';
GO
CREATE OR ALTER PROCEDURE chk.s06_e1 AS EXEC chk.verificar 's06_e1';
GO
CREATE OR ALTER PROCEDURE chk.s06_e2 AS EXEC chk.verificar 's06_e2';
GO
CREATE OR ALTER PROCEDURE chk.s06_e3 AS EXEC chk.verificar 's06_e3';
GO
CREATE OR ALTER PROCEDURE chk.s06_e4 AS EXEC chk.verificar 's06_e4';
GO
CREATE OR ALTER PROCEDURE chk.s06_reto AS EXEC chk.verificar 's06_reto';
GO
CREATE OR ALTER PROCEDURE chk.s07_e1 AS EXEC chk.verificar 's07_e1';
GO
CREATE OR ALTER PROCEDURE chk.s07_e2 AS EXEC chk.verificar 's07_e2';
GO
CREATE OR ALTER PROCEDURE chk.s07_e3 AS EXEC chk.verificar 's07_e3';
GO
CREATE OR ALTER PROCEDURE chk.s07_e4 AS EXEC chk.verificar 's07_e4';
GO
CREATE OR ALTER PROCEDURE chk.s07_reto AS EXEC chk.verificar 's07_reto';
GO
CREATE OR ALTER PROCEDURE chk.s08_e1 AS EXEC chk.verificar 's08_e1';
GO
CREATE OR ALTER PROCEDURE chk.s08_e2 AS EXEC chk.verificar 's08_e2';
GO
CREATE OR ALTER PROCEDURE chk.s08_e3 AS EXEC chk.verificar 's08_e3';
GO
CREATE OR ALTER PROCEDURE chk.s08_e4 AS EXEC chk.verificar 's08_e4';
GO
CREATE OR ALTER PROCEDURE chk.s08_reto AS EXEC chk.verificar 's08_reto';
GO
CREATE OR ALTER PROCEDURE chk.s09_e1 AS EXEC chk.verificar 's09_e1';
GO
CREATE OR ALTER PROCEDURE chk.s09_e2 AS EXEC chk.verificar 's09_e2';
GO
CREATE OR ALTER PROCEDURE chk.s09_e3 AS EXEC chk.verificar 's09_e3';
GO
CREATE OR ALTER PROCEDURE chk.s09_e4 AS EXEC chk.verificar 's09_e4';
GO
CREATE OR ALTER PROCEDURE chk.s09_reto AS EXEC chk.verificar 's09_reto';
GO
