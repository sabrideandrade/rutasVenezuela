
-- TABLAS TEMPORALES DE BLOQUE 3 (Via y ParadaTransporte)
-- Eliminar cuando Bloque 3 suba su script definitivo

drop table if exists "paradaVia" cascade;
drop table if exists "horarioParada" cascade;
drop table if exists "equipamiento" cascade;
drop table if exists "cercanaA" cascade;
drop table if exists "paradaTransporte" cascade;
drop table if exists via cascade;

create table via (
    "codigoVia"        varchar(20)  not null,
    "nombreVia"        varchar(100) not null,
    "tipoVia"          varchar(50)  not null,
    "condicionTerreno" varchar(50),
    desnivel           numeric(8,2),
    "estadoVia"        varchar(30)  not null,
    constraint "pkVia" primary key ("codigoVia"),
    constraint "chkViaEstado" check ("estadoVia" in
        ('habilitada','cierreTotal','cerradaPermanentemente'))
);

create table "paradaTransporte" (
    "codigoOficial"          varchar(20)   not null,
    "nombreParada"           varchar(150)  not null,
    "tarifaBasica"           numeric(12,2) not null,
    "modalidadTrans"         varchar(50)   not null,
    "disponibilidadOperativa" varchar(30)  not null,
    "nivelAccesibilidad"     varchar(30),
    "frecuenciaPaso"         numeric(8,2)  not null,
    "capacidadAforo"         integer       not null,
    latitud                  numeric(9,6)  not null,
    longitud                 numeric(9,6)  not null,
    elevacion                numeric(8,2)  not null,
    "alturaEstructura"       numeric(6,2)  not null default 0,
    constraint "pkParadaTransporte" primary key ("codigoOficial"),
    constraint "chkParadaTarifa"    check ("tarifaBasica" >= 0),
    constraint "chkParadaFrecuencia" check ("frecuenciaPaso" > 0),
    constraint "chkParadaAforo"     check ("capacidadAforo" >= 1),
    constraint "chkParadaLatitud"   check (latitud between -90 and 90),
    constraint "chkParadaLongitud"  check (longitud between -180 and 180),
    constraint "chkParadaAltura"    check ("alturaEstructura" >= 0)
);

-- ============================================================
-- TABLAS DEL BLOQUE 2
-- ============================================================
drop table if exists credencial cascade;
drop table if exists "experienciaServicio" cascade;
drop table if exists "experienciaHito" cascade;
drop table if exists experiencia cascade;
drop table if exists servicio cascade;
drop table if exists evaluacion cascade;
drop table if exists "visitaHito" cascade;
drop table if exists recorrido cascade;
drop table if exists etapa cascade;
drop table if exists "guiaRuta" cascade;
drop table if exists tematica cascade;
drop table if exists "preferenciaTransporte" cascade;
drop table if exists "rutaDinamica" cascade;
drop table if exists "rutaFija" cascade;
drop table if exists ruta cascade;
drop table if exists "idiomaGuia" cascade;
drop table if exists "especialidadGuia" cascade;

-- atributos multivaluados de Guia (si no los creo Iliany)
create table "especialidadGuia" (
    rtn              varchar(20)  not null,
    "codigoLicencia" varchar(20)  not null,
    especialidad     varchar(100) not null,
    constraint "pkEspecialidadGuia" primary key (rtn, "codigoLicencia", especialidad),
    constraint "fkEspecialidadGuia" foreign key (rtn, "codigoLicencia")
        references guia (rtn, "codigoLicencia")
        on update cascade on delete cascade
);

create table "idiomaGuia" (
    rtn              varchar(20) not null,
    "codigoLicencia" varchar(20) not null,
    idioma           varchar(80) not null,
    constraint "pkIdiomaGuia" primary key (rtn, "codigoLicencia", idioma),
    constraint "fkIdiomaGuia" foreign key (rtn, "codigoLicencia")
        references guia (rtn, "codigoLicencia")
        on update cascade on delete cascade
);

-- RR-25 tipoRuta fija/dinamica  RR-26 duracion > 0
create table ruta (
    "nombreEstado"       varchar(60)  not null,
    "nombreMunicipio"    varchar(80)  not null,
    "nombreRuta"         varchar(200) not null,
    "duracionEstimada"   numeric(8,2) not null,
    "mejorHorarioInicio" time,
    "nivelDificultad"    varchar(30)  not null,
    "tipoRuta"           varchar(10)  not null,
    constraint "pkRuta" primary key ("nombreEstado", "nombreMunicipio", "nombreRuta"),
    constraint "fkRutaMunicipio" foreign key ("nombreEstado", "nombreMunicipio")
        references municipio ("nombreEstado", "nombreMunicipio")
        on update cascade on delete restrict,
    constraint "chkRutaDuracion"    check ("duracionEstimada" > 0),
    constraint "chkRutaTipo"        check ("tipoRuta" in ('fija','dinamica')),
    constraint "chkRutaDificultad"  check ("nivelDificultad" in ('facil','moderado','dificil','experto'))
);

-- especializacion total y disjunta de ruta (RR-25)
create table "rutaFija" (
    "nombreEstado"    varchar(60)  not null,
    "nombreMunicipio" varchar(80)  not null,
    "nombreRuta"      varchar(200) not null,
    constraint "pkRutaFija" primary key ("nombreEstado", "nombreMunicipio", "nombreRuta"),
    constraint "fkRutaFija" foreign key ("nombreEstado", "nombreMunicipio", "nombreRuta")
        references ruta ("nombreEstado", "nombreMunicipio", "nombreRuta")
        on update cascade on delete cascade
);

create table "rutaDinamica" (
    "nombreEstado"    varchar(60)  not null,
    "nombreMunicipio" varchar(80)  not null,
    "nombreRuta"      varchar(200) not null,
    "tipoDocumento"   varchar(20)  not null,
    "numeroDocumento" varchar(30)  not null,
    constraint "pkRutaDinamica" primary key ("nombreEstado", "nombreMunicipio", "nombreRuta"),
    constraint "fkRutaDinamica" foreign key ("nombreEstado", "nombreMunicipio", "nombreRuta")
        references ruta ("nombreEstado", "nombreMunicipio", "nombreRuta")
        on update cascade on delete cascade,
    constraint "fkRutaDinamicaVisitante" foreign key ("tipoDocumento", "numeroDocumento")
        references visitante ("tipoDocumento", "numeroDocumento")
        on update cascade on delete restrict
);

-- preferencias de transporte de una ruta (atributo multivaluado)
create table "preferenciaTransporte" (
    "nombreEstado"          varchar(60)  not null,
    "nombreMunicipio"       varchar(80)  not null,
    "nombreRuta"            varchar(200) not null,
    "preferenciaTransporte" varchar(80)  not null,
    constraint "pkPreferenciaTransporte" primary key
        ("nombreEstado", "nombreMunicipio", "nombreRuta", "preferenciaTransporte"),
    constraint "fkPtRuta" foreign key ("nombreEstado", "nombreMunicipio", "nombreRuta")
        references ruta ("nombreEstado", "nombreMunicipio", "nombreRuta")
        on update cascade on delete cascade
);

-- categorias tematicas de una ruta
create table tematica (
    "nombreEstado"    varchar(60)  not null,
    "nombreMunicipio" varchar(80)  not null,
    "nombreRuta"      varchar(200) not null,
    "nombreCategoria" varchar(60)  not null,
    constraint "pkTematica" primary key
        ("nombreEstado", "nombreMunicipio", "nombreRuta", "nombreCategoria"),
    constraint "fkTematicaRuta" foreign key ("nombreEstado", "nombreMunicipio", "nombreRuta")
        references ruta ("nombreEstado", "nombreMunicipio", "nombreRuta")
        on update cascade on delete cascade,
    constraint "fkTematicaCategoria" foreign key ("nombreCategoria")
        references categoria ("nombreCategoria")
        on update cascade on delete restrict
);

-- asignacion de guia a ruta
create table "guiaRuta" (
    rtn              varchar(20)  not null,
    "codigoLicencia" varchar(20)  not null,
    "nombreEstado"   varchar(60)  not null,
    "nombreMunicipio" varchar(80) not null,
    "nombreRuta"     varchar(200) not null,
    constraint "pkGuiaRuta" primary key (rtn, "codigoLicencia", "nombreEstado", "nombreMunicipio", "nombreRuta"),
    constraint "fkGuiaRutaGuia" foreign key (rtn, "codigoLicencia")
        references guia (rtn, "codigoLicencia")
        on update cascade on delete restrict,
    constraint "fkGuiaRutaRuta" foreign key ("nombreEstado", "nombreMunicipio", "nombreRuta")
        references ruta ("nombreEstado", "nombreMunicipio", "nombreRuta")
        on update cascade on delete cascade
);

-- RR-28 arco hito/parada completo  RR-29 exclusivo  RR-30 secuencia  RR-31 extremos hito  RR-32 via obligatoria desde etapa 2
create table etapa (
    "nombreEstadoRuta"    varchar(60)  not null,
    "nombreMunicipioRuta" varchar(80)  not null,
    "nombreRuta"          varchar(200) not null,
    "numeroSecuencia"     integer      not null,
    "modoTransporte"      varchar(50),
    "tiempoDesdeAnterior" numeric(8,2),
    -- arco hito (4 columnas)
    "nombreEstadoHito"    varchar(60),
    "nombreMunicipioHito" varchar(80),
    "nombreParroquia"     varchar(80),
    "nombreHito"          varchar(120),
    -- arco parada (1 columna)
    "codigoOficial"       varchar(20),
    -- via (obligatoria desde etapa 2)
    "codigoVia"           varchar(20),
    constraint "pkEtapa" primary key
        ("nombreEstadoRuta", "nombreMunicipioRuta", "nombreRuta", "numeroSecuencia"),
    constraint "fkEtapaRuta" foreign key ("nombreEstadoRuta", "nombreMunicipioRuta", "nombreRuta")
        references ruta ("nombreEstado", "nombreMunicipio", "nombreRuta")
        on update cascade on delete cascade,
    constraint "fkEtapaHito" foreign key
        ("nombreEstadoHito", "nombreMunicipioHito", "nombreParroquia", "nombreHito")
        references hito ("nombreEstado", "nombreMunicipio", "nombreParroquia", "nombreHito")
        on update cascade on delete restrict,
    constraint "fkEtapaParada" foreign key ("codigoOficial")
        references "paradaTransporte" ("codigoOficial")
        on update cascade on delete restrict,
    constraint "fkEtapaVia" foreign key ("codigoVia")
        references via ("codigoVia")
        on update cascade on delete restrict,
    -- RR-28: columnas hito todas null o todas not null
    constraint "chkEtapaHitoCompleto" check (
        ("nombreEstadoHito" is null and "nombreMunicipioHito" is null
         and "nombreParroquia" is null and "nombreHito" is null)
        or
        ("nombreEstadoHito" is not null and "nombreMunicipioHito" is not null
         and "nombreParroquia" is not null and "nombreHito" is not null)
    ),
    -- RR-29: hito XOR parada (arco exclusivo completo)
    constraint "chkEtapaArco" check (
        ("nombreHito" is not null and "codigoOficial" is null)
        or
        ("nombreHito" is null and "codigoOficial" is not null)
    ),
    -- RR-30: numero de secuencia >= 1
    constraint "chkEtapaSecuencia" check ("numeroSecuencia" >= 1),
    -- RR-32: desde etapa 2 en adelante, via + modo + tiempo obligatorios
    constraint "chkEtapaDesdeSegunda" check (
        "numeroSecuencia" = 1
        or ("numeroSecuencia" > 1
            and "codigoVia" is not null
            and "modoTransporte" is not null
            and "tiempoDesdeAnterior" is not null)
    ),
    constraint "chkEtapaTiempo" check ("tiempoDesdeAnterior" is null or "tiempoDesdeAnterior" >= 0)
);

-- RR-33
create table recorrido (
    "codigoRecorrido"     varchar(30)  not null,
    "fechaRealizacion"    date         not null,
    "estadoRecorrido"     varchar(20)  not null,
    "tipoDocumento"       varchar(20)  not null,
    "numeroDocumento"     varchar(30)  not null,
    "nombreEstadoRuta"    varchar(60)  not null,
    "nombreMunicipioRuta" varchar(80)  not null,
    "nombreRuta"          varchar(200) not null,
    constraint "pkRecorrido" primary key ("codigoRecorrido"),
    constraint "fkRecorridoVisitante" foreign key ("tipoDocumento", "numeroDocumento")
        references visitante ("tipoDocumento", "numeroDocumento")
        on update cascade on delete restrict,
    constraint "fkRecorridoRuta" foreign key ("nombreEstadoRuta", "nombreMunicipioRuta", "nombreRuta")
        references ruta ("nombreEstado", "nombreMunicipio", "nombreRuta")
        on update cascade on delete restrict,
    constraint "chkRecorridoEstado" check ("estadoRecorrido" in ('enCurso','completado'))
);

-- registro de visita a un hito especifico
create table "visitaHito" (
    "tipoDocumento"      varchar(20)  not null,
    "numeroDocumento"    varchar(30)  not null,
    "fechaHora"          timestamp    not null,
    "nombreEstadoHito"   varchar(60)  not null,
    "nombreMunicipioHito" varchar(80) not null,
    "nombreParroquia"    varchar(80)  not null,
    "nombreHito"         varchar(120) not null,
    constraint "pkVisitaHito" primary key
        ("tipoDocumento", "numeroDocumento", "fechaHora",
         "nombreEstadoHito", "nombreMunicipioHito", "nombreParroquia", "nombreHito"),
    constraint "fkVisitaVisitante" foreign key ("tipoDocumento", "numeroDocumento")
        references visitante ("tipoDocumento", "numeroDocumento")
        on update cascade on delete restrict,
    constraint "fkVisitaHito" foreign key
        ("nombreEstadoHito", "nombreMunicipioHito", "nombreParroquia", "nombreHito")
        references hito ("nombreEstado", "nombreMunicipio", "nombreParroquia", "nombreHito")
        on update cascade on delete restrict
);

-- RR-34 arco hito/ruta completo  RR-35 exclusivo  RR-36 calificacion 1-5
-- UPDATE bloqueado por trigger (02_triggers.sql)
create table evaluacion (
    "codigoResena"         varchar(30) not null,
    calificacion           integer     not null,
    "indiceSeguridad"      integer     not null,
    "fechaEmision"         date        not null,
    opinion                text,
    "verificacionRecorrido" boolean    not null default false,
    "tipoDocumento"        varchar(20) not null,
    "numeroDocumento"      varchar(30) not null,
    -- arco hito (4 columnas)
    "nombreEstadoHito"     varchar(60),
    "nombreMunicipioHito"  varchar(80),
    "nombreParroquia"      varchar(80),
    "nombreHito"           varchar(120),
    -- arco ruta (3 columnas)
    "nombreEstadoRuta"     varchar(60),
    "nombreMunicipioRuta"  varchar(80),
    "nombreRuta"           varchar(200),
    constraint "pkEvaluacion" primary key ("codigoResena"),
    constraint "fkEvalVisitante" foreign key ("tipoDocumento", "numeroDocumento")
        references visitante ("tipoDocumento", "numeroDocumento")
        on update cascade on delete restrict,
    constraint "fkEvalHito" foreign key
        ("nombreEstadoHito", "nombreMunicipioHito", "nombreParroquia", "nombreHito")
        references hito ("nombreEstado", "nombreMunicipio", "nombreParroquia", "nombreHito")
        on update cascade on delete restrict,
    constraint "fkEvalRuta" foreign key ("nombreEstadoRuta", "nombreMunicipioRuta", "nombreRuta")
        references ruta ("nombreEstado", "nombreMunicipio", "nombreRuta")
        on update cascade on delete restrict,
    -- RR-36
    constraint "chkEvalCalificacion"  check (calificacion between 1 and 5),
    constraint "chkEvalSeguridad"     check ("indiceSeguridad" between 1 and 5),
    -- RR-34: columnas hito todas null o todas not null
    constraint "chkEvalHitoCompleto" check (
        ("nombreEstadoHito" is null and "nombreMunicipioHito" is null
         and "nombreParroquia" is null and "nombreHito" is null)
        or
        ("nombreEstadoHito" is not null and "nombreMunicipioHito" is not null
         and "nombreParroquia" is not null and "nombreHito" is not null)
    ),
    -- RR-35: columnas ruta todas null o todas not null
    constraint "chkEvalRutaCompleta" check (
        ("nombreEstadoRuta" is null and "nombreMunicipioRuta" is null and "nombreRuta" is null)
        or
        ("nombreEstadoRuta" is not null and "nombreMunicipioRuta" is not null and "nombreRuta" is not null)
    ),
    -- arco exclusivo hito XOR ruta
    constraint "chkEvalArco" check (
        ("nombreHito" is not null and "nombreRuta" is null)
        or
        ("nombreHito" is null and "nombreRuta" is not null)
    )
);

-- RR-39
create table servicio (
    rif             varchar(20)   not null,
    "nombreServicio" varchar(150) not null,
    tipologia       varchar(80)   not null,
    precio          numeric(12,2) not null,
    constraint "pkServicio" primary key (rif, "nombreServicio"),
    constraint "fkServicioComercio" foreign key (rif)
        references comercio (rif)
        on update cascade on delete cascade,
    constraint "chkServicioPrecio" check (precio >= 0)
);

-- RR-40 fechaVencimiento > fechaActivacion  RR-41 cupo/precio/descuento
create table experiencia (
    titulo               varchar(200)  not null,
    "fechaActivacion"    date          not null,
    descripcion          text          not null,
    "precioTotal"        numeric(12,2) not null,
    "cupoMaximo"         integer       not null,
    "porcentajeDescuento" numeric(5,2) not null,
    "fechaVencimiento"   date          not null,
    "codigoPromocional"  varchar(50),
    rif                  varchar(20)   not null,
    rtn                  varchar(20)   not null,
    "codigoLicencia"     varchar(20)   not null,
    "nombreEstadoRuta"   varchar(60)   not null,
    "nombreMunicipioRuta" varchar(80)  not null,
    "nombreRuta"         varchar(200)  not null,
    constraint "pkExperiencia" primary key (titulo, "fechaActivacion"),
    constraint "fkExpComercio" foreign key (rif)
        references comercio (rif)
        on update cascade on delete restrict,
    constraint "fkExpGuia" foreign key (rtn, "codigoLicencia")
        references guia (rtn, "codigoLicencia")
        on update cascade on delete restrict,
    constraint "fkExpRuta" foreign key ("nombreEstadoRuta", "nombreMunicipioRuta", "nombreRuta")
        references ruta ("nombreEstado", "nombreMunicipio", "nombreRuta")
        on update cascade on delete restrict,
    constraint "chkExpFechas"     check ("fechaVencimiento" > "fechaActivacion"),
    constraint "chkExpPrecio"     check ("precioTotal" >= 0),
    constraint "chkExpCupo"       check ("cupoMaximo" >= 1),
    constraint "chkExpDescuento"  check ("porcentajeDescuento" between 0 and 100)
);

-- hitos que incluye una experiencia
create table "experienciaHito" (
    titulo            varchar(200) not null,
    "fechaActivacion" date         not null,
    "nombreEstado"    varchar(60)  not null,
    "nombreMunicipio" varchar(80)  not null,
    "nombreParroquia" varchar(80)  not null,
    "nombreHito"      varchar(120) not null,
    constraint "pkExpHito" primary key
        (titulo, "fechaActivacion", "nombreEstado", "nombreMunicipio", "nombreParroquia", "nombreHito"),
    constraint "fkExpHitoExp" foreign key (titulo, "fechaActivacion")
        references experiencia (titulo, "fechaActivacion")
        on update cascade on delete cascade,
    constraint "fkExpHitoHito" foreign key
        ("nombreEstado", "nombreMunicipio", "nombreParroquia", "nombreHito")
        references hito ("nombreEstado", "nombreMunicipio", "nombreParroquia", "nombreHito")
        on update cascade on delete restrict
);

-- servicios que incluye una experiencia
create table "experienciaServicio" (
    titulo            varchar(200) not null,
    "fechaActivacion" date         not null,
    rif               varchar(20)  not null,
    "nombreServicio"  varchar(150) not null,
    constraint "pkExpServicio" primary key (titulo, "fechaActivacion", rif, "nombreServicio"),
    constraint "fkExpServicioExp" foreign key (titulo, "fechaActivacion")
        references experiencia (titulo, "fechaActivacion")
        on update cascade on delete cascade,
    constraint "fkExpServicioServ" foreign key (rif, "nombreServicio")
        references servicio (rif, "nombreServicio")
        on update cascade on delete restrict
);

-- RR-42 arco hito/servicio  RR-43 exclusivo  RR-44 hito no libre acceso (trigger)
-- RR-45 estadoPase  RR-46 canjeado IFF validador+fecha  RR-47 fecha/hora (trigger)
-- RR-48 horario coherente  RR-49 validador es comercio o guia (trigger)
-- DELETE bloqueado por trigger (02_triggers.sql)
create table credencial (
    "codigoVerificacion"    varchar(50)   not null,
    "fechaProgramada"       date          not null,
    "horaProgramada"        time          not null,
    "montoAbonado"          numeric(12,2) not null,
    "cantidadBeneficiarios" integer       not null,
    "estadoPase"            varchar(20)   not null,
    "horaInicio"            time          not null,
    "horaFin"               time          not null,
    "fechaHoraCanje"        timestamp,
    "tipoDocumento"         varchar(20)   not null,
    "numeroDocumento"       varchar(30)   not null,
    -- arco hito (4 columnas)
    "nombreEstadoHito"      varchar(60),
    "nombreMunicipioHito"   varchar(80),
    "nombreParroquia"       varchar(80),
    "nombreHito"            varchar(120),
    -- arco servicio (2 columnas)
    rif                     varchar(20),
    "nombreServicio"        varchar(150),
    -- validador: comercio o guia
    "idUsuarioValida"       integer,
    constraint "pkCredencial" primary key ("codigoVerificacion"),
    constraint "fkCredVisitante" foreign key ("tipoDocumento", "numeroDocumento")
        references visitante ("tipoDocumento", "numeroDocumento")
        on update cascade on delete restrict,
    constraint "fkCredHito" foreign key
        ("nombreEstadoHito", "nombreMunicipioHito", "nombreParroquia", "nombreHito")
        references hito ("nombreEstado", "nombreMunicipio", "nombreParroquia", "nombreHito")
        on update cascade on delete restrict,
    constraint "fkCredServicio" foreign key (rif, "nombreServicio")
        references servicio (rif, "nombreServicio")
        on update cascade on delete restrict,
    constraint "fkCredValida" foreign key ("idUsuarioValida")
        references usuario ("idUsuario")
        on update cascade on delete restrict,
    -- RR-45
    constraint "chkCredEstado" check ("estadoPase" in ('emitido','canjeado','cancelado','vencido')),
    -- RR-48
    constraint "chkCredHorario"       check ("horaInicio" < "horaFin"),
    constraint "chkCredMonto"         check ("montoAbonado" >= 0),
    constraint "chkCredBeneficiarios" check ("cantidadBeneficiarios" >= 1),
    -- RR-42: hito todo null o todo not null
    constraint "chkCredHitoCompleto" check (
        ("nombreEstadoHito" is null and "nombreMunicipioHito" is null
         and "nombreParroquia" is null and "nombreHito" is null)
        or
        ("nombreEstadoHito" is not null and "nombreMunicipioHito" is not null
         and "nombreParroquia" is not null and "nombreHito" is not null)
    ),
    -- RR-43: servicio todo null o todo not null
    constraint "chkCredServCompleto" check (
        (rif is null and "nombreServicio" is null)
        or
        (rif is not null and "nombreServicio" is not null)
    ),
    -- arco exclusivo hito XOR servicio
    constraint "chkCredArco" check (
        ("nombreHito" is not null and "nombreServicio" is null)
        or
        ("nombreHito" is null and "nombreServicio" is not null)
    ),
    -- RR-46: canjeado IFF validador y fecha de canje presentes
    constraint "chkCredCanje" check (
        ("estadoPase" = 'canjeado') = ("idUsuarioValida" is not null and "fechaHoraCanje" is not null)
    )
);
