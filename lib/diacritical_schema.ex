defmodule DiacriticalSchema do
  @moduledoc "Defines commonalities for `Ecto.Schema` schemata."
  @moduledoc since: "0.9.0"

  use Boundary, deps: [Ecto]

  @doc """
  In `use`, calls `use Ecto.Schema`, then defines select module attributes.

  ## Example

      iex> defmodule TestSchema do
      ...>   use DiacriticalSchema
      ...>
      ...>   schema "test_schema" do
      ...>     belongs_to :test_schema, __MODULE__, foreign_key: :parent_id
      ...>   end
      ...> end
      iex>
      iex> TestSchema.__schema__(:autogenerate_id)
      nil
      iex> TestSchema.__schema__(:read_after_writes)
      [:id]
      iex> TestSchema.__schema__(:type, :id)
      Ecto.UUID
      iex> TestSchema.__schema__(:type, :parent_id)
      Ecto.UUID

  """
  @doc since: "0.9.0"
  defmacro __using__(opt) when is_list(opt) do
    quote do
      use Ecto.Schema, unquote(opt)

      @primary_key {:id, Ecto.UUID, read_after_writes: true}
      @foreign_key_type elem(@primary_key, 1)
    end
  end
end
