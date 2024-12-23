defmodule DiacriticalCase.RepoTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.10.0"

  use DiacriticalCase.Template, async: true

  alias Diacritical
  alias DiacriticalCase

  alias DiacriticalCase.Repo

  @typedoc "Represents the context."
  @typedoc since: "0.17.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.17.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec checkout_core(context()) :: context_merge()
  defp checkout_core(c) when is_map(c) do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Diacritical.Repo)
  end

  doctest Repo, import: true

  describe "__ex_unit__/2" do
    setup :c_context

    test ":setup", %{context: %{valid: context}} do
      assert Repo.__ex_unit__(:setup, context) == context
    end

    test ":setup_all", %{context: %{valid: context}} do
      assert Repo.__ex_unit__(:setup_all, context) == context
    end
  end

  describe "c_account/0" do
    import Repo, only: [c_account: 0]

    test "success" do
      assert %{account: _account} = c_account()
    end
  end

  describe "c_account/1" do
    import Repo, only: [c_account: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_account(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{account: _account} = c_account(context)
    end
  end

  describe "c_data_email/0" do
    import Repo, only: [c_data_email: 0]

    test "success" do
      assert %{email: _email} = c_data_email()
    end
  end

  describe "c_data_email/1" do
    import Repo, only: [c_data_email: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_data_email(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{email: _email} = c_data_email(context)
    end
  end

  describe "c_data_password/0" do
    import Repo, only: [c_data_password: 0]

    test "success" do
      assert %{password: _password} = c_data_password()
    end
  end

  describe "c_data_password/1" do
    import Repo, only: [c_data_password: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_data_password(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{password: _password} = c_data_password(context)
    end
  end

  describe "c_data_slug/0" do
    import Repo, only: [c_data_slug: 0]

    test "success" do
      assert %{slug: _slug} = c_data_slug()
    end
  end

  describe "c_data_slug/1" do
    import Repo, only: [c_data_slug: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_data_slug(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{slug: _slug} = c_data_slug(context)
    end
  end

  describe "c_param_account/0" do
    import Repo, only: [c_param_account: 0]

    test "success" do
      assert %{param: _param} = c_param_account()
    end
  end

  describe "c_param_account/1" do
    import Repo, only: [c_param_account: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_param_account(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{param: _param} = c_param_account(context)
    end
  end

  describe "c_param_token/0" do
    import Repo, only: [c_param_token: 0]

    test "success" do
      assert %{param: _param} = c_param_token()
    end
  end

  describe "c_param_token/1" do
    import Repo, only: [c_param_token: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_param_token(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{param: _param} = c_param_token(context)
    end
  end

  describe "c_token_loaded/0" do
    import Repo, only: [c_token_loaded: 0]

    setup :checkout_core

    test "success" do
      assert %{token: %{loaded: _token}} = c_token_loaded()
    end
  end

  describe "c_token_loaded/1" do
    import Repo, only: [c_token_loaded: 1]

    setup [:checkout_core, :c_context]

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_token_loaded(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{token: %{loaded: _token}} = c_token_loaded(context)
    end
  end

  describe "checkout_repo/0" do
    import Repo, only: [checkout_repo: 0]

    test "success" do
      assert checkout_repo() == :ok
    end
  end

  describe "checkout_repo/1" do
    import Repo, only: [checkout_repo: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> checkout_repo(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert checkout_repo(context) == :ok
    end
  end
end
