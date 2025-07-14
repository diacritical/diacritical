defmodule DiacriticalCase.SupervisorTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.3.0"

  use ExUnit.Case, async: true

  alias DiacriticalCase

  alias DiacriticalCase.Supervisor

  @typedoc "Represents the context."
  @typedoc since: "0.3.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.3.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_context(context()) :: context_merge()
  defp c_context(c) when is_map(c), do: %{context: %{invalid: [], valid: %{}}}

  doctest Supervisor, import: true

  describe "__ex_unit__/2" do
    setup :c_context

    test ":setup", %{context: %{valid: context}} do
      assert Supervisor.__ex_unit__(:setup, context) == context
    end

    test ":setup_all", %{context: %{valid: context}} do
      assert Supervisor.__ex_unit__(:setup_all, context) == context
    end
  end

  describe "c_err/0" do
    import Supervisor, only: [c_err: 0]

    test "success" do
      assert %{err: _err} = c_err()
    end
  end

  describe "c_err/1" do
    import Supervisor, only: [c_err: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_err(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{err: _err} = c_err(context)
    end
  end

  describe "c_init/0" do
    import Supervisor, only: [c_init: 0]

    test "success" do
      assert %{init: _init} = c_init()
    end
  end

  describe "c_init/1" do
    import Supervisor, only: [c_init: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_init(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{init: _init} = c_init(context)
    end
  end
end
