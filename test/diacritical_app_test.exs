defmodule DiacriticalAppTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.3.0"

  use DiacriticalCase.Supervisor, async: true

  alias DiacriticalApp

  doctest DiacriticalApp, import: true

  describe "app/0" do
    import DiacriticalApp, only: [app: 0]

    test "success" do
      assert app() == :diacritical
    end
  end

  describe "config_change/3" do
    import DiacriticalApp, only: [config_change: 3]

    test "success" do
      assert config_change([], [], []) == :ok
    end
  end

  describe "start/2" do
    import DiacriticalApp, only: [start: 2]

    setup [:c_init_arg, :c_err]
    setup do: %{start_type: %{invalid: "normal", valid: :normal}}

    test "FunctionClauseError (&1)", %{
      init_arg: %{valid: init_arg},
      start_type: %{invalid: start_type}
    } do
      assert_raise FunctionClauseError, fn -> start(start_type, init_arg) end
    end

    test "FunctionClauseError (&2)", %{
      init_arg: %{invalid: init_arg},
      start_type: %{valid: start_type}
    } do
      assert_raise FunctionClauseError, fn -> start(start_type, init_arg) end
    end

    test "success", %{
      err: err,
      init_arg: %{valid: init_arg},
      start_type: %{valid: start_type}
    } do
      assert start(start_type, init_arg) == err
    end
  end

  describe "stop/1" do
    import DiacriticalApp, only: [stop: 1]

    test "success" do
      assert stop([]) == :ok
    end
  end
end
