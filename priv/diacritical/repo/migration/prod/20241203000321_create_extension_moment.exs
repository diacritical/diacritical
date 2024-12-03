defmodule Diacritical.Repo.Migration.CreateDomainMoment do
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

  Creates a domain, `moment`.

  ## Example

      iex> up()
      :ok

  """
  @doc since: "0.14.0"
  @spec up() :: status()
  def up() do
    command = """
    CREATE DOMAIN moment AS timestamp with time zone DEFAULT clock_timestamp()
    """

    execute command
  end

  @doc """
  Reverts changes put onto the database by `up/0`.

  Drops a domain, `moment`.

  ## Example

      iex> down()
      :ok

  """
  @doc since: "0.14.0"
  @spec down() :: status()
  def down() do
    execute "DROP DOMAIN moment"
  end
end
