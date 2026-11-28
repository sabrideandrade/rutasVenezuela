drop trigger if exists trg_ruta_subtipo on ruta;
drop trigger if exists trg_ruta_fija_subtipo on "rutaFija";
drop trigger if exists trg_ruta_dinamica_subtipo on "rutaDinamica";
drop trigger if exists trg_ruta_min_etapas on ruta;
drop trigger if exists trg_etapa_min_etapas on etapa;
drop trigger if exists trg_etapa_secuencia on etapa;
drop trigger if exists trg_etapa_extremos_hito on etapa;
drop trigger if exists trg_eval_no_update on evaluacion;
drop trigger if exists trg_eval_verificacion on evaluacion;
drop trigger if exists trg_cred_no_delete on credencial;
drop trigger if exists trg_cred_hito_libre_acceso on credencial;
drop trigger if exists trg_cred_validador_autorizado on credencial;
drop trigger if exists trg_cred_canje_fecha_hora on credencial;

drop function if exists fn_validar_ruta_subtipo() cascade;
drop function if exists fn_validar_ruta_min_etapas() cascade;
drop function if exists fn_validar_etapa_secuencia() cascade;
drop function if exists fn_validar_etapa_extremos_hito() cascade;
drop function if exists fn_bloquear_update_evaluacion() cascade;
drop function if exists fn_verificar_evaluacion() cascade;
drop function if exists fn_bloquear_delete_credencial() cascade;
drop function if exists fn_validar_credencial_hito() cascade;
drop function if exists fn_validar_credencial_validador() cascade;
drop function if exists fn_validar_credencial_canje() cascade;
drop procedure if exists sp_crear_ruta_completa(varchar, varchar, varchar, numeric, time, varchar, varchar, varchar, varchar, jsonb, text[]);
drop procedure if exists sp_canjear_credencial(varchar, integer);
drop function if exists fn_ranking_rutas(varchar, varchar, integer);

-- ============================================================
-- 1. RR-25: Especialización total y disjunta de Ruta


create or replace function fn_validar_ruta_subtipo()
returns trigger
language plpgsql
as $$
declare
    v_estado    varchar(60);
    v_municipio varchar(80);
    v_ruta      varchar(200);
    v_tipo      varchar(10);
    v_en_fija   integer;
    v_en_din    integer;
begin
    if tg_table_name = 'ruta' then
        if tg_op = 'DELETE' then
            return null;
        end if;
        v_estado    := new."nombreEstado";
        v_municipio := new."nombreMunicipio";
        v_ruta      := new."nombreRuta";
    else
        v_estado    := coalesce(new."nombreEstado", old."nombreEstado");
        v_municipio := coalesce(new."nombreMunicipio", old."nombreMunicipio");
        v_ruta      := coalesce(new."nombreRuta", old."nombreRuta");
    end if;

    select "tipoRuta" into v_tipo
    from ruta
    where "nombreEstado" = v_estado
      and "nombreMunicipio" = v_municipio
      and "nombreRuta" = v_ruta;

    if not found then
        return null;
    end if;

    select count(*) into v_en_fija
    from "rutaFija"
    where "nombreEstado" = v_estado
      and "nombreMunicipio" = v_municipio
      and "nombreRuta" = v_ruta;

    select count(*) into v_en_din
    from "rutaDinamica"
    where "nombreEstado" = v_estado
      and "nombreMunicipio" = v_municipio
      and "nombreRuta" = v_ruta;

    if (v_en_fija + v_en_din) <> 1 then
        raise exception 'RR-25: La ruta "%" (%, %) debe pertenecer exactamente a rutaFija o rutaDinamica (fija=%, dinamica=%).',
            v_ruta, v_estado, v_municipio, v_en_fija, v_en_din;
    end if;

    if v_tipo = 'fija' and v_en_fija <> 1 then
        raise exception 'RR-25: La ruta "%" tiene tipoRuta=''fija'', pero no está registrada en rutaFija.', v_ruta;
    end if;

    if v_tipo = 'dinamica' and v_en_din <> 1 then
        raise exception 'RR-25: La ruta "%" tiene tipoRuta=''dinamica'', pero no está registrada en rutaDinamica.', v_ruta;
    end if;

    return null;
end;
$$;

create constraint trigger trg_ruta_subtipo
after insert or update on ruta
deferrable initially deferred
for each row execute function fn_validar_ruta_subtipo();

create constraint trigger trg_ruta_fija_subtipo
after insert or update or delete on "rutaFija"
deferrable initially deferred
for each row execute function fn_validar_ruta_subtipo();

create constraint trigger trg_ruta_dinamica_subtipo
after insert or update or delete on "rutaDinamica"
deferrable initially deferred
for each row execute function fn_validar_ruta_subtipo();

-- ============================================================
-- 2. RR-27: Toda ruta tiene al menos 2 etapas
--    DEFERRABLE INITIALLY DEFERRED
-- ============================================================
-- Autor: Verónica Betancourt - Bloque 2
create or replace function fn_validar_ruta_min_etapas()
returns trigger
language plpgsql
as $$
declare
    v_estado    varchar(60);
    v_municipio varchar(80);
    v_ruta      varchar(200);
    v_existe    boolean;
    v_total     integer;
begin
    if tg_table_name = 'ruta' then
        v_estado    := new."nombreEstado";
        v_municipio := new."nombreMunicipio";
        v_ruta      := new."nombreRuta";
    else
        v_estado    := coalesce(new."nombreEstadoRuta", old."nombreEstadoRuta");
        v_municipio := coalesce(new."nombreMunicipioRuta", old."nombreMunicipioRuta");
        v_ruta      := coalesce(new."nombreRuta", old."nombreRuta");
    end if;

    select exists(
        select 1 from ruta
        where "nombreEstado" = v_estado
          and "nombreMunicipio" = v_municipio
          and "nombreRuta" = v_ruta
    ) into v_existe;

    if not v_existe then
        return null;
    end if;

    select count(*) into v_total
    from etapa
    where "nombreEstadoRuta" = v_estado
      and "nombreMunicipioRuta" = v_municipio
      and "nombreRuta" = v_ruta;

    if v_total < 2 then
        raise exception 'RR-27: La ruta "%" (%, %) debe tener al menos 2 etapas (actual: %).',
            v_ruta, v_estado, v_municipio, v_total;
    end if;

    return null;
end;
$$;

create constraint trigger trg_ruta_min_etapas
after insert on ruta
deferrable initially deferred
for each row execute function fn_validar_ruta_min_etapas();

create constraint trigger trg_etapa_min_etapas
after insert or delete on etapa
deferrable initially deferred
for each row execute function fn_validar_ruta_min_etapas();

-- ============================================================
-- 3. RR-30: numeroSecuencia consecutivo desde 1 sin saltos
--    DEFERRABLE INITIALLY DEFERRED
-- ============================================================
-- Autor: Verónica Betancourt - Bloque 2
create or replace function fn_validar_etapa_secuencia()
returns trigger
language plpgsql
as $$
declare
    v_estado    varchar(60);
    v_municipio varchar(80);
    v_ruta      varchar(200);
    v_total     integer;
    v_min       integer;
    v_max       integer;
begin
    v_estado    := coalesce(new."nombreEstadoRuta", old."nombreEstadoRuta");
    v_municipio := coalesce(new."nombreMunicipioRuta", old."nombreMunicipioRuta");
    v_ruta      := coalesce(new."nombreRuta", old."nombreRuta");

    select count(*), min("numeroSecuencia"), max("numeroSecuencia")
    into v_total, v_min, v_max
    from etapa
    where "nombreEstadoRuta" = v_estado
      and "nombreMunicipioRuta" = v_municipio
      and "nombreRuta" = v_ruta;

    if v_total = 0 then
        return null;
    end if;

    if v_min <> 1 or v_max <> v_total then
        raise exception 'RR-30: Las etapas de la ruta "%" deben numerarse consecutivamente desde 1 sin saltos (min=%, max=%, total=%).',
            v_ruta, v_min, v_max, v_total;
    end if;

    return null;
end;
$$;

create constraint trigger trg_etapa_secuencia
after insert or update or delete on etapa
deferrable initially deferred
for each row execute function fn_validar_etapa_secuencia();


-- 4. RR-31: Primera (1) y última etapa deben ser Hitos
--    DEFERRABLE INITIALLY DEFERRED
create or replace function fn_validar_etapa_extremos_hito()
returns trigger
language plpgsql
as $$
declare
    v_estado     varchar(60);
    v_municipio  varchar(80);
    v_ruta       varchar(200);
    v_max        integer;
    v_hito_ini   varchar(120);
    v_hito_fin   varchar(120);
begin
    v_estado    := coalesce(new."nombreEstadoRuta", old."nombreEstadoRuta");
    v_municipio := coalesce(new."nombreMunicipioRuta", old."nombreMunicipioRuta");
    v_ruta      := coalesce(new."nombreRuta", old."nombreRuta");

    select max("numeroSecuencia") into v_max
    from etapa
    where "nombreEstadoRuta" = v_estado
      and "nombreMunicipioRuta" = v_municipio
      and "nombreRuta" = v_ruta;

    if v_max is null then
        return null;
    end if;

    select "nombreHito" into v_hito_ini
    from etapa
    where "nombreEstadoRuta" = v_estado
      and "nombreMunicipioRuta" = v_municipio
      and "nombreRuta" = v_ruta
      and "numeroSecuencia" = 1;

    if v_hito_ini is null then
        raise exception 'RR-31: La primera etapa (secuencia 1) de la ruta "%" debe ser un hito, no una parada.', v_ruta;
    end if;

    select "nombreHito" into v_hito_fin
    from etapa
    where "nombreEstadoRuta" = v_estado
      and "nombreMunicipioRuta" = v_municipio
      and "nombreRuta" = v_ruta
      and "numeroSecuencia" = v_max;

    if v_hito_fin is null then
        raise exception 'RR-31: La última etapa (secuencia %) de la ruta "%" debe ser un hito, no una parada.', v_max, v_ruta;
    end if;

    return null;
end;
$$;

create constraint trigger trg_etapa_extremos_hito
after insert or update or delete on etapa
deferrable initially deferred
for each row execute function fn_validar_etapa_extremos_hito();


-- 5. Evaluacion inmutable: bloquear UPDATE

create or replace function fn_bloquear_update_evaluacion()
returns trigger
language plpgsql
as $$
begin
    raise exception 'Regla de negocio: Las evaluaciones son inmutables y no pueden modificarse (codigoResena=%).', old."codigoResena";
end;
$$;

create trigger trg_eval_no_update
before update on evaluacion
for each row execute function fn_bloquear_update_evaluacion();

-- ============================================================
-- 6. RR-37 / RR-38: Verificar recorrido completado o visita a hito
--    antes de insertar en Evaluacion
-- ============================================================
-- Autor: Verónica Betancourt - Bloque 2
create or replace function fn_verificar_evaluacion()
returns trigger
language plpgsql
as $$
declare
    v_ok boolean := false;
begin
    if new."nombreRuta" is not null then
        select exists(
            select 1 from recorrido r
            where r."tipoDocumento" = new."tipoDocumento"
              and r."numeroDocumento" = new."numeroDocumento"
              and r."nombreEstadoRuta" = new."nombreEstadoRuta"
              and r."nombreMunicipioRuta" = new."nombreMunicipioRuta"
              and r."nombreRuta" = new."nombreRuta"
              and r."estadoRecorrido" = 'completado'
        ) into v_ok;

        if not v_ok then
            raise exception 'RR-37: El visitante %-% no tiene un recorrido completado en la ruta "%".',
                new."tipoDocumento", new."numeroDocumento", new."nombreRuta";
        end if;
    elsif new."nombreHito" is not null then
        select exists(
            select 1 from "visitaHito" vh
            where vh."tipoDocumento" = new."tipoDocumento"
              and vh."numeroDocumento" = new."numeroDocumento"
              and vh."nombreEstadoHito" = new."nombreEstadoHito"
              and vh."nombreMunicipioHito" = new."nombreMunicipioHito"
              and vh."nombreParroquia" = new."nombreParroquia"
              and vh."nombreHito" = new."nombreHito"
        ) into v_ok;

        if not v_ok then
            raise exception 'RR-38: El visitante %-% no tiene una visita registrada en el hito "%".',
                new."tipoDocumento", new."numeroDocumento", new."nombreHito";
        end if;
    end if;

    new."verificacionRecorrido" := true;
    return new;
end;
$$;

create trigger trg_eval_verificacion
before insert on evaluacion
for each row execute function fn_verificar_evaluacion();

-- ============================================================
-- 7. RR-45: Credencial no permite DELETE
-- ============================================================
-- Autor: Verónica Betancourt - Bloque 2
create or replace function fn_bloquear_delete_credencial()
returns trigger
language plpgsql
as $$
begin
    raise exception 'RR-45: No se permite eliminar credenciales (%). Cambie estadoPase a ''cancelado''.', old."codigoVerificacion";
end;
$$;

create trigger trg_cred_no_delete
before delete on credencial
for each row execute function fn_bloquear_delete_credencial();

-- ============================================================
-- 8. RR-44: Si Credencial reserva un Hito, libreAcceso debe ser FALSE
-- ============================================================
-- Autor: Verónica Betancourt - Bloque 2
create or replace function fn_validar_credencial_hito()
returns trigger
language plpgsql
as $$
declare
    v_libre boolean;
begin
    if new."nombreHito" is not null then
        select "libreAcceso" into v_libre
        from hito
        where "nombreEstado" = new."nombreEstadoHito"
          and "nombreMunicipio" = new."nombreMunicipioHito"
          and "nombreParroquia" = new."nombreParroquia"
          and "nombreHito" = new."nombreHito";

        if v_libre is true then
            raise exception 'RR-44: El hito "%" es de libre acceso y no requiere credencial digital.', new."nombreHito";
        end if;
    end if;
    return new;
end;
$$;

create trigger trg_cred_hito_libre_acceso
before insert or update on credencial
for each row execute function fn_validar_credencial_hito();

-- ============================================================
-- 9. RR-49: idUsuarioValida debe pertenecer a Comercio o Guia
-- ============================================================
-- Autor: Verónica Betancourt - Bloque 2
create or replace function fn_validar_credencial_validador()
returns trigger
language plpgsql
as $$
declare
    v_autorizado boolean := false;
begin
    if new."idUsuarioValida" is not null then
        select (
            exists(select 1 from comercio c where c."idUsuario" = new."idUsuarioValida")
            or
            exists(select 1 from guia g where g."idUsuario" = new."idUsuarioValida")
        ) into v_autorizado;

        if not v_autorizado then
            raise exception 'RR-49: El usuario % no está autorizado para validar credenciales (debe ser Comercio o Guia).',
                new."idUsuarioValida";
        end if;
    end if;
    return new;
end;
$$;

create trigger trg_cred_validador_autorizado
before insert or update on credencial
for each row execute function fn_validar_credencial_validador();

-- ============================================================
-- 10. RR-46 / RR-47: Canje único, irreversible, en fecha y ventana horaria
-- ============================================================
-- Autor: Verónica Betancourt - Bloque 2
create or replace function fn_validar_credencial_canje()
returns trigger
language plpgsql
as $$
begin
    if tg_op = 'UPDATE' and old."estadoPase" = 'canjeado' then
        raise exception 'RR-46: La credencial % ya fue canjeada y no puede modificarse.', old."codigoVerificacion";
    end if;

    if new."estadoPase" = 'canjeado' then
        if new."fechaHoraCanje"::date <> new."fechaProgramada" then
            raise exception 'RR-47: La fecha de canje (%) no coincide con la fecha programada (%).',
                new."fechaHoraCanje"::date, new."fechaProgramada";
        end if;

        if new."fechaHoraCanje"::time < new."horaInicio"
           or new."fechaHoraCanje"::time >= new."horaFin" then
            raise exception 'RR-47: La hora de canje (%) está fuera del rango autorizado [% - %).',
                new."fechaHoraCanje"::time, new."horaInicio", new."horaFin";
        end if;
    end if;

    return new;
end;
$$;

create trigger trg_cred_canje_fecha_hora
before insert or update on credencial
for each row execute function fn_validar_credencial_canje();

-- ============================================================
-- PROCEDIMIENTO ALMACENADO 1: sp_crear_ruta_completa
-- Inserta Ruta + subtipo + etapas + temáticas en 1 transacción
-- ============================================================
-- Autor: Verónica Betancourt - Bloque 2
create or replace procedure sp_crear_ruta_completa(
    p_estado           varchar(60),
    p_municipio        varchar(80),
    p_nombre_ruta      varchar(200),
    p_duracion         numeric(8,2),
    p_horario_inicio   time,
    p_nivel_dificultad varchar(30),
    p_tipo_ruta        varchar(10),
    p_tipo_doc         varchar(20),   -- NULL si tipo = 'fija'
    p_num_doc          varchar(30),   -- NULL si tipo = 'fija'
    p_etapas           jsonb,         -- arreglo JSON de etapas
    p_categorias       text[] default '{}'
)
language plpgsql
as $$
declare
    v_etapa jsonb;
    v_cat   text;
begin
    insert into ruta (
        "nombreEstado", "nombreMunicipio", "nombreRuta",
        "duracionEstimada", "mejorHorarioInicio", "nivelDificultad", "tipoRuta"
    ) values (
        p_estado, p_municipio, p_nombre_ruta,
        p_duracion, p_horario_inicio, p_nivel_dificultad, p_tipo_ruta
    );

    if p_tipo_ruta = 'fija' then
        insert into "rutaFija" ("nombreEstado", "nombreMunicipio", "nombreRuta")
        values (p_estado, p_municipio, p_nombre_ruta);
    elsif p_tipo_ruta = 'dinamica' then
        insert into "rutaDinamica" (
            "nombreEstado", "nombreMunicipio", "nombreRuta",
            "tipoDocumento", "numeroDocumento"
        ) values (
            p_estado, p_municipio, p_nombre_ruta,
            p_tipo_doc, p_num_doc
        );
    end if;

    for v_etapa in select * from jsonb_array_elements(p_etapas)
    loop
        insert into etapa (
            "nombreEstadoRuta", "nombreMunicipioRuta", "nombreRuta",
            "numeroSecuencia", "modoTransporte", "tiempoDesdeAnterior",
            "nombreEstadoHito", "nombreMunicipioHito", "nombreParroquia", "nombreHito",
            "codigoOficial", "codigoVia"
        ) values (
            p_estado, p_municipio, p_nombre_ruta,
            (v_etapa->>'numeroSecuencia')::integer,
            v_etapa->>'modoTransporte',
            (v_etapa->>'tiempoDesdeAnterior')::numeric,
            v_etapa->>'nombreEstadoHito',
            v_etapa->>'nombreMunicipioHito',
            v_etapa->>'nombreParroquia',
            v_etapa->>'nombreHito',
            v_etapa->>'codigoOficial',
            v_etapa->>'codigoVia'
        );
    end loop;

    foreach v_cat in array p_categorias
    loop
        insert into tematica ("nombreEstado", "nombreMunicipio", "nombreRuta", "nombreCategoria")
        values (p_estado, p_municipio, p_nombre_ruta, v_cat);
    end loop;
end;
$$;

-- ============================================================
-- PROCEDIMIENTO ALMACENADO 2: sp_canjear_credencial
-- Valida y ejecuta el canje único de una credencial digital
-- ============================================================
-- Autor: Verónica Betancourt - Bloque 2
create or replace procedure sp_canjear_credencial(
    p_codigo            varchar(50),
    p_id_usuario_valida integer
)
language plpgsql
as $$
declare
    v_estado_actual varchar(20);
begin
    select "estadoPase" into v_estado_actual
    from credencial
    where "codigoVerificacion" = p_codigo
    for update;

    if not found then
        raise exception 'No existe la credencial con código "%".', p_codigo;
    end if;

    if v_estado_actual <> 'emitido' then
        raise exception 'La credencial "%" no puede canjearse porque su estado actual es "%".',
            p_codigo, v_estado_actual;
    end if;

    update credencial
    set "estadoPase"      = 'canjeado',
        "idUsuarioValida" = p_id_usuario_valida,
        "fechaHoraCanje"  = current_timestamp
    where "codigoVerificacion" = p_codigo;
end;
$$;

-- ============================================================
-- FUNCIÓN REP04 (P08): fn_ranking_rutas
-- Ranking de rutas por calidad y seguridad

create or replace function fn_ranking_rutas(
    p_estado    varchar(60) default null,
    p_categoria varchar(60) default null,
    p_min_eval  integer     default 0
)
returns table (
    "nombreRuta"            varchar(200),
    "nombreEstado"          varchar(60),
    "nombreMunicipio"       varchar(80),
    "tipoRuta"              varchar(10),
    "nivelDificultad"       varchar(30),
    "cantidadEvaluaciones"  bigint,
    "promedioCalificacion"  numeric(4,2),
    "promedioSeguridad"     numeric(4,2),
    "recorridosCompletados" bigint
)
language sql
stable
as $$
    select
        r."nombreRuta",
        r."nombreEstado",
        r."nombreMunicipio",
        r."tipoRuta",
        r."nivelDificultad",
        count(distinct e."codigoResena") as "cantidadEvaluaciones",
        round(coalesce(avg(e.calificacion), 0), 2) as "promedioCalificacion",
        round(coalesce(avg(e."indiceSeguridad"), 0), 2) as "promedioSeguridad",
        count(distinct rec."codigoRecorrido") filter (where rec."estadoRecorrido" = 'completado')
            as "recorridosCompletados"
    from ruta r
    left join evaluacion e
        on e."nombreEstadoRuta" = r."nombreEstado"
       and e."nombreMunicipioRuta" = r."nombreMunicipio"
       and e."nombreRuta" = r."nombreRuta"
    left join recorrido rec
        on rec."nombreEstadoRuta" = r."nombreEstado"
       and rec."nombreMunicipioRuta" = r."nombreMunicipio"
       and rec."nombreRuta" = r."nombreRuta"
    where (p_estado is null or r."nombreEstado" = p_estado)
      and (
          p_categoria is null
          or exists (
              select 1 from tematica t
              where t."nombreEstado" = r."nombreEstado"
                and t."nombreMunicipio" = r."nombreMunicipio"
                and t."nombreRuta" = r."nombreRuta"
                and t."nombreCategoria" = p_categoria
          )
      )
    group by r."nombreRuta", r."nombreEstado", r."nombreMunicipio", r."tipoRuta", r."nivelDificultad"
    having count(distinct e."codigoResena") >= p_min_eval
    order by "promedioCalificacion" desc, "promedioSeguridad" desc, "cantidadEvaluaciones" desc;
$$;
