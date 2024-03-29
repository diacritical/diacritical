defmodule Diacritical.Repo.Migration.CreateDomainArgon2 do
  @moduledoc "Defines an `Ecto.Migration` migration."
  @moduledoc since: "0.15.0"

  use Diacritical.Repo.Migration

  alias Diacritical

  alias Diacritical.Repo

  alias Repo.Migration

  @typedoc "Represents the status."
  @typedoc since: "0.15.0"
  @type status() :: Migration.status()

  @doc """
  Migrates the database forward.

  Creates a domain, `argon2`.

  ## Example

      iex> up()
      :ok

  """
  @doc since: "0.15.0"
  @spec up() :: status()
  def up() do
    command = ~S"""
    CREATE DOMAIN argon2 AS text
        CONSTRAINT argon2_format_check
            CHECK (
                VALUE IS NULL
                OR VALUE ~ (
                    '^\$argon2(?:[di]|id)' ||
                    '\$v=[0-9]+\$m=[0-9]+,t=[0-9]+,p=[0-9]+' ||
                    '\$(?:[+/0-9A-Za-z]+)\$(?:[+/0-9A-Za-z]+)$'
                )
            )
    """

    execute command
  end

  @doc """
  Reverts changes put onto the database by `up/0`.

  Drops a domain, `argon2`.

  ## Example

      iex> down()
      :ok

  """
  @doc since: "0.15.0"
  @spec down() :: status()
  def down() do
    execute "DROP DOMAIN argon2"
  end
end
