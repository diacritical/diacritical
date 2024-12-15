defmodule DiacriticalSchema.AccountTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.14.0"

  use ExUnit.Case, async: true

  alias DiacriticalCase
  alias DiacriticalSchema

  alias DiacriticalSchema.Account

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
        updated_at: nil
      }
    }
  end

  describe "__struct__/0" do
    import Account, only: [__struct__: 0]

    setup :c_struct

    test "success", %{struct: struct} do
      assert __struct__() == struct
    end
  end

  describe "__struct__/1" do
    import Account, only: [__struct__: 1]

    setup :c_struct

    test "success", %{struct: struct} do
      assert __struct__(%{}) == struct
    end
  end

  describe "__changeset__/0" do
    import Account, only: [__changeset__: 0]

    test "success" do
      assert __changeset__() == %{
               confirmed_at: :utc_datetime_usec,
               deleted_at: :utc_datetime_usec,
               email: :string,
               id: Ecto.UUID,
               inserted_at: :utc_datetime_usec,
               password: :string,
               password_digest: :string,
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
      assert __schema__(:read_after_writes) == ~w[id inserted_at updated_at]a
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
      assert __schema__(:associations) == []
    end

    test ":embeds" do
      assert __schema__(:embeds) == []
    end

    test ":updatable_fields" do
      assert __schema__(:updatable_fields) == {
               [
                 :deleted_at,
                 :updated_at,
                 :inserted_at,
                 :confirmed_at,
                 :password_digest,
                 :email,
                 :id
               ],
               []
             }
    end

    test ":insertable_fields" do
      assert __schema__(:insertable_fields) == {
               [
                 :deleted_at,
                 :updated_at,
                 :inserted_at,
                 :confirmed_at,
                 :password_digest,
                 :email,
                 :id
               ],
               []
             }
    end
  end

  describe "__schema__/2" do
    import Account, only: [__schema__: 2]

    test ":field_source, field" do
      assert __schema__(:field_source, :id) == :id
      assert __schema__(:field_source, :email) == :email
      assert __schema__(:field_source, :password) == nil
      assert __schema__(:field_source, :password_digest) == :password_digest
      assert __schema__(:field_source, :confirmed_at) == :confirmed_at
      assert __schema__(:field_source, :inserted_at) == :inserted_at
      assert __schema__(:field_source, :updated_at) == :updated_at
      assert __schema__(:field_source, :deleted_at) == :deleted_at
      assert __schema__(:field_source, :field) == nil
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
      assert __schema__(:type, :field) == nil
    end

    test ":virtual_type, field" do
      assert __schema__(:virtual_type, :password) == :string
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
