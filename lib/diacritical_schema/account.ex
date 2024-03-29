defmodule DiacriticalSchema.Account do
  @moduledoc "Defines an `Ecto.Schema` schema."
  @moduledoc since: "0.15.0"

  use DiacriticalSchema

  schema "account" do
    field :email, :string
    field :password, :string, redact: true, virtual: true
    field :password_digest, :string, redact: true
    field :confirmed_at, :utc_datetime_usec
    field :inserted_at, :utc_datetime_usec, read_after_writes: true
    field :updated_at, :utc_datetime_usec, read_after_writes: true
    field :deleted_at, :utc_datetime_usec
  end
end
