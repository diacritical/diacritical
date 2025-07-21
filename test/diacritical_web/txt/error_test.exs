defmodule DiacriticalWeb.TXT.ErrorTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.5.0"

  use DiacriticalCase.View, async: true

  alias DiacriticalWeb

  alias DiacriticalWeb.TXT

  alias TXT.Error

  @typedoc "Represents the context."
  @typedoc since: "0.5.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.5.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_assigns_empty(context()) :: context_merge()
  defp c_assigns_empty(c) when is_map(c), do: %{assigns: %{}}

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
      assert Error."404"(assigns) == "Not Found\n"
    end
  end

  describe "500/1" do
    setup :c_assigns_empty

    test "success", %{assigns: assigns} do
      assert function_exported?(Error, :"500", 1)
      assert Error."500"(assigns) == "Internal Server Error\n"
    end
  end
end
