defmodule DiacriticalSchema.TestSchemaTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.9.0"

  use ExUnit.Case, async: true

  alias DiacriticalCase
  alias DiacriticalSchema

  alias DiacriticalSchema.TestSchema

  @typedoc "Represents the context."
  @typedoc since: "0.9.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.9.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_struct(context()) :: context_merge()
  defp c_struct(c) when is_map(c) do
    %{
      struct: %{
        __meta__: %Ecto.Schema.Metadata{
          schema: TestSchema,
          source: "test_schema",
          state: :built
        },
        __struct__: TestSchema,
        id: nil,
        parent_id: nil,
        test_schema: %Ecto.Association.NotLoaded{
          __cardinality__: :one,
          __field__: :test_schema,
          __owner__: TestSchema
        },
        x: nil
      }
    }
  end

  @spec c_assoc(context()) :: context_merge()
  defp c_assoc(c) when is_map(c) do
    %{
      assoc: %{
        test_schema: %Ecto.Association.BelongsTo{
          field: :test_schema,
          on_replace: :raise,
          owner: TestSchema,
          owner_key: :parent_id,
          queryable: TestSchema,
          related: TestSchema,
          related_key: :id
        }
      }
    }
  end

  describe "__struct__/0" do
    import TestSchema, only: [__struct__: 0]

    setup :c_struct

    test "success", %{struct: struct} do
      assert __struct__() == struct
    end
  end

  describe "__struct__/1" do
    import TestSchema, only: [__struct__: 1]

    setup :c_struct

    test "success", %{struct: struct} do
      assert __struct__(%{}) == struct
    end
  end

  describe "__changeset__/0" do
    import TestSchema, only: [__changeset__: 0]

    setup :c_assoc

    test "success", %{assoc: assoc} do
      assert __changeset__() == %{
               id: Ecto.UUID,
               parent_id: Ecto.UUID,
               test_schema: {:assoc, assoc.test_schema},
               x: :integer
             }
    end
  end

  describe "__schema__/1" do
    import TestSchema, only: [__schema__: 1]

    setup :c_struct

    test ":query" do
      assert __schema__(:query) == %Ecto.Query{
               from: %Ecto.Query.FromExpr{source: {"test_schema", TestSchema}}
             }
    end

    test ":source" do
      assert __schema__(:source) == "test_schema"
    end

    test ":prefix" do
      assert __schema__(:prefix) == nil
    end

    test ":dump" do
      assert __schema__(:dump) == %{
               id: {:id, Ecto.UUID, :always},
               parent_id: {:parent_id, Ecto.UUID, :always},
               x: {:x, :integer, :always}
             }
    end

    test ":load" do
      assert __schema__(:load) ==
               [id: Ecto.UUID, x: :integer, parent_id: Ecto.UUID]
    end

    test ":associations" do
      assert __schema__(:associations) == [:test_schema]
    end

    test ":embeds" do
      assert __schema__(:embeds) == []
    end

    test ":updatable_fields" do
      assert __schema__(:updatable_fields) == {~W[parent_id x id]a, []}
    end

    test ":insertable_fields" do
      assert __schema__(:insertable_fields) == {~W[parent_id x id]a, []}
    end

    test ":redact_fields" do
      assert __schema__(:redact_fields) == []
    end

    test ":autogenerate_fields" do
      assert __schema__(:autogenerate_fields) == []
    end

    test ":virtual_fields" do
      assert __schema__(:virtual_fields) == []
    end

    test ":fields" do
      assert __schema__(:fields) == ~W[id x parent_id]a
    end

    test ":query_fields" do
      assert __schema__(:query_fields) == ~W[id x parent_id]a
    end

    test ":primary_key" do
      assert __schema__(:primary_key) == [:id]
    end

    test ":hash" do
      assert __schema__(:hash) == 108_285_710
    end

    test ":read_after_writes" do
      assert __schema__(:read_after_writes) == [:id, :x]
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

    test ":loaded", %{struct: struct} do
      assert __schema__(:loaded) == Ecto.put_meta(struct, state: :loaded)
    end
  end

  describe "__schema__/2" do
    import TestSchema, only: [__schema__: 2]

    setup :c_assoc

    test ":field_source, field" do
      assert __schema__(:field_source, :id) == :id
      assert __schema__(:field_source, :x) == :x
      assert __schema__(:field_source, :parent_id) == :parent_id
      assert __schema__(:field_source, :field) == nil
    end

    test ":type, field" do
      assert __schema__(:type, :id) == Ecto.UUID
      assert __schema__(:type, :x) == :integer
      assert __schema__(:type, :parent_id) == Ecto.UUID
      assert __schema__(:type, :field) == nil
    end

    test ":virtual_type, field" do
      assert __schema__(:virtual_type, :field) == nil
    end

    test ":association, schema", %{assoc: assoc} do
      assert __schema__(:association, :test_schema) == assoc.test_schema
      assert __schema__(:association, :schema) == nil
    end

    test ":embed, schema" do
      assert __schema__(:embed, :schema) == nil
    end
  end
end
