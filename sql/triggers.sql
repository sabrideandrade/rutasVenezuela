-- Proyecto RutasVenezuela - Bloque 1
-- Iliany Rodriguez
-- Triggers para las reglas RR-19 y RR-20


-- RR-19: todo hito debe tener al menos una categoria

create or replace function "validarHitoCategoria"()
returns trigger as $$
declare
    vEstado varchar(60);
    vMunicipio varchar(80);
    vParroquia varchar(80);
    vHito varchar(120);
begin
    if tg_op = 'DELETE' then
        vEstado := old."nombreEstado";
        vMunicipio := old."nombreMunicipio";
        vParroquia := old."nombreParroquia";
        vHito := old."nombreHito";
    else
        vEstado := new."nombreEstado";
        vMunicipio := new."nombreMunicipio";
        vParroquia := new."nombreParroquia";
        vHito := new."nombreHito";
    end if;

    -- si el hito fue eliminado no hay nada que validar
    if not exists (select 1 from hito
                   where "nombreEstado" = vEstado and "nombreMunicipio" = vMunicipio
                   and "nombreParroquia" = vParroquia and "nombreHito" = vHito) then
        return null;
    end if;

    if not exists (select 1 from "hitoCategoria"
                   where "nombreEstado" = vEstado and "nombreMunicipio" = vMunicipio
                   and "nombreParroquia" = vParroquia and "nombreHito" = vHito) then
        raise exception 'El hito % debe tener al menos una categoria (RR-19)', vHito;
    end if;

    return null;
end;
$$ language plpgsql;

drop trigger if exists "trgHitoCategoriaInsert" on hito;
create constraint trigger "trgHitoCategoriaInsert"
after insert on hito
deferrable initially deferred
for each row execute function "validarHitoCategoria"();

drop trigger if exists "trgHitoCategoriaDelete" on "hitoCategoria";
create constraint trigger "trgHitoCategoriaDelete"
after delete on "hitoCategoria"
deferrable initially deferred
for each row execute function "validarHitoCategoria"();


-- RR-20: si el hito no es de libre acceso debe tener al menos un horario

create or replace function "validarHitoHorario"()
returns trigger as $$
declare
    vEstado varchar(60);
    vMunicipio varchar(80);
    vParroquia varchar(80);
    vHito varchar(120);
    vLibre boolean;
begin
    if tg_op = 'DELETE' then
        vEstado := old."nombreEstado";
        vMunicipio := old."nombreMunicipio";
        vParroquia := old."nombreParroquia";
        vHito := old."nombreHito";
    else
        vEstado := new."nombreEstado";
        vMunicipio := new."nombreMunicipio";
        vParroquia := new."nombreParroquia";
        vHito := new."nombreHito";
    end if;

    select "libreAcceso" into vLibre from hito
    where "nombreEstado" = vEstado and "nombreMunicipio" = vMunicipio
    and "nombreParroquia" = vParroquia and "nombreHito" = vHito;

    -- si el hito no existe o es de libre acceso no se valida
    if vLibre is null or vLibre = true then
        return null;
    end if;

    if not exists (select 1 from "horarioHito"
                   where "nombreEstado" = vEstado and "nombreMunicipio" = vMunicipio
                   and "nombreParroquia" = vParroquia and "nombreHito" = vHito) then
        raise exception 'El hito % no es de libre acceso y debe tener horario (RR-20)', vHito;
    end if;

    return null;
end;
$$ language plpgsql;

drop trigger if exists "trgHitoHorario" on hito;
create constraint trigger "trgHitoHorario"
after insert or update on hito
deferrable initially deferred
for each row execute function "validarHitoHorario"();

drop trigger if exists "trgHorarioDelete" on "horarioHito";
create constraint trigger "trgHorarioDelete"
after delete on "horarioHito"
deferrable initially deferred
for each row execute function "validarHitoHorario"();
