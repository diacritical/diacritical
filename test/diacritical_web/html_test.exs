defmodule DiacriticalWeb.HTMLTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.6.0"

  use DiacriticalCase.View, async: true

  alias DiacriticalCase
  alias DiacriticalWeb

  alias DiacriticalWeb.HTML

  @typedoc "Represents the context."
  @typedoc since: "0.6.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.6.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_resp_body_to_html(context()) :: context_merge()
  defp c_resp_body_to_html(%{resp_body: resp_body}) when is_binary(resp_body) do
    %{resp_body: {:safe, ["<span>", String.trim(resp_body), "</span>\n"]}}
  end

  doctest HTML

  describe "embed_templates/1" do
    import HTML, only: [embed_templates: 1]

    embed_templates "../../support/diacritical_web/html/template/greet"

    setup ~W[c_assigns c_resp_body_greeting c_resp_body_to_html]a

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

    setup ~W[c_assigns c_resp_body_dismissal c_resp_body_to_html]a

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
