defmodule DiacriticalWeb.HTML.ErrorTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.5.0"

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
    setup :c_assigns_empty

    test "success", %{assigns: assigns} do
      assert function_exported?(Error, :"404", 1)
      assert_element render_component(&Error."404"/1, assigns), "span"
    end
  end

  describe "500/1" do
    setup :c_assigns_empty

    test "success", %{assigns: assigns} do
      assert function_exported?(Error, :"500", 1)
      assert_element render_component(&Error."500"/1, assigns), "span"
    end
  end
end
