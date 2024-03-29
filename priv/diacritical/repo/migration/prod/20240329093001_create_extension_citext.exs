defmodule Diacritical.Repo.Migration.CreateExtensionCitext do
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

  Creates an extension, `citext`.

  Updates the comment on an extension, `citext`.

  ## Example

      iex> up()
      :ok

  """
  @doc since: "0.15.0"
  @spec up() :: status()
  def up() do
    execute "CREATE EXTENSION citext WITH SCHEMA public"

    command = """
    COMMENT ON
        EXTENSION citext IS 'data type for case-insensitive character strings'
    """

    execute command
  end

  @doc """
  Reverts changes put onto the database by `up/0`.

  Nullifies the comment on an extension, `citext`.

  Drops an extension, `citext`.

  ## Example

      iex> down()
      :ok

  """
  @doc since: "0.15.0"
  @spec down() :: status()
  def down() do
    execute "COMMENT ON EXTENSION citext IS NULL"
    execute "DROP EXTENSION citext"
  end
end
