defmodule DiacriticalSchema.Option do
  @moduledoc "Defines an `Ecto.Schema` schema."
  @moduledoc since: "0.22.0"

  use DiacriticalSchema

  schema "option" do
    field :key, :string
    field :value, :string
    field :description, :string
    field :inserted_at, :utc_datetime_usec, read_after_writes: true
    field :updated_at, :utc_datetime_usec, read_after_writes: true
  end
end
