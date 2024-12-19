defmodule DiacriticalSchema.Option do
  @moduledoc "Defines an `Ecto.Schema` schema and `Ecto.Changeset` changeset."
  @moduledoc since: "0.22.0"

  use DiacriticalSchema

  alias Diacritical
  alias DiacriticalSchema

  alias Diacritical.Repo
  alias DiacriticalSchema.Changeset

  @typedoc "Represents the schema."
  @typedoc since: "0.22.0"
  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          description: nil | String.t(),
          id: nil | Ecto.UUID.t(),
          inserted_at: nil | DateTime.t(),
          key: nil | String.t(),
          updated_at: nil | DateTime.t(),
          value: nil | String.t()
        }

  @typedoc "Represents the changeset."
  @typedoc since: "0.22.0"
  @type changeset() :: Changeset.t(t())

  @typedoc "Represents the data."
  @typedoc since: "0.22.0"
  @type data() :: Changeset.data(changeset(), t())

  @typedoc "Represents the parameter."
  @typedoc since: "0.22.0"
  @type param() :: Changeset.param()

  schema "option" do
    field :key, :string
    field :value, :string
    field :description, :string
    field :inserted_at, :utc_datetime_usec, read_after_writes: true
    field :updated_at, :utc_datetime_usec, read_after_writes: true
  end

  @spec do_changeset(data(), param()) :: changeset()
  defp do_changeset(data, param)
       when (is_struct(data, __MODULE__) or is_struct(data, Ecto.Changeset)) and
              is_map(param) do
    required = [:key]
    permitted = [:description, :value] ++ required

    data
    |> Ecto.Changeset.cast(param, permitted)
    |> Ecto.Changeset.validate_required(required)
    |> Changeset.validate_slug(:key)
    |> Ecto.Changeset.unsafe_validate_unique(:key, Repo)
    |> Ecto.Changeset.unique_constraint(:key)
  end

  @doc """
  Applies the given `param` as a validated changeset for the given `data`.

  ## Examples

      iex> checkout_repo()
      iex> %{param: %{err: param}} = c_param_option(%{})
      iex>
      iex> %Ecto.Changeset{valid?: false} = changeset(param)

      iex> checkout_repo()
      iex> %{param: %{atom: param}} = c_param_option(%{})
      iex>
      iex> %Ecto.Changeset{valid?: true} = changeset(param)

  """
  @doc since: "0.22.0"
  @spec changeset(param()) :: changeset()
  @spec changeset(data(), param()) :: changeset()
  def changeset(data \\ %__MODULE__{}, param)

  def changeset(data, param)
      when is_struct(data, __MODULE__) and is_map(param) do
    do_changeset(data, param)
  end

  def changeset(%Ecto.Changeset{data: struct} = data, param)
      when is_struct(struct, __MODULE__) and is_map(param) do
    do_changeset(data, param)
  end
end
