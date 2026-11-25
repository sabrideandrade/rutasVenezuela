-- Proyecto RutasVenezuela - Bloque 1
-- Iliany Rodriguez
-- Gestion territorial, hitos, categorias, actividades culturales y puntos de anclaje

-- se borran las tablas viejas que tenian guion bajo
drop table if exists punto_anclaje cascade;
drop table if exists actividad_cultural cascade;
drop table if exists hito_categoria cascade;
drop table if exists horario_hito cascade;
drop function if exists validar_hito_categoria cascade;
drop function if exists validar_hito_horario cascade;
drop function if exists buscar_hitos;

drop table if exists "puntoAnclaje" cascade;
drop table if exists "actividadCultural" cascade;
drop table if exists "hitoCategoria" cascade;
drop table if exists "horarioHito" cascade;
drop table if exists hito cascade;
drop table if exists categoria cascade;
drop table if exists parroquia cascade;
drop table if exists municipio cascade;
drop table if exists estado cascade;


create table estado (
    "nombreEstado" varchar(60) not null,
    constraint "pkEstado" primary key ("nombreEstado")
);

create table municipio (
    "nombreEstado" varchar(60) not null,
    "nombreMunicipio" varchar(80) not null,
    constraint "pkMunicipio" primary key ("nombreEstado", "nombreMunicipio"),
    constraint "fkMunicipioEstado" foreign key ("nombreEstado")
        references estado ("nombreEstado")
        on update cascade on delete restrict
);

create table parroquia (
    "nombreEstado" varchar(60) not null,
    "nombreMunicipio" varchar(80) not null,
    "nombreParroquia" varchar(80) not null,
    constraint "pkParroquia" primary key ("nombreEstado", "nombreMunicipio", "nombreParroquia"),
    constraint "fkParroquiaMunicipio" foreign key ("nombreEstado", "nombreMunicipio")
        references municipio ("nombreEstado", "nombreMunicipio")
        on update cascade on delete restrict
);

create table categoria (
    "nombreCategoria" varchar(60) not null,
    descripcion varchar(300),
    constraint "pkCategoria" primary key ("nombreCategoria")
);

create table hito (
    "nombreEstado" varchar(60) not null,
    "nombreMunicipio" varchar(80) not null,
    "nombreParroquia" varchar(80) not null,
    "nombreHito" varchar(120) not null,
    "estadoOperativo" varchar(30) not null default 'disponible',
    "estadoConservacion" varchar(30),
    "libreAcceso" boolean not null,
    latitud numeric(9,6) not null,
    longitud numeric(9,6) not null,
    elevacion numeric(8,2) not null,
    "alturaEstructura" numeric(6,2) not null default 0,
    constraint "pkHito" primary key ("nombreEstado", "nombreMunicipio", "nombreParroquia", "nombreHito"),
    constraint "fkHitoParroquia" foreign key ("nombreEstado", "nombreMunicipio", "nombreParroquia")
        references parroquia ("nombreEstado", "nombreMunicipio", "nombreParroquia")
        on update cascade on delete restrict,
    -- RR-17
    constraint "chkHitoEstado" check ("estadoOperativo" in
        ('disponible', 'enRestauracion', 'clausuradoTemporalmente', 'cerradoPermanentemente')),
    -- RR-18
    constraint "chkHitoLatitud" check (latitud between -90 and 90),
    constraint "chkHitoLongitud" check (longitud between -180 and 180),
    constraint "chkHitoAltura" check ("alturaEstructura" >= 0)
);

-- horario de visita del hito (atributo multivaluado)
create table "horarioHito" (
    "nombreEstado" varchar(60) not null,
    "nombreMunicipio" varchar(80) not null,
    "nombreParroquia" varchar(80) not null,
    "nombreHito" varchar(120) not null,
    dia varchar(10) not null,
    "horaApertura" time not null,
    "horaCierre" time not null,
    constraint "pkHorarioHito" primary key
        ("nombreEstado", "nombreMunicipio", "nombreParroquia", "nombreHito", dia, "horaApertura"),
    constraint "fkHorarioHito" foreign key ("nombreEstado", "nombreMunicipio", "nombreParroquia", "nombreHito")
        references hito ("nombreEstado", "nombreMunicipio", "nombreParroquia", "nombreHito")
        on update cascade on delete cascade,
    constraint "chkHorarioDia" check (dia in
        ('lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado', 'domingo')),
    -- RR-21
    constraint "chkHorarioHoras" check ("horaApertura" < "horaCierre")
);

-- relacion clasifica entre hito y categoria
create table "hitoCategoria" (
    "nombreEstado" varchar(60) not null,
    "nombreMunicipio" varchar(80) not null,
    "nombreParroquia" varchar(80) not null,
    "nombreHito" varchar(120) not null,
    "nombreCategoria" varchar(60) not null,
    constraint "pkHitoCategoria" primary key
        ("nombreEstado", "nombreMunicipio", "nombreParroquia", "nombreHito", "nombreCategoria"),
    constraint "fkHcHito" foreign key ("nombreEstado", "nombreMunicipio", "nombreParroquia", "nombreHito")
        references hito ("nombreEstado", "nombreMunicipio", "nombreParroquia", "nombreHito")
        on update cascade on delete cascade,
    constraint "fkHcCategoria" foreign key ("nombreCategoria")
        references categoria ("nombreCategoria")
        on update cascade on delete restrict
);

create table "actividadCultural" (
    "nombreEstado" varchar(60) not null,
    "nombreMunicipio" varchar(80) not null,
    "nombreParroquia" varchar(80) not null,
    "nombreHito" varchar(120) not null,
    "nombreActividad" varchar(120) not null,
    "fechaInicio" date not null,
    "fechaFin" date not null,
    descripcion varchar(500),
    constraint "pkActividadCultural" primary key
        ("nombreEstado", "nombreMunicipio", "nombreParroquia", "nombreHito", "nombreActividad", "fechaInicio"),
    constraint "fkActividadHito" foreign key ("nombreEstado", "nombreMunicipio", "nombreParroquia", "nombreHito")
        references hito ("nombreEstado", "nombreMunicipio", "nombreParroquia", "nombreHito")
        on update cascade on delete cascade,
    -- RR-22
    constraint "chkActividadFechas" check ("fechaInicio" <= "fechaFin")
);

create table "puntoAnclaje" (
    "nombreEstado" varchar(60) not null,
    "nombreMunicipio" varchar(80) not null,
    "nombreParroquia" varchar(80) not null,
    "nombreHito" varchar(120) not null,
    "numeroPunto" integer not null,
    latitud numeric(9,6) not null,
    longitud numeric(9,6) not null,
    altitud numeric(8,2) not null,
    azimut numeric(6,2) not null,
    inclinacion numeric(6,2) not null,
    rotacion numeric(6,2) not null,
    "idRecurso3D" varchar(100) not null,
    "radioActivacion" numeric(8,2) not null,
    "escalaVisualizacion" numeric(6,3) not null,
    constraint "pkPuntoAnclaje" primary key
        ("nombreEstado", "nombreMunicipio", "nombreParroquia", "nombreHito", "numeroPunto"),
    constraint "fkPuntoHito" foreign key ("nombreEstado", "nombreMunicipio", "nombreParroquia", "nombreHito")
        references hito ("nombreEstado", "nombreMunicipio", "nombreParroquia", "nombreHito")
        on update cascade on delete cascade,
    -- RR-23
    constraint "chkPuntoRadio" check ("radioActivacion" > 0),
    constraint "chkPuntoEscala" check ("escalaVisualizacion" > 0),
    -- RR-24
    constraint "chkPuntoLatitud" check (latitud between -90 and 90),
    constraint "chkPuntoLongitud" check (longitud between -180 and 180)
);
