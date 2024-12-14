defmodule Diacritical.Repo.Migration.CreateTableTestSchema do
  @moduledoc "Defines an `Ecto.Migration` migration."
  @moduledoc since: "0.10.0"

  use Diacritical.Repo.Migration

  alias Diacritical

  alias Diacritical.Repo

  alias Repo.Migration

  @typedoc "Represents the status."
  @typedoc since: "0.10.0"
  @type status() :: Migration.status()

  @doc """
  Migrates the database forward.

  Creates a table, `test_schema`.

  Creates an index, `test_schema_parent_id_fkey`.

  ## Example

      iex> up()
      :ok

  """
  @doc since: "0.10.0"
  @spec up() :: status()
  def up() do
    command = """
    CREATE TABLE test_schema (
        id pkey CONSTRAINT test_schema_pkey PRIMARY KEY,
        x acc CONSTRAINT test_schema_x_nn NOT NULL,

        parent_id fkey
            CONSTRAINT test_schema_parent_id_fkey
                REFERENCES test_schema ON DELETE SET NULL ON UPDATE CASCADE
    )
    """

    execute command

    execute "CREATE INDEX test_schema_parent_id_fkey ON test_schema (parent_id)"
  end

  @doc """
  Reverts changes put onto the database by `up/0`.

  Drops an index, `test_schema_parent_id_fkey`.

  Drops a table, `test_schema`.

  ## Example

      iex> down()
      :ok

  """
  @doc since: "0.10.0"
  @spec down() :: status()
  def down() do
    execute "DROP INDEX test_schema_parent_id_fkey"
    execute "DROP TABLE test_schema"
  end
end
