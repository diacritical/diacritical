defmodule DiacriticalSchema.Account.Token do
  @moduledoc "Defines an `Ecto.Schema` schema and `Ecto.Changeset` changeset."
  @moduledoc since: "0.15.0"

  use DiacriticalSchema

  import Ecto.Query

  alias Diacritical
  alias DiacriticalSchema

  alias Diacritical.Repo
  alias DiacriticalSchema.Account
  alias DiacriticalSchema.Changeset

  @typedoc "Represents the token data."
  @typedoc since: "0.16.0"
  @type token_data() :: DiacriticalSchema.token_data()

  @typedoc "Represents the token type."
  @typedoc since: "0.16.0"
  @type token_type() :: DiacriticalSchema.token_type()

  @typedoc "Represents the changeset."
  @typedoc since: "0.15.0"
  @type changeset() :: Changeset.t(t())

  @typedoc "Represents the data."
  @typedoc since: "0.15.0"
  @type data() :: Changeset.data(changeset(), t())

  @typedoc "Represents the parameter."
  @typedoc since: "0.15.0"
  @type param() :: Changeset.param()

  @typedoc "Represents the schema."
  @typedoc since: "0.15.0"
  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          account: nil | Ecto.Association.NotLoaded.t() | Account.t(),
          account_id: nil | Ecto.UUID.t(),
          data: nil | token_data(),
          id: nil | Ecto.UUID.t(),
          inserted_at: nil | DateTime.t(),
          sent_to: nil | String.t(),
          type: nil | token_type()
        }

  @typedoc "Represents the potential query expression."
  @typedoc since: "0.15.0"
  @type maybe_expr() :: DiacriticalSchema.maybe_expr()

  @typedoc "Represents the queryable."
  @typedoc since: "0.15.0"
  @type queryable() :: DiacriticalSchema.queryable()

  @typedoc "Represents the query argument."
  @typedoc since: "0.15.0"
  @type arg() :: DiacriticalSchema.arg()

  @assoc [:account]

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
  @doc since: "0.14.0"
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

  @spec build_filter(maybe_expr(), queryable()) :: queryable()
  defp build_filter({:where_data_type, {data, type}}, queryable)
       when is_binary(data) and is_binary(type) and
              (queryable == __MODULE__ or is_struct(queryable, Ecto.Query)) do
    where(queryable, data: ^data, type: ^type)
  end

  defp build_filter(_maybe_expr, queryable)
       when queryable == __MODULE__ or is_struct(queryable, Ecto.Query) do
    queryable
  end

  @spec build_query(maybe_expr(), queryable()) :: queryable()
  defp build_query({:filter, arg}, queryable)
       when (is_list(arg) or is_map(arg)) and
              (queryable == __MODULE__ or is_struct(queryable, Ecto.Query)) do
    Enum.reduce(arg, queryable, &build_filter/2)
  end

  defp build_query({:select, target}, queryable)
       when target in @assoc and
              (queryable == __MODULE__ or is_struct(queryable, Ecto.Query)) do
    queryable
    |> select([_q0, q1], q1)
    |> join(:inner, [q0], assoc(q0, ^target))
    |> where([_q0, q1], is_nil(q1.deleted_at))
  end

  defp build_query(_maybe_expr, queryable)
       when queryable == __MODULE__ or is_struct(queryable, Ecto.Query) do
    queryable
  end

  @spec do_query(queryable(), arg()) :: queryable()
  defp do_query(queryable, arg)
       when (queryable == __MODULE__ or is_struct(queryable, Ecto.Query)) and
              (is_list(arg) or is_map(arg)) do
    Enum.reduce(arg, DiacriticalSchema.query(queryable, arg), &build_query/2)
  end

  @doc """
  Creates an `Ecto.Query` query from the given `queryable` with the given `arg`.

  ## Examples

      iex> %{arg: %{filter: %{where_data_type: %{valid: arg}}}} = c_arg(%{})
      iex>
      iex> %Ecto.Query{wheres: [%{}]} = query(Token, arg)

      iex> %{arg: %{select: %{valid: arg}}} = c_arg(%{})
      iex>
      iex> %Ecto.Query{select: %{}} = query(Token, arg)

  """
  @doc since: "0.15.0"
  @spec query(queryable(), arg()) :: queryable()
  def query(__MODULE__ = queryable, arg) when is_list(arg) or is_map(arg) do
    do_query(queryable, arg)
  end

  def query(
        %Ecto.Query{from: %{source: {_source, __MODULE__}}} = queryable,
        arg
      )
      when is_list(arg) or is_map(arg) do
    do_query(queryable, arg)
  end
end
