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

  @spec c_conf_stop(context()) :: context_merge()
  defp c_conf_stop(c) when is_map(c), do: %{conf: :ok}

  @spec c_schema(context()) :: context_merge()
  defp c_schema(c) when is_map(c), do: %{schema: TestSchema}

  @spec c_fun_checkout(context()) :: context_merge()
  defp c_fun_checkout(c) when is_map(c) do
    %{conf: Diacritical.greet(), fun: &Diacritical.greet/0}
  end

  @spec c_fun_transaction(context()) :: context_merge()
  defp c_fun_transaction(c) when is_map(c) do
    %{
      conf: %{greeting: {:ok, Diacritical.greet()}, repo: {:ok, Repo}},
      fun: %{greeting: &Diacritical.greet/0, repo: & &1}
    }
  end

  @spec c_struct_built(context()) :: context_merge()
  defp c_struct_built(%{schema: schema}) when is_atom(schema) do
    built = schema.__struct__(id: Ecto.UUID.generate(), x: 0)

    %{
      changeset: %{built: Ecto.Changeset.change(built, %{})},
      struct: %{loaded: Ecto.put_meta(built, state: :loaded)}
    }
  end

  @spec c_conf_loaded(context()) :: context_merge()
  defp c_conf_loaded(%{struct: %{loaded: loaded}}) when is_struct(loaded) do
    %{conf: %{loaded: {:ok, loaded}}}
  end

  @spec c_source(context()) :: context_merge()
  defp c_source(%{schema: schema}) when is_atom(schema) do
    %{source: schema.__schema__(:source)}
  end

  @spec c_struct_loaded(context()) :: context_merge()
  defp c_struct_loaded(%{schema: schema, source: source})
       when is_atom(schema) and is_binary(source) do
    sql = "SELECT * FROM #{source} LIMIT 1 OFFSET floor(random() * 1000)"
    %{columns: columns, rows: rows} = Repo.query!(sql)
    [loaded] = Enum.map(rows, &Repo.load(schema, {columns, &1}))
    %{struct: %{loaded: loaded}}
  end

  @spec c_struct_updated(context()) :: context_merge()
  defp c_struct_updated(%{struct: %{loaded: loaded = %{x: x}} = struct} = c)
       when is_struct(loaded) and is_integer(x) do
    i = x + 1

    %{
      changeset:
        Map.merge(
          c[:changeset] || %{},
          %{loaded: Ecto.Changeset.change(loaded, %{x: i})}
        ),
      struct: Map.merge(struct, %{updated: %{loaded | x: i}})
    }
  end

  @spec c_conf_updated(context()) :: context_merge()
  defp c_conf_updated(%{struct: %{updated: updated}} = c)
       when is_struct(updated) do
    %{conf: Map.merge(c[:conf] || %{}, %{updated: {:ok, updated}})}
  end

  @spec c_struct_deleted(context()) :: context_merge()
  defp c_struct_deleted(%{struct: %{loaded: loaded} = struct})
       when is_struct(loaded) do
    %{
      struct:
        Map.merge(struct, %{deleted: Ecto.put_meta(loaded, state: :deleted)})
    }
  end

  @spec c_conf_deleted(context()) :: context_merge()
  defp c_conf_deleted(%{struct: %{deleted: deleted}}) when is_struct(deleted) do
    %{conf: %{deleted: {:ok, deleted}}}
  end

  @spec c_entries(context()) :: context_merge()
  defp c_entries(c) when is_map(c) do
    count = 10
    %{conf: {count, nil}, entries: List.duplicate(%{}, count)}
  end

  @spec c_updates(context()) :: context_merge()
  defp c_updates(c) when is_map(c), do: %{updates: [inc: [x: 1]]}

  @spec c_count(context()) :: context_merge()
  defp c_count(%{source: source}) when is_binary(source) do
    %{rows: [[count]]} = Repo.query!("SELECT count(*) FROM #{source}")
    %{count: count}
  end

  @spec c_conf_count(context()) :: context_merge()
  defp c_conf_count(%{count: count}) when is_integer(count) do
    %{conf: {count, nil}}
  end

  @spec c_query_order(context()) :: context_merge()
  defp c_query_order(%{schema: schema}) when is_atom(schema) do
    %{query: %{order: from(s in schema, order_by: s.id)}}
  end

  @spec c_structs_loaded(context()) :: context_merge()
  defp c_structs_loaded(%{schema: schema, source: source})
       when is_atom(schema) and is_binary(source) do
    %{columns: columns, rows: rows} =
      Repo.query!("SELECT * FROM #{source} ORDER BY id")

    loaded = Enum.map(rows, &Repo.load(schema, {columns, &1}))
    %{structs: %{loaded: loaded}}
  end

  @spec c_conf_structs(context()) :: context_merge()
  defp c_conf_structs(%{structs: %{loaded: loaded}}) when is_list(loaded) do
    %{conf: {:ok, loaded}}
  end

  @spec c_clauses(context()) :: context_merge()
  defp c_clauses(%{struct: %{loaded: %{id: id}}}) when is_binary(id) do
    %{clauses: [id: id]}
  end

  @spec c_query_where(context()) :: context_merge()
  defp c_query_where(%{schema: schema, struct: %{loaded: %{id: id}}})
       when is_atom(schema) and is_binary(id) do
    %{query: %{where: from(s in schema, where: s.id == ^id)}}
  end

  @spec c_field(context()) :: context_merge()
  defp c_field(c) when is_map(c), do: %{field: :x}

  @spec c_agg_field(context()) :: context_merge()
  defp c_agg_field(%{field: field, source: source})
       when is_atom(field) and is_binary(source) do
    %{rows: [[count]]} = Repo.query!("SELECT count(#{field}) FROM #{source}")
    %{rows: [[avg]]} = Repo.query!("SELECT avg(#{field}) FROM #{source}")
    %{rows: [[max]]} = Repo.query!("SELECT max(#{field}) FROM #{source}")
    %{rows: [[min]]} = Repo.query!("SELECT min(#{field}) FROM #{source}")
    %{rows: [[sum]]} = Repo.query!("SELECT sum(#{field}) FROM #{source}")

    %{agg: %{avg: avg, count: count, max: max, min: min, sum: sum}}
  end

  @spec c_assoc(context()) :: context_merge()
  defp c_assoc(%{schema: schema}) when is_atom(schema) do
    [assoc | []] = schema.__schema__(:associations)
    %{assoc: assoc}
  end

  @spec c_preload(context()) :: context_merge()
  defp c_preload(%{assoc: assoc, struct: %{loaded: loaded}})
       when is_atom(assoc) and is_struct(loaded) do
    %{preload: %{loaded | assoc => nil}}
  end

  @spec c_query_update(context()) :: context_merge()
  defp c_query_update(%{schema: schema, updates: updates} = c)
       when is_atom(schema) and is_list(updates) do
    %{
      query:
        Map.merge(
          c[:query] || %{},
          %{update: from(s in schema, update: ^updates)}
        )
    }
  end

  @spec c_exp(context()) :: context_merge()
  defp c_exp(%{source: source}) when is_binary(source) do
    %{
      exp: %{
        delete: "Delete on #{source}",
        scan: "Seq Scan on #{source}",
        update: "Update on #{source}"
      }
    }
  end

  @spec c_sql_select(context()) :: context_merge()
  defp c_sql_select(c) when is_map(c) do
    %{
      params: [1],
      rows: [[1]],
      sql: %{
        select: "SELECT 1::integer",
        select_many: "SELECT 1::integer; SELECT 2::integer",
        select_params: "SELECT $1::integer",
        select_params_many: "SELECT $1::integer; SELECT $2::integer"
      }
    }
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

    setup [:sleep_on_exit, :c_conf_stop]

    test "success", %{conf: conf} do
      assert stop() == conf
    end
  end

  describe "stop/1" do
    @describetag supervisor: Repo
    import Repo, only: [stop: 1]

    setup [:sleep_on_exit, :c_conf_stop]

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

    setup [:checkout_repo, :c_fun_checkout]

    test "success", %{conf: conf, fun: fun} do
      assert checkout(fun) == conf
    end
  end

  describe "checkout/2" do
    import Repo, only: [checkout: 2]

    setup [:checkout_repo, :c_fun_checkout]

    test "success", %{conf: conf, fun: fun} do
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
  end

  describe "transaction/1" do
    import Repo, only: [transaction: 1]

    setup [:checkout_repo, :c_fun_transaction]

    test "fun/0", %{conf: %{greeting: conf}, fun: %{greeting: fun}} do
      assert transaction(fun) == conf
    end

    test "fun/1", %{conf: %{repo: conf}, fun: %{repo: fun}} do
      assert transaction(fun) == conf
    end
  end

  describe "transaction/2" do
    import Repo, only: [transaction: 2]

    setup [:checkout_repo, :c_fun_transaction]
    setup do: %{opt: []}

    test "fun/0", %{conf: %{greeting: conf}, fun: %{greeting: fun}, opt: opt} do
      assert transaction(fun, opt) == conf
    end

    test "fun/1", %{conf: %{repo: conf}, fun: %{repo: fun}, opt: opt} do
      assert transaction(fun, opt) == conf
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
    @describetag schema: TestSchema
    import Repo, only: [insert: 1]

    setup ~W[checkout_repo c_schema c_struct_built c_conf_loaded]a

    test "success", %{changeset: %{built: changeset}, conf: %{loaded: conf}} do
      assert insert(changeset) == conf
    end
  end

  describe "insert/2" do
    @describetag schema: TestSchema
    import Repo, only: [insert: 2]

    setup ~W[checkout_repo c_schema c_struct_built c_conf_loaded]a

    test "success", %{changeset: %{built: changeset}, conf: %{loaded: conf}} do
      assert insert(changeset, []) == conf
    end
  end

  describe "update/1" do
    @describetag schema: TestSchema
    import Repo, only: [update: 1]

    setup [
      :checkout_repo,
      :c_schema,
      :c_source,
      :c_struct_loaded,
      :c_struct_updated,
      :c_conf_updated
    ]

    test "success", %{
      changeset: %{loaded: changeset},
      conf: %{updated: conf}
    } do
      assert update(changeset) == conf
    end
  end

  describe "update/2" do
    @describetag schema: TestSchema
    import Repo, only: [update: 2]

    setup [
      :checkout_repo,
      :c_schema,
      :c_source,
      :c_struct_loaded,
      :c_struct_updated,
      :c_conf_updated
    ]

    test "success", %{
      changeset: %{loaded: changeset},
      conf: %{updated: conf}
    } do
      assert update(changeset, []) == conf
    end
  end

  describe "insert_or_update/1" do
    @describetag schema: TestSchema
    import Repo, only: [insert_or_update: 1]

    setup [
      :checkout_repo,
      :c_schema,
      :c_struct_built,
      :c_struct_updated,
      :c_conf_loaded,
      :c_conf_updated
    ]

    test "success", %{
      changeset: %{built: changeset, loaded: changeset!},
      conf: %{loaded: conf, updated: conf!}
    } do
      assert insert_or_update(changeset) == conf
      assert insert_or_update(changeset!) == conf!
    end
  end

  describe "insert_or_update/2" do
    @describetag schema: TestSchema
    import Repo, only: [insert_or_update: 2]

    setup [
      :checkout_repo,
      :c_schema,
      :c_struct_built,
      :c_struct_updated,
      :c_conf_loaded,
      :c_conf_updated
    ]

    test "success", %{
      changeset: %{built: changeset, loaded: changeset!},
      conf: %{loaded: conf, updated: conf!}
    } do
      assert insert_or_update(changeset, []) == conf
      assert insert_or_update(changeset!, []) == conf!
    end
  end

  describe "delete/1" do
    @describetag schema: TestSchema
    import Repo, only: [delete: 1]

    setup [
      :checkout_repo,
      :c_schema,
      :c_source,
      :c_struct_loaded,
      :c_struct_deleted,
      :c_conf_deleted
    ]

    test "success", %{conf: %{deleted: conf}, struct: %{loaded: struct}} do
      assert delete(struct) == conf
    end
  end

  describe "delete/2" do
    @describetag schema: TestSchema
    import Repo, only: [delete: 2]

    setup [
      :checkout_repo,
      :c_schema,
      :c_source,
      :c_struct_loaded,
      :c_struct_deleted,
      :c_conf_deleted
    ]

    test "success", %{conf: %{deleted: conf}, struct: %{loaded: struct}} do
      assert delete(struct, []) == conf
    end
  end

  describe "insert!/1" do
    @describetag schema: TestSchema
    import Repo, only: [insert!: 1]

    setup ~W[checkout_repo c_schema c_struct_built]a

    test "success", %{
      changeset: %{built: changeset},
      struct: %{loaded: struct}
    } do
      assert insert!(changeset) == struct
    end
  end

  describe "insert!/2" do
    @describetag schema: TestSchema
    import Repo, only: [insert!: 2]

    setup ~W[checkout_repo c_schema c_struct_built]a

    test "success", %{
      changeset: %{built: changeset},
      struct: %{loaded: struct}
    } do
      assert insert!(changeset, []) == struct
    end
  end

  describe "update!/1" do
    @describetag schema: TestSchema
    import Repo, only: [update!: 1]

    setup ~W[checkout_repo c_schema c_source c_struct_loaded c_struct_updated]a

    test "success", %{
      changeset: %{loaded: changeset},
      struct: %{updated: struct}
    } do
      assert update!(changeset) == struct
    end
  end

  describe "update!/2" do
    @describetag schema: TestSchema
    import Repo, only: [update!: 2]

    setup ~W[checkout_repo c_schema c_source c_struct_loaded c_struct_updated]a

    test "success", %{
      changeset: %{loaded: changeset},
      struct: %{updated: struct}
    } do
      assert update!(changeset, []) == struct
    end
  end

  describe "insert_or_update!/1" do
    @describetag schema: TestSchema
    import Repo, only: [insert_or_update!: 1]

    setup ~W[checkout_repo c_schema c_struct_built c_struct_updated]a

    test "success", %{
      changeset: %{built: changeset, loaded: changeset!},
      struct: %{loaded: struct, updated: struct!}
    } do
      assert insert_or_update!(changeset) == struct
      assert insert_or_update!(changeset!) == struct!
    end
  end

  describe "insert_or_update!/2" do
    @describetag schema: TestSchema
    import Repo, only: [insert_or_update!: 2]

    setup ~W[checkout_repo c_schema c_struct_built c_struct_updated]a

    test "success", %{
      changeset: %{built: changeset, loaded: changeset!},
      struct: %{loaded: struct, updated: struct!}
    } do
      assert insert_or_update!(changeset, []) == struct
      assert insert_or_update!(changeset!, []) == struct!
    end
  end

  describe "delete!/1" do
    @describetag schema: TestSchema
    import Repo, only: [delete!: 1]

    setup ~W[checkout_repo c_schema c_source c_struct_loaded c_struct_deleted]a

    test "success", %{struct: %{deleted: struct!, loaded: struct}} do
      assert delete!(struct) == struct!
    end
  end

  describe "delete!/2" do
    @describetag schema: TestSchema
    import Repo, only: [delete!: 2]

    setup ~W[checkout_repo c_schema c_source c_struct_loaded c_struct_deleted]a

    test "success", %{struct: %{deleted: struct!, loaded: struct}} do
      assert delete!(struct, []) == struct!
    end
  end

  describe "insert_all/2" do
    @describetag schema: TestSchema
    import Repo, only: [insert_all: 2]

    setup ~W[checkout_repo c_schema c_entries]a

    test "success", %{conf: conf, entries: entries, schema: schema} do
      assert insert_all(schema, entries) == conf
    end
  end

  describe "insert_all/3" do
    @describetag schema: TestSchema
    import Repo, only: [insert_all: 3]

    setup ~W[checkout_repo c_schema c_entries]a

    test "success", %{conf: conf, entries: entries, schema: schema} do
      assert insert_all(schema, entries, []) == conf
    end
  end

  describe "update_all/2" do
    @describetag schema: TestSchema
    import Repo, only: [update_all: 2]

    setup ~W[checkout_repo c_schema c_updates c_source c_count c_conf_count]a

    test "success", %{conf: conf, schema: schema, updates: updates} do
      assert update_all(schema, updates) == conf
    end
  end

  describe "update_all/3" do
    @describetag schema: TestSchema
    import Repo, only: [update_all: 3]

    setup ~W[checkout_repo c_schema c_updates c_source c_count c_conf_count]a

    test "success", %{conf: conf, schema: schema, updates: updates} do
      assert update_all(schema, updates, []) == conf
    end
  end

  describe "delete_all/1" do
    @describetag schema: TestSchema
    import Repo, only: [delete_all: 1]

    setup ~W[checkout_repo c_schema c_source c_count c_conf_count]a

    test "success", %{conf: conf, schema: schema} do
      assert delete_all(schema) == conf
    end
  end

  describe "delete_all/2" do
    @describetag schema: TestSchema
    import Repo, only: [delete_all: 2]

    setup ~W[checkout_repo c_schema c_source c_count c_conf_count]a

    test "success", %{conf: conf, schema: schema} do
      assert delete_all(schema, []) == conf
    end
  end

  describe "all/1" do
    @describetag schema: TestSchema
    import Repo, only: [all: 1]

    setup ~W[checkout_repo c_schema c_query_order c_source c_structs_loaded]a

    test "success", %{query: %{order: query}, structs: %{loaded: structs}} do
      assert all(query) == structs
    end
  end

  describe "all/2" do
    @describetag schema: TestSchema
    import Repo, only: [all: 2]

    setup ~W[checkout_repo c_schema c_query_order c_source c_structs_loaded]a

    test "success", %{query: %{order: query}, structs: %{loaded: structs}} do
      assert all(query, []) == structs
    end
  end

  describe "stream/1" do
    @describetag schema: TestSchema
    import Repo, only: [stream: 1]

    setup [
      :checkout_repo,
      :c_schema,
      :c_query_order,
      :c_source,
      :c_structs_loaded,
      :c_conf_structs
    ]

    test "success", %{conf: conf, query: %{order: query}} do
      assert Repo.transaction(fn -> Enum.to_list(stream(query)) end) == conf
    end
  end

  describe "stream/2" do
    @describetag schema: TestSchema
    import Repo, only: [stream: 2]

    setup [
      :checkout_repo,
      :c_schema,
      :c_query_order,
      :c_source,
      :c_structs_loaded,
      :c_conf_structs
    ]

    test "success", %{conf: conf, query: %{order: query}} do
      assert Repo.transaction(fn -> Enum.to_list(stream(query, [])) end) == conf
    end
  end

  describe "get/2" do
    @describetag schema: TestSchema
    import Repo, only: [get: 2]

    setup ~W[checkout_repo c_schema c_source c_struct_loaded]a

    test "success", %{schema: schema, struct: %{loaded: %{id: id} = struct}} do
      assert get(schema, id) == struct
    end
  end

  describe "get/3" do
    @describetag schema: TestSchema
    import Repo, only: [get: 3]

    setup ~W[checkout_repo c_schema c_source c_struct_loaded]a

    test "success", %{schema: schema, struct: %{loaded: %{id: id} = struct}} do
      assert get(schema, id, []) == struct
    end
  end

  describe "get!/2" do
    @describetag schema: TestSchema
    import Repo, only: [get!: 2]

    setup ~W[checkout_repo c_schema c_source c_struct_loaded]a

    test "success", %{schema: schema, struct: %{loaded: %{id: id} = struct}} do
      assert get!(schema, id) == struct
    end
  end

  describe "get!/3" do
    @describetag schema: TestSchema
    import Repo, only: [get!: 3]

    setup ~W[checkout_repo c_schema c_source c_struct_loaded]a

    test "success", %{schema: schema, struct: %{loaded: %{id: id} = struct}} do
      assert get!(schema, id, []) == struct
    end
  end

  describe "get_by/2" do
    @describetag schema: TestSchema
    import Repo, only: [get_by: 2]

    setup ~W[checkout_repo c_schema c_source c_struct_loaded c_clauses]a

    test "success", %{
      clauses: clauses,
      schema: schema,
      struct: %{loaded: struct}
    } do
      assert get_by(schema, clauses) == struct
    end
  end

  describe "get_by/3" do
    @describetag schema: TestSchema
    import Repo, only: [get_by: 3]

    setup ~W[checkout_repo c_schema c_source c_struct_loaded c_clauses]a

    test "success", %{
      clauses: clauses,
      schema: schema,
      struct: %{loaded: struct}
    } do
      assert get_by(schema, clauses, []) == struct
    end
  end

  describe "get_by!/2" do
    @describetag schema: TestSchema
    import Repo, only: [get_by!: 2]

    setup ~W[checkout_repo c_schema c_source c_struct_loaded c_clauses]a

    test "success", %{
      clauses: clauses,
      schema: schema,
      struct: %{loaded: struct}
    } do
      assert get_by!(schema, clauses) == struct
    end
  end

  describe "get_by!/3" do
    @describetag schema: TestSchema
    import Repo, only: [get_by!: 3]

    setup ~W[checkout_repo c_schema c_source c_struct_loaded c_clauses]a

    test "success", %{
      clauses: clauses,
      schema: schema,
      struct: %{loaded: struct}
    } do
      assert get_by!(schema, clauses, []) == struct
    end
  end

  describe "reload/1" do
    @describetag schema: TestSchema
    import Repo, only: [reload: 1]

    setup ~W[checkout_repo c_schema c_source c_struct_loaded c_struct_updated]a

    test "success", %{struct: %{loaded: struct!, updated: struct}} do
      assert reload(struct) == struct!
    end
  end

  describe "reload/2" do
    @describetag schema: TestSchema
    import Repo, only: [reload: 2]

    setup ~W[checkout_repo c_schema c_source c_struct_loaded c_struct_updated]a

    test "success", %{struct: %{loaded: struct!, updated: struct}} do
      assert reload(struct, []) == struct!
    end
  end

  describe "reload!/1" do
    @describetag schema: TestSchema
    import Repo, only: [reload!: 1]

    setup ~W[checkout_repo c_schema c_source c_struct_loaded c_struct_updated]a

    test "success", %{struct: %{loaded: struct!, updated: struct}} do
      assert reload!(struct) == struct!
    end
  end

  describe "reload!/2" do
    @describetag schema: TestSchema
    import Repo, only: [reload!: 2]

    setup ~W[checkout_repo c_schema c_source c_struct_loaded c_struct_updated]a

    test "success", %{struct: %{loaded: struct!, updated: struct}} do
      assert reload!(struct, []) == struct!
    end
  end

  describe "one/1" do
    @describetag schema: TestSchema
    import Repo, only: [one: 1]

    setup ~W[checkout_repo c_schema c_source c_struct_loaded c_query_where]a

    test "success", %{query: %{where: query}, struct: %{loaded: struct}} do
      assert one(query) == struct
    end
  end

  describe "one/2" do
    @describetag schema: TestSchema
    import Repo, only: [one: 2]

    setup ~W[checkout_repo c_schema c_source c_struct_loaded c_query_where]a

    test "success", %{query: %{where: query}, struct: %{loaded: struct}} do
      assert one(query, []) == struct
    end
  end

  describe "one!/1" do
    @describetag schema: TestSchema
    import Repo, only: [one!: 1]

    setup ~W[checkout_repo c_schema c_source c_struct_loaded c_query_where]a

    test "success", %{query: %{where: query}, struct: %{loaded: struct}} do
      assert one!(query) == struct
    end
  end

  describe "one!/2" do
    @describetag schema: TestSchema
    import Repo, only: [one!: 2]

    setup ~W[checkout_repo c_schema c_source c_struct_loaded c_query_where]a

    test "success", %{query: %{where: query}, struct: %{loaded: struct}} do
      assert one!(query, []) == struct
    end
  end

  describe "aggregate/2" do
    @describetag schema: TestSchema
    import Repo, only: [aggregate: 2]

    setup ~W[checkout_repo c_schema c_source c_count]a

    test "success", %{count: count, schema: schema} do
      assert aggregate(schema, :count) == count
    end
  end

  describe "aggregate/3 when is_list(opts)" do
    @describetag schema: TestSchema
    import Repo, only: [aggregate: 3]

    setup ~W[checkout_repo c_schema c_source c_count]a

    test "success", %{count: count, schema: schema} do
      assert aggregate(schema, :count, []) == count
    end
  end

  describe "aggregate/3 when is_atom(field)" do
    @describetag schema: TestSchema
    import Repo, only: [aggregate: 3]

    setup ~W[checkout_repo c_schema c_field c_source c_agg_field]a

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
    @describetag schema: TestSchema
    import Repo, only: [aggregate: 4]

    setup ~W[checkout_repo c_schema c_field c_source c_agg_field]a
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
    @describetag schema: TestSchema
    import Repo, only: [exists?: 1]

    setup [:checkout_repo, :c_schema]

    test "success", %{schema: schema} do
      assert exists?(schema)
    end
  end

  describe "exists?/2" do
    @describetag schema: TestSchema
    import Repo, only: [exists?: 2]

    setup [:checkout_repo, :c_schema]

    test "success", %{schema: schema} do
      assert exists?(schema, [])
    end
  end

  describe "preload/2" do
    import Repo, only: [preload: 2]

    setup ~W[c_schema c_struct_built c_assoc c_preload]a

    test "success", %{
      assoc: assoc,
      preload: preload,
      struct: %{loaded: struct}
    } do
      assert preload(struct, assoc) == preload
    end
  end

  describe "preload/3" do
    import Repo, only: [preload: 3]

    setup ~W[c_schema c_struct_built c_assoc c_preload]a

    test "success", %{
      assoc: assoc,
      preload: preload,
      struct: %{loaded: struct}
    } do
      assert preload(struct, assoc, []) == preload
    end
  end

  describe "prepare_query/3" do
    import Repo, only: [prepare_query: 3]

    setup ~W[c_schema c_query_order c_updates c_query_update]a

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

  describe "explain/2" do
    @describetag schema: TestSchema
    import Repo, only: [explain: 2]

    setup ~W[checkout_repo c_schema c_source c_updates c_query_update c_exp]a

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
    @describetag schema: TestSchema
    import Repo, only: [explain: 3]

    setup ~W[checkout_repo c_schema c_source c_updates c_query_update c_exp]a
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

  describe "query/1" do
    import Repo, only: [query: 1]

    setup [:checkout_repo, :c_sql_select]

    test "success", %{rows: rows, sql: %{select: sql}} do
      assert {:ok, %{rows: ^rows}} = query(sql)
    end
  end

  describe "query/2" do
    import Repo, only: [query: 2]

    setup [:checkout_repo, :c_sql_select]

    test "success", %{params: params, rows: rows, sql: %{select_params: sql}} do
      assert {:ok, %{rows: ^rows}} = query(sql, params)
    end
  end

  describe "query/3" do
    import Repo, only: [query: 3]

    setup [:checkout_repo, :c_sql_select]

    test "success", %{params: params, rows: rows, sql: %{select_params: sql}} do
      assert {:ok, %{rows: ^rows}} = query(sql, params, [])
    end
  end

  describe "query!/1" do
    import Repo, only: [query!: 1]

    setup [:checkout_repo, :c_sql_select]

    test "success", %{rows: rows, sql: %{select: sql}} do
      assert %{rows: ^rows} = query!(sql)
    end
  end

  describe "query!/2" do
    import Repo, only: [query!: 2]

    setup [:checkout_repo, :c_sql_select]

    test "success", %{params: params, rows: rows, sql: %{select_params: sql}} do
      assert %{rows: ^rows} = query!(sql, params)
    end
  end

  describe "query!/3" do
    import Repo, only: [query!: 3]

    setup [:checkout_repo, :c_sql_select]

    test "success", %{params: params, rows: rows, sql: %{select_params: sql}} do
      assert %{rows: ^rows} = query!(sql, params, [])
    end
  end

  describe "query_many/1" do
    import Repo, only: [query_many: 1]

    setup [:checkout_repo, :c_sql_select]

    test "RuntimeError", %{sql: %{select_many: sql}} do
      assert_raise RuntimeError, fn -> query_many(sql) end
    end
  end

  describe "query_many/2" do
    import Repo, only: [query_many: 2]

    setup [:checkout_repo, :c_sql_select]

    test "RuntimeError", %{params: params, sql: %{select_params_many: sql}} do
      assert_raise RuntimeError, fn -> query_many(sql, params) end
    end
  end

  describe "query_many/3" do
    import Repo, only: [query_many: 3]

    setup [:checkout_repo, :c_sql_select]

    test "RuntimeError", %{params: params, sql: %{select_params_many: sql}} do
      assert_raise RuntimeError, fn -> query_many(sql, params, []) end
    end
  end

  describe "query_many!/1" do
    import Repo, only: [query_many!: 1]

    setup [:checkout_repo, :c_sql_select]

    test "RuntimeError", %{sql: %{select_many: sql}} do
      assert_raise RuntimeError, fn -> query_many!(sql) end
    end
  end

  describe "query_many!/2" do
    import Repo, only: [query_many!: 2]

    setup [:checkout_repo, :c_sql_select]

    test "RuntimeError", %{params: params, sql: %{select_params_many: sql}} do
      assert_raise RuntimeError, fn -> query_many!(sql, params) end
    end
  end

  describe "query_many!/3" do
    import Repo, only: [query_many!: 3]

    setup [:checkout_repo, :c_sql_select]

    test "RuntimeError", %{params: params, sql: %{select_params_many: sql}} do
      assert_raise RuntimeError, fn -> query_many!(sql, params, []) end
    end
  end

  describe "to_sql/2" do
    import Repo, only: [to_sql: 2]

    setup ~W[c_schema c_source c_updates c_query_update]a
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
