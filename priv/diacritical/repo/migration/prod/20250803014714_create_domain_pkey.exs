defmodule Diacritical.Repo.Migration.CreateDomainPkey do
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

  Creates a domain, `pkey`.

  ## Example

      iex> up()
      :ok

  """
  @doc since: "0.10.0"
  @spec up() :: status()
  def up() do
    execute "CREATE DOMAIN pkey AS uuid DEFAULT gen_random_uuid()"
  end

  @doc """
  Reverts changes put onto the database by `up/0`.

  Drops a domain, `pkey`.

  ## Example

      iex> down()
      :ok

  """
  @doc since: "0.10.0"
  @spec down() :: status()
  def down() do
    execute "DROP DOMAIN pkey"
  end
end
