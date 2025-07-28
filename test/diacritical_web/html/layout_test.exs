defmodule DiacriticalWeb.HTML.LayoutTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.6.0"

  use DiacriticalCase.View, async: true

  alias DiacriticalCase
  alias DiacriticalWeb

  alias DiacriticalWeb.HTML

  alias HTML.Layout

  @typedoc "Represents the context."
  @typedoc since: "0.6.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.6.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_assigns_inner_content(context()) :: context_merge()
  defp c_assigns_inner_content(c) when is_map(c) do
    %{assigns: %{invalid: {}, valid: %{inner_content: ""}}}
  end

  describe "__mix_recompile__?/0" do
    import Layout, only: [__mix_recompile__?: 0]

    test "failure" do
      refute __mix_recompile__?()
    end
  end

  describe "__phoenix_verify_routes__/1" do
    import Layout, only: [__phoenix_verify_routes__: 1]

    test "success" do
      assert __phoenix_verify_routes__(Layout) == :ok
    end
  end

  describe "main/1" do
    import Layout, only: [main: 1]

    setup :c_assigns_inner_content

    test "FunctionClauseError", %{assigns: %{invalid: assigns}} do
      assert_raise FunctionClauseError, fn -> main(assigns) end
    end

    test "success", %{assigns: %{valid: assigns}} do
      assert function_exported?(Layout, :main, 1)
      assert safe_to_string(main(assigns)) =~ "<main>"
    end
  end

  describe "root/1" do
    import Layout, only: [root: 1]

    setup :c_assigns_inner_content

    test "FunctionClauseError", %{assigns: %{invalid: assigns}} do
      assert_raise FunctionClauseError, fn -> root(assigns) end
    end

    test "success", %{assigns: %{valid: assigns}} do
      assert function_exported?(Layout, :root, 1)
      assert safe_to_string(root(assigns)) =~ "<!DOCTYPE html>"
    end
  end
end
