-- We put things inside the basic_auth schema to hide
-- them from public view. Certain public procs/views will
-- refer to helpers and tables inside.
create schema if not exists basic_auth;

-- add the pgcrypto extension to handle the cryptography
CREATE EXTENSION IF NOT EXISTS pgcrypto schema public;

-- add the pgjwt extension to handle the signing og the jwt tokens
CREATE EXTENSION IF NOT EXISTS pgjwt SCHEMA public;

CREATE TABLE if not exists
basic_auth.users (
  email    text primary key check ( email ~* '^.+@.+\..+$' ),
  pass     text not null check (length(pass) < 512),
  role     name not null check (length(role) < 512)
);

CREATE TYPE jwt_token AS (
  token text
);

CREATE OR REPLACE FUNCTION jwt_test() RETURNS public.jwt_token AS $$
 -- function that tests if a token is valid, based on our secret key
 SELECT public.sign(
    row_to_json(r), 'zOTMma3rOGRey8y4prnnxt08P52DXWZ5'
   -- TODO : don't hardcode this in
  ) AS token
  FROM (
    SELECT
      'my_role'::text as role,
	-- have the token expire in 300 seconds
      extract(epoch from now())::integer + 86400 AS exp
  ) r;
$$ LANGUAGE sql;

create or replace function
basic_auth.check_role_exists() returns trigger as $$
begin
  if not exists (select 1 from pg_roles as r where r.rolname = new.role) then
    raise foreign_key_violation using message =
      'unknown database role: ' || new.role;
    return null;
  end if;
  return new;
end
$$ language plpgsql;

-- trigger that makes sure the roles are up to date
drop trigger if exists ensure_user_role_exists on basic_auth.users;
create constraint trigger ensure_user_role_exists
  after insert or update on basic_auth.users
  for each row
  execute procedure basic_auth.check_role_exists();


create extension if not exists pgcrypto;

-- store encrypted versions of passwords
create or replace function
basic_auth.encrypt_pass() returns trigger as $$
begin
  if tg_op = 'INSERT' or new.pass <> old.pass then
    new.pass = crypt(new.pass, gen_salt('bf'));
  end if;
  return new;
end
$$ language plpgsql;

drop trigger if exists encrypt_pass on basic_auth.users;
create trigger encrypt_pass
  before insert or update on basic_auth.users
  for each row
  execute procedure basic_auth.encrypt_pass();

-- get the role given name and password
create or replace function
basic_auth.user_role(email text, pass text) returns name
  language plpgsql
  as $$
begin
  return (
  select role from basic_auth.users
   where users.email = user_role.email
     and users.pass = crypt(user_role.pass, users.pass)
  );
end;
$$;


-- login should be on your exposed schema
create or replace function
login(email text, pass text) returns jwt_token as $$
declare
  _role name;
  result jwt_token;
begin
  -- check email and password
  select basic_auth.user_role(email, pass) into _role;
  if _role is null then
    raise invalid_password using message = 'invalid user or password';
  end if;

  select sign(
      row_to_json(r), 'zOTMma3rOGRey8y4prnnxt08P52DXWZ5'
    ) as token
    from (
      select _role as role, login.email as email,
         extract(epoch from now())::integer + 60*1440 as exp
    ) r
    into result;
  return result;
end;
$$ language plpgsql security definer;



--make a new user
drop function make_user;

create or replace function
make_user(email text, pass text, venmo text, name text, major text default NULL, dorm text default NULL)
  RETURNS smallint AS -- return 1 if successful, else 0
$BODY$
DECLARE
BEGIN
    -- create role for user
--	EXECUTE FORMAT (
  --      'Create role %I', email);
	          -- insert into basic_auth.users values('test2@gmail.com', 'mypassword', 'basic_user');
    EXECUTE FORMAT (
	'INSERT INTO basic_auth.users(email,pass,role) values(%L, %L, %L)', 
	email, pass, 'todo_user');
   EXECUTE FORMAT (
	'INSERT INTO public.REGISTEREDUSER(email,name,venmo,major,dorm)  VALUES(%L, %L, %L, %L, %L)',
	email, name,  venmo, major, dorm);
	RETURN 1;
    -- Simple Exception
EXCEPTION
    WHEN others THEN
-- give the errors in console if unsuccessful
	raise notice 'The transaction is in an uncommittable state. '
                 'Transaction was rolled back';

    	raise notice '% %', SQLERRM, SQLSTATE;
        RETURN 0;
END;
$BODY$
language plpgsql security definer;


-- anyone can log in
revoke all from web_anon;
grant execute on function login(text,text) to web_anon;


-- only authenticated can make a new user
revoke all on function make_user(text,text,text,text,text,text) from web_anon;
grant execute on function make_user(text,text,text,text,text,text) to todo_user;

INSERT INTO basic_auth.users VALUES('pd88@duke.edu','Password1','todo_user');
