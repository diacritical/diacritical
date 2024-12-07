defmodule Diacritical.SupervisorTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.3.0"

  use DiacriticalCase.Supervisor, async: true

  alias Diacritical
  alias DiacriticalCase

  alias Diacritical.Supervisor

  @typedoc "Represents the context."
  @typedoc since: "0.3.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.3.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec start_supervisor!(context()) :: context_merge()
  defp start_supervisor!(c) when is_map(c) do
    start_supervised!(Supervisor)
    :ok
  end

  doctest Supervisor, import: true

  describe "child_spec/1" do
    import Supervisor, only: [child_spec: 1]

    setup :c_init_arg

    test "FunctionClauseError", %{init_arg: %{invalid: init_arg}} do
      assert_raise FunctionClauseError, fn -> child_spec(init_arg) end
    end

    test "success", %{init_arg: %{valid: init_arg}} do
      assert child_spec(init_arg) == %{
               id: Supervisor,
               start: {Supervisor, :start_link, [init_arg]},
               type: :supervisor
             }
    end
  end

  describe "init/1" do
    import Supervisor, only: [init: 1]

    setup :c_init_arg

    test "FunctionClauseError", %{init_arg: %{invalid: init_arg}} do
      assert_raise FunctionClauseError, fn -> init(init_arg) end
    end

    test "success", %{init_arg: %{valid: init_arg}} do
      assert init(init_arg) == {
               :ok,
               {
                 %{
                   auto_shutdown: :never,
                   intensity: 3,
                   period: 5,
                   strategy: :one_for_one
                 },
                 init_arg
               }
             }
    end
  end

  describe "start_link/1" do
    import Supervisor, only: [start_link: 1]

    setup ~W[start_supervisor! c_init_arg c_err]a

    test "FunctionClauseError", %{init_arg: %{invalid: init_arg}} do
      assert_raise FunctionClauseError, fn -> start_link(init_arg) end
    end

    test "success", %{err: err, init_arg: %{valid: init_arg}} do
      assert start_link(init_arg) == err
    end
  end

  describe "start_link/2" do
    import Supervisor, only: [start_link: 2]

    setup ~W[start_supervisor! c_init_arg c_err]a
    setup do: %{opt: %{default: [name: Supervisor], empty: [], invalid: %{}}}

    test "FunctionClauseError (&1)", %{
      init_arg: %{invalid: init_arg},
      opt: %{default: opt}
    } do
      assert_raise FunctionClauseError, fn -> start_link(init_arg, opt) end
    end

    test "FunctionClauseError (&2)", %{
      init_arg: %{valid: init_arg},
      opt: %{invalid: opt}
    } do
      assert_raise FunctionClauseError, fn -> start_link(init_arg, opt) end
    end

    test "default", %{
      err: err,
      init_arg: %{valid: init_arg},
      opt: %{default: opt}
    } do
      assert start_link(init_arg, opt) == err
    end

    test "empty", %{init_arg: %{valid: init_arg}, opt: %{empty: opt}} do
      assert {:ok, _pid} = start_link(init_arg, opt)
    end
  end
end
