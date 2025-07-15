defmodule Diacritical.SupervisorTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.3.0"

  use DiacriticalCase.Supervisor, async: true

  alias Diacritical

  alias Diacritical.Supervisor

  doctest Supervisor, import: true

  describe "child_spec/1" do
    import Supervisor, only: [child_spec: 1]

    setup :c_init

    test "FunctionClauseError", %{init: %{invalid: init}} do
      assert_raise FunctionClauseError, fn -> child_spec(init) end
    end

    test "success", %{init: %{valid: init}} do
      assert child_spec(init) == %{
               id: Supervisor,
               start: {Supervisor, :start_link, [init]},
               type: :supervisor
             }
    end
  end

  describe "init/1" do
    import Supervisor, only: [init: 1]

    setup :c_init

    test "FunctionClauseError", %{init: %{invalid: init}} do
      assert_raise FunctionClauseError, fn -> init(init) end
    end

    test "success", %{init: %{valid: init}} do
      assert init(init) == {
               :ok,
               {
                 %{
                   auto_shutdown: :never,
                   intensity: 3,
                   period: 5,
                   strategy: :one_for_one
                 },
                 init
               }
             }
    end
  end

  describe "start_link/1" do
    import Supervisor, only: [start_link: 1]

    setup [:c_init, :c_err]

    test "FunctionClauseError", %{init: %{invalid: init}} do
      assert_raise FunctionClauseError, fn -> start_link(init) end
    end

    test "success", %{err: err, init: %{valid: init}} do
      assert start_link(init) == err
    end
  end

  describe "start_link/2" do
    import Supervisor, only: [start_link: 2]

    setup [:c_init, :c_err]
    setup do: %{opt: %{default: [name: Supervisor], empty: [], invalid: %{}}}

    test "FunctionClauseError (&1)", %{
      init: %{invalid: init},
      opt: %{default: opt}
    } do
      assert_raise FunctionClauseError, fn -> start_link(init, opt) end
    end

    test "FunctionClauseError (&2)", %{
      init: %{valid: init},
      opt: %{invalid: opt}
    } do
      assert_raise FunctionClauseError, fn -> start_link(init, opt) end
    end

    test "default", %{err: err, init: %{valid: init}, opt: %{default: opt}} do
      assert start_link(init, opt) == err
    end

    test "empty", %{init: %{valid: init}, opt: %{empty: opt}} do
      assert {:ok, _pid} = start_link(init, opt)
    end
  end
end
