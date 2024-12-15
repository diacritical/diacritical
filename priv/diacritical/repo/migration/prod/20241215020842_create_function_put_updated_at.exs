defmodule Diacritical.Repo.Migration.CreateFunctionPutUpdatedAt do
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

  Creates a function, `put_updated_at()`.

  ## Example

      iex> up()
      :ok

  """
  @doc since: "0.14.0"
  @spec up() :: status()
  def up() do
    command = """
    CREATE FUNCTION put_updated_at() RETURNS TRIGGER AS $$
        BEGIN
            NEW.updated_at = clock_timestamp();
            RETURN NEW;
        END;
    $$ LANGUAGE plpgsql
    """

    execute command
  end

  @doc """
  Reverts changes put onto the database by `up/0`.

  Drops a function, `put_updated_at()`.

  ## Example

      iex> down()
      :ok

  """
  @doc since: "0.14.0"
  @spec down() :: status()
  def down() do
    execute "DROP FUNCTION put_updated_at()"
  end
end
