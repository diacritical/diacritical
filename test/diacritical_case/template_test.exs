defmodule DiacriticalCase.TemplateTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.5.0"

  use DiacriticalCase.Template, async: true

  alias DiacriticalCase

  alias DiacriticalCase.Template

  doctest Template, import: true

  describe "__ex_unit__/2" do
    setup :c_context

    test ":setup", %{context: %{valid: context}} do
      assert Template.__ex_unit__(:setup, context) == context
    end

    test ":setup_all", %{context: %{valid: context}} do
      assert Template.__ex_unit__(:setup_all, context) == context
    end
  end

  describe "c_context/0" do
    import Template, only: [c_context: 0]

    test "success" do
      assert %{context: _context} = c_context()
    end
  end

  describe "c_context/1" do
    import Template, only: [c_context: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_context(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{context: _context} = c_context(context)
    end
  end
end
