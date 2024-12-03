defmodule DiacriticalSchema.Account.Token do
  @moduledoc "Defines an `Ecto.Schema` schema and `Ecto.Changeset` changeset."
  @moduledoc since: "0.15.0"

  use DiacriticalSchema

  alias Diacritical
  alias DiacriticalSchema

  alias Diacritical.Repo
  alias DiacriticalSchema.Account
  alias DiacriticalSchema.Changeset

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

  @typedoc "Represents the changeset."
  @typedoc since: "0.15.0"
  @type changeset() :: Changeset.t(t())

  @typedoc "Represents the data."
  @typedoc since: "0.15.0"
  @type data() :: Changeset.data(changeset(), t())

  @typedoc "Represents the parameter."
  @typedoc since: "0.15.0"
  @type param() :: Changeset.param()

  schema "account_token" do
    field :data, :binary
    field :type, :string
    field :sent_to, :string
    belongs_to :account, Account
    field :inserted_at, :utc_datetime_usec, read_after_writes: true
  end

  @spec do_changeset(data(), param()) :: changeset()
  defp do_changeset(data, param)
       when (is_struct(data, __MODULE__) or is_struct(data, Ecto.Changeset)) and
              is_map(param) do
    required = ~W[account_id data type]a
    permitted = [:sent_to] ++ required

    data
    |> Ecto.Changeset.cast(param, permitted)
    |> Ecto.Changeset.validate_required(required)
    |> Changeset.validate_email(:sent_to)
    |> Ecto.Changeset.unsafe_validate_unique([:data, :type], Repo)
    |> Ecto.Changeset.unique_constraint(
      [:data, :type],
      name: :account_token_data_type_key
    )
    |> Ecto.Changeset.assoc_constraint(
      :account,
      name: :account_token_account_id_fkey
    )
  end

  @doc """
  Applies the given `param` as a validated changeset for the given `data`.

  ## Examples

      iex> checkout_repo()
      iex> %{param: %{err: param}} = c_param_token(%{})
      iex>
      iex> %Ecto.Changeset{valid?: false} = changeset(param)

      iex> checkout_repo()
      iex> %{param: %{atom: param}} = c_param_token(%{})
      iex>
      iex> %Ecto.Changeset{valid?: true} = changeset(param)

  """
  @doc since: "0.15.0"
  @spec changeset(param()) :: changeset()
  @spec changeset(data(), param()) :: changeset()
  def changeset(data \\ %__MODULE__{}, param)

  def changeset(%__MODULE__{} = data, param) when is_map(param) do
    do_changeset(data, param)
  end

  def changeset(%Ecto.Changeset{data: %__MODULE__{}} = data, param)
      when is_map(param) do
    do_changeset(data, param)
  end
end
