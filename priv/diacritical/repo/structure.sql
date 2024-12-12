SET client_encoding TO UTF8;

CREATE TABLE schema_migration (
  version bigint CONSTRAINT schema_migration_pkey PRIMARY KEY,

  inserted_at timestamp(0) without time zone
    CONSTRAINT schema_migration_inserted_at_nn NOT NULL
);
