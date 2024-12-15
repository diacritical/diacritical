defmodule DiacriticalSchema.Account do
  @moduledoc "Defines an `Ecto.Schema` schema and `Ecto.Changeset` changeset."
  @moduledoc since: "0.14.0"

  use DiacriticalSchema

  import Ecto.Query

  alias Diacritical
  alias DiacriticalSchema

  alias Diacritical.Repo
  alias DiacriticalSchema.Changeset

  alias DiacriticalSchema.Account.Token

  @typedoc "Represents the email address."
  @typedoc since: "0.16.0"
  @type email() :: DiacriticalSchema.email()

  @typedoc "Represents the password."
  @typedoc since: "0.16.0"
  @type password() :: DiacriticalSchema.password()

  @typedoc "Represents the potential password."
  @typedoc since: "0.16.0"
  @type maybe_password() :: nil | password()

  @typedoc "Represents the schema."
  @typedoc since: "0.14.0"
  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          confirmed_at: nil | DateTime.t(),
          deleted_at: nil | DateTime.t(),
          email: nil | email(),
          id: nil | Ecto.UUID.t(),
          inserted_at: nil | DateTime.t(),
          password: maybe_password(),
          password_digest: nil | String.t(),
          token: nil | Ecto.Association.NotLoaded.t() | Token.t(),
          updated_at: nil | DateTime.t()
        }

  @typedoc "Represents the changeset."
  @typedoc since: "0.14.0"
  @type changeset() :: Changeset.t(t())

  @typedoc "Represents the data."
  @typedoc since: "0.14.0"
  @type data() :: Changeset.data(changeset(), t())

  @typedoc "Represents the parameter."
  @typedoc since: "0.14.0"
  @type param() :: Changeset.param()

  @typedoc "Represents the parameter key."
  @typedoc since: "0.14.0"
  @type key() :: Changeset.key()

  @typedoc "Represents the potential schema."
  @typedoc since: "0.16.0"
  @type maybe_schema() :: nil | t()

  @typedoc "Represents the potential query expression."
  @typedoc since: "0.15.0"
  @type maybe_expr() :: DiacriticalSchema.maybe_expr()

  @typedoc "Represents the queryable."
  @typedoc since: "0.15.0"
  @type queryable() :: DiacriticalSchema.queryable()

  @typedoc "Represents the query argument."
  @typedoc since: "0.15.0"
  @type arg() :: DiacriticalSchema.arg()

  schema "account" do
    field :email, :string
    field :password, :string, redact: true, virtual: true
    field :password_digest, :string, redact: true
    has_many :token, Token
    field :confirmed_at, :utc_datetime_usec
    field :inserted_at, :utc_datetime_usec, read_after_writes: true
    field :updated_at, :utc_datetime_usec, read_after_writes: true
    field :deleted_at, :utc_datetime_usec
  end

  @spec do_digest(data(), param(), key()) :: changeset()
  defp do_digest(data, param, key)
       when (is_struct(data, __MODULE__) or is_struct(data, Ecto.Changeset)) and
              is_map(param) and (is_atom(key) or is_binary(key)) do
    field = [:password]

    data
    |> Ecto.Changeset.cast(param, field)
    |> Ecto.Changeset.validate_required(field)
    |> Changeset.validate_password()
    |> Changeset.put_digest()
    |> changeset(Map.delete(param, key))
  end

  @spec do_changeset(data(), param()) :: changeset()
  defp do_changeset(data, param)
       when (is_struct(data, __MODULE__) or is_struct(data, Ecto.Changeset)) and
              is_map_key(param, :password) do
    do_digest(data, param, :password)
  end

  defp do_changeset(data, param)
       when (is_struct(data, __MODULE__) or is_struct(data, Ecto.Changeset)) and
              is_map_key(param, "password") do
    do_digest(data, param, "password")
  end

  defp do_changeset(data, param)
       when (is_struct(data, __MODULE__) or is_struct(data, Ecto.Changeset)) and
              is_map(param) do
    required = [:email, :password_digest]
    permitted = [:confirmed_at, :deleted_at] ++ required

    data
    |> Ecto.Changeset.cast(param, permitted)
    |> Ecto.Changeset.validate_required(required)
    |> Changeset.validate_email()
    |> Changeset.validate_argon2()
    |> Ecto.Changeset.unsafe_validate_unique(:email, Repo)
    |> Ecto.Changeset.unique_constraint(:email)
  end

  @doc """
  Applies the given `param` as a validated changeset for the given `data`.

  ## Examples

      iex> checkout_repo()
      iex> c = c_password()
      iex> %{param: %{err: param}} = c_param_account(c)
      iex>
      iex> %Ecto.Changeset{valid?: false} = changeset(param)

      iex> checkout_repo()
      iex> c = c_password()
      iex> %{param: %{atom: param}} = c_param_account(c)
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
  defp build_filter({:matching, maybe_expr}, queryable)
       when is_binary(maybe_expr) and
              (queryable == __MODULE__ or is_struct(queryable, Ecto.Query)) do
    where(queryable, [q], ilike(q.email, ^maybe_expr))
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

      iex> %{arg: %{filter: %{matching: %{valid: arg}}}} = c_arg(%{})
      iex>
      iex> %Ecto.Query{wheres: [%{}]} = query(Account, arg)

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

  @doc """
  Verifies the given `password` for the given `schema`.

  If a `schema` or a `password` is not given, a call will be made to
  `Argon2.no_user_verify()` to help circumvent timing attacks.

  ## Examples

      iex> %{password: %{incorrect: password}} = c = c_password()
      iex> %{account: %{built: schema}} = c_account(c)
      iex>
      iex> valid_password?(schema, password)
      false

      iex> %{password: %{correct: password}} = c = c_password()
      iex> %{account: %{built: schema}} = c_account(c)
      iex>
      iex> valid_password?(schema, password)
      true

  """
  @doc since: "0.16.0"
  @spec valid_password?(maybe_schema(), maybe_password) :: boolean()
  def valid_password?(%__MODULE__{password_digest: password_digest}, password)
      when is_binary(password_digest) and is_binary(password) do
    Argon2.verify_pass(password, password_digest)
  end

  def valid_password?(maybe_schema, maybe_password)
      when is_nil(maybe_schema) or
             (is_struct(maybe_schema, __MODULE__) and is_nil(maybe_password)) do
    Argon2.no_user_verify()
  end
end
