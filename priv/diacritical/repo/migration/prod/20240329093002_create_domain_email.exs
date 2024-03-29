defmodule Diacritical.Repo.Migration.CreateDomainEmail do
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

  Creates a domain, `email`.

  ## Example

      iex> up()
      :ok

  """
  @doc since: "0.15.0"
  @spec up() :: status()
  def up() do
    command = """
    CREATE DOMAIN email AS citext
        CONSTRAINT email_format_check
            CHECK (VALUE IS NULL OR VALUE ~* ('^.+@.+$'))

        CONSTRAINT email_length_check CHECK (char_length(VALUE) <= 254)
    """

    execute command
  end

  @doc """
  Reverts changes put onto the database by `up/0`.

  Drops a domain, `email`.

  ## Example

      iex> down()
      :ok

  """
  @doc since: "0.15.0"
  @spec down() :: status()
  def down() do
    execute "DROP DOMAIN email"
  end
end
