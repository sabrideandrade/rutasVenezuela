-- Proyecto RutasVenezuela - Bloque 1
-- Iliany Rodriguez
-- Gestion territorial, hitos, categorias, actividades culturales y puntos de anclaje

drop table if exists punto_anclaje cascade;
drop table if exists actividad_cultural cascade;
drop table if exists hito_categoria cascade;
drop table if exists horario_hito cascade;
drop table if exists hito cascade;
drop table if exists categoria cascade;
drop table if exists parroquia cascade;
drop table if exists municipio cascade;
drop table if exists estado cascade;


create table estado (
    nombre_estado varchar(60) not null,
    constraint pk_estado primary key (nombre_estado)
);

create table municipio (
    nombre_estado varchar(60) not null,
    nombre_municipio varchar(80) not null,
    constraint pk_municipio primary key (nombre_estado, nombre_municipio),
    constraint fk_municipio_estado foreign key (nombre_estado)
        references estado (nombre_estado)
        on update cascade on delete restrict
);

create table parroquia (
    nombre_estado varchar(60) not null,
    nombre_municipio varchar(80) not null,
    nombre_parroquia varchar(80) not null,
    constraint pk_parroquia primary key (nombre_estado, nombre_municipio, nombre_parroquia),
    constraint fk_parroquia_municipio foreign key (nombre_estado, nombre_municipio)
        references municipio (nombre_estado, nombre_municipio)
        on update cascade on delete restrict
);

create table categoria (
    nombre_categoria varchar(60) not null,
    descripcion varchar(300),
    constraint pk_categoria primary key (nombre_categoria)
);

create table hito (
    nombre_estado varchar(60) not null,
    nombre_municipio varchar(80) not null,
    nombre_parroquia varchar(80) not null,
    nombre_hito varchar(120) not null,
    estado_operativo varchar(30) not null default 'disponible',
    estado_conservacion varchar(30),
    libre_acceso boolean not null,
    latitud numeric(9,6) not null,
    longitud numeric(9,6) not null,
    elevacion numeric(8,2) not null,
    altura_estructura numeric(6,2) not null default 0,
    constraint pk_hito primary key (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito),
    constraint fk_hito_parroquia foreign key (nombre_estado, nombre_municipio, nombre_parroquia)
        references parroquia (nombre_estado, nombre_municipio, nombre_parroquia)
        on update cascade on delete restrict,
    -- RR-17
    constraint chk_hito_estado check (estado_operativo in
        ('disponible', 'enRestauracion', 'clausuradoTemporalmente', 'cerradoPermanentemente')),
    -- RR-18
    constraint chk_hito_latitud check (latitud between -90 and 90),
    constraint chk_hito_longitud check (longitud between -180 and 180),
    constraint chk_hito_altura check (altura_estructura >= 0)
);

-- horario de visita del hito (atributo multivaluado)
create table horario_hito (
    nombre_estado varchar(60) not null,
    nombre_municipio varchar(80) not null,
    nombre_parroquia varchar(80) not null,
    nombre_hito varchar(120) not null,
    dia varchar(10) not null,
    hora_apertura time not null,
    hora_cierre time not null,
    constraint pk_horario_hito primary key
        (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, dia, hora_apertura),
    constraint fk_horario_hito foreign key (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
        references hito (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
        on update cascade on delete cascade,
    constraint chk_horario_dia check (dia in
        ('lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado', 'domingo')),
    -- RR-21
    constraint chk_horario_horas check (hora_apertura < hora_cierre)
);

-- relacion clasifica entre hito y categoria
create table hito_categoria (
    nombre_estado varchar(60) not null,
    nombre_municipio varchar(80) not null,
    nombre_parroquia varchar(80) not null,
    nombre_hito varchar(120) not null,
    nombre_categoria varchar(60) not null,
    constraint pk_hito_categoria primary key
        (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, nombre_categoria),
    constraint fk_hc_hito foreign key (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
        references hito (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
        on update cascade on delete cascade,
    constraint fk_hc_categoria foreign key (nombre_categoria)
        references categoria (nombre_categoria)
        on update cascade on delete restrict
);

create table actividad_cultural (
    nombre_estado varchar(60) not null,
    nombre_municipio varchar(80) not null,
    nombre_parroquia varchar(80) not null,
    nombre_hito varchar(120) not null,
    nombre_actividad varchar(120) not null,
    fecha_inicio date not null,
    fecha_fin date not null,
    descripcion varchar(500),
    constraint pk_actividad primary key
        (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, nombre_actividad, fecha_inicio),
    constraint fk_actividad_hito foreign key (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
        references hito (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
        on update cascade on delete cascade,
    -- RR-22
    constraint chk_actividad_fechas check (fecha_inicio <= fecha_fin)
);

create table punto_anclaje (
    nombre_estado varchar(60) not null,
    nombre_municipio varchar(80) not null,
    nombre_parroquia varchar(80) not null,
    nombre_hito varchar(120) not null,
    numero_punto integer not null,
    latitud numeric(9,6) not null,
    longitud numeric(9,6) not null,
    altitud numeric(8,2) not null,
    azimut numeric(6,2) not null,
    inclinacion numeric(6,2) not null,
    rotacion numeric(6,2) not null,
    id_recurso_3d varchar(100) not null,
    radio_activacion numeric(8,2) not null,
    escala_visualizacion numeric(6,3) not null,
    constraint pk_punto_anclaje primary key
        (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, numero_punto),
    constraint fk_punto_hito foreign key (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
        references hito (nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito)
        on update cascade on delete cascade,
    -- RR-23
    constraint chk_punto_radio check (radio_activacion > 0),
    constraint chk_punto_escala check (escala_visualizacion > 0),
    -- RR-24
    constraint chk_punto_latitud check (latitud between -90 and 90),
    constraint chk_punto_longitud check (longitud between -180 and 180)
);
