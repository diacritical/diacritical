defmodule DiacriticalCase.RepoTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.10.0"

  use DiacriticalCase.Template, async: true

  alias DiacriticalCase

  alias DiacriticalCase.Repo

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

    setup do
      %{
        context: %{
          invalid: %{password: %{correct: ~C""}},
          valid: %{password: %{correct: ""}}
        }
      }
    end

    test "ArgumentError", %{context: %{invalid: context}} do
      assert_raise ArgumentError, fn -> c_account(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{account: _account} = c_account(context)
    end
  end

  describe "c_password/0" do
    import Repo, only: [c_password: 0]

    test "success" do
      assert %{password: _password} = c_password()
    end
  end

  describe "c_password/1" do
    import Repo, only: [c_password: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_password(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{password: _password} = c_password(context)
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
