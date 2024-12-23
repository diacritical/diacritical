defmodule DiacriticalSchema.ChangesetTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.14.0"

  use DiacriticalCase.Repo, async: true

  alias DiacriticalCase
  alias DiacriticalSchema

  alias DiacriticalSchema.Changeset

  @typedoc "Represents the context."
  @typedoc since: "0.14.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.14.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_changeset_digest(context()) :: context_merge()
  defp c_changeset_digest(c) when is_map(c) do
    %{password: %{correct: password}} = c_data_password()

    changeset =
      Ecto.Changeset.change(
        {
          %{password: nil, password_digest: nil},
          %{password: :string, password_digest: :string}
        },
        %{password: password}
      )

    %{
      changeset: %{
        digestible: changeset,
        indigestible: %{changeset | valid?: false},
        invalid: %{}
      }
    }
  end

  @spec c_key_password(context()) :: context_merge()
  defp c_key_password(c) when is_map(c) do
    %{key: %{invalid: "password", valid: :password}}
  end

  @spec c_changeset_argon2(context()) :: context_merge()
  defp c_changeset_argon2(c) when is_map(c) do
    data = {%{password_digest: nil}, %{password_digest: :string}}
    message = "correct horse battery staple"

    %{
      changeset: %{
        digested:
          Ecto.Changeset.change(
            data,
            %{password_digest: Argon2.hash_pwd_salt(message)}
          ),
        invalid: %{},
        undigested: Ecto.Changeset.change(data, %{password_digest: message})
      }
    }
  end

  @spec c_changeset_email(context()) :: context_merge()
  defp c_changeset_email(c) when is_map(c) do
    data = {%{email: nil}, %{email: :string}}
    %{email: %{addressed: email, unaddressed: email!}} = c_data_email()

    %{
      changeset: %{
        addressed: Ecto.Changeset.change(data, %{email: email}),
        invalid: %{},
        unaddressed: Ecto.Changeset.change(data, %{email: email!})
      }
    }
  end

  @spec c_changeset_password(context()) :: context_merge()
  defp c_changeset_password(c) when is_map(c) do
    data = {%{password: nil}, %{password: :string}}
    %{password: %{correct: password, incorrect: password!}} = c_data_password()

    %{
      changeset: %{
        goldilocks: Ecto.Changeset.change(data, %{password: password}),
        invalid: %{},
        long:
          Ecto.Changeset.change(
            data,
            %{password: Enum.reduce(1..129, "", fn _i, acc -> "-#{acc}" end)}
          ),
        short: Ecto.Changeset.change(data, %{password: password!})
      }
    }
  end

  @spec c_changeset_slug(context()) :: context_merge()
  defp c_changeset_slug(c) when is_map(c) do
    data = {%{slug: nil}, %{slug: :string}}
    %{slug: %{slugified: slug, unslugified: slug!}} = c_data_slug()

    %{
      changeset: %{
        invalid: %{},
        slugified: Ecto.Changeset.change(data, %{slug: slug}),
        unslugified: Ecto.Changeset.change(data, %{slug: slug!})
      }
    }
  end

  doctest Changeset, import: true

  describe "put_digest/1" do
    import Changeset, only: [put_digest: 1]

    setup :c_changeset_digest

    test "FunctionClauseError", %{changeset: %{invalid: changeset}} do
      assert_raise FunctionClauseError, fn -> put_digest(changeset) end
    end

    test "indigestible", %{changeset: %{indigestible: changeset}} do
      assert put_digest(changeset) == changeset
    end

    test "digestible", %{changeset: %{digestible: changeset}} do
      assert %Ecto.Changeset{changes: %{password_digest: _digest}} =
               put_digest(changeset)
    end
  end

  describe "put_digest/2" do
    import Changeset, only: [put_digest: 2]

    setup [:c_changeset_digest, :c_key_password]

    test "FunctionClauseError (&1)", %{
      changeset: %{invalid: changeset},
      key: %{valid: key}
    } do
      assert_raise FunctionClauseError, fn -> put_digest(changeset, key) end
    end

    test "FunctionClauseError (&2)", %{
      changeset: %{digestible: changeset},
      key: %{invalid: key}
    } do
      assert_raise FunctionClauseError, fn -> put_digest(changeset, key) end
    end

    test "indigestible", %{
      changeset: %{indigestible: changeset},
      key: %{valid: key}
    } do
      assert put_digest(changeset, key) == changeset
    end

    test "digestible", %{
      changeset: %{digestible: changeset},
      key: %{valid: key}
    } do
      assert %Ecto.Changeset{changes: %{password_digest: _digest}} =
               put_digest(changeset, key)
    end
  end

  describe "put_digest/3" do
    import Changeset, only: [put_digest: 3]

    setup [:c_changeset_digest, :c_key_password]

    setup do
      %{digest_key: %{invalid: "password_digest", valid: :password_digest}}
    end

    test "FunctionClauseError (&1)", %{
      changeset: %{invalid: changeset},
      digest_key: %{valid: digest_key},
      key: %{valid: key}
    } do
      assert_raise FunctionClauseError, fn ->
        put_digest(changeset, key, digest_key)
      end
    end

    test "FunctionClauseError (&2)", %{
      changeset: %{digestible: changeset},
      digest_key: %{valid: digest_key},
      key: %{invalid: key}
    } do
      assert_raise FunctionClauseError, fn ->
        put_digest(changeset, key, digest_key)
      end
    end

    test "FunctionClauseError (&3)", %{
      changeset: %{digestible: changeset},
      digest_key: %{invalid: digest_key},
      key: %{valid: key}
    } do
      assert_raise FunctionClauseError, fn ->
        put_digest(changeset, key, digest_key)
      end
    end

    test "indigestible", %{
      changeset: %{indigestible: changeset},
      digest_key: %{valid: digest_key},
      key: %{valid: key}
    } do
      assert put_digest(changeset, key, digest_key) == changeset
    end

    test "digestible", %{
      changeset: %{digestible: changeset},
      digest_key: %{valid: digest_key},
      key: %{valid: key}
    } do
      assert %Ecto.Changeset{changes: %{password_digest: _digest}} =
               put_digest(changeset, key, digest_key)
    end
  end

  describe "validate_argon2/1" do
    import Changeset, only: [validate_argon2: 1]

    setup :c_changeset_argon2

    test "FunctionClauseError", %{changeset: %{invalid: changeset}} do
      assert_raise FunctionClauseError, fn -> validate_argon2(changeset) end
    end

    test "failure", %{changeset: %{undigested: changeset}} do
      refute validate_argon2(changeset).valid?
    end

    test "success", %{changeset: %{digested: changeset}} do
      assert validate_argon2(changeset).valid?
    end
  end

  describe "validate_argon2/2" do
    import Changeset, only: [validate_argon2: 2]

    setup :c_changeset_argon2
    setup do: %{key: %{invalid: "password_digest", valid: :password_digest}}

    test "FunctionClauseError (&1)", %{
      changeset: %{invalid: changeset},
      key: %{valid: key}
    } do
      assert_raise FunctionClauseError, fn ->
        validate_argon2(changeset, key)
      end
    end

    test "FunctionClauseError (&2)", %{
      changeset: %{digested: changeset},
      key: %{invalid: key}
    } do
      assert_raise FunctionClauseError, fn ->
        validate_argon2(changeset, key)
      end
    end

    test "failure", %{
      changeset: %{undigested: changeset},
      key: %{valid: key}
    } do
      refute validate_argon2(changeset, key).valid?
    end

    test "success", %{changeset: %{digested: changeset}, key: %{valid: key}} do
      assert validate_argon2(changeset, key).valid?
    end
  end

  describe "validate_email/1" do
    import Changeset, only: [validate_email: 1]

    setup :c_changeset_email

    test "FunctionClauseError", %{changeset: %{invalid: changeset}} do
      assert_raise FunctionClauseError, fn -> validate_email(changeset) end
    end

    test "failure", %{changeset: %{unaddressed: changeset}} do
      refute validate_email(changeset).valid?
    end

    test "success", %{changeset: %{addressed: changeset}} do
      assert validate_email(changeset).valid?
    end
  end

  describe "validate_email/2" do
    import Changeset, only: [validate_email: 2]

    setup :c_changeset_email
    setup do: %{key: %{invalid: "email", valid: :email}}

    test "FunctionClauseError (&1)", %{
      changeset: %{invalid: changeset},
      key: %{valid: key}
    } do
      assert_raise FunctionClauseError, fn -> validate_email(changeset, key) end
    end

    test "FunctionClauseError (&2)", %{
      changeset: %{addressed: changeset},
      key: %{invalid: key}
    } do
      assert_raise FunctionClauseError, fn -> validate_email(changeset, key) end
    end

    test "failure", %{
      changeset: %{unaddressed: changeset},
      key: %{valid: key}
    } do
      refute validate_email(changeset, key).valid?
    end

    test "success", %{changeset: %{addressed: changeset}, key: %{valid: key}} do
      assert validate_email(changeset, key).valid?
    end
  end

  describe "validate_password/1" do
    import Changeset, only: [validate_password: 1]

    setup :c_changeset_password

    test "FunctionClauseError", %{changeset: %{invalid: changeset}} do
      assert_raise FunctionClauseError, fn -> validate_password(changeset) end
    end

    test "short", %{changeset: %{short: changeset}} do
      refute validate_password(changeset).valid?
    end

    test "long", %{changeset: %{long: changeset}} do
      refute validate_password(changeset).valid?
    end

    test "success", %{changeset: %{goldilocks: changeset}} do
      assert validate_password(changeset).valid?
    end
  end

  describe "validate_password/2" do
    import Changeset, only: [validate_password: 2]

    setup [:c_changeset_password, :c_key_password]

    test "FunctionClauseError (&1)", %{
      changeset: %{invalid: changeset},
      key: %{valid: key}
    } do
      assert_raise FunctionClauseError, fn ->
        validate_password(changeset, key)
      end
    end

    test "FunctionClauseError (&2)", %{
      changeset: %{goldilocks: changeset},
      key: %{invalid: key}
    } do
      assert_raise FunctionClauseError, fn ->
        validate_password(changeset, key)
      end
    end

    test "short", %{changeset: %{short: changeset}, key: %{valid: key}} do
      refute validate_password(changeset, key).valid?
    end

    test "long", %{changeset: %{long: changeset}, key: %{valid: key}} do
      refute validate_password(changeset, key).valid?
    end

    test "success", %{
      changeset: %{goldilocks: changeset},
      key: %{valid: key}
    } do
      assert validate_password(changeset, key).valid?
    end
  end

  describe "validate_slug/1" do
    import Changeset, only: [validate_slug: 1]

    setup :c_changeset_slug

    test "FunctionClauseError", %{changeset: %{invalid: changeset}} do
      assert_raise FunctionClauseError, fn -> validate_slug(changeset) end
    end

    test "failure", %{changeset: %{unslugified: changeset}} do
      refute validate_slug(changeset).valid?
    end

    test "success", %{changeset: %{slugified: changeset}} do
      assert validate_slug(changeset).valid?
    end
  end

  describe "validate_slug/2" do
    import Changeset, only: [validate_slug: 2]

    setup :c_changeset_slug
    setup do: %{key: %{invalid: "slug", valid: :slug}}

    test "FunctionClauseError (&1)", %{
      changeset: %{invalid: changeset},
      key: %{valid: key}
    } do
      assert_raise FunctionClauseError, fn -> validate_slug(changeset, key) end
    end

    test "FunctionClauseError (&2)", %{
      changeset: %{slugified: changeset},
      key: %{invalid: key}
    } do
      assert_raise FunctionClauseError, fn -> validate_slug(changeset, key) end
    end

    test "failure", %{
      changeset: %{unslugified: changeset},
      key: %{valid: key}
    } do
      refute validate_slug(changeset, key).valid?
    end

    test "success", %{changeset: %{slugified: changeset}, key: %{valid: key}} do
      assert validate_slug(changeset, key).valid?
    end
  end
end
