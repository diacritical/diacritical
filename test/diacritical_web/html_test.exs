defmodule DiacriticalWeb.HTMLTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.6.0"

  use DiacriticalCase.View, async: true

  alias DiacriticalWeb

  alias DiacriticalWeb.HTML

  doctest HTML

  describe "embed_templates/1" do
    import HTML, only: [embed_templates: 1]

    embed_templates "../../support/diacritical_web/html/template/greet"

    setup ~W[c_assigns_greeting c_resp_body_greet c_resp_body_to_html]a

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
    import HTML, only: [embed_templates: 2]

    embed_templates "template/dismiss",
      root: "../../support/diacritical_web/html"

    setup ~W[c_assigns_greeting c_resp_body_dismiss c_resp_body_to_html]a

    test "CompileError" do
      refute function_exported?(__MODULE__, :ignore, 1)
    end

    test "FunctionClauseError", %{assigns: %{invalid: assigns}} do
      assert_raise FunctionClauseError, fn -> dismiss(assigns) end
    end

    test "success", %{assigns: %{valid: assigns}, resp_body: resp_body} do
      assert function_exported?(__MODULE__, :dismiss, 1)
      assert dismiss(assigns) == resp_body
    end
  end
end
