SET statement_timeout TO 0;
SET lock_timeout TO 0;
SET idle_in_transaction_session_timeout TO 0;
SET client_encoding TO UTF8;
SET standard_conforming_strings TO on;
SET search_path TO "$user", public;
SET check_function_bodies TO on;
SET xmloption TO content;
SET client_min_messages TO notice;
SET row_security TO on;
SET default_tablespace TO '';
SET default_table_access_method TO heap;

CREATE TABLE schema_migration (
    version bigint CONSTRAINT schema_migration_pkey PRIMARY KEY,

    inserted_at timestamp(0) without time zone
        CONSTRAINT schema_migration_inserted_at_nn NOT NULL
);
