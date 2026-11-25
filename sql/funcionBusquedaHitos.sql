-- Proyecto RutasVenezuela - Bloque 1
-- Iliany Rodriguez
-- Funcion de busqueda de hitos con filtros, ordenamiento y paginado

create or replace function "buscarHitos"(
    pTexto varchar default null,
    pEstado varchar default null,
    pMunicipio varchar default null,
    pParroquia varchar default null,
    pCategoria varchar default null,
    pEstadoOperativo varchar default null,
    pOrdenarPor varchar default 'nombreHito',
    pDireccion varchar default 'asc',
    pPagina integer default 1,
    pTamano integer default 10
)
returns table (
    "nombreEstado" varchar,
    "nombreMunicipio" varchar,
    "nombreParroquia" varchar,
    "nombreHito" varchar,
    "estadoOperativo" varchar,
    "libreAcceso" boolean,
    categorias text,
    "totalRegistros" bigint
) as $$
declare
    vColumna text;
    vDireccion text;
begin
    -- solo se permite ordenar por estas columnas
    if pOrdenarPor in ('nombreHito', 'nombreEstado', 'nombreMunicipio',
                       'nombreParroquia', 'estadoOperativo') then
        vColumna := pOrdenarPor;
    else
        vColumna := 'nombreHito';
    end if;

    if lower(pDireccion) = 'desc' then
        vDireccion := 'desc';
    else
        vDireccion := 'asc';
    end if;

    if pPagina is null or pPagina < 1 then
        pPagina := 1;
    end if;

    if pTamano is null or pTamano < 1 then
        pTamano := 10;
    end if;

    return query execute format(
        'select h."nombreEstado", h."nombreMunicipio", h."nombreParroquia", h."nombreHito",
                h."estadoOperativo", h."libreAcceso",
                (select string_agg(hc."nombreCategoria", '', '' order by hc."nombreCategoria")
                 from "hitoCategoria" hc
                 where hc."nombreEstado" = h."nombreEstado"
                 and hc."nombreMunicipio" = h."nombreMunicipio"
                 and hc."nombreParroquia" = h."nombreParroquia"
                 and hc."nombreHito" = h."nombreHito") as categorias,
                count(*) over () as "totalRegistros"
         from hito h
         where ($1 is null or h."nombreHito" ilike ''%%'' || $1 || ''%%'')
         and ($2 is null or h."nombreEstado" = $2)
         and ($3 is null or h."nombreMunicipio" = $3)
         and ($4 is null or h."nombreParroquia" = $4)
         and ($5 is null or exists (select 1 from "hitoCategoria" c
                                    where c."nombreEstado" = h."nombreEstado"
                                    and c."nombreMunicipio" = h."nombreMunicipio"
                                    and c."nombreParroquia" = h."nombreParroquia"
                                    and c."nombreHito" = h."nombreHito"
                                    and c."nombreCategoria" = $5))
         and ($6 is null or h."estadoOperativo" = $6)
         order by h.%I %s
         limit $7 offset $8',
        vColumna, vDireccion)
    using pTexto, pEstado, pMunicipio, pParroquia, pCategoria,
          pEstadoOperativo, pTamano, (pPagina - 1) * pTamano;
end;
$$ language plpgsql;
