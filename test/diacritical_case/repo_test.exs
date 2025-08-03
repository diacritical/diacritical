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
