defmodule DiacriticalSchema.TestSchema do
  @moduledoc "Defines an `Ecto.Schema` schema."
  @moduledoc since: "0.9.0"

  use DiacriticalSchema

  schema "test_schema" do
    field :x, :integer, read_after_writes: true
    belongs_to :test_schema, __MODULE__, foreign_key: :parent_id
  end
end
