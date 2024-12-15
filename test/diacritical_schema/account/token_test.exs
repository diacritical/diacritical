defmodule DiacriticalSchema.Account.TokenTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.15.0"

  use DiacriticalCase.Repo, async: true

  alias DiacriticalCase
  alias DiacriticalSchema

  alias DiacriticalSchema.Account
  alias DiacriticalSchema.TestSchema

  alias Account.Token

  @typedoc "Represents the context."
  @typedoc since: "0.15.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.15.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_struct(context()) :: context_merge()
  defp c_struct(c) when is_map(c) do
    %{
      struct: %{
        invalid: %{},
        valid: %{
          __meta__: %Ecto.Schema.Metadata{
            schema: Token,
            source: "account_token",
            state: :built
          },
          __struct__: Token,
          account: %Ecto.Association.NotLoaded{
            __cardinality__: :one,
            __field__: :account,
            __owner__: Token
          },
          account_id: nil,
          data: nil,
          id: nil,
          inserted_at: nil,
          sent_to: nil,
          type: nil
        }
      }
    }
  end

  @spec c_assoc(context()) :: context_merge()
  defp c_assoc(c) when is_map(c) do
    %{
      assoc: %{
        account: %Ecto.Association.BelongsTo{
          field: :account,
          on_replace: :raise,
          owner: Token,
          owner_key: :account_id,
          queryable: Account,
          related: Account,
          related_key: :id
        }
      }
    }
  end

  @spec c_param_token(context()) :: context_merge()
  defp c_param_token(c) when is_map(c) do
    account_id = Ecto.UUID.generate()
    data = :crypto.strong_rand_bytes(32)
    sent_to = "jdoe@example.com"
    type = "unknown"

    %{
      param: %{
        atom: %{
          account_id: account_id,
          data: data,
          sent_to: sent_to,
          type: type
        },
        err: %{account_id: "", data: "", sent_to: "jdoeexample.com", type: ""},
        invalid: [],
        string: %{
          "account_id" => account_id,
          "data" => data,
          "sent_to" => sent_to,
          "type" => type
        }
      }
    }
  end

  @spec c_arg(context()) :: context_merge()
  defp c_arg(c) when is_map(c) do
    type = "unknown"

    %{
      arg: %{
        empty: %{},
        filter: %{
          empty: %{filter: %{}},
          unknown: %{filter: [:unknown]},
          where_data_type: %{
            invalid: %{filter: %{where_data_type: {nil, ~c"#{type}"}}},
            valid: %{
              filter: %{where_data_type: {:crypto.strong_rand_bytes(32), type}}
            }
          }
        },
        invalid: {},
        select: %{invalid: %{select: :test_schema}, valid: %{select: :account}},
        unknown: [:unknown]
      }
    }
  end

  doctest Token, import: true

  describe "__struct__/0" do
    import Token, only: [__struct__: 0]

    setup :c_struct

    test "success", %{struct: %{valid: struct}} do
      assert __struct__() == struct
    end
  end

  describe "__struct__/1" do
    import Token, only: [__struct__: 1]

    setup :c_struct

    test "success", %{struct: %{valid: struct}} do
      assert __struct__(%{}) == struct
    end
  end

  describe "__changeset__/0" do
    import Token, only: [__changeset__: 0]

    setup :c_assoc

    test "success", %{assoc: %{account: account}} do
      assert __changeset__() == %{
               account: {:assoc, account},
               account_id: Ecto.UUID,
               data: :binary,
               id: Ecto.UUID,
               inserted_at: :utc_datetime_usec,
               sent_to: :string,
               type: :string
             }
    end
  end

  describe "__schema__/1" do
    import Token, only: [__schema__: 1]

    test ":prefix" do
      assert __schema__(:prefix) == nil
    end

    test ":source" do
      assert __schema__(:source) == "account_token"
    end

    test ":fields" do
      assert __schema__(:fields) == [
               :id,
               :data,
               :type,
               :sent_to,
               :account_id,
               :inserted_at
             ]
    end

    test ":query_fields" do
      assert __schema__(:query_fields) == [
               :id,
               :data,
               :type,
               :sent_to,
               :account_id,
               :inserted_at
             ]
    end

    test ":primary_key" do
      assert __schema__(:primary_key) == [:id]
    end

    test ":hash" do
      assert __schema__(:hash) == 91_048_560
    end

    test ":read_after_writes" do
      assert __schema__(:read_after_writes) == [:id, :inserted_at]
    end

    test ":autogenerate_id" do
      assert __schema__(:autogenerate_id) == nil
    end

    test ":autogenerate" do
      assert __schema__(:autogenerate) == []
    end

    test ":autoupdate" do
      assert __schema__(:autoupdate) == []
    end

    test ":loaded" do
      assert __schema__(:loaded) == Ecto.put_meta(%Token{}, state: :loaded)
    end

    test ":redact_fields" do
      assert __schema__(:redact_fields) == []
    end

    test ":virtual_fields" do
      assert __schema__(:virtual_fields) == []
    end

    test ":autogenerate_fields" do
      assert __schema__(:autogenerate_fields) == []
    end

    test ":query" do
      assert __schema__(:query) == %Ecto.Query{
               from: %Ecto.Query.FromExpr{source: {"account_token", Token}}
             }
    end

    test ":dump" do
      assert __schema__(:dump) == %{
               account_id: {:account_id, Ecto.UUID, :always},
               data: {:data, :binary, :always},
               id: {:id, Ecto.UUID, :always},
               inserted_at: {:inserted_at, :utc_datetime_usec, :always},
               sent_to: {:sent_to, :string, :always},
               type: {:type, :string, :always}
             }
    end

    test ":load" do
      assert __schema__(:load) == [
               id: Ecto.UUID,
               data: :binary,
               type: :string,
               sent_to: :string,
               account_id: Ecto.UUID,
               inserted_at: :utc_datetime_usec
             ]
    end

    test ":associations" do
      assert __schema__(:associations) == [:account]
    end

    test ":embeds" do
      assert __schema__(:embeds) == []
    end

    test ":updatable_fields" do
      assert __schema__(:updatable_fields) ==
               {~W[inserted_at account_id sent_to type data id]a, []}
    end

    test ":insertable_fields" do
      assert __schema__(:insertable_fields) ==
               {~W[inserted_at account_id sent_to type data id]a, []}
    end
  end

  describe "__schema__/2" do
    import Token, only: [__schema__: 2]

    setup :c_assoc

    test ":field_source, field" do
      assert __schema__(:field_source, :id) == :id
      assert __schema__(:field_source, :data) == :data
      assert __schema__(:field_source, :type) == :type
      assert __schema__(:field_source, :sent_to) == :sent_to
      assert __schema__(:field_source, :account_id) == :account_id
      assert __schema__(:field_source, :inserted_at) == :inserted_at
      assert __schema__(:field_source, :field) == nil
    end

    test ":type, field" do
      assert __schema__(:type, :id) == Ecto.UUID
      assert __schema__(:type, :data) == :binary
      assert __schema__(:type, :type) == :string
      assert __schema__(:type, :sent_to) == :string
      assert __schema__(:type, :account_id) == Ecto.UUID
      assert __schema__(:type, :inserted_at) == :utc_datetime_usec
      assert __schema__(:type, :field) == nil
    end

    test ":virtual_type, field" do
      assert __schema__(:virtual_type, :field) == nil
    end

    test ":association, assoc", %{assoc: %{account: account}} do
      assert __schema__(:association, :account) == account
      assert __schema__(:association, :field) == nil
    end

    test ":embed, embed" do
      assert __schema__(:embed, :field) == nil
    end
  end

  describe "changeset/1" do
    import Token, only: [changeset: 1]

    setup [:checkout_repo, :c_param_token]

    test "FunctionClauseError", %{param: %{invalid: param}} do
      assert_raise FunctionClauseError, fn -> changeset(param) end
    end

    test "failure", %{param: %{err: param}} do
      refute changeset(param).valid?
    end

    test "atom", %{param: %{atom: param}} do
      assert changeset(param).valid?
    end

    test "string", %{param: %{string: param}} do
      assert changeset(param).valid?
    end
  end

  describe "changeset/2 when is_struct(data, Token)" do
    import Token, only: [changeset: 2]

    setup ~W[checkout_repo c_struct c_param_token]a

    test "FunctionClauseError (&1)", %{
      param: %{atom: param},
      struct: %{invalid: struct}
    } do
      assert_raise FunctionClauseError, fn -> changeset(struct, param) end
    end

    test "FunctionClauseError (&2)", %{
      param: %{invalid: param},
      struct: %{valid: struct}
    } do
      assert_raise FunctionClauseError, fn -> changeset(struct, param) end
    end

    test "failure", %{param: %{err: param}, struct: %{valid: struct}} do
      refute changeset(struct, param).valid?
    end

    test "atom", %{param: %{atom: param}, struct: %{valid: struct}} do
      assert changeset(struct, param).valid?
    end

    test "string", %{param: %{string: param}, struct: %{valid: struct}} do
      assert changeset(struct, param).valid?
    end
  end

  describe "changeset/2 when is_struct(data, Ecto.Changeset)" do
    import Token, only: [changeset: 2]

    setup ~W[checkout_repo c_struct c_param_token]a

    setup %{struct: %{invalid: struct, valid: struct!}} do
      %{
        changeset: %{
          invalid: %Ecto.Changeset{data: struct},
          valid: %Ecto.Changeset{
            data: struct!,
            types: Token.__changeset__(),
            valid?: true
          }
        }
      }
    end

    test "FunctionClauseError (&1)", %{
      changeset: %{invalid: changeset},
      param: %{atom: param}
    } do
      assert_raise FunctionClauseError, fn -> changeset(changeset, param) end
    end

    test "FunctionClauseError (&2)", %{
      changeset: %{valid: changeset},
      param: %{invalid: param}
    } do
      assert_raise FunctionClauseError, fn -> changeset(changeset, param) end
    end

    test "failure", %{changeset: %{valid: changeset}, param: %{err: param}} do
      refute changeset(changeset, param).valid?
    end

    test "atom", %{changeset: %{valid: changeset}, param: %{atom: param}} do
      assert changeset(changeset, param).valid?
    end

    test "string", %{changeset: %{valid: changeset}, param: %{string: param}} do
      assert changeset(changeset, param).valid?
    end
  end

  describe "query/2 when is_atom(queryable)" do
    import Token, only: [query: 2]

    setup :c_arg
    setup do: %{module: %{invalid: TestSchema, valid: Token}}

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

    test "filter (:where_data_type)", %{
      arg: %{filter: %{where_data_type: %{invalid: arg, valid: arg!}}},
      module: %{valid: module}
    } do
      assert query(module, arg) == module
      assert %Ecto.Query{wheres: [%{}]} = query(module, arg!)
    end

    test "select", %{
      arg: %{select: %{invalid: arg, valid: arg!}},
      module: %{valid: module}
    } do
      assert query(module, arg) == module
      assert %Ecto.Query{select: %{}} = query(module, arg!)
    end
  end

  describe "query/2 when is_struct(queryable, Ecto.Query)" do
    import Token, only: [query: 2]

    setup :c_arg

    setup do
      %{
        query: %{
          invalid: %Ecto.Query{
            from: %Ecto.Query.FromExpr{
              source: {TestSchema.__schema__(:source), TestSchema}
            }
          },
          valid: %Ecto.Query{
            from: %Ecto.Query.FromExpr{
              source: {Token.__schema__(:source), Token}
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

    test "filter (:where_data_type)", %{
      arg: %{filter: %{where_data_type: %{invalid: arg, valid: arg!}}},
      query: %{valid: query}
    } do
      assert query(query, arg) == query
      assert %Ecto.Query{wheres: [%{}]} = query(query, arg!)
    end

    test "select", %{
      arg: %{select: %{invalid: arg, valid: arg!}},
      query: %{valid: query}
    } do
      assert query(query, arg) == query
      assert %Ecto.Query{select: %{}} = query(query, arg!)
    end
  end
end
