defmodule Diacritical.Repo.Migration.CreateTableOption do
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

  Creates a table, `option`.

  Creates a trigger, `inserted_at_abort_invalid_update`, on `option`.

  Creates a trigger, `put_updated_at`, on `option`.

  ## Example

      iex> up()
      :ok

  """
  @doc since: "0.22.0"
  @spec up() :: status()
  def up() do
    command = """
    CREATE TABLE option (
        id pkey CONSTRAINT option_pkey PRIMARY KEY,

        key slug
            CONSTRAINT option_key_nn NOT NULL
            CONSTRAINT option_key_key UNIQUE,

        value text,
        description text,
        inserted_at moment CONSTRAINT option_inserted_at_nn NOT NULL,
        updated_at moment CONSTRAINT option_updated_at_nn NOT NULL
    )
    """

    execute command

    command! = """
    CREATE TRIGGER inserted_at_abort_invalid_update BEFORE UPDATE OF inserted_at
        ON option
        FOR EACH ROW
        WHEN (NEW.inserted_at IS DISTINCT FROM OLD.inserted_at)
        EXECUTE FUNCTION abort_invalid_update(
            'inserted_at',
            'cannot be updated'
        )
    """

    execute command!

    command! = """
    CREATE TRIGGER put_updated_at BEFORE UPDATE
        ON option FOR EACH ROW EXECUTE FUNCTION put_updated_at()
    """

    execute command!
  end

  @doc """
  Reverts changes put onto the database by `up/0`.

  Drops a trigger, `put_updated_at`, on `option`.

  Drops a trigger, `inserted_at_abort_invalid_update`, on `option`.

  Drops a table, `option`.

  ## Example

      iex> down()
      :ok

  """
  @doc since: "0.22.0"
  @spec down() :: status()
  def down() do
    execute "DROP TRIGGER put_updated_at ON option"
    execute "DROP TRIGGER inserted_at_abort_invalid_update ON option"
    execute "DROP TABLE option"
  end
end
