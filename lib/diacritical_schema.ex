defmodule DiacriticalSchema do
  @moduledoc "Defines commonalities for `Ecto.Schema` schemata."
  @moduledoc since: "0.10.0"

  use Boundary, deps: [Argon2, Ecto], exports: {:all, except: [Changeset]}

  import Ecto.Query

  @typedoc "Represents the potential query expression."
  @typedoc since: "0.16.0"
  @type maybe_expr() :: {Keyword.key(), Keyword.value()} | term()

  @typedoc "Represents the queryable."
  @typedoc since: "0.16.0"
  @type queryable() :: Ecto.Queryable.t()

  @typedoc "Represents the query argument."
  @typedoc since: "0.16.0"
  @type arg() :: Enum.t()

  @typedoc "Represents the email address."
  @typedoc since: "0.17.0"
  @type email() :: String.t()

  @typedoc "Represents the password."
  @typedoc since: "0.17.0"
  @type password() :: String.t()

  @typedoc "Represents the schema."
  @typedoc since: "0.15.0"
  @type t() :: Ecto.Schema.t()

  @typedoc "Represents the token data."
  @typedoc since: "0.17.0"
  @type token_data() :: binary()

  @typedoc "Represents the token type."
  @typedoc since: "0.17.0"
  @type token_type() :: String.t()

  @field [
    :account_id,
    :confirmed_at,
    :data,
    :deleted_at,
    :description,
    :email,
    :id,
    :inserted_at,
    :key,
    :parent_id,
    :password_digest,
    :sent_to,
    :type,
    :updated_at,
    :value,
    :x
  ]

  @interval [
    "day",
    "hour",
    "microsecond",
    "millisecond",
    "minute",
    "month",
    "second",
    "week",
    "year"
  ]

  @doc """
  In `use`, calls `use Ecto.Schema`, then redefines select module attributes.

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
  @doc since: "0.10.0"
  defmacro __using__(opt) when is_list(opt) do
    quote do
      use Ecto.Schema, unquote(opt)

      @primary_key {:id, Ecto.UUID, read_after_writes: true}
      @foreign_key_type elem(@primary_key, 1)
    end
  end

  @spec build_filter(maybe_expr(), queryable()) :: queryable()
  defp build_filter({:where_inserted_at, {count, interval}}, queryable)
       when is_integer(count) and interval in @interval and
              (is_atom(queryable) or is_struct(queryable)) do
    where(queryable, [q], q.inserted_at > ago(^count, ^interval))
  end

  defp build_filter({:where_nil, maybe_expr}, queryable)
       when maybe_expr in @field and
              (is_atom(queryable) or is_struct(queryable)) do
    where(queryable, [q], is_nil(field(q, ^maybe_expr)))
  end

  defp build_filter(_maybe_expr, queryable)
       when is_atom(queryable) or is_struct(queryable) do
    queryable
  end

  @spec build_query(maybe_expr(), queryable()) :: queryable()
  defp build_query({:filter, arg}, queryable)
       when (is_list(arg) or is_map(arg)) and
              (is_atom(queryable) or is_struct(queryable)) do
    Enum.reduce(arg, queryable, &build_filter/2)
  end

  defp build_query({:limit, maybe_expr}, queryable)
       when is_integer(maybe_expr) and maybe_expr >= 0 and
              (is_atom(queryable) or is_struct(queryable)) do
    limit(queryable, ^maybe_expr)
  end

  defp build_query({:offset, maybe_expr}, queryable)
       when is_integer(maybe_expr) and maybe_expr >= 0 and
              (is_atom(queryable) or is_struct(queryable)) do
    offset(queryable, ^maybe_expr)
  end

  defp build_query({:order_by, :random}, queryable)
       when is_atom(queryable) or is_struct(queryable) do
    order_by(queryable, fragment("random()"))
  end

  defp build_query({:order_by, maybe_expr}, queryable)
       when (maybe_expr in @field or is_list(maybe_expr)) and
              (is_atom(queryable) or is_struct(queryable)) do
    order_by(queryable, ^maybe_expr)
  end

  defp build_query(_maybe_expr, queryable)
       when is_atom(queryable) or is_struct(queryable) do
    queryable
  end

  @spec do_query(queryable(), arg()) :: queryable()
  defp do_query(queryable, arg)
       when (is_atom(queryable) or is_struct(queryable)) and
              (is_list(arg) or is_map(arg)) do
    Enum.reduce(arg, queryable, &build_query/2)
  end

  @doc """
  Creates an `Ecto` query from the given `queryable` with the given `arg`.

  ## Examples

      iex> %{arg: %{filter: %{where_inserted_at: %{valid: arg}}}} = c_arg(%{})
      iex>
      iex> %Ecto.Query{wheres: [%{}]} = query(TestSchema, arg)

      iex> %{arg: %{filter: %{where_nil: %{valid: arg}}}} = c_arg(%{})
      iex>
      iex> %Ecto.Query{wheres: [%{}]} = query(TestSchema, arg)

      iex> %{arg: %{limit: %{valid: arg}}} = c_arg(%{})
      iex>
      iex> %Ecto.Query{limit: %{}} = query(TestSchema, arg)

      iex> %{arg: %{offset: %{valid: arg}}} = c_arg(%{})
      iex>
      iex> %Ecto.Query{offset: %{}} = query(TestSchema, arg)

      iex> %{arg: %{order_by: %{random: %{valid: arg}}}} = c_arg(%{})
      iex>
      iex> %Ecto.Query{order_bys: [%{}]} = query(TestSchema, arg)

      iex> %{arg: %{order_by: %{field: %{valid: arg}}}} = c_arg(%{})
      iex>
      iex> %Ecto.Query{order_bys: [%{}]} = query(TestSchema, arg)

      iex> %{arg: %{order_by: %{list: %{valid: arg}}}} = c_arg(%{})
      iex>
      iex> %Ecto.Query{order_bys: [%{}]} = query(TestSchema, arg)

  """
  @doc since: "0.16.0"
  @spec query(queryable(), arg()) :: queryable()
  def query(queryable, arg)
      when is_atom(queryable) and (is_list(arg) or is_map(arg)) do
    do_query(queryable, arg)
  end

  def query(queryable, arg)
      when is_struct(queryable, Ecto.Query) and (is_list(arg) or is_map(arg)) do
    do_query(queryable, arg)
  end
end
