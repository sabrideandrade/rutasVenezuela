insert into estado ("nombreEstado") values
    ('Distrito Capital'),
    ('Mérida'),
    ('Bolívar'),
    ('Falcón'),
    ('Nueva Esparta')
on conflict ("nombreEstado") do nothing;

insert into municipio ("nombreEstado", "nombreMunicipio") values
    ('Distrito Capital', 'Libertador'),
    ('Mérida', 'Libertador'),
    ('Bolívar', 'Caroní'),
    ('Falcón', 'Miranda'),
    ('Nueva Esparta', 'Arismendi')
on conflict ("nombreEstado", "nombreMunicipio") do nothing;

insert into parroquia ("nombreEstado", "nombreMunicipio", "nombreParroquia") values
    ('Distrito Capital', 'Libertador', 'Catedral'),
    ('Distrito Capital', 'Libertador', 'Altagracia'),
    ('Mérida', 'Libertador', 'El Sagrario'),
    ('Bolívar', 'Caroní', 'Cachamay'),
    ('Falcón', 'Miranda', 'Santa Ana'),
    ('Nueva Esparta', 'Arismendi', 'La Asunción')
on conflict ("nombreEstado", "nombreMunicipio", "nombreParroquia") do nothing;

insert into categoria ("nombreCategoria", descripcion) values
    ('Histórico', 'Monumentos, cascos coloniales y sitios históricos'),
    ('Natural', 'Parques nacionales, saltos de agua y montañas'),
    ('Cultural', 'Museos, teatros y manifestaciones artísticas'),
    ('Gastronómico', 'Mercados tradicionales y rutas culinarias')
on conflict ("nombreCategoria") do nothing;

insert into hito (
    "nombreEstado", "nombreMunicipio", "nombreParroquia", "nombreHito",
    "estadoOperativo", "estadoConservacion", "libreAcceso",
    latitud, longitud, elevacion, "alturaEstructura"
) values
    ('Distrito Capital', 'Libertador', 'Catedral', 'Plaza Bolívar de Caracas',
     'disponible', 'bueno', true, 10.506060, -66.914610, 920.00, 0),
    ('Distrito Capital', 'Libertador', 'Catedral', 'Casa Natal del Libertador',
     'disponible', 'excelente', false, 10.504850, -66.913520, 918.00, 8.50),
    ('Distrito Capital', 'Libertador', 'Altagracia', 'Panteón Nacional',
     'disponible', 'excelente', false, 10.512220, -66.911940, 945.00, 22.00),
    ('Mérida', 'Libertador', 'El Sagrario', 'Teleférico Mukumbarí Estación Barinitas',
     'disponible', 'excelente', false, 8.594440, -71.140830, 1577.00, 15.00),
    ('Mérida', 'Libertador', 'El Sagrario', 'Plaza Las Heroínas',
     'disponible', 'bueno', true, 8.594900, -71.141500, 1580.00, 0),
    ('Bolívar', 'Caroní', 'Cachamay', 'Parque Cachamay',
     'disponible', 'bueno', false, 8.308890, -62.712500, 65.00, 0),
    ('Bolívar', 'Caroní', 'Cachamay', 'Parque La Llovizna',
     'disponible', 'excelente', true, 8.316670, -62.668330, 58.00, 0),
    ('Falcón', 'Miranda', 'Santa Ana', 'Médanos de Coro',
     'disponible', 'bueno', true, 11.433330, -69.683330, 18.00, 0),
    ('Falcón', 'Miranda', 'Santa Ana', 'Casa de las Ventanas de Hierro',
     'disponible', 'bueno', false, 11.409720, -69.676670, 21.00, 7.00)
on conflict ("nombreEstado", "nombreMunicipio", "nombreParroquia", "nombreHito") do nothing;

-- ============================================================
-- 1. VÍAS Y PARADAS TEMPORALES (Stub Bloque 3)
-- ============================================================
insert into via ("codigoVia", "nombreVia", "tipoVia", "condicionTerreno", desnivel, "estadoVia") values
    ('VIA-CCS-01', 'Bulevar Panteón', 'peatonal', 'adoquinado', 12.50, 'habilitada'),
    ('VIA-CCS-02', 'Avenida Universidad', 'vehicular', 'asfaltado', 5.00, 'habilitada'),
    ('VIA-MER-01', 'Calle 24 Rangel', 'mixta', 'asfaltado', 35.00, 'habilitada'),
    ('VIA-BOL-01', 'Avenida Guayana', 'vehicular', 'asfaltado', 4.00, 'habilitada'),
    ('VIA-FAL-01', 'Paseo Monseñor Iturriza', 'peatonal', 'empedrado', 2.00, 'habilitada')
on conflict ("codigoVia") do nothing;

insert into "paradaTransporte" (
    "codigoOficial", "nombreParada", "tarifaBasica", "modalidadTrans",
    "disponibilidadOperativa", "nivelAccesibilidad", "frecuenciaPaso",
    "capacidadAforo", latitud, longitud, elevacion, "alturaEstructura"
) values
    ('PAR-CCS-01', 'Estación Metro Capitolio', 10.00, 'metro', 'activa', 'alta', 5.00, 400, 10.505500, -66.916500, 915.00, 0),
    ('PAR-MER-01', 'Terminal Trolcable Mérida', 15.00, 'trolebus', 'activa', 'alta', 10.00, 120, 8.593800, -71.142200, 1575.00, 4.00),
    ('PAR-BOL-01', 'Parada Transbolívar Alta Vista', 12.00, 'autobus', 'activa', 'media', 12.00, 80, 8.299500, -62.728000, 70.00, 3.00)
on conflict ("codigoOficial") do nothing;

-- ============================================================
-- 2. ACTORES DE PRUEBA (Visitante, Guia, Comercio)
--    Ajustar nombres de columnas si bloque_transversal difiere
-- ============================================================
insert into usuario ("idUsuario", contrasena) values
    (101, 'hash_visitante_1'),
    (102, 'hash_visitante_2'),
    (201, 'hash_guia_1'),
    (202, 'hash_guia_2'),
    (301, 'hash_comercio_1'),
    (302, 'hash_comercio_2')
on conflict ("idUsuario") do nothing;

insert into visitante (
    "tipoDocumento", "numeroDocumento", "paisOrigen", "idiomaNativo",
    "telefonoEmergencia", "grupoSanguineo", "idUsuario"
) values
    ('cedula', 'V-26451890', 'Venezuela', 'Español', '+58-412-5550101', 'O+', 101),
    ('pasaporte', 'US-9948201', 'Estados Unidos', 'Inglés', '+1-305-5550199', 'A+', 102)
on conflict ("tipoDocumento", "numeroDocumento") do nothing;

insert into guia (
    rtn, "codigoLicencia", "nombreCompleto", "acreditacionOficial",
    "aniosTrayectoria", "tarifaHoraria", "zonaGeografica", "idUsuario"
) values
    ('RTN-10452', 'LIC-CCS-001', 'Carlos Eduardo Mendoza', 'MINTUR-2021-045', 8, 25.00, 'Distrito Capital', 201),
    ('RTN-20881', 'LIC-MER-009', 'Andreína Sofía Rangel', 'MINTUR-2019-112', 11, 30.00, 'Mérida', 202)
on conflict (rtn, "codigoLicencia") do nothing;

insert into comercio (
    rif, "razonSocial", "categoriaComercial", aforo, "permisoSanitario",
    "cuentaBancaria", latitud, longitud, elevacion, "alturaEstructura", "idUsuario"
) values
    ('J-30112233-4', 'Café Colonial El Marqués C.A.', 'Gastronomía', 45, 'PS-CCS-8821',
     '0102-0001-000012345678', 10.505100, -66.913900, 919.00, 0, 301),
    ('J-40556677-8', 'Posada Andina Sierra Nevada S.R.L.', 'Alojamiento y Tours', 60, 'PS-MER-3310',
     '0134-0002-000087654321', 8.594600, -71.141100, 1578.00, 0, 302)
on conflict (rif) do nothing;

-- ============================================================
-- 3. ESPECIALIDADES E IDIOMAS DE GUÍAS
-- ============================================================
insert into "especialidadGuia" (rtn, "codigoLicencia", especialidad) values
    ('RTN-10452', 'LIC-CCS-001', 'Historia Republicana'),
    ('RTN-10452', 'LIC-CCS-001', 'Arquitectura Colonial'),
    ('RTN-20881', 'LIC-MER-009', 'Ecoturismo de Alta Montaña'),
    ('RTN-20881', 'LIC-MER-009', 'Fotografía de Paisajes')
on conflict do nothing;

insert into "idiomaGuia" (rtn, "codigoLicencia", idioma) values
    ('RTN-10452', 'LIC-CCS-001', 'Español'),
    ('RTN-10452', 'LIC-CCS-001', 'Inglés'),
    ('RTN-20881', 'LIC-MER-009', 'Español'),
    ('RTN-20881', 'LIC-MER-009', 'Francés')
on conflict do nothing;

-- ============================================================
-- 4. RUTAS + SUBTIPOS + ETAPAS (en transacciones atómicas)
-- ============================================================
begin;
    -- Ruta Fija 1: Casco Histórico de Caracas (3 etapas: Hito -> Parada -> Hito)
    call sp_crear_ruta_completa(
        'Distrito Capital', 'Libertador', 'Ruta Histórica del Casco Central',
        2.50, '09:00:00', 'facil', 'fija', null, null,
        '[
            {"numeroSecuencia":1,"modoTransporte":null,"tiempoDesdeAnterior":null,
             "nombreEstadoHito":"Distrito Capital","nombreMunicipioHito":"Libertador",
             "nombreParroquia":"Catedral","nombreHito":"Plaza Bolívar de Caracas",
             "codigoOficial":null,"codigoVia":null},
            {"numeroSecuencia":2,"modoTransporte":"aPie","tiempoDesdeAnterior":8,
             "nombreEstadoHito":null,"nombreMunicipioHito":null,
             "nombreParroquia":null,"nombreHito":null,
             "codigoOficial":"PAR-CCS-01","codigoVia":"VIA-CCS-02"},
            {"numeroSecuencia":3,"modoTransporte":"aPie","tiempoDesdeAnterior":12,
             "nombreEstadoHito":"Distrito Capital","nombreMunicipioHito":"Libertador",
             "nombreParroquia":"Altagracia","nombreHito":"Panteón Nacional",
             "codigoOficial":null,"codigoVia":"VIA-CCS-01"}
        ]'::jsonb,
        array['Histórico','Cultural']
    );

    -- Ruta Fija 2: Aventura en los Parques del Caroní
    call sp_crear_ruta_completa(
        'Bolívar', 'Caroní', 'Circuito Saltos del Caroní',
        3.00, '08:30:00', 'moderado', 'fija', null, null,
        '[
            {"numeroSecuencia":1,"modoTransporte":null,"tiempoDesdeAnterior":null,
             "nombreEstadoHito":"Bolívar","nombreMunicipioHito":"Caroní",
             "nombreParroquia":"Cachamay","nombreHito":"Parque Cachamay",
             "codigoOficial":null,"codigoVia":null},
            {"numeroSecuencia":2,"modoTransporte":"autobus","tiempoDesdeAnterior":15,
             "nombreEstadoHito":"Bolívar","nombreMunicipioHito":"Caroní",
             "nombreParroquia":"Cachamay","nombreHito":"Parque La Llovizna",
             "codigoOficial":null,"codigoVia":"VIA-BOL-01"}
        ]'::jsonb,
        array['Natural']
    );

    -- Ruta Dinámica 1: Creada por el visitante V-26451890 en Mérida
    call sp_crear_ruta_completa(
        'Mérida', 'Libertador', 'Mi Ascenso Mukumbarí',
        4.00, '07:30:00', 'moderado', 'dinamica', 'cedula', 'V-26451890',
        '[
            {"numeroSecuencia":1,"modoTransporte":null,"tiempoDesdeAnterior":null,
             "nombreEstadoHito":"Mérida","nombreMunicipioHito":"Libertador",
             "nombreParroquia":"El Sagrario","nombreHito":"Plaza Las Heroínas",
             "codigoOficial":null,"codigoVia":null},
            {"numeroSecuencia":2,"modoTransporte":"aPie","tiempoDesdeAnterior":5,
             "nombreEstadoHito":"Mérida","nombreMunicipioHito":"Libertador",
             "nombreParroquia":"El Sagrario","nombreHito":"Teleférico Mukumbarí Estación Barinitas",
             "codigoOficial":null,"codigoVia":"VIA-MER-01"}
        ]'::jsonb,
        array['Natural','Cultural']
    );
commit;

insert into "preferenciaTransporte" ("nombreEstado", "nombreMunicipio", "nombreRuta", "preferenciaTransporte") values
    ('Distrito Capital', 'Libertador', 'Ruta Histórica del Casco Central', 'aPie'),
    ('Bolívar', 'Caroní', 'Circuito Saltos del Caroní', 'autobus'),
    ('Mérida', 'Libertador', 'Mi Ascenso Mukumbarí', 'aPie')
on conflict do nothing;

insert into "guiaRuta" (rtn, "codigoLicencia", "nombreEstado", "nombreMunicipio", "nombreRuta") values
    ('RTN-10452', 'LIC-CCS-001', 'Distrito Capital', 'Libertador', 'Ruta Histórica del Casco Central'),
    ('RTN-20881', 'LIC-MER-009', 'Mérida', 'Libertador', 'Mi Ascenso Mukumbarí')
on conflict do nothing;

-- ============================================================
-- 5. RECORRIDOS, VISITAS A HITOS Y EVALUACIONES VERIFICADAS
-- ============================================================
insert into recorrido (
    "codigoRecorrido", "fechaRealizacion", "estadoRecorrido",
    "tipoDocumento", "numeroDocumento",
    "nombreEstadoRuta", "nombreMunicipioRuta", "nombreRuta"
) values
    ('REC-2026-001', current_date - 5, 'completado', 'cedula', 'V-26451890',
     'Distrito Capital', 'Libertador', 'Ruta Histórica del Casco Central'),
    ('REC-2026-002', current_date - 2, 'completado', 'pasaporte', 'US-9948201',
     'Distrito Capital', 'Libertador', 'Ruta Histórica del Casco Central'),
    ('REC-2026-003', current_date - 1, 'enCurso', 'cedula', 'V-26451890',
     'Mérida', 'Libertador', 'Mi Ascenso Mukumbarí')
on conflict ("codigoRecorrido") do nothing;

insert into "visitaHito" (
    "tipoDocumento", "numeroDocumento", "fechaHora",
    "nombreEstadoHito", "nombreMunicipioHito", "nombreParroquia", "nombreHito"
) values
    ('cedula', 'V-26451890', current_timestamp - interval '5 days',
     'Distrito Capital', 'Libertador', 'Catedral', 'Casa Natal del Libertador'),
    ('pasaporte', 'US-9948201', current_timestamp - interval '3 days',
     'Mérida', 'Libertador', 'El Sagrario', 'Teleférico Mukumbarí Estación Barinitas')
on conflict do nothing;

-- Evaluaciones (disparan trg_eval_verificacion)
insert into evaluacion (
    "codigoResena", calificacion, "indiceSeguridad", "fechaEmision", opinion,
    "tipoDocumento", "numeroDocumento",
    "nombreEstadoRuta", "nombreMunicipioRuta", "nombreRuta"
) values
    ('RES-001', 5, 4, current_date - 4,
     'Excelente recorrido guiado por el casco colonial, muy informativo.',
     'cedula', 'V-26451890',
     'Distrito Capital', 'Libertador', 'Ruta Histórica del Casco Central'),
    ('RES-002', 4, 4, current_date - 1,
     'Muy buena arquitectura histórica y señalización clara.',
     'pasaporte', 'US-9948201',
     'Distrito Capital', 'Libertador', 'Ruta Histórica del Casco Central')
on conflict ("codigoResena") do nothing;

insert into evaluacion (
    "codigoResena", calificacion, "indiceSeguridad", "fechaEmision", opinion,
    "tipoDocumento", "numeroDocumento",
    "nombreEstadoHito", "nombreMunicipioHito", "nombreParroquia", "nombreHito"
) values
    ('RES-003', 5, 5, current_date - 4,
     'Museo impecable y guías muy amables en la Casa Natal.',
     'cedula', 'V-26451890',
     'Distrito Capital', 'Libertador', 'Catedral', 'Casa Natal del Libertador')
on conflict ("codigoResena") do nothing;

-- ============================================================
-- 6. SERVICIOS Y EXPERIENCIAS PROMOCIONALES
-- ============================================================
insert into servicio (rif, "nombreServicio", tipologia, precio) values
    ('J-30112233-4', 'Desayuno Criollo Colonial', 'Gastronomía', 12.50),
    ('J-30112233-4', 'Degustación de Cacao Venezolano', 'Gastronomía', 18.00),
    ('J-40556677-8', 'Alquiler de Equipo Térmico de Montaña', 'Equipamiento', 22.00)
on conflict (rif, "nombreServicio") do nothing;

insert into experiencia (
    titulo, "fechaActivacion", descripcion, "precioTotal", "cupoMaximo",
    "porcentajeDescuento", "fechaVencimiento", "codigoPromocional",
    rif, rtn, "codigoLicencia",
    "nombreEstadoRuta", "nombreMunicipioRuta", "nombreRuta"
) values
    ('Mañana Histórica y Cacao en Caracas', current_date - 10,
     'Recorrido guiado por el Casco Central con desayuno y degustación de cacao.',
     35.00, 15, 15.00, current_date + 60, 'CARACAS15',
     'J-30112233-4', 'RTN-10452', 'LIC-CCS-001',
     'Distrito Capital', 'Libertador', 'Ruta Histórica del Casco Central')
on conflict (titulo, "fechaActivacion") do nothing;

insert into "experienciaHito" (
    titulo, "fechaActivacion",
    "nombreEstado", "nombreMunicipio", "nombreParroquia", "nombreHito"
) values
    ('Mañana Histórica y Cacao en Caracas', current_date - 10,
     'Distrito Capital', 'Libertador', 'Catedral', 'Plaza Bolívar de Caracas'),
    ('Mañana Histórica y Cacao en Caracas', current_date - 10,
     'Distrito Capital', 'Libertador', 'Altagracia', 'Panteón Nacional')
on conflict do nothing;

insert into "experienciaServicio" (titulo, "fechaActivacion", rif, "nombreServicio") values
    ('Mañana Histórica y Cacao en Caracas', current_date - 10, 'J-30112233-4', 'Desayuno Criollo Colonial'),
    ('Mañana Histórica y Cacao en Caracas', current_date - 10, 'J-30112233-4', 'Degustación de Cacao Venezolano')
on conflict do nothing;

-- ============================================================
-- 7. CREDENCIALES DIGITALES (emitida, cancelada y para canje hoy)
-- ============================================================
insert into credencial (
    "codigoVerificacion", "fechaProgramada", "horaProgramada", "montoAbonado",
    "cantidadBeneficiarios", "estadoPase", "horaInicio", "horaFin", "fechaHoraCanje",
    "tipoDocumento", "numeroDocumento",
    "nombreEstadoHito", "nombreMunicipioHito", "nombreParroquia", "nombreHito",
    rif, "nombreServicio", "idUsuarioValida"
) values
    -- Credencial emitida para hito pagado (Casa Natal del Libertador)
    ('CRED-CCS-2026-001', current_date, '10:00:00', 10.00, 2, 'emitido',
     '00:00:00', '23:59:59', null,
     'cedula', 'V-26451890',
     'Distrito Capital', 'Libertador', 'Catedral', 'Casa Natal del Libertador',
     null, null, null),
    -- Credencial emitida para servicio de comercio
    ('CRED-SRV-2026-002', current_date + 3, '09:30:00', 25.00, 2, 'emitido',
     '08:00:00', '12:00:00', null,
     'pasaporte', 'US-9948201',
     null, null, null, null,
     'J-30112233-4', 'Desayuno Criollo Colonial', null),
    -- Credencial cancelada (demuestra que no se elimina, solo cambia estado)
    ('CRED-CCS-2026-003', current_date - 1, '14:00:00', 15.00, 1, 'cancelado',
     '13:00:00', '17:00:00', null,
     'cedula', 'V-26451890',
     'Distrito Capital', 'Libertador', 'Altagracia', 'Panteón Nacional',
     null, null, null)
on conflict ("codigoVerificacion") do nothing;
