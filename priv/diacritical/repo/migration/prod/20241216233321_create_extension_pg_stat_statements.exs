defmodule Diacritical.Repo.Migration.CreateExtensionPgStatStatements do
  @moduledoc "Defines an `Ecto.Migration` migration."
  @moduledoc since: "0.18.0"

  use Diacritical.Repo.Migration

  alias Diacritical

  alias Diacritical.Repo

  alias Repo.Migration

  @typedoc "Represents the status."
  @typedoc since: "0.18.0"
  @type status() :: Migration.status()

  @doc """
  Migrates the database forward.

  Creates an extension, `pg_stat_statements`.

  Updates the comment on an extension, `pg_stat_statements`.

  ## Example

      iex> up()
      :ok

  """
  @doc since: "0.18.0"
  @spec up() :: status()
  def up() do
    execute "CREATE EXTENSION pg_stat_statements WITH SCHEMA public"

    command = """
    COMMENT ON
        EXTENSION pg_stat_statements IS 'tracks statement execution statistics'
    """

    execute command
  end

  @doc """
  Reverts changes put onto the database by `up/0`.

  Nullifies the comment on an extension, `pg_stat_statements`.

  Drops an extension, `pg_stat_statements`.

  ## Example

      iex> down()
      :ok

  """
  @doc since: "0.18.0"
  @spec down() :: status()
  def down() do
    execute "COMMENT ON EXTENSION pg_stat_statements IS NULL"
    execute "DROP EXTENSION pg_stat_statements"
  end
end
