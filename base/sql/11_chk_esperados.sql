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
