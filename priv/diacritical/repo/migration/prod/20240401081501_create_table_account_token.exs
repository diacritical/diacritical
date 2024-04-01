defmodule Diacritical.Repo.Migration.CreateTableAccountToken do
  @moduledoc "Defines an `Ecto.Migration` migration."
  @moduledoc since: "0.16.0"

  use Diacritical.Repo.Migration

  alias Diacritical

  alias Diacritical.Repo

  alias Repo.Migration

  @typedoc "Represents the status."
  @typedoc since: "0.16.0"
  @type status() :: Migration.status()

  @doc """
  Migrates the database forward.

  Creates a table, `account_token`.

  Creates an index, `account_token_data_type_key`.

  Creates an index, `account_token_account_id_fkey`.

  Creates a trigger, `inserted_at_abort_invalid_update`, on `account_token`.

  ## Example

      iex> up()
      :ok

  """
  @doc since: "0.16.0"
  @spec up() :: status()
  def up() do
    command = """
    CREATE TABLE account_token (
        id pkey CONSTRAINT account_token_pkey PRIMARY KEY,
        data bytea CONSTRAINT account_token_data_nn NOT NULL,
        type text CONSTRAINT account_token_type_nn NOT NULL,
        sent_to email,

        account_id fkey
            CONSTRAINT account_token_account_id_nn NOT NULL
            CONSTRAINT account_token_account_id_fkey
                REFERENCES account ON DELETE CASCADE ON UPDATE CASCADE,

        inserted_at moment CONSTRAINT account_token_inserted_at_nn NOT NULL
    )
    """

    execute command

    command! = """
    CREATE UNIQUE INDEX account_token_data_type_key
        ON account_token (data, type)
    """

    execute command!

    command! =
      "CREATE INDEX account_token_account_id_fkey ON account_token (account_id)"

    execute command!

    command! = """
    CREATE TRIGGER inserted_at_abort_invalid_update BEFORE UPDATE OF inserted_at
        ON account_token
        FOR EACH ROW
        WHEN (NEW.inserted_at IS DISTINCT FROM OLD.inserted_at)
        EXECUTE FUNCTION abort_invalid_update(
            'inserted_at',
            'cannot be updated'
        )
    """

    execute command!
  end

  @doc """
  Reverts changes put onto the database by `up/0`.

  Drops a trigger, `inserted_at_abort_invalid_update`, on `account_token`.

  Drops an index, `account_token_account_id_fkey`.

  Drops an index, `account_token_data_type_key`.

  Drops a table, `account_token`.

  ## Example

      iex> down()
      :ok

  """
  @doc since: "0.16.0"
  @spec down() :: status()
  def down() do
    execute "DROP TRIGGER inserted_at_abort_invalid_update ON account_token"
    execute "DROP INDEX account_token_account_id_fkey"
    execute "DROP INDEX account_token_data_type_key"
    execute "DROP TABLE account_token"
  end
end
