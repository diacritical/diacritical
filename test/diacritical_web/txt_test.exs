defmodule DiacriticalWeb.TXTTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.5.0"

  use DiacriticalCase.View, async: true

  alias DiacriticalWeb

  alias DiacriticalWeb.TXT

  doctest TXT

  describe "embed_templates/1" do
    import TXT, only: [embed_templates: 1]

    embed_templates "../../support/diacritical_web/txt/template/greet"

    setup [:c_assigns, :c_resp_body]

    test "CompileError" do
      refute function_exported?(__MODULE__, :ignore, 1)
    end

    test "FunctionClauseError", %{assigns: %{invalid: assigns}} do
      assert_raise FunctionClauseError, fn -> greet(assigns) end
    end

    test "success", %{assigns: %{valid: assigns}, resp_body: resp_body} do
      assert function_exported?(__MODULE__, :greet, 1)
      assert greet(assigns) == resp_body
    end
  end

  describe "embed_templates/2" do
    import TXT, only: [embed_templates: 2]

    embed_templates "template/dismiss",
      root: "../../support/diacritical_web/txt"

    setup :c_assigns

    test "CompileError" do
      refute function_exported?(__MODULE__, :ignore, 1)
    end

    test "FunctionClauseError", %{assigns: %{invalid: assigns}} do
      assert_raise FunctionClauseError, fn -> dismiss(assigns) end
    end

    test "success", %{assigns: %{valid: assigns}} do
      assert function_exported?(__MODULE__, :dismiss, 1)
      assert dismiss(assigns) == "Goodbye, world!\n"
    end
  end
end
