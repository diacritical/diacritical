defmodule DiacriticalSchema.OptionTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.22.0"

  use ExUnit.Case, async: true

  alias DiacriticalCase
  alias DiacriticalSchema

  alias DiacriticalSchema.Option

  @typedoc "Represents the context."
  @typedoc since: "0.22.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.22.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_struct(context()) :: context_merge()
  defp c_struct(c) when is_map(c) do
    %{
      struct: %{
        __meta__: %Ecto.Schema.Metadata{
          schema: Option,
          source: "option",
          state: :built
        },
        __struct__: Option,
        description: nil,
        id: nil,
        inserted_at: nil,
        key: nil,
        updated_at: nil,
        value: nil
      }
    }
  end

  describe "__struct__/0" do
    import Option, only: [__struct__: 0]

    setup :c_struct

    test "success", %{struct: struct} do
      assert __struct__() == struct
    end
  end

  describe "__struct__/1" do
    import Option, only: [__struct__: 1]

    setup :c_struct

    test "success", %{struct: struct} do
      assert __struct__(%{}) == struct
    end
  end

  describe "__changeset__/0" do
    import Option, only: [__changeset__: 0]

    test "success" do
      assert __changeset__() == %{
               description: :string,
               id: Ecto.UUID,
               inserted_at: :utc_datetime_usec,
               key: :string,
               updated_at: :utc_datetime_usec,
               value: :string
             }
    end
  end

  describe "__schema__/1" do
    import Option, only: [__schema__: 1]

    test ":prefix" do
      assert __schema__(:prefix) == nil
    end

    test ":source" do
      assert __schema__(:source) == "option"
    end

    test ":fields" do
      assert __schema__(:fields) ==
               ~W[id key value description inserted_at updated_at]a
    end

    test ":query_fields" do
      assert __schema__(:query_fields) ==
               ~W[id key value description inserted_at updated_at]a
    end

    test ":primary_key" do
      assert __schema__(:primary_key) == [:id]
    end

    test ":hash" do
      assert __schema__(:hash) == 75_806_050
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
      assert __schema__(:loaded) == Ecto.put_meta(%Option{}, state: :loaded)
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
               from: %Ecto.Query.FromExpr{source: {"option", Option}}
             }
    end

    test ":dump" do
      assert __schema__(:dump) == %{
               id: {:id, Ecto.UUID},
               inserted_at: {:inserted_at, :utc_datetime_usec},
               key: {:key, :string},
               description: {:description, :string},
               updated_at: {:updated_at, :utc_datetime_usec},
               value: {:value, :string}
             }
    end

    test ":load" do
      assert __schema__(:load) == [
               id: Ecto.UUID,
               key: :string,
               value: :string,
               description: :string,
               inserted_at: :utc_datetime_usec,
               updated_at: :utc_datetime_usec
             ]
    end

    test ":associations" do
      assert __schema__(:associations) == []
    end

    test ":embeds" do
      assert __schema__(:embeds) == []
    end
  end

  describe "__schema__/2" do
    import Option, only: [__schema__: 2]

    test ":field_source, field" do
      assert __schema__(:field_source, :id) == :id
      assert __schema__(:field_source, :key) == :key
      assert __schema__(:field_source, :value) == :value
      assert __schema__(:field_source, :description) == :description
      assert __schema__(:field_source, :inserted_at) == :inserted_at
      assert __schema__(:field_source, :updated_at) == :updated_at
    end

    test ":type, field" do
      assert __schema__(:type, :id) == Ecto.UUID
      assert __schema__(:type, :key) == :string
      assert __schema__(:type, :value) == :string
      assert __schema__(:type, :description) == :string
      assert __schema__(:type, :inserted_at) == :utc_datetime_usec
      assert __schema__(:type, :updated_at) == :utc_datetime_usec
    end

    test ":virtual_type, field" do
      assert __schema__(:virtual_type, :field) == nil
    end

    test ":association, assoc" do
      assert __schema__(:association, :field) == nil
    end

    test ":embed, embed" do
      assert __schema__(:embed, :field) == nil
    end
  end
end
