defmodule DiacriticalCase.ViewTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.5.0"

  use DiacriticalCase.Template, async: true

  alias DiacriticalCase

  alias DiacriticalCase.View

  doctest View, import: true

  describe "__ex_unit__/2" do
    setup :c_context

    test ":setup", %{context: %{valid: context}} do
      assert View.__ex_unit__(:setup, context) == context
    end

    test ":setup_all", %{context: %{valid: context}} do
      assert View.__ex_unit__(:setup_all, context) == context
    end
  end

  describe "c_assigns/0" do
    import View, only: [c_assigns: 0]

    test "success" do
      assert %{assigns: _assigns} = c_assigns()
    end
  end

  describe "c_assigns/1" do
    import View, only: [c_assigns: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_assigns(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{assigns: _assigns} = c_assigns(context)
    end
  end

  describe "c_resp_body/0" do
    import View, only: [c_resp_body: 0]

    test "success" do
      assert %{resp_body: _resp_body} = c_resp_body()
    end
  end

  describe "c_resp_body/1" do
    import View, only: [c_resp_body: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_resp_body(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{resp_body: _resp_body} = c_resp_body(context)
    end
  end
end
