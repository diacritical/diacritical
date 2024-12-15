defmodule Diacritical.Repo.Migration.CreateTableAccount do
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

  Creates a table, `account`.

  Creates a trigger, `inserted_at_abort_invalid_update`, on `account`.

  Creates a trigger, `put_updated_at`, on `account`.

  ## Example

      iex> up()
      :ok

  """
  @doc since: "0.14.0"
  @spec up() :: status()
  def up() do
    command = """
    CREATE TABLE account (
        id pkey CONSTRAINT account_pkey PRIMARY KEY,

        email email
            CONSTRAINT account_email_nn NOT NULL
            CONSTRAINT account_email_key UNIQUE,

        password_digest argon2 CONSTRAINT account_password_digest_nn NOT NULL,
        confirmed_at timestamp with time zone,
        inserted_at moment CONSTRAINT account_inserted_at_nn NOT NULL,
        updated_at moment CONSTRAINT account_updated_at_nn NOT NULL,
        deleted_at timestamp with time zone
    )
    """

    execute command

    command! = """
    CREATE TRIGGER inserted_at_abort_invalid_update BEFORE UPDATE OF inserted_at
        ON account
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
        ON account FOR EACH ROW EXECUTE FUNCTION put_updated_at()
    """

    execute command!
  end

  @doc """
  Reverts changes put onto the database by `up/0`.

  Drops a trigger, `put_updated_at`, on `account`.

  Drops a trigger, `inserted_at_abort_invalid_update`, on `account`.

  Drops a table, `account`.

  ## Example

      iex> down()
      :ok

  """
  @doc since: "0.14.0"
  @spec down() :: status()
  def down() do
    execute "DROP TRIGGER put_updated_at ON account"
    execute "DROP TRIGGER inserted_at_abort_invalid_update ON account"
    execute "DROP TABLE account"
  end
end
