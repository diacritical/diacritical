defmodule DiacriticalWeb.TXT.PageTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.5.0"

  use DiacriticalCase.View, async: true

  alias DiacriticalWeb

  alias DiacriticalWeb.TXT

  alias TXT.Page

  describe "__mix_recompile__?/0" do
    import Page, only: [__mix_recompile__?: 0]

    test "failure" do
      refute __mix_recompile__?()
    end
  end

  describe "__phoenix_verify_routes__/1" do
    import Page, only: [__phoenix_verify_routes__: 1]

    test "success" do
      assert __phoenix_verify_routes__(Page) == :ok
    end
  end

  describe "greet/1" do
    import Page, only: [greet: 1]

    setup [:c_assigns_greeting, :c_resp_body_greeting]

    test "FunctionClauseError", %{assigns: %{invalid: assigns}} do
      assert_raise FunctionClauseError, fn -> greet(assigns) end
    end

    test "success", %{assigns: %{valid: assigns}, resp_body: resp_body} do
      assert function_exported?(Page, :greet, 1)
      assert greet(assigns) == resp_body
    end
  end
end
