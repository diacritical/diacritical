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

  describe "c_resp_body_greet/0" do
    import View, only: [c_resp_body_greet: 0]

    test "success" do
      assert %{resp_body: _resp_body} = c_resp_body_greet()
    end
  end

  describe "c_resp_body_greet/1" do
    import View, only: [c_resp_body_greet: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_resp_body_greet(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{resp_body: _resp_body} = c_resp_body_greet(context)
    end
  end
end
