-- Proyecto RutasVenezuela - Bloque 1
-- Iliany Rodriguez
-- Funcion de busqueda de hitos con filtros, ordenamiento y paginado

create or replace function buscar_hitos(
    p_texto varchar default null,
    p_estado varchar default null,
    p_municipio varchar default null,
    p_parroquia varchar default null,
    p_categoria varchar default null,
    p_estado_operativo varchar default null,
    p_ordenar_por varchar default 'nombre_hito',
    p_direccion varchar default 'asc',
    p_pagina integer default 1,
    p_tamano integer default 10
)
returns table (
    nombre_estado varchar,
    nombre_municipio varchar,
    nombre_parroquia varchar,
    nombre_hito varchar,
    estado_operativo varchar,
    libre_acceso boolean,
    categorias text,
    total_registros bigint
) as $$
declare
    v_columna text;
    v_direccion text;
begin
    -- solo se permite ordenar por estas columnas
    if p_ordenar_por in ('nombre_hito', 'nombre_estado', 'nombre_municipio',
                         'nombre_parroquia', 'estado_operativo') then
        v_columna := p_ordenar_por;
    else
        v_columna := 'nombre_hito';
    end if;

    if lower(p_direccion) = 'desc' then
        v_direccion := 'desc';
    else
        v_direccion := 'asc';
    end if;

    if p_pagina is null or p_pagina < 1 then
        p_pagina := 1;
    end if;

    if p_tamano is null or p_tamano < 1 then
        p_tamano := 10;
    end if;

    return query execute format(
        'select h.nombre_estado, h.nombre_municipio, h.nombre_parroquia, h.nombre_hito,
                h.estado_operativo, h.libre_acceso,
                (select string_agg(hc.nombre_categoria, '', '' order by hc.nombre_categoria)
                 from hito_categoria hc
                 where hc.nombre_estado = h.nombre_estado
                 and hc.nombre_municipio = h.nombre_municipio
                 and hc.nombre_parroquia = h.nombre_parroquia
                 and hc.nombre_hito = h.nombre_hito) as categorias,
                count(*) over () as total_registros
         from hito h
         where ($1 is null or h.nombre_hito ilike ''%%'' || $1 || ''%%'')
         and ($2 is null or h.nombre_estado = $2)
         and ($3 is null or h.nombre_municipio = $3)
         and ($4 is null or h.nombre_parroquia = $4)
         and ($5 is null or exists (select 1 from hito_categoria c
                                    where c.nombre_estado = h.nombre_estado
                                    and c.nombre_municipio = h.nombre_municipio
                                    and c.nombre_parroquia = h.nombre_parroquia
                                    and c.nombre_hito = h.nombre_hito
                                    and c.nombre_categoria = $5))
         and ($6 is null or h.estado_operativo = $6)
         order by h.%I %s
         limit $7 offset $8',
        v_columna, v_direccion)
    using p_texto, p_estado, p_municipio, p_parroquia, p_categoria,
          p_estado_operativo, p_tamano, (p_pagina - 1) * p_tamano;
end;
$$ language plpgsql;
