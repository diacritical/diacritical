defmodule DiacriticalSchema.AccountTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.14.0"

  use DiacriticalCase.Repo, async: true

  alias DiacriticalCase
  alias DiacriticalSchema

  alias DiacriticalSchema.Account
  alias DiacriticalSchema.TestSchema

  alias Account.Token

  @typedoc "Represents the context."
  @typedoc since: "0.14.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.14.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_struct(context()) :: context_merge()
  defp c_struct(c) when is_map(c) do
    %{
      struct: %{
        invalid: %{},
        valid: %{
          __meta__: %Ecto.Schema.Metadata{
            schema: Account,
            source: "account",
            state: :built
          },
          __struct__: Account,
          confirmed_at: nil,
          deleted_at: nil,
          email: nil,
          id: nil,
          inserted_at: nil,
          password: nil,
          password_digest: nil,
          token: %Ecto.Association.NotLoaded{
            __cardinality__: :many,
            __field__: :token,
            __owner__: Account
          },
          updated_at: nil
        }
      }
    }
  end

  @spec c_assoc(context()) :: context_merge()
  defp c_assoc(c) when is_map(c) do
    %{
      assoc: %{
        token: %Ecto.Association.Has{
          cardinality: :many,
          field: :token,
          on_delete: :nothing,
          on_replace: :raise,
          owner: Account,
          owner_key: :id,
          queryable: Token,
          related: Token,
          related_key: :account_id
        }
      }
    }
  end

  @spec c_param_account(context()) :: context_merge()
  defp c_param_account(c) when is_map(c) do
    email = "jdoe@example.com"
    password = "correct horse battery staple"

    %{
      param: %{
        atom: %{email: email, password: password},
        err: %{email: "jdoeexample.com", password: "hunter2"},
        invalid: [],
        string: %{"email" => email, "password" => password}
      }
    }
  end

  @spec c_arg(context()) :: context_merge()
  defp c_arg(c) when is_map(c) do
    search = "%jdoe%"

    %{
      arg: %{
        empty: %{},
        filter: %{
          empty: %{filter: %{}},
          matching: %{
            invalid: %{filter: %{matching: ~c"#{search}"}},
            valid: %{filter: %{matching: search}}
          },
          unknown: %{filter: [:unknown]}
        },
        invalid: {},
        unknown: [:unknown]
      }
    }
  end

  doctest Account, import: true

  describe "__struct__/0" do
    import Account, only: [__struct__: 0]

    setup :c_struct

    test "success", %{struct: %{valid: struct}} do
      assert __struct__() == struct
    end
  end

  describe "__struct__/1" do
    import Account, only: [__struct__: 1]

    setup :c_struct

    test "success", %{struct: %{valid: struct}} do
      assert __struct__(%{}) == struct
    end
  end

  describe "__changeset__/0" do
    import Account, only: [__changeset__: 0]

    setup :c_assoc

    test "success", %{assoc: %{token: token}} do
      assert __changeset__() == %{
               confirmed_at: :utc_datetime_usec,
               deleted_at: :utc_datetime_usec,
               email: :string,
               id: Ecto.UUID,
               inserted_at: :utc_datetime_usec,
               password: :string,
               password_digest: :string,
               token: {:assoc, token},
               updated_at: :utc_datetime_usec
             }
    end
  end

  describe "__schema__/1" do
    import Account, only: [__schema__: 1]

    test ":prefix" do
      assert __schema__(:prefix) == nil
    end

    test ":source" do
      assert __schema__(:source) == "account"
    end

    test ":fields" do
      assert __schema__(:fields) == [
               :id,
               :email,
               :password_digest,
               :confirmed_at,
               :inserted_at,
               :updated_at,
               :deleted_at
             ]
    end

    test ":query_fields" do
      assert __schema__(:query_fields) == [
               :id,
               :email,
               :password_digest,
               :confirmed_at,
               :inserted_at,
               :updated_at,
               :deleted_at
             ]
    end

    test ":primary_key" do
      assert __schema__(:primary_key) == [:id]
    end

    test ":hash" do
      assert __schema__(:hash) == 14_510_005
    end

    test ":read_after_writes" do
      assert __schema__(:read_after_writes) == ~W[id inserted_at updated_at]a
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
      assert __schema__(:loaded) == Ecto.put_meta(%Account{}, state: :loaded)
    end

    test ":redact_fields" do
      assert __schema__(:redact_fields) == [:password_digest, :password]
    end

    test ":virtual_fields" do
      assert __schema__(:virtual_fields) == [:password]
    end

    test ":autogenerate_fields" do
      assert __schema__(:autogenerate_fields) == []
    end

    test ":query" do
      assert __schema__(:query) == %Ecto.Query{
               from: %Ecto.Query.FromExpr{source: {"account", Account}}
             }
    end

    test ":dump" do
      assert __schema__(:dump) == %{
               confirmed_at: {:confirmed_at, :utc_datetime_usec, :always},
               deleted_at: {:deleted_at, :utc_datetime_usec, :always},
               email: {:email, :string, :always},
               id: {:id, Ecto.UUID, :always},
               inserted_at: {:inserted_at, :utc_datetime_usec, :always},
               password_digest: {:password_digest, :string, :always},
               updated_at: {:updated_at, :utc_datetime_usec, :always}
             }
    end

    test ":load" do
      assert __schema__(:load) == [
               id: Ecto.UUID,
               email: :string,
               password_digest: :string,
               confirmed_at: :utc_datetime_usec,
               inserted_at: :utc_datetime_usec,
               updated_at: :utc_datetime_usec,
               deleted_at: :utc_datetime_usec
             ]
    end

    test ":associations" do
      assert __schema__(:associations) == [:token]
    end

    test ":embeds" do
      assert __schema__(:embeds) == []
    end
  end

  describe "__schema__/2" do
    import Account, only: [__schema__: 2]

    setup :c_assoc

    test ":field_source, field" do
      assert __schema__(:field_source, :id) == :id
      assert __schema__(:field_source, :email) == :email
      assert __schema__(:field_source, :password) == nil
      assert __schema__(:field_source, :password_digest) == :password_digest
      assert __schema__(:field_source, :confirmed_at) == :confirmed_at
      assert __schema__(:field_source, :inserted_at) == :inserted_at
      assert __schema__(:field_source, :updated_at) == :updated_at
      assert __schema__(:field_source, :deleted_at) == :deleted_at
    end

    test ":type, field" do
      assert __schema__(:type, :id) == Ecto.UUID
      assert __schema__(:type, :email) == :string
      assert __schema__(:type, :password) == nil
      assert __schema__(:type, :password_digest) == :string
      assert __schema__(:type, :confirmed_at) == :utc_datetime_usec
      assert __schema__(:type, :inserted_at) == :utc_datetime_usec
      assert __schema__(:type, :updated_at) == :utc_datetime_usec
      assert __schema__(:type, :deleted_at) == :utc_datetime_usec
    end

    test ":virtual_type, field" do
      assert __schema__(:virtual_type, :password) == :string
    end

    test ":association, assoc", %{assoc: %{token: token}} do
      assert __schema__(:association, :token) == token
    end

    test ":embed, embed" do
      assert __schema__(:embed, :field) == nil
    end
  end

  describe "changeset/1" do
    import Account, only: [changeset: 1]

    setup [:checkout_repo, :c_param_account]

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

  describe "changeset/2 when %Account{} = data" do
    import Account, only: [changeset: 2]

    setup ~W[checkout_repo c_struct c_param_account]a

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

  describe "changeset/2 when %Ecto.Changeset{data: %Account{}} = data" do
    import Account, only: [changeset: 2]

    setup ~W[checkout_repo c_struct c_param_account]a

    setup %{struct: %{invalid: struct, valid: struct!}} do
      %{
        changeset: %{
          invalid: %Ecto.Changeset{data: struct},
          valid: %Ecto.Changeset{
            data: struct!,
            types: Account.__changeset__(),
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

  describe "query/2 when Account = queryable" do
    import Account, only: [query: 2]

    setup :c_arg
    setup do: %{module: %{invalid: TestSchema, valid: Account}}

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

    test "filter = {:matching, maybe_expr}", %{
      arg: %{filter: %{matching: %{invalid: arg, valid: arg!}}},
      module: %{valid: module}
    } do
      assert query(module, arg) == module
      assert %Ecto.Query{wheres: [%{}]} = query(module, arg!)
    end
  end

  describe "query/2 when %Ecto.Query{from: %{...}} = queryable" do
    import Account, only: [query: 2]

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
              source: {Account.__schema__(:source), Account}
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

    test "filter = {:matching, maybe_expr}", %{
      arg: %{filter: %{matching: %{invalid: arg, valid: arg!}}},
      query: %{valid: query}
    } do
      assert query(query, arg) == query
      assert %Ecto.Query{wheres: [%{}]} = query(query, arg!)
    end
  end
end
