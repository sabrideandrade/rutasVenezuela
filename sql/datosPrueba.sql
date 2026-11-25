-- Proyecto RutasVenezuela - Bloque 1
-- Iliany Rodriguez
-- Datos de prueba
-- (se carga todo en una sola transaccion por los triggers de RR-19 y RR-20)

begin;

truncate table puntoAnclaje, actividadCultural, hitoCategoria, horarioHito,
               hito, categoria, parroquia, municipio, estado;


-- estados
insert into estado values ('Distrito Capital');
insert into estado values ('Miranda');
insert into estado values ('Merida');
insert into estado values ('Falcon');
insert into estado values ('Zulia');


-- municipios
insert into municipio values ('Distrito Capital', 'Libertador');
insert into municipio values ('Miranda', 'Chacao');
insert into municipio values ('Miranda', 'Sucre');
insert into municipio values ('Merida', 'Libertador');
insert into municipio values ('Merida', 'Rangel');
insert into municipio values ('Merida', 'Sucre');
insert into municipio values ('Falcon', 'Miranda');
insert into municipio values ('Zulia', 'Maracaibo');


-- parroquias
insert into parroquia values ('Distrito Capital', 'Libertador', 'Catedral');
insert into parroquia values ('Distrito Capital', 'Libertador', 'Altagracia');
insert into parroquia values ('Distrito Capital', 'Libertador', '23 de Enero');
insert into parroquia values ('Distrito Capital', 'Libertador', 'San Juan');
insert into parroquia values ('Distrito Capital', 'Libertador', 'La Pastora');
insert into parroquia values ('Miranda', 'Chacao', 'Chacao');
insert into parroquia values ('Miranda', 'Sucre', 'Petare');
insert into parroquia values ('Miranda', 'Sucre', 'Leoncio Martinez');
insert into parroquia values ('Merida', 'Libertador', 'El Sagrario');
insert into parroquia values ('Merida', 'Libertador', 'Milla');
insert into parroquia values ('Merida', 'Rangel', 'Mucuchies');
insert into parroquia values ('Merida', 'Sucre', 'Lagunillas');
insert into parroquia values ('Falcon', 'Miranda', 'Santa Ana');
insert into parroquia values ('Falcon', 'Miranda', 'San Antonio');
insert into parroquia values ('Zulia', 'Maracaibo', 'Bolivar');
insert into parroquia values ('Zulia', 'Maracaibo', 'Chiquinquira');


-- categorias
insert into categoria values ('Historico', 'Lugares asociados a hechos o personajes de la historia de Venezuela');
insert into categoria values ('Religioso', 'Iglesias, catedrales y lugares de devocion');
insert into categoria values ('Natural', 'Parques, paisajes y espacios naturales');
insert into categoria values ('Museo', 'Espacios con exposiciones permanentes o temporales');
insert into categoria values ('Arquitectonico', 'Edificaciones de valor arquitectonico');
insert into categoria values ('Plaza publica', 'Plazas y espacios abiertos de encuentro');
insert into categoria values ('Patrimonio de la Humanidad', 'Lugares reconocidos por la UNESCO');
insert into categoria values ('Artes escenicas', 'Teatros y espacios para espectaculos');


-- hitos
insert into hito values ('Distrito Capital', 'Libertador', 'Catedral', 'Plaza Bolivar de Caracas',
    'disponible', 'bueno', true, 10.506100, -66.914600, 900, 0);
insert into hito values ('Distrito Capital', 'Libertador', 'Catedral', 'Catedral de Caracas',
    'disponible', 'bueno', false, 10.506200, -66.913900, 900, 30);
insert into hito values ('Distrito Capital', 'Libertador', 'Catedral', 'Casa Natal del Libertador',
    'disponible', 'bueno', false, 10.505300, -66.913200, 900, 8);
insert into hito values ('Distrito Capital', 'Libertador', 'Catedral', 'Palacio Federal Legislativo',
    'disponible', 'bueno', false, 10.505400, -66.915700, 900, 20);
insert into hito values ('Distrito Capital', 'Libertador', 'Altagracia', 'Panteon Nacional',
    'disponible', 'bueno', false, 10.514400, -66.911500, 930, 25);
insert into hito values ('Distrito Capital', 'Libertador', '23 de Enero', 'Cuartel de la Montana',
    'disponible', 'regular', false, 10.508400, -66.926200, 950, 12);
insert into hito values ('Miranda', 'Chacao', 'Chacao', 'Plaza Francia de Altamira',
    'disponible', 'bueno', true, 10.496100, -66.849100, 890, 30);
insert into hito values ('Miranda', 'Sucre', 'Petare', 'Plaza Sucre de Petare',
    'disponible', 'regular', true, 10.477000, -66.808700, 830, 0);
insert into hito values ('Merida', 'Libertador', 'El Sagrario', 'Plaza Bolivar de Merida',
    'disponible', 'bueno', true, 8.598100, -71.145200, 1630, 0);
insert into hito values ('Merida', 'Libertador', 'El Sagrario', 'Catedral Basilica de Merida',
    'disponible', 'bueno', false, 8.597600, -71.144900, 1630, 35);
insert into hito values ('Merida', 'Libertador', 'Milla', 'Teleferico Mukumbari',
    'disponible', 'bueno', false, 8.589900, -71.152300, 1577, 0);
insert into hito values ('Merida', 'Rangel', 'Mucuchies', 'Plaza Bolivar de Mucuchies',
    'disponible', 'bueno', true, 8.749000, -70.917000, 2983, 0);
insert into hito values ('Falcon', 'Miranda', 'Santa Ana', 'Catedral de Coro',
    'disponible', 'regular', false, 11.407800, -69.676400, 20, 15);
insert into hito values ('Falcon', 'Miranda', 'Santa Ana', 'Casa de las Ventanas de Hierro',
    'enRestauracion', 'regular', false, 11.408500, -69.675500, 20, 7);
insert into hito values ('Falcon', 'Miranda', 'San Antonio', 'Parque Nacional Medanos de Coro',
    'disponible', 'bueno', true, 11.480000, -69.650000, 10, 0);
insert into hito values ('Zulia', 'Maracaibo', 'Bolivar', 'Plaza Bolivar de Maracaibo',
    'disponible', 'bueno', true, 10.642700, -71.612500, 6, 0);
insert into hito values ('Zulia', 'Maracaibo', 'Bolivar', 'Teatro Baralt',
    'clausuradoTemporalmente', 'regular', false, 10.643000, -71.611900, 6, 18);
insert into hito values ('Zulia', 'Maracaibo', 'Chiquinquira', 'Basilica de la Chiquinquira',
    'disponible', 'bueno', false, 10.638900, -71.613300, 6, 40);


-- categorias de cada hito (RR-19)
insert into hitoCategoria values ('Distrito Capital', 'Libertador', 'Catedral', 'Plaza Bolivar de Caracas', 'Plaza publica');
insert into hitoCategoria values ('Distrito Capital', 'Libertador', 'Catedral', 'Plaza Bolivar de Caracas', 'Historico');
insert into hitoCategoria values ('Distrito Capital', 'Libertador', 'Catedral', 'Catedral de Caracas', 'Religioso');
insert into hitoCategoria values ('Distrito Capital', 'Libertador', 'Catedral', 'Catedral de Caracas', 'Arquitectonico');
insert into hitoCategoria values ('Distrito Capital', 'Libertador', 'Catedral', 'Casa Natal del Libertador', 'Historico');
insert into hitoCategoria values ('Distrito Capital', 'Libertador', 'Catedral', 'Casa Natal del Libertador', 'Museo');
insert into hitoCategoria values ('Distrito Capital', 'Libertador', 'Catedral', 'Palacio Federal Legislativo', 'Historico');
insert into hitoCategoria values ('Distrito Capital', 'Libertador', 'Catedral', 'Palacio Federal Legislativo', 'Arquitectonico');
insert into hitoCategoria values ('Distrito Capital', 'Libertador', 'Altagracia', 'Panteon Nacional', 'Historico');
insert into hitoCategoria values ('Distrito Capital', 'Libertador', 'Altagracia', 'Panteon Nacional', 'Arquitectonico');
insert into hitoCategoria values ('Distrito Capital', 'Libertador', '23 de Enero', 'Cuartel de la Montana', 'Historico');
insert into hitoCategoria values ('Distrito Capital', 'Libertador', '23 de Enero', 'Cuartel de la Montana', 'Museo');
insert into hitoCategoria values ('Miranda', 'Chacao', 'Chacao', 'Plaza Francia de Altamira', 'Plaza publica');
insert into hitoCategoria values ('Miranda', 'Sucre', 'Petare', 'Plaza Sucre de Petare', 'Plaza publica');
insert into hitoCategoria values ('Miranda', 'Sucre', 'Petare', 'Plaza Sucre de Petare', 'Historico');
insert into hitoCategoria values ('Merida', 'Libertador', 'El Sagrario', 'Plaza Bolivar de Merida', 'Plaza publica');
insert into hitoCategoria values ('Merida', 'Libertador', 'El Sagrario', 'Catedral Basilica de Merida', 'Religioso');
insert into hitoCategoria values ('Merida', 'Libertador', 'El Sagrario', 'Catedral Basilica de Merida', 'Arquitectonico');
insert into hitoCategoria values ('Merida', 'Libertador', 'Milla', 'Teleferico Mukumbari', 'Natural');
insert into hitoCategoria values ('Merida', 'Rangel', 'Mucuchies', 'Plaza Bolivar de Mucuchies', 'Plaza publica');
insert into hitoCategoria values ('Falcon', 'Miranda', 'Santa Ana', 'Catedral de Coro', 'Religioso');
insert into hitoCategoria values ('Falcon', 'Miranda', 'Santa Ana', 'Catedral de Coro', 'Patrimonio de la Humanidad');
insert into hitoCategoria values ('Falcon', 'Miranda', 'Santa Ana', 'Casa de las Ventanas de Hierro', 'Arquitectonico');
insert into hitoCategoria values ('Falcon', 'Miranda', 'Santa Ana', 'Casa de las Ventanas de Hierro', 'Patrimonio de la Humanidad');
insert into hitoCategoria values ('Falcon', 'Miranda', 'San Antonio', 'Parque Nacional Medanos de Coro', 'Natural');
insert into hitoCategoria values ('Zulia', 'Maracaibo', 'Bolivar', 'Plaza Bolivar de Maracaibo', 'Plaza publica');
insert into hitoCategoria values ('Zulia', 'Maracaibo', 'Bolivar', 'Teatro Baralt', 'Artes escenicas');
insert into hitoCategoria values ('Zulia', 'Maracaibo', 'Bolivar', 'Teatro Baralt', 'Arquitectonico');
insert into hitoCategoria values ('Zulia', 'Maracaibo', 'Chiquinquira', 'Basilica de la Chiquinquira', 'Religioso');


-- horarios de los hitos que no son de libre acceso (RR-20)
insert into horarioHito
select nombreEstado, nombreMunicipio, nombreParroquia, nombreHito, d.dia, time '08:00', time '17:00'
from hito, (values ('lunes'), ('martes'), ('miercoles'), ('jueves'), ('viernes'), ('sabado'), ('domingo')) as d(dia)
where nombreHito in ('Catedral de Caracas', 'Catedral Basilica de Merida', 'Catedral de Coro', 'Basilica de la Chiquinquira');

insert into horarioHito
select nombreEstado, nombreMunicipio, nombreParroquia, nombreHito, d.dia, time '09:00', time '16:00'
from hito, (values ('martes'), ('miercoles'), ('jueves'), ('viernes'), ('sabado'), ('domingo')) as d(dia)
where nombreHito in ('Casa Natal del Libertador', 'Panteon Nacional', 'Cuartel de la Montana', 'Casa de las Ventanas de Hierro');

insert into horarioHito
select nombreEstado, nombreMunicipio, nombreParroquia, nombreHito, d.dia, time '09:00', time '15:00'
from hito, (values ('lunes'), ('martes'), ('miercoles'), ('jueves'), ('viernes')) as d(dia)
where nombreHito in ('Palacio Federal Legislativo', 'Teatro Baralt');

insert into horarioHito
select nombreEstado, nombreMunicipio, nombreParroquia, nombreHito, d.dia, time '08:00', time '15:00'
from hito, (values ('miercoles'), ('jueves'), ('viernes'), ('sabado'), ('domingo')) as d(dia)
where nombreHito = 'Teleferico Mukumbari';


-- actividades culturales
insert into actividadCultural values ('Distrito Capital', 'Libertador', 'Catedral', 'Plaza Bolivar de Caracas',
    'Retreta de la Banda Marcial Caracas', '2026-12-06', '2026-12-06', 'Concierto al aire libre en la plaza');
insert into actividadCultural values ('Distrito Capital', 'Libertador', 'Catedral', 'Casa Natal del Libertador',
    'Exposicion de objetos del Libertador', '2026-12-01', '2027-03-31', 'Muestra de objetos personales y documentos');
insert into actividadCultural values ('Distrito Capital', 'Libertador', 'Altagracia', 'Panteon Nacional',
    'Recorrido guiado nocturno', '2026-12-10', '2026-12-20', 'Recorrido por la historia de los proceres');
insert into actividadCultural values ('Merida', 'Rangel', 'Mucuchies', 'Plaza Bolivar de Mucuchies',
    'Fiestas de San Benito', '2026-12-27', '2026-12-29', 'Celebracion tradicional con los chimbangueles andinos');
insert into actividadCultural values ('Merida', 'Libertador', 'El Sagrario', 'Plaza Bolivar de Merida',
    'Feria del Sol', '2027-02-06', '2027-02-10', 'Feria tradicional de la ciudad de Merida');
insert into actividadCultural values ('Falcon', 'Miranda', 'Santa Ana', 'Catedral de Coro',
    'Paseo por el casco colonial', '2027-01-15', '2027-01-15', 'Recorrido por la zona colonial de Coro');
insert into actividadCultural values ('Zulia', 'Maracaibo', 'Chiquinquira', 'Basilica de la Chiquinquira',
    'Feria de la Chinita', '2026-11-08', '2026-11-19', 'Festividades en honor a la Virgen de Chiquinquira');


-- puntos de anclaje
insert into puntoAnclaje values ('Distrito Capital', 'Libertador', 'Catedral', 'Plaza Bolivar de Caracas',
    1, 10.506100, -66.914600, 900, 180, 0, 0, 'estatua_bolivar_caracas', 15, 1.000);
insert into puntoAnclaje values ('Distrito Capital', 'Libertador', 'Catedral', 'Plaza Bolivar de Caracas',
    2, 10.505900, -66.914300, 900, 90, 5, 0, 'info_fundacion_caracas', 10, 0.500);
insert into puntoAnclaje values ('Distrito Capital', 'Libertador', 'Altagracia', 'Panteon Nacional',
    1, 10.514400, -66.911500, 930, 0, 10, 0, 'fachada_panteon', 20, 1.500);
insert into puntoAnclaje values ('Miranda', 'Chacao', 'Chacao', 'Plaza Francia de Altamira',
    1, 10.496100, -66.849100, 890, 0, 15, 0, 'obelisco_altamira', 25, 2.000);
insert into puntoAnclaje values ('Falcon', 'Miranda', 'San Antonio', 'Parque Nacional Medanos de Coro',
    1, 11.480000, -69.650000, 10, 270, 0, 0, 'dunas_medanos', 50, 3.000);

commit;
