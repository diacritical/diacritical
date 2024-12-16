defmodule Diacritical.Repo.Migration.CreateExtensionSslinfo do
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

  Creates an extension, `sslinfo`.

  Updates the comment on an extension, `sslinfo`.

  ## Example

      iex> up()
      :ok

  """
  @doc since: "0.18.0"
  @spec up() :: status()
  def up() do
    execute "CREATE EXTENSION sslinfo WITH SCHEMA public"

    command = """
    COMMENT ON
        EXTENSION sslinfo IS 'provides information about the SSL connection'
    """

    execute command
  end

  @doc """
  Reverts changes put onto the database by `up/0`.

  Nullifies the comment on an extension, `sslinfo`.

  Drops an extension, `sslinfo`.

  ## Example

      iex> down()
      :ok

  """
  @doc since: "0.18.0"
  @spec down() :: status()
  def down() do
    execute "COMMENT ON EXTENSION sslinfo IS NULL"
    execute "DROP EXTENSION sslinfo"
  end
end
