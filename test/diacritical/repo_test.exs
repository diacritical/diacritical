defmodule Diacritical.RepoTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.10.0"

  use DiacriticalCase.Repo, async: true

  alias Diacritical
  alias DiacriticalCase
  alias DiacriticalSchema

  alias Diacritical.Repo
  alias DiacriticalSchema.TestSchema

  @typedoc "Represents the context."
  @typedoc since: "0.10.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.10.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_init_arg(context()) :: context_merge()
  defp c_init_arg(c) when is_map(c), do: %{init_arg: []}

  @spec c_err(context()) :: context_merge()
  defp c_err(c) when is_map(c) do
    %{err: {:error, {:already_started, Process.whereis(Repo)}}}
  end

  @spec sleep_on_exit(context()) :: context_merge()
  defp sleep_on_exit(c) when is_map(c) do
    :ok = on_exit(fn -> :timer.sleep(250) end)
  end

  @spec c_conf(context()) :: context_merge()
  defp c_conf(c) when is_map(c), do: %{conf: :ok}

  @spec c_schema(context()) :: context_merge()
  defp c_schema(c \\ %{}) when is_map(c), do: %{schema: TestSchema}

  @spec c_fun_self(context()) :: context_merge()
  defp c_fun_self(c) when is_map(c) do
    %{fun: %{self: fn -> {:ok, self()} end}}
  end

  @spec c_conf_self(context()) :: context_merge()
  defp c_conf_self(c) when is_map(c) do
    %{conf: %{self: {:ok, self()}}}
  end

  @spec c_fun_repo(context()) :: context_merge()
  defp c_fun_repo(c) when is_map(c) do
    %{fun: %{repo: &{:ok, Process.whereis(&1)}}}
  end

  @spec c_conf_repo(context()) :: context_merge()
  defp c_conf_repo(c) when is_map(c) do
    %{conf: %{repo: {:ok, Process.whereis(Repo)}}}
  end

  @spec c_multi(context()) :: context_merge()
  defp c_multi(c) when is_map(c) do
    %{multi: %Ecto.Multi{}}
  end

  @spec c_conf_multi(context()) :: context_merge()
  defp c_conf_multi(c) when is_map(c) do
    %{conf: %{multi: {:ok, %{}}}}
  end

  @spec c_struct_built(context()) :: context_merge()
  defp c_struct_built(c \\ %{}) when is_map(c) do
    schema = Map.get(c, :schema, c_schema().schema)

    %{
      struct: %{
        built:
          schema
          |> struct(id: Ecto.UUID.generate(), x: 0)
          |> Ecto.put_meta(state: :loaded)
      }
    }
  end

  @spec c_changeset_built(context()) :: context_merge()
  defp c_changeset_built(c \\ %{}) when is_map(c) do
    struct =
      case c do
        %{struct: %{built: _value}} -> c.struct
        _value -> c_struct_built().struct
      end

    %{changeset: %{loaded: Ecto.Changeset.change(struct.built, %{})}}
  end

  @spec c_conf_loaded(context()) :: context_merge()
  defp c_conf_loaded(c) when is_map(c) do
    changeset =
      case c do
        %{changeset: %{loaded: _value}} -> c.changeset
        _value -> c_changeset_built().changeset
      end

    %{conf: %{loaded: Ecto.Changeset.apply_action(changeset.loaded, :insert)}}
  end

  @spec c_source(context()) :: context_merge()
  defp c_source(c \\ %{}) when is_map(c) do
    schema = Map.get(c, :schema, c_schema().schema)
    %{source: schema.__schema__(:source)}
  end

  @spec c_struct_loaded(context()) :: context_merge()
  defp c_struct_loaded(c \\ %{}) when is_map(c) do
    schema = Map.get(c, :schema, c_schema().schema)
    source = Map.get(c, :source, c_source(%{schema: schema}).source)
    sql = "SELECT * FROM #{source} LIMIT 1 OFFSET floor(random() * 1000)"
    %{columns: columns, rows: rows} = Repo.query!(sql)
    [loaded] = Enum.map(rows, &Repo.load(schema, {columns, &1}))
    %{struct: %{loaded: loaded}}
  end

  @spec c_changeset_updated(context()) :: context_merge()
  defp c_changeset_updated(c \\ %{}) when is_map(c) do
    struct =
      case c do
        %{struct: %{loaded: _value}} -> c.struct
        _value -> c_struct_loaded().struct
      end

    %{
      changeset:
        Map.merge(
          c[:changeset] || %{},
          %{
            updated:
              Ecto.Changeset.change(struct.loaded, %{x: struct.loaded.x + 1})
          }
        )
    }
  end

  @spec c_conf_updated(context()) :: context_merge()
  defp c_conf_updated(c) when is_map(c) do
    changeset =
      case c do
        %{changeset: %{updated: _value}} -> c.changeset
        _value -> c_changeset_updated().changeset
      end

    %{
      conf:
        Map.merge(
          c[:conf] || %{},
          %{updated: Ecto.Changeset.apply_action(changeset.updated, :update)}
        )
    }
  end

  @spec c_struct_deleted(context()) :: context_merge()
  defp c_struct_deleted(c \\ %{}) when is_map(c) do
    struct =
      case c do
        %{struct: %{loaded: _value}} -> c.struct
        _value -> c_struct_loaded().struct
      end

    %{
      struct:
        Map.merge(
          c[:struct] || %{},
          %{deleted: Ecto.put_meta(struct.loaded, state: :deleted)}
        )
    }
  end

  @spec c_conf_deleted(context()) :: context_merge()
  defp c_conf_deleted(c) when is_map(c) do
    struct =
      case c do
        %{struct: %{deleted: _value}} -> c.struct
        _value -> c_struct_deleted().struct
      end

    %{conf: %{deleted: {:ok, struct.deleted}}}
  end

  @spec c_struct_updated(context()) :: context_merge()
  defp c_struct_updated(c) when is_map(c) do
    struct_updated =
      case c do
        %{changeset: %{updated: changeset_updated}} ->
          Ecto.Changeset.apply_action!(changeset_updated, :updated)

        %{struct: %{loaded: struct_loaded}} ->
          Map.update!(struct_loaded, :x, &(&1 + 1))

        _value ->
          Map.update!(c_struct_loaded().struct.loaded, :x, &(&1 + 1))
      end

    %{struct: Map.merge(c[:struct] || %{}, %{updated: struct_updated})}
  end

  @spec c_entries(context()) :: context_merge()
  defp c_entries(c) when is_map(c) do
    count = 10
    %{conf: {count, nil}, entries: List.duplicate(%{}, count)}
  end

  @spec c_updates(context()) :: context_merge()
  defp c_updates(c) when is_map(c), do: %{updates: [inc: [x: 1]]}

  @spec c_count(context()) :: context_merge()
  defp c_count(c \\ %{}) when is_map(c) do
    source = Map.get(c, :source, c_source().source)
    %{rows: [[count]]} = Repo.query!("SELECT count(*) FROM #{source}")
    %{count: count}
  end

  @spec c_conf_count(context()) :: context_merge()
  defp c_conf_count(c) when is_map(c) do
    count = Map.get(c, :count, c_count().count)
    %{conf: {count, nil}}
  end

  @spec c_query_order(context()) :: context_merge()
  defp c_query_order(c) when is_map(c) do
    schema = Map.get(c, :schema, c_schema().schema)
    %{query: %{order: from(s in schema, order_by: s.id)}}
  end

  @spec c_structs_loaded(context()) :: context_merge()
  defp c_structs_loaded(c \\ %{}) when is_map(c) do
    schema = Map.get(c, :schema, c_schema().schema)
    source = Map.get(c, :source, c_source(%{schema: schema}).source)

    %{columns: columns, rows: rows} =
      Repo.query!("SELECT * FROM #{source} ORDER BY id")

    %{structs: %{loaded: Enum.map(rows, &Repo.load(schema, {columns, &1}))}}
  end

  @spec c_clauses(context()) :: context_merge()
  defp c_clauses(c) when is_map(c) do
    struct =
      case c do
        %{struct: %{loaded: _value}} -> c.struct
        _value -> c_struct_loaded().struct
      end

    %{clauses: [id: struct.loaded.id]}
  end

  @spec c_conf_structs(context()) :: context_merge()
  defp c_conf_structs(c) when is_map(c) do
    structs =
      case c do
        %{structs: %{loaded: _value}} -> c.structs
        _value -> c_structs_loaded().structs
      end

    %{conf: {:ok, structs.loaded}}
  end

  @spec c_query_where(context()) :: context_merge()
  defp c_query_where(c) when is_map(c) do
    schema = Map.get(c, :schema, c_schema().schema)

    struct =
      case c do
        %{struct: %{loaded: _value}} -> c.struct
        _value -> c_struct_loaded().struct
      end

    %{query: %{where: from(s in schema, where: s.id == ^struct.loaded.id)}}
  end

  @spec c_field(context()) :: context_merge()
  defp c_field(c) when is_map(c), do: %{field: :x}

  @spec c_agg(context()) :: context_merge()
  defp c_agg(c) when is_map(c) do
    source = Map.get(c, :source, c_source().source)
    field = Map.get(c, :field, c_field(%{source: source}).field)
    %{rows: [[count]]} = Repo.query!("SELECT count(#{field}) FROM #{source}")
    %{rows: [[avg]]} = Repo.query!("SELECT avg(#{field}) FROM #{source}")
    %{rows: [[max]]} = Repo.query!("SELECT max(#{field}) FROM #{source}")
    %{rows: [[min]]} = Repo.query!("SELECT min(#{field}) FROM #{source}")
    %{rows: [[sum]]} = Repo.query!("SELECT sum(#{field}) FROM #{source}")
    %{agg: %{avg: avg, count: count, max: max, min: min, sum: sum}}
  end

  @spec c_assoc(context()) :: context_merge()
  defp c_assoc(c) when is_map(c) do
    schema = Map.get(c, :schema, c_schema().schema)
    [assoc | []] = schema.__schema__(:associations)
    %{assoc: assoc}
  end

  @spec c_struct_preload(context()) :: context_merge()
  defp c_struct_preload(c) when is_map(c) do
    struct =
      case c do
        %{struct: %{built: _value}} -> c.struct
        _value -> c_struct_built().struct
      end

    assoc = Map.get(c, :assoc, c_assoc(%{struct: struct}).assoc)

    %{
      struct:
        Map.merge(c[:struct] || %{}, %{preload: %{struct.built | assoc => nil}})
    }
  end

  @spec c_query_update(context()) :: context_merge()
  defp c_query_update(c) when is_map(c) do
    schema = Map.get(c, :schema, c_schema().schema)
    updates = Map.get(c, :updates, c_updates(%{schema: schema}).updates)

    %{
      query:
        Map.merge(
          c[:query] || %{},
          %{update: from(s in schema, update: ^updates)}
        )
    }
  end

  @spec c_exp(context()) :: context_merge()
  defp c_exp(c) when is_map(c) do
    source = Map.get(c, :source, c_source().source)

    %{
      exp: %{
        delete: "Delete on #{source}",
        scan: "Seq Scan on #{source}",
        update: "Update on #{source}"
      }
    }
  end

  @spec c_exp(context()) :: context_merge()
  defp c_exp(c) when is_map(c) do
    source = Map.get(c, :source, c_source().source)

    %{
      exp: %{
        delete: "Delete on #{source}",
        scan: "Seq Scan on #{source}",
        update: "Update on #{source}"
      }
    }
  end

  @spec c_interval(context()) :: context_merge()
  defp c_interval(c) when is_map(c) do
    %{interval: 5_000}
  end

  @spec c_sql_select(context()) :: context_merge()
  defp c_sql_select(c) when is_map(c) do
    %{sql: %{select: "SELECT 1::integer"}}
  end

  @spec c_rows(context()) :: context_merge()
  defp c_rows(c) when is_map(c) do
    %{rows: [[1]]}
  end

  @spec c_sql_select_params(context()) :: context_merge()
  defp c_sql_select_params(c) when is_map(c) do
    %{sql: %{select_params: "SELECT $1::integer"}}
  end

  @spec c_params(context()) :: context_merge()
  defp c_params(c) when is_map(c) do
    %{params: [1]}
  end

  @spec c_sql_select_many(context()) :: context_merge()
  defp c_sql_select_many(c) when is_map(c) do
    %{sql: %{select_many: "SELECT 1::integer; SELECT 2::integer"}}
  end

  @spec c_sql_select_params_many(context()) :: context_merge()
  defp c_sql_select_params_many(c) when is_map(c) do
    %{sql: %{select_params_many: "SELECT $1::integer; SELECT $2::integer"}}
  end

  describe "config/0" do
    import Repo, only: [config: 0]

    test "success" do
      assert config() == [
               telemetry_prefix: [:diacritical, :repo],
               otp_app: :diacritical,
               timeout: 15_000,
               after_connect: {Postgrex, :query!, ["SET timezone TO UTC", []]},
               migration_source: "schema_migration",
               priv: "priv/diacritical/repo",
               socket_options: [:inet6],
               database: "diacritical_test",
               hostname: "localhost",
               password: "postgres",
               pool: Ecto.Adapters.SQL.Sandbox,
               pool_size: System.schedulers_online() * 2,
               username: "postgres"
             ]
    end
  end

  describe "__adapter__/0" do
    import Repo, only: [__adapter__: 0]

    test "success" do
      assert __adapter__() == Ecto.Adapters.Postgres
    end
  end

  describe "child_spec/1" do
    import Repo, only: [child_spec: 1]

    setup :c_init_arg

    test "success", %{init_arg: init_arg} do
      assert child_spec(init_arg) == %{
               id: Repo,
               start: {Repo, :start_link, [init_arg]},
               type: :supervisor
             }
    end
  end

  describe "start_link/0" do
    import Repo, only: [start_link: 0]

    setup :c_err

    test "success", %{err: err} do
      assert start_link() == err
    end
  end

  describe "start_link/1" do
    import Repo, only: [start_link: 1]

    setup [:c_init_arg, :c_err]

    test "success", %{err: err, init_arg: init_arg} do
      assert start_link(init_arg) == err
    end
  end

  describe "stop/0" do
    @describetag supervisor: Repo
    import Repo, only: [stop: 0]

    setup [:sleep_on_exit, :c_conf]

    test "success", %{conf: conf} do
      assert stop() == conf
    end
  end

  describe "stop/1" do
    @describetag supervisor: Repo
    import Repo, only: [stop: 1]

    setup [:sleep_on_exit, :c_conf]

    test "success", %{conf: conf} do
      assert stop(5_000) == conf
    end
  end

  describe "load/2" do
    import Repo, only: [load: 2]

    setup :c_schema

    test "success", %{schema: schema} do
      assert load(schema, %{}) == schema.__schema__(:loaded)
    end
  end

  describe "checkout/1" do
    import Repo, only: [checkout: 1]

    setup ~W[checkout_repo c_fun_self c_conf_self]a

    test "success", %{conf: %{self: conf}, fun: %{self: fun}} do
      assert checkout(fun) == conf
    end
  end

  describe "checkout/2" do
    import Repo, only: [checkout: 2]

    setup ~W[checkout_repo c_fun_self c_conf_self]a

    test "success", %{conf: %{self: conf}, fun: %{self: fun}} do
      assert checkout(fun, []) == conf
    end
  end

  describe "checked_out?/0" do
    import Repo, only: [checked_out?: 0]

    setup :checkout_repo

    test "failure" do
      refute checked_out?()
    end

    test "success" do
      assert Repo.checkout(&checked_out?/0)
    end
  end

  describe "get_dynamic_repo/0" do
    import Repo, only: [get_dynamic_repo: 0]

    test "success" do
      assert get_dynamic_repo() == Repo
    end
  end

  describe "put_dynamic_repo/1" do
    import Repo, only: [put_dynamic_repo: 1]

    test "success" do
      assert put_dynamic_repo(Repo) == Repo
    end
  end

  describe "default_options/1" do
    import Repo, only: [default_options: 1]

    setup do: %{opt: []}

    test ":transaction", %{opt: opt} do
      assert default_options(:transaction) == opt
    end

    test ":insert", %{opt: opt} do
      assert default_options(:insert) == opt
    end

    test ":update", %{opt: opt} do
      assert default_options(:update) == opt
    end

    test ":insert_or_update", %{opt: opt} do
      assert default_options(:insert_or_update) == opt
    end

    test ":delete", %{opt: opt} do
      assert default_options(:delete) == opt
    end

    test ":insert_all", %{opt: opt} do
      assert default_options(:insert_all) == opt
    end

    test ":update_all", %{opt: opt} do
      assert default_options(:update_all) == opt
    end

    test ":delete_all", %{opt: opt} do
      assert default_options(:delete_all) == opt
    end

    test ":all", %{opt: opt} do
      assert default_options(:all) == opt
    end

    test ":stream", %{opt: opt} do
      assert default_options(:stream) == opt
    end

    test ":reload", %{opt: opt} do
      assert default_options(:reload) == opt
    end

    test ":preload", %{opt: opt} do
      assert default_options(:preload) == opt
    end
  end

  describe "transact/1 when is_function(fun, 0)" do
    import Repo, only: [transact: 1]

    setup ~W[checkout_repo c_fun_self c_conf_self]a

    test "success", %{conf: %{self: conf}, fun: %{self: fun}} do
      assert transact(fun) == conf
    end
  end

  describe "transact/1 when is_function(fun, 1)" do
    import Repo, only: [transact: 1]

    setup ~W[checkout_repo c_fun_repo c_conf_repo]a

    test "success", %{conf: %{repo: conf}, fun: %{repo: fun}} do
      assert transact(fun) == conf
    end
  end

  describe "transact/1 when is_struct(multi, Ecto.Multi)" do
    import Repo, only: [transact: 1]

    setup ~W[checkout_repo c_multi c_conf_multi]a

    test "success", %{conf: %{multi: conf}, multi: multi} do
      assert transact(multi) == conf
    end
  end

  describe "transact/2 when is_function(fun, 0)" do
    import Repo, only: [transact: 2]

    setup ~W[checkout_repo c_fun_self c_conf_self]a

    test "success", %{conf: %{self: conf}, fun: %{self: fun}} do
      assert transact(fun, []) == conf
    end
  end

  describe "transact/2 when is_function(fun, 1)" do
    import Repo, only: [transact: 2]

    setup ~W[checkout_repo c_fun_repo c_conf_repo]a

    test "success", %{conf: %{repo: conf}, fun: %{repo: fun}} do
      assert transact(fun, []) == conf
    end
  end

  describe "in_transaction?/0" do
    import Repo, only: [in_transaction?: 0]

    setup :checkout_repo

    test "failure" do
      refute in_transaction?()
    end

    test "success" do
      assert Repo.transaction(&in_transaction?/0) == {:ok, true}
    end
  end

  describe "rollback/1" do
    import Repo, only: [rollback: 1]

    setup :checkout_repo
    setup do: %{conf: :exit}

    test "success", %{conf: conf} do
      assert Repo.transaction(fn -> rollback(conf) end) == {:error, conf}
    end
  end

  describe "insert/1" do
    @describetag repo: TestSchema
    import Repo, only: [insert: 1]

    setup ~W[checkout_repo c_changeset_built c_conf_loaded]a

    test "success", %{changeset: %{loaded: changeset}, conf: %{loaded: conf}} do
      assert insert(changeset) == conf
    end
  end

  describe "insert/2" do
    @describetag repo: TestSchema
    import Repo, only: [insert: 2]

    setup ~W[checkout_repo c_changeset_built c_conf_loaded]a

    test "success", %{changeset: %{loaded: changeset}, conf: %{loaded: conf}} do
      assert insert(changeset, []) == conf
    end
  end

  describe "update/1" do
    @describetag repo: TestSchema
    import Repo, only: [update: 1]

    setup ~W[checkout_repo c_changeset_updated c_conf_updated]a

    test "success", %{
      changeset: %{updated: changeset},
      conf: %{updated: conf}
    } do
      assert update(changeset) == conf
    end
  end

  describe "update/2" do
    @describetag repo: TestSchema
    import Repo, only: [update: 2]

    setup ~W[checkout_repo c_changeset_updated c_conf_updated]a

    test "success", %{
      changeset: %{updated: changeset},
      conf: %{updated: conf}
    } do
      assert update(changeset, []) == conf
    end
  end

  describe "insert_or_update/1" do
    @describetag repo: TestSchema
    import Repo, only: [insert_or_update: 1]

    setup [
      :checkout_repo,
      :c_changeset_built,
      :c_changeset_updated,
      :c_conf_loaded,
      :c_conf_updated
    ]

    test "success", %{
      changeset: %{loaded: changeset, updated: changeset!},
      conf: %{loaded: conf, updated: conf!}
    } do
      assert insert_or_update(changeset) == conf
      assert insert_or_update(changeset!) == conf!
    end
  end

  describe "insert_or_update/2" do
    @describetag repo: TestSchema
    import Repo, only: [insert_or_update: 2]

    setup [
      :checkout_repo,
      :c_changeset_built,
      :c_changeset_updated,
      :c_conf_loaded,
      :c_conf_updated
    ]

    setup do: %{opt: []}

    test "success", %{
      changeset: %{loaded: changeset, updated: changeset!},
      conf: %{loaded: conf, updated: conf!},
      opt: opt
    } do
      assert insert_or_update(changeset, opt) == conf
      assert insert_or_update(changeset!, opt) == conf!
    end
  end

  describe "delete/1" do
    @describetag repo: TestSchema
    import Repo, only: [delete: 1]

    setup ~W[checkout_repo c_struct_deleted c_conf_deleted]a

    test "success", %{struct: %{deleted: struct}, conf: %{deleted: conf}} do
      assert delete(struct) == conf
    end
  end

  describe "delete/2" do
    @describetag repo: TestSchema
    import Repo, only: [delete: 2]

    setup ~W[checkout_repo c_struct_deleted c_conf_deleted]a

    test "success", %{struct: %{deleted: struct}, conf: %{deleted: conf}} do
      assert delete(struct, []) == conf
    end
  end

  describe "insert!/1" do
    @describetag repo: TestSchema
    import Repo, only: [insert!: 1]

    setup ~W[checkout_repo c_struct_built c_changeset_built]a

    test "success", %{
      changeset: %{loaded: changeset},
      struct: %{built: struct}
    } do
      assert insert!(changeset) == struct
    end
  end

  describe "insert!/2" do
    @describetag repo: TestSchema
    import Repo, only: [insert!: 2]

    setup ~W[checkout_repo c_struct_built c_changeset_built]a

    test "success", %{
      changeset: %{loaded: changeset},
      struct: %{built: struct}
    } do
      assert insert!(changeset, []) == struct
    end
  end

  describe "update!/1" do
    @describetag repo: TestSchema
    import Repo, only: [update!: 1]

    setup ~W[checkout_repo c_changeset_updated c_struct_updated]a

    test "success", %{
      changeset: %{updated: changeset},
      struct: %{updated: struct}
    } do
      assert update!(changeset) == struct
    end
  end

  describe "update!/2" do
    @describetag repo: TestSchema
    import Repo, only: [update!: 2]

    setup ~W[checkout_repo c_changeset_updated c_struct_updated]a

    test "success", %{
      changeset: %{updated: changeset},
      struct: %{updated: struct}
    } do
      assert update!(changeset, []) == struct
    end
  end

  describe "insert_or_update!/1" do
    @describetag repo: TestSchema
    import Repo, only: [insert_or_update!: 1]

    setup [
      :checkout_repo,
      :c_struct_built,
      :c_changeset_built,
      :c_changeset_updated,
      :c_struct_updated
    ]

    test "success", %{
      changeset: %{loaded: changeset, updated: changeset!},
      struct: %{built: struct, updated: struct!}
    } do
      assert insert_or_update!(changeset) == struct
      assert insert_or_update!(changeset!) == struct!
    end
  end

  describe "insert_or_update!/2" do
    @describetag repo: TestSchema
    import Repo, only: [insert_or_update!: 2]

    setup [
      :checkout_repo,
      :c_struct_built,
      :c_changeset_built,
      :c_changeset_updated,
      :c_struct_updated
    ]

    setup do: %{opt: []}

    test "success", %{
      changeset: %{loaded: changeset, updated: changeset!},
      opt: opt,
      struct: %{built: struct, updated: struct!}
    } do
      assert insert_or_update!(changeset, opt) == struct
      assert insert_or_update!(changeset!, opt) == struct!
    end
  end

  describe "delete!/1" do
    @describetag repo: TestSchema
    import Repo, only: [delete!: 1]

    setup ~W[checkout_repo c_struct_loaded c_struct_deleted]a

    test "success", %{
      struct: %{deleted: struct!, loaded: struct}
    } do
      assert delete!(struct) == struct!
    end
  end

  describe "delete!/2" do
    @describetag repo: TestSchema
    import Repo, only: [delete!: 2]

    setup ~W[checkout_repo c_struct_loaded c_struct_deleted]a

    test "success", %{
      struct: %{deleted: struct!, loaded: struct}
    } do
      assert delete!(struct, []) == struct!
    end
  end

  describe "insert_all/2" do
    @describetag repo: TestSchema
    import Repo, only: [insert_all: 2]

    setup ~W[checkout_repo c_schema c_entries]a

    test "success", %{conf: conf, entries: entries, schema: schema} do
      assert insert_all(schema, entries) == conf
    end
  end

  describe "insert_all/3" do
    @describetag repo: TestSchema
    import Repo, only: [insert_all: 3]

    setup ~W[checkout_repo c_schema c_entries]a

    test "success", %{conf: conf, entries: entries, schema: schema} do
      assert insert_all(schema, entries, []) == conf
    end
  end

  describe "update_all/2" do
    @describetag repo: TestSchema
    import Repo, only: [update_all: 2]

    setup ~W[checkout_repo c_schema c_updates c_conf_count]a

    test "success", %{conf: conf, schema: schema, updates: updates} do
      assert update_all(schema, updates) == conf
    end
  end

  describe "update_all/3" do
    @describetag repo: TestSchema
    import Repo, only: [update_all: 3]

    setup ~W[checkout_repo c_schema c_updates c_conf_count]a

    test "success", %{conf: conf, schema: schema, updates: updates} do
      assert update_all(schema, updates, []) == conf
    end
  end

  describe "delete_all/1" do
    @describetag repo: TestSchema
    import Repo, only: [delete_all: 1]

    setup ~W[checkout_repo c_schema c_conf_count]a

    test "success", %{conf: conf, schema: schema} do
      assert delete_all(schema) == conf
    end
  end

  describe "delete_all/2" do
    @describetag repo: TestSchema
    import Repo, only: [delete_all: 2]

    setup ~W[checkout_repo c_schema c_conf_count]a

    test "success", %{conf: conf, schema: schema} do
      assert delete_all(schema, []) == conf
    end
  end

  describe "all/1" do
    @describetag repo: TestSchema
    import Repo, only: [all: 1]

    setup ~W[checkout_repo c_query_order c_structs_loaded]a

    test "success", %{query: %{order: query}, structs: %{loaded: structs}} do
      assert all(query) == structs
    end
  end

  describe "all/2" do
    @describetag repo: TestSchema
    import Repo, only: [all: 2]

    setup ~W[checkout_repo c_query_order c_structs_loaded]a

    test "success", %{query: %{order: query}, structs: %{loaded: structs}} do
      assert all(query, []) == structs
    end
  end

  describe "all_by/2" do
    @describetag repo: TestSchema
    import Repo, only: [all_by: 2]

    setup ~W[checkout_repo c_query_order c_struct_loaded c_clauses]a

    test "success", %{
      clauses: clauses,
      query: %{order: query},
      struct: %{loaded: struct}
    } do
      assert all_by(query, clauses) == [struct]
    end
  end

  describe "all_by/3" do
    @describetag repo: TestSchema
    import Repo, only: [all_by: 3]

    setup ~W[checkout_repo c_query_order c_struct_loaded c_clauses]a

    test "success", %{
      clauses: clauses,
      query: %{order: query},
      struct: %{loaded: struct}
    } do
      assert all_by(query, clauses, []) == [struct]
    end
  end

  describe "stream/1" do
    @describetag repo: TestSchema
    import Repo, only: [stream: 1]

    setup ~W[checkout_repo c_query_order c_conf_structs]a

    test "success", %{conf: conf, query: %{order: query}} do
      assert Repo.transaction(fn -> Enum.to_list(stream(query)) end) == conf
    end
  end

  describe "stream/2" do
    @describetag repo: TestSchema
    import Repo, only: [stream: 2]

    setup ~W[checkout_repo c_query_order c_conf_structs]a

    test "success", %{conf: conf, query: %{order: query}} do
      assert Repo.transaction(fn -> Enum.to_list(stream(query, [])) end) == conf
    end
  end

  describe "get/2" do
    @describetag repo: TestSchema
    import Repo, only: [get: 2]

    setup ~W[checkout_repo c_schema c_struct_loaded]a

    test "success", %{schema: schema, struct: %{loaded: %{id: id} = struct}} do
      assert get(schema, id) == struct
    end
  end

  describe "get/3" do
    @describetag repo: TestSchema
    import Repo, only: [get: 3]

    setup ~W[checkout_repo c_schema c_struct_loaded]a

    test "success", %{schema: schema, struct: %{loaded: %{id: id} = struct}} do
      assert get(schema, id, []) == struct
    end
  end

  describe "get!/2" do
    @describetag repo: TestSchema
    import Repo, only: [get!: 2]

    setup ~W[checkout_repo c_schema c_struct_loaded]a

    test "success", %{schema: schema, struct: %{loaded: %{id: id} = struct}} do
      assert get!(schema, id) == struct
    end
  end

  describe "get!/3" do
    @describetag repo: TestSchema
    import Repo, only: [get!: 3]

    setup ~W[checkout_repo c_schema c_struct_loaded]a

    test "success", %{schema: schema, struct: %{loaded: %{id: id} = struct}} do
      assert get!(schema, id, []) == struct
    end
  end

  describe "get_by/2" do
    @describetag repo: TestSchema
    import Repo, only: [get_by: 2]

    setup ~W[checkout_repo c_schema c_struct_loaded c_clauses]a

    test "success", %{
      clauses: clauses,
      schema: schema,
      struct: %{loaded: struct}
    } do
      assert get_by(schema, clauses) == struct
    end
  end

  describe "get_by/3" do
    @describetag repo: TestSchema
    import Repo, only: [get_by: 3]

    setup ~W[checkout_repo c_schema c_struct_loaded c_clauses]a

    test "success", %{
      clauses: clauses,
      schema: schema,
      struct: %{loaded: struct}
    } do
      assert get_by(schema, clauses, []) == struct
    end
  end

  describe "get_by!/2" do
    @describetag repo: TestSchema
    import Repo, only: [get_by!: 2]

    setup ~W[checkout_repo c_schema c_struct_loaded c_clauses]a

    test "success", %{
      clauses: clauses,
      schema: schema,
      struct: %{loaded: struct}
    } do
      assert get_by!(schema, clauses) == struct
    end
  end

  describe "get_by!/3" do
    @describetag repo: TestSchema
    import Repo, only: [get_by!: 3]

    setup ~W[checkout_repo c_schema c_struct_loaded c_clauses]a

    test "success", %{
      clauses: clauses,
      schema: schema,
      struct: %{loaded: struct}
    } do
      assert get_by!(schema, clauses, []) == struct
    end
  end

  describe "reload/1" do
    @describetag repo: TestSchema
    import Repo, only: [reload: 1]

    setup ~W[checkout_repo c_struct_loaded c_struct_updated]a

    test "success", %{struct: %{loaded: struct!, updated: struct}} do
      assert reload(struct) == struct!
    end
  end

  describe "reload/2" do
    @describetag repo: TestSchema
    import Repo, only: [reload: 2]

    setup ~W[checkout_repo c_struct_loaded c_struct_updated]a

    test "success", %{struct: %{loaded: struct!, updated: struct}} do
      assert reload(struct, []) == struct!
    end
  end

  describe "reload!/1" do
    @describetag repo: TestSchema
    import Repo, only: [reload!: 1]

    setup ~W[checkout_repo c_struct_loaded c_struct_updated]a

    test "success", %{struct: %{loaded: struct!, updated: struct}} do
      assert reload!(struct) == struct!
    end
  end

  describe "reload!/2" do
    @describetag repo: TestSchema
    import Repo, only: [reload!: 2]

    setup ~W[checkout_repo c_struct_loaded c_struct_updated]a

    test "success", %{struct: %{loaded: struct!, updated: struct}} do
      assert reload!(struct, []) == struct!
    end
  end

  describe "one/1" do
    @describetag repo: TestSchema
    import Repo, only: [one: 1]

    setup ~W[checkout_repo c_struct_loaded c_query_where]a

    test "success", %{query: %{where: query}, struct: %{loaded: struct}} do
      assert one(query) == struct
    end
  end

  describe "one/2" do
    @describetag repo: TestSchema
    import Repo, only: [one: 2]

    setup ~W[checkout_repo c_struct_loaded c_query_where]a

    test "success", %{query: %{where: query}, struct: %{loaded: struct}} do
      assert one(query, []) == struct
    end
  end

  describe "one!/1" do
    @describetag repo: TestSchema
    import Repo, only: [one!: 1]

    setup ~W[checkout_repo c_struct_loaded c_query_where]a

    test "success", %{query: %{where: query}, struct: %{loaded: struct}} do
      assert one!(query) == struct
    end
  end

  describe "one!/2" do
    @describetag repo: TestSchema
    import Repo, only: [one!: 2]

    setup ~W[checkout_repo c_struct_loaded c_query_where]a

    test "success", %{query: %{where: query}, struct: %{loaded: struct}} do
      assert one!(query, []) == struct
    end
  end

  describe "aggregate/2" do
    @describetag repo: TestSchema
    import Repo, only: [aggregate: 2]

    setup ~W[checkout_repo c_schema c_count]a

    test "success", %{count: count, schema: schema} do
      assert aggregate(schema, :count) == count
    end
  end

  describe "aggregate/3 when is_list(opts)" do
    @describetag repo: TestSchema
    import Repo, only: [aggregate: 3]

    setup ~W[checkout_repo c_schema c_count]a

    test "success", %{count: count, schema: schema} do
      assert aggregate(schema, :count, []) == count
    end
  end

  describe "aggregate/3 when is_atom(field)" do
    @describetag repo: TestSchema
    import Repo, only: [aggregate: 3]

    setup ~W[checkout_repo c_schema c_field c_agg]a

    test ":count", %{agg: %{count: count}, field: field, schema: schema} do
      assert aggregate(schema, :count, field) == count
    end

    test ":avg", %{agg: %{avg: avg}, field: field, schema: schema} do
      assert aggregate(schema, :avg, field) == avg
    end

    test ":max", %{agg: %{max: max}, field: field, schema: schema} do
      assert aggregate(schema, :max, field) == max
    end

    test ":min", %{agg: %{min: min}, field: field, schema: schema} do
      assert aggregate(schema, :min, field) == min
    end

    test ":sum", %{agg: %{sum: sum}, field: field, schema: schema} do
      assert aggregate(schema, :sum, field) == sum
    end
  end

  describe "aggregate/4" do
    @describetag repo: TestSchema
    import Repo, only: [aggregate: 4]

    setup ~W[checkout_repo c_schema c_field c_agg]a
    setup do: %{opt: []}

    test ":count", %{
      agg: %{count: count},
      field: field,
      opt: opt,
      schema: schema
    } do
      assert aggregate(schema, :count, field, opt) == count
    end

    test ":avg", %{agg: %{avg: avg}, field: field, opt: opt, schema: schema} do
      assert aggregate(schema, :avg, field, opt) == avg
    end

    test ":max", %{agg: %{max: max}, field: field, opt: opt, schema: schema} do
      assert aggregate(schema, :max, field, opt) == max
    end

    test ":min", %{agg: %{min: min}, field: field, opt: opt, schema: schema} do
      assert aggregate(schema, :min, field, opt) == min
    end

    test ":sum", %{agg: %{sum: sum}, field: field, opt: opt, schema: schema} do
      assert aggregate(schema, :sum, field, opt) == sum
    end
  end

  describe "exists?/1" do
    @describetag repo: TestSchema
    import Repo, only: [exists?: 1]

    setup [:checkout_repo, :c_schema]

    test "success", %{schema: schema} do
      assert exists?(schema)
    end
  end

  describe "exists?/2" do
    @describetag repo: TestSchema
    import Repo, only: [exists?: 2]

    setup [:checkout_repo, :c_schema]

    test "success", %{schema: schema} do
      assert exists?(schema, [])
    end
  end

  describe "preload/2" do
    import Repo, only: [preload: 2]

    setup ~W[c_struct_built c_assoc c_struct_preload]a

    test "success", %{
      assoc: assoc,
      struct: %{built: struct, preload: struct!}
    } do
      assert preload(struct, assoc) == struct!
    end
  end

  describe "preload/3" do
    import Repo, only: [preload: 3]

    setup ~W[c_struct_built c_assoc c_struct_preload]a

    test "success", %{
      assoc: assoc,
      struct: %{built: struct, preload: struct!}
    } do
      assert preload(struct, assoc, []) == struct!
    end
  end

  describe "prepare_query/3" do
    import Repo, only: [prepare_query: 3]

    setup ~W[c_query_order c_query_update]a

    setup %{query: %{order: order, update: update}} do
      %{conf: %{order: {order, []}, update: {update, []}}, opt: []}
    end

    test ":insert_all, query, opt", %{
      conf: %{order: conf},
      opt: opt,
      query: %{order: query}
    } do
      assert prepare_query(:insert_all, query, opt) == conf
    end

    test ":update_all, query, opt", %{
      conf: %{update: conf},
      opt: opt,
      query: %{update: query}
    } do
      assert prepare_query(:update_all, query, opt) == conf
    end

    test ":delete_all, query, opt", %{
      conf: %{order: conf},
      opt: opt,
      query: %{order: query}
    } do
      assert prepare_query(:delete_all, query, opt) == conf
    end

    test ":all, query, opt", %{
      conf: %{order: conf},
      opt: opt,
      query: %{order: query}
    } do
      assert prepare_query(:all, query, opt) == conf
    end

    test ":stream, query, opt", %{
      conf: %{order: conf},
      opt: opt,
      query: %{order: query}
    } do
      assert prepare_query(:stream, query, opt) == conf
    end
  end

  describe "prepare_transaction/2 when is_function(fun, 0)" do
    import Repo, only: [prepare_transaction: 2]

    setup [:c_fun_self]
    setup do: %{opt: []}

    test "success", %{fun: %{self: fun}, opt: opt} do
      assert prepare_transaction(fun, opt) == {fun, opt}
    end
  end

  describe "prepare_transaction/2 when is_function(fun, 1)" do
    import Repo, only: [prepare_transaction: 2]

    setup [:c_fun_repo]
    setup do: %{opt: []}

    test "success", %{fun: %{repo: fun}, opt: opt} do
      assert prepare_transaction(fun, opt) == {fun, opt}
    end
  end

  describe "prepare_transaction/2 when is_struct(multi, Ecto.Multi)" do
    import Repo, only: [prepare_transaction: 2]

    setup :c_multi
    setup do: %{opt: []}

    test "success", %{multi: multi, opt: opt} do
      assert prepare_transaction(multi, opt) == {multi, opt}
    end
  end

  describe "explain/2" do
    @describetag repo: TestSchema
    import Repo, only: [explain: 2]

    setup ~W[checkout_repo c_query_update c_schema c_exp]a

    test ":update_all, queryable", %{
      exp: %{update: exp},
      query: %{update: query}
    } do
      assert explain(:update_all, query) =~ exp
    end

    test ":delete_all, queryable", %{exp: %{delete: exp}, schema: schema} do
      assert explain(:delete_all, schema) =~ exp
    end

    test ":all, queryable", %{exp: %{scan: exp}, schema: schema} do
      assert explain(:all, schema) =~ exp
    end
  end

  describe "explain/3" do
    @describetag repo: TestSchema
    import Repo, only: [explain: 3]

    setup ~W[checkout_repo c_query_update c_schema c_exp]a
    setup do: %{opt: []}

    test ":update_all, queryable", %{
      exp: %{update: exp},
      opt: opt,
      query: %{update: query}
    } do
      assert explain(:update_all, query, opt) =~ exp
    end

    test ":delete_all, queryable", %{
      exp: %{delete: exp},
      opt: opt,
      schema: schema
    } do
      assert explain(:delete_all, schema, opt) =~ exp
    end

    test ":all, queryable", %{exp: %{scan: exp}, opt: opt, schema: schema} do
      assert explain(:all, schema, opt) =~ exp
    end
  end

  describe "disconnect_all/1" do
    @describetag supervisor: Repo
    import Repo, only: [disconnect_all: 1]

    setup ~W[checkout_repo c_interval]a

    test "success", %{interval: interval} do
      assert disconnect_all(interval) == :ok
    end
  end

  describe "disconnect_all/2" do
    @describetag supervisor: Repo
    import Repo, only: [disconnect_all: 2]

    setup ~W[checkout_repo c_interval]a

    test "success", %{interval: interval} do
      assert disconnect_all(interval, []) == :ok
    end
  end

  describe "query/1" do
    import Repo, only: [query: 1]

    setup ~W[checkout_repo c_sql_select c_rows]a

    test "success", %{rows: rows, sql: %{select: sql}} do
      assert {:ok, %{rows: ^rows}} = query(sql)
    end
  end

  describe "query/2" do
    import Repo, only: [query: 2]

    setup ~W[checkout_repo c_sql_select_params c_rows c_params]a

    test "success", %{params: params, rows: rows, sql: %{select_params: sql}} do
      assert {:ok, %{rows: ^rows}} = query(sql, params)
    end
  end

  describe "query/3" do
    import Repo, only: [query: 3]

    setup ~W[checkout_repo c_sql_select_params c_rows c_params]a

    test "success", %{params: params, rows: rows, sql: %{select_params: sql}} do
      assert {:ok, %{rows: ^rows}} = query(sql, params, [])
    end
  end

  describe "query!/1" do
    import Repo, only: [query!: 1]

    setup ~W[checkout_repo c_sql_select c_rows]a

    test "success", %{rows: rows, sql: %{select: sql}} do
      assert %{rows: ^rows} = query!(sql)
    end
  end

  describe "query!/2" do
    import Repo, only: [query!: 2]

    setup ~W[checkout_repo c_sql_select_params c_rows c_params]a

    test "success", %{params: params, rows: rows, sql: %{select_params: sql}} do
      assert %{rows: ^rows} = query!(sql, params)
    end
  end

  describe "query!/3" do
    import Repo, only: [query!: 3]

    setup ~W[checkout_repo c_sql_select_params c_rows c_params]a

    test "success", %{params: params, rows: rows, sql: %{select_params: sql}} do
      assert %{rows: ^rows} = query!(sql, params, [])
    end
  end

  describe "query_many/1" do
    import Repo, only: [query_many: 1]

    setup [:checkout_repo, :c_sql_select_many]

    test "RuntimeError", %{sql: %{select_many: sql}} do
      assert_raise RuntimeError, fn -> query_many(sql) end
    end
  end

  describe "query_many/2" do
    import Repo, only: [query_many: 2]

    setup ~W[checkout_repo c_sql_select_params_many c_params]a

    test "RuntimeError", %{params: params, sql: %{select_params_many: sql}} do
      assert_raise RuntimeError, fn -> query_many(sql, params) end
    end
  end

  describe "query_many/3" do
    import Repo, only: [query_many: 3]

    setup ~W[checkout_repo c_sql_select_params_many c_params]a

    test "RuntimeError", %{params: params, sql: %{select_params_many: sql}} do
      assert_raise RuntimeError, fn -> query_many(sql, params, []) end
    end
  end

  describe "query_many!/1" do
    import Repo, only: [query_many!: 1]

    setup [:checkout_repo, :c_sql_select_many]

    test "RuntimeError", %{sql: %{select_many: sql}} do
      assert_raise RuntimeError, fn -> query_many!(sql) end
    end
  end

  describe "query_many!/2" do
    import Repo, only: [query_many!: 2]

    setup ~W[checkout_repo c_sql_select_params_many c_params]a

    test "RuntimeError", %{params: params, sql: %{select_params_many: sql}} do
      assert_raise RuntimeError, fn -> query_many!(sql, params) end
    end
  end

  describe "query_many!/3" do
    import Repo, only: [query_many!: 3]

    setup ~W[checkout_repo c_sql_select_params_many c_params]a

    test "RuntimeError", %{params: params, sql: %{select_params_many: sql}} do
      assert_raise RuntimeError, fn -> query_many!(sql, params, []) end
    end
  end

  describe "to_sql/2" do
    import Repo, only: [to_sql: 2]

    setup ~W[checkout_repo c_query_update c_schema]a
    setup do: %{params: %{empty: [], update: [1]}}

    test ":update_all, queryable", %{
      params: %{update: params},
      query: %{update: query}
    } do
      assert {"UPDATE " <> _sql, ^params} = to_sql(:update_all, query)
    end

    test ":delete_all, queryable", %{
      params: %{empty: params},
      schema: schema
    } do
      assert {"DELETE " <> _sql, ^params} = to_sql(:delete_all, schema)
    end

    test ":all, queryable", %{params: %{empty: params}, schema: schema} do
      assert {"SELECT " <> _sql, ^params} = to_sql(:all, schema)
    end
  end
end
