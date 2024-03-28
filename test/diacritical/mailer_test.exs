defmodule Diacritical.MailerTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.14.0"

  use ExUnit.Case, async: true

  import Swoosh.TestAssertions

  alias Diacritical
  alias DiacriticalCase

  alias Diacritical.Mailer

  @typedoc "Represents the context."
  @typedoc since: "0.14.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.14.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_email(context()) :: context_merge()
  defp c_email(c) when is_map(c) do
    %{
      email: %{
        invalid: %{},
        set: %Swoosh.Email{from: {"John Doe", "jdoe@example.com"}},
        unset: %Swoosh.Email{}
      }
    }
  end

  @spec c_config(context()) :: context_merge()
  defp c_config(c) when is_map(c), do: %{config: %{invalid: %{}, valid: []}}

  describe "deliver/1" do
    import Mailer, only: [deliver: 1]

    setup :c_email

    test "FunctionClauseError", %{email: %{invalid: email}} do
      assert_raise FunctionClauseError, fn -> deliver(email) end
      refute_receive {:email, _email}
    end

    test "unset", %{email: %{unset: email}} do
      assert deliver(email) == {:error, :from_not_set}
      assert_email_not_sent(email)
    end

    test "success", %{email: %{set: email}} do
      assert deliver(email) == {:ok, %{}}
      assert_email_sent(email)
    end
  end

  describe "deliver/2" do
    import Mailer, only: [deliver: 2]

    setup [:c_email, :c_config]

    test "FunctionClauseError (&1)", %{
      config: %{valid: config},
      email: %{invalid: email}
    } do
      assert_raise FunctionClauseError, fn -> deliver(email, config) end
      refute_receive {:email, _email}
    end

    test "FunctionClauseError (&2)", %{
      config: %{invalid: config},
      email: %{set: email}
    } do
      assert_raise FunctionClauseError, fn -> deliver(email, config) end
      assert_email_not_sent(email)
    end

    test "unset", %{config: %{valid: config}, email: %{unset: email}} do
      assert deliver(email, config) == {:error, :from_not_set}
      assert_email_not_sent(email)
    end

    test "success", %{config: %{valid: config}, email: %{set: email}} do
      assert deliver(email, config) == {:ok, %{}}
      assert_email_sent(email)
    end
  end

  describe "deliver!/1" do
    import Mailer, only: [deliver!: 1]

    setup :c_email

    test "FunctionClauseError", %{email: %{invalid: email}} do
      assert_raise FunctionClauseError, fn -> deliver!(email) end
      refute_receive {:email, _email}
    end

    test "Swoosh.DeliveryError", %{email: %{unset: email}} do
      assert_raise Swoosh.DeliveryError, fn -> deliver!(email) end
      assert_email_not_sent(email)
    end

    test "success", %{email: %{set: email}} do
      assert deliver!(email) == %{}
      assert_email_sent(email)
    end
  end

  describe "deliver!/2" do
    import Mailer, only: [deliver!: 2]

    setup [:c_email, :c_config]

    test "FunctionClauseError (&1)", %{
      config: %{valid: config},
      email: %{invalid: email}
    } do
      assert_raise FunctionClauseError, fn -> deliver!(email, config) end
      refute_receive {:email, _email}
    end

    test "FunctionClauseError (&2)", %{
      config: %{invalid: config},
      email: %{set: email}
    } do
      assert_raise FunctionClauseError, fn -> deliver!(email, config) end
      assert_email_not_sent(email)
    end

    test "Swoosh.DeliveryError", %{
      config: %{valid: config},
      email: %{unset: email}
    } do
      assert_raise Swoosh.DeliveryError, fn -> deliver!(email, config) end
      assert_email_not_sent(email)
    end

    test "success", %{config: %{valid: config}, email: %{set: email}} do
      assert deliver!(email, config) == %{}
      assert_email_sent(email)
    end
  end

  describe "deliver_many/1" do
    import Mailer, only: [deliver_many: 1]

    setup :c_email

    test "success", %{email: %{set: email}} do
      assert deliver_many([email]) == {:ok, [%{}]}
      assert_receive {:emails, _emails}
    end
  end

  describe "deliver_many/2" do
    import Mailer, only: [deliver_many: 2]

    setup [:c_email, :c_config]

    test "FunctionClauseError", %{
      config: %{invalid: config},
      email: %{set: email}
    } do
      assert_raise FunctionClauseError, fn -> deliver_many([email], config) end
      refute_receive {:emails, _emails}
    end

    test "success", %{config: %{valid: config}, email: %{set: email}} do
      assert deliver_many([email], config) == {:ok, [%{}]}
      assert_receive {:emails, _emails}
    end
  end

  describe "validate_dependency/0" do
    import Mailer, only: [validate_dependency: 0]

    test "success" do
      assert validate_dependency() == :ok
    end
  end
end
