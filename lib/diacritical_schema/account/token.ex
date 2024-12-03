defmodule DiacriticalSchema.Account.Token do
  @moduledoc "Defines an `Ecto.Schema` schema."
  @moduledoc since: "0.15.0"

  use DiacriticalSchema

  alias DiacriticalSchema

  alias DiacriticalSchema.Account

  @typedoc "Represents the schema."
  @typedoc since: "0.15.0"
  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          account: nil | Ecto.Association.NotLoaded.t() | Account.t(),
          account_id: nil | Ecto.UUID.t(),
          data: nil | binary(),
          id: nil | Ecto.UUID.t(),
          inserted_at: nil | DateTime.t(),
          type: nil | String.t(),
          sent_to: nil | String.t()
        }

  schema "account_token" do
    field :data, :binary
    field :type, :string
    field :sent_to, :string
    belongs_to :account, Account
    field :inserted_at, :utc_datetime_usec, read_after_writes: true
  end
end
