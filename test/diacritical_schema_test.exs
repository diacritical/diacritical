defmodule DiacriticalSchemaTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.9.0"

  use ExUnit.Case, async: true

  alias DiacriticalSchema

  alias DiacriticalSchema.TestSchema

  @typedoc "Represents the context."
  @typedoc since: "0.15.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.15.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_arg(context()) :: context_merge()
  defp c_arg(c) when is_map(c) do
    %{
      arg: %{
        empty: %{},
        filter: %{
          empty: %{filter: %{}},
          unknown: %{filter: [:unknown]},
          where_inserted_at: %{
            invalid: %{filter: %{where_inserted_at: {nil, "unknown"}}},
            valid: %{filter: %{where_inserted_at: {1, "day"}}}
          },
          where_nil: %{
            invalid: %{filter: %{where_nil: :field}},
            valid: %{filter: %{where_nil: :deleted_at}}
          }
        },
        invalid: {},
        limit: %{invalid: %{limit: -1}, valid: %{limit: 1}},
        offset: %{invalid: %{offset: -1}, valid: %{offset: 0}},
        order_by: %{
          field: %{
            invalid: %{order_by: :field},
            valid: %{order_by: :inserted_at}
          },
          list: %{
            invalid: %{order_by: %{}},
            valid: %{order_by: [asc: :inserted_at]}
          },
          random: %{
            invalid: %{order_by: "random"},
            valid: %{order_by: :random}
          }
        },
        unknown: [:unknown]
      }
    }
  end

  doctest DiacriticalSchema, import: true

  describe "query/2 when is_atom(queryable)" do
    import DiacriticalSchema, only: [query: 2]

    setup :c_arg
    setup do: %{module: %{invalid: "TestSchema", valid: TestSchema}}

    test "FunctionClauseError (&1)", %{
      arg: %{empty: arg},
      module: %{invalid: module}
    } do
      assert_raise FunctionClauseError, fn -> query(module, arg) end
    end

    test "FunctionClauseError (&2)", %{
      arg: %{invalid: arg},
      module: %{valid: module}
    } do
      assert_raise FunctionClauseError, fn -> query(module, arg) end
    end

    test "empty", %{arg: %{empty: arg}, module: %{valid: module}} do
      assert query(module, arg) == module
    end

    test "unknown", %{arg: %{unknown: arg}, module: %{valid: module}} do
      assert query(module, arg) == module
    end

    test "filter (empty)", %{
      arg: %{filter: %{empty: arg}},
      module: %{valid: module}
    } do
      assert query(module, arg) == module
    end

    test "filter (unknown)", %{
      arg: %{filter: %{unknown: arg}},
      module: %{valid: module}
    } do
      assert query(module, arg) == module
    end

    test "filter = {:where_inserted_at, maybe_expr}", %{
      arg: %{filter: %{where_inserted_at: %{invalid: arg, valid: arg!}}},
      module: %{valid: module}
    } do
      assert query(module, arg) == module
      assert %Ecto.Query{wheres: [%{}]} = query(module, arg!)
    end

    test "filter = {:where_nil, maybe_expr}", %{
      arg: %{filter: %{where_nil: %{invalid: arg, valid: arg!}}},
      module: %{valid: module}
    } do
      assert query(module, arg) == module
      assert %Ecto.Query{wheres: [%{}]} = query(module, arg!)
    end

    test "limit", %{
      arg: %{limit: %{invalid: arg, valid: arg!}},
      module: %{valid: module}
    } do
      assert query(module, arg) == module
      assert %Ecto.Query{limit: %{}} = query(module, arg!)
    end

    test "offset", %{
      arg: %{offset: %{invalid: arg, valid: arg!}},
      module: %{valid: module}
    } do
      assert query(module, arg) == module
      assert %Ecto.Query{offset: %{}} = query(module, arg!)
    end

    test "order_by = :random", %{
      arg: %{order_by: %{random: %{invalid: arg, valid: arg!}}},
      module: %{valid: module}
    } do
      assert query(module, arg) == module
      assert %Ecto.Query{order_bys: [%{}]} = query(module, arg!)
    end

    test "order_by in @field", %{
      arg: %{order_by: %{field: %{invalid: arg, valid: arg!}}},
      module: %{valid: module}
    } do
      assert query(module, arg) == module
      assert %Ecto.Query{order_bys: [%{}]} = query(module, arg!)
    end

    test "is_list(order_by)", %{
      arg: %{order_by: %{list: %{invalid: arg, valid: arg!}}},
      module: %{valid: module}
    } do
      assert query(module, arg) == module
      assert %Ecto.Query{order_bys: [%{}]} = query(module, arg!)
    end
  end

  describe "query/2 when %Ecto.Query{} = queryable" do
    import DiacriticalSchema, only: [query: 2]

    setup :c_arg

    setup do
      %{
        query: %{
          invalid: %{},
          valid: %Ecto.Query{
            from: %Ecto.Query.FromExpr{
              source: {TestSchema.__schema__(:source), TestSchema}
            }
          }
        }
      }
    end

    test "FunctionClauseError (&1)", %{
      arg: %{empty: arg},
      query: %{invalid: query}
    } do
      assert_raise FunctionClauseError, fn -> query(query, arg) end
    end

    test "FunctionClauseError (&2)", %{
      arg: %{invalid: arg},
      query: %{valid: query}
    } do
      assert_raise FunctionClauseError, fn -> query(query, arg) end
    end

    test "empty", %{arg: %{empty: arg}, query: %{valid: query}} do
      assert query(query, arg) == query
    end

    test "unknown", %{arg: %{unknown: arg}, query: %{valid: query}} do
      assert query(query, arg) == query
    end

    test "filter (empty)", %{
      arg: %{filter: %{empty: arg}},
      query: %{valid: query}
    } do
      assert query(query, arg) == query
    end

    test "filter (unknown)", %{
      arg: %{filter: %{unknown: arg}},
      query: %{valid: query}
    } do
      assert query(query, arg) == query
    end

    test "filter = {:where_inserted_at, maybe_expr}", %{
      arg: %{filter: %{where_inserted_at: %{invalid: arg, valid: arg!}}},
      query: %{valid: query}
    } do
      assert query(query, arg) == query
      assert %Ecto.Query{wheres: [%{}]} = query(query, arg!)
    end

    test "filter = {:where_nil, maybe_expr}", %{
      arg: %{filter: %{where_nil: %{invalid: arg, valid: arg!}}},
      query: %{valid: query}
    } do
      assert query(query, arg) == query
      assert %Ecto.Query{wheres: [%{}]} = query(query, arg!)
    end

    test "limit", %{
      arg: %{limit: %{invalid: arg, valid: arg!}},
      query: %{valid: query}
    } do
      assert query(query, arg) == query
      assert %Ecto.Query{limit: %{}} = query(query, arg!)
    end

    test "offset", %{
      arg: %{offset: %{invalid: arg, valid: arg!}},
      query: %{valid: query}
    } do
      assert query(query, arg) == query
      assert %Ecto.Query{offset: %{}} = query(query, arg!)
    end

    test "order_by = :random", %{
      arg: %{order_by: %{random: %{invalid: arg, valid: arg!}}},
      query: %{valid: query}
    } do
      assert query(query, arg) == query
      assert %Ecto.Query{order_bys: [%{}]} = query(query, arg!)
    end

    test "order_by in @field", %{
      arg: %{order_by: %{field: %{invalid: arg, valid: arg!}}},
      query: %{valid: query}
    } do
      assert query(query, arg) == query
      assert %Ecto.Query{order_bys: [%{}]} = query(query, arg!)
    end

    test "is_list(order_by)", %{
      arg: %{order_by: %{list: %{invalid: arg, valid: arg!}}},
      query: %{valid: query}
    } do
      assert query(query, arg) == query
      assert %Ecto.Query{order_bys: [%{}]} = query(query, arg!)
    end
  end
end
