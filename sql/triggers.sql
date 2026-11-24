-- Proyecto RutasVenezuela - Bloque 1
-- Iliany Rodriguez
-- Triggers para las reglas RR-19 y RR-20


-- RR-19: todo hito debe tener al menos una categoria

create or replace function validar_hito_categoria()
returns trigger as $$
declare
    v_estado varchar(60);
    v_municipio varchar(80);
    v_parroquia varchar(80);
    v_hito varchar(120);
begin
    if tg_op = 'DELETE' then
        v_estado := old.nombre_estado;
        v_municipio := old.nombre_municipio;
        v_parroquia := old.nombre_parroquia;
        v_hito := old.nombre_hito;
    else
        v_estado := new.nombre_estado;
        v_municipio := new.nombre_municipio;
        v_parroquia := new.nombre_parroquia;
        v_hito := new.nombre_hito;
    end if;

    -- si el hito fue eliminado no hay nada que validar
    if not exists (select 1 from hito
                   where nombre_estado = v_estado and nombre_municipio = v_municipio
                   and nombre_parroquia = v_parroquia and nombre_hito = v_hito) then
        return null;
    end if;

    if not exists (select 1 from hito_categoria
                   where nombre_estado = v_estado and nombre_municipio = v_municipio
                   and nombre_parroquia = v_parroquia and nombre_hito = v_hito) then
        raise exception 'El hito % debe tener al menos una categoria (RR-19)', v_hito;
    end if;

    return null;
end;
$$ language plpgsql;

drop trigger if exists trg_hito_categoria_insert on hito;
create constraint trigger trg_hito_categoria_insert
after insert on hito
deferrable initially deferred
for each row execute function validar_hito_categoria();

drop trigger if exists trg_hito_categoria_delete on hito_categoria;
create constraint trigger trg_hito_categoria_delete
after delete on hito_categoria
deferrable initially deferred
for each row execute function validar_hito_categoria();


-- RR-20: si el hito no es de libre acceso debe tener al menos un horario

create or replace function validar_hito_horario()
returns trigger as $$
declare
    v_estado varchar(60);
    v_municipio varchar(80);
    v_parroquia varchar(80);
    v_hito varchar(120);
    v_libre boolean;
begin
    if tg_op = 'DELETE' then
        v_estado := old.nombre_estado;
        v_municipio := old.nombre_municipio;
        v_parroquia := old.nombre_parroquia;
        v_hito := old.nombre_hito;
    else
        v_estado := new.nombre_estado;
        v_municipio := new.nombre_municipio;
        v_parroquia := new.nombre_parroquia;
        v_hito := new.nombre_hito;
    end if;

    select libre_acceso into v_libre from hito
    where nombre_estado = v_estado and nombre_municipio = v_municipio
    and nombre_parroquia = v_parroquia and nombre_hito = v_hito;

    -- si el hito no existe o es de libre acceso no se valida
    if v_libre is null or v_libre = true then
        return null;
    end if;

    if not exists (select 1 from horario_hito
                   where nombre_estado = v_estado and nombre_municipio = v_municipio
                   and nombre_parroquia = v_parroquia and nombre_hito = v_hito) then
        raise exception 'El hito % no es de libre acceso y debe tener horario (RR-20)', v_hito;
    end if;

    return null;
end;
$$ language plpgsql;

drop trigger if exists trg_hito_horario_hito on hito;
create constraint trigger trg_hito_horario_hito
after insert or update on hito
deferrable initially deferred
for each row execute function validar_hito_horario();

drop trigger if exists trg_hito_horario_delete on horario_hito;
create constraint trigger trg_hito_horario_delete
after delete on horario_hito
deferrable initially deferred
for each row execute function validar_hito_horario();
