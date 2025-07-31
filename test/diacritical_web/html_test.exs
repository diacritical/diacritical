defmodule DiacriticalWeb.HTMLTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.6.0"

  use DiacriticalCase.View, async: true

  alias DiacriticalWeb

  alias DiacriticalWeb.HTML

  doctest HTML

  describe "embed_templates/1" do
    import HTML, only: [embed_templates: 1]

    embed_templates "../../support/diacritical_web/html/template/dismiss"

    setup ~W[c_assigns c_resp_body_dismissal c_resp_body_to_html]a

    test "CompileError" do
      refute function_exported?(__MODULE__, :ignore, 1)
    end

    test "Protocol.UndefinedError", %{assigns: %{invalid: assigns}} do
      assert_raise Protocol.UndefinedError, fn ->
        render_component(&dismiss/1, assigns)
      end
    end

    test "success", %{assigns: %{valid: assigns}, resp_body: resp_body} do
      assert function_exported?(__MODULE__, :dismiss, 1)
      assert render_component(&dismiss/1, assigns) == resp_body
    end
  end

  describe "embed_templates/2" do
    import HTML, only: [embed_templates: 2]

    embed_templates "page/greet",
      root: "../../lib/diacritical_web/html"

    setup ~W[c_assigns_greeting c_resp_body_greeting c_resp_body_to_html]a

    test "CompileError" do
      refute function_exported?(__MODULE__, :ignore, 1)
    end

    test "Protocol.UndefinedError", %{assigns: %{invalid: assigns}} do
      assert_raise Protocol.UndefinedError, fn ->
        render_component(&greet/1, assigns)
      end
    end

    test "success", %{assigns: %{valid: assigns}, resp_body: resp_body} do
      assert function_exported?(__MODULE__, :greet, 1)
      assert render_component(&greet/1, assigns) == resp_body
    end
  end
end
