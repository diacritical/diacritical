defmodule Diacritical.Repo.Migration.CreateFunctionInvalidUpdate do
  @moduledoc "Defines an `Ecto.Migration` migration."
  @moduledoc since: "0.14.0"

  use Diacritical.Repo.Migration

  alias Diacritical

  alias Diacritical.Repo

  alias Repo.Migration

  @typedoc "Represents the status."
  @typedoc since: "0.14.0"
  @type status() :: Migration.status()

  @doc """
  Migrates the database forward.

  Creates a function, `abort_invalid_update()`.

  ## Example

      iex> up()
      :ok

  """
  @doc since: "0.14.0"
  @spec up() :: status()
  def up() do
    command = """
    CREATE FUNCTION abort_invalid_update() RETURNS TRIGGER AS $$
        BEGIN
            RAISE EXCEPTION 'value in column % of relation % %',
                TG_ARGV[0],
                TG_TABLE_NAME,
                TG_ARGV[1];
        END;
    $$ LANGUAGE plpgsql
    """

    execute command
  end

  @doc """
  Reverts changes put onto the database by `up/0`.

  Drops a function, `abort_invalid_update()`.

  ## Example

      iex> down()
      :ok

  """
  @doc since: "0.14.0"
  @spec down() :: status()
  def down() do
    execute "DROP FUNCTION abort_invalid_update()"
  end
end
