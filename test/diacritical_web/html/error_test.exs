defmodule DiacriticalWeb.HTML.ErrorTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.6.0"

  use DiacriticalCase.View, async: true

  alias DiacriticalWeb

  alias DiacriticalWeb.HTML

  alias HTML.Error

  describe "__mix_recompile__?/0" do
    import Error, only: [__mix_recompile__?: 0]

    test "failure" do
      refute __mix_recompile__?()
    end
  end

  describe "__phoenix_verify_routes__/1" do
    import Error, only: [__phoenix_verify_routes__: 1]

    test "success" do
      assert __phoenix_verify_routes__(Error) == :ok
    end
  end

  describe "404/1" do
    setup ~W[c_assigns c_resp_body_404 c_resp_body_to_html]a

    test "success", %{assigns: %{valid: assigns}, resp_body: resp_body} do
      assert function_exported?(Error, :"404", 1)
      assert Error."404"(assigns) == resp_body
    end
  end

  describe "500/1" do
    setup ~W[c_assigns c_resp_body_500 c_resp_body_to_html]a

    test "success", %{assigns: %{valid: assigns}, resp_body: resp_body} do
      assert function_exported?(Error, :"500", 1)
      assert Error."500"(assigns) == resp_body
    end
  end
end
