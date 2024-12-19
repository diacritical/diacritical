defmodule Diacritical.Repo.Migration.CreateDomainSlug do
  @moduledoc "Defines an `Ecto.Migration` migration."
  @moduledoc since: "0.22.0"

  use Diacritical.Repo.Migration

  alias Diacritical

  alias Diacritical.Repo

  alias Repo.Migration

  @typedoc "Represents the status."
  @typedoc since: "0.22.0"
  @type status() :: Migration.status()

  @doc """
  Migrates the database forward.

  Creates a domain, `slug`.

  ## Example

      iex> up()
      :ok

  """
  @doc since: "0.22.0"
  @spec up() :: status()
  def up() do
    command = """
    CREATE DOMAIN slug AS citext
        CONSTRAINT slug_format_check
            CHECK (
                VALUE IS NULL
                OR VALUE ~* ('^(?!^-|.*-$|.*-{2})(?:[-0-9_a-z])+$')
            )

        CONSTRAINT slug_length_check CHECK (char_length(VALUE) <= 128)
    """

    execute command
  end

  @doc """
  Reverts changes put onto the database by `up/0`.

  Drops a domain, `slug`.

  ## Example

      iex> down()
      :ok

  """
  @doc since: "0.22.0"
  @spec down() :: status()
  def down() do
    execute "DROP DOMAIN slug"
  end
end
