defmodule DiacriticalAppTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.3.0"

  use DiacriticalCase.Supervisor, async: true

  alias DiacriticalApp

  doctest DiacriticalApp, import: true

  describe "get_app/0" do
    import DiacriticalApp, only: [get_app: 0]

    test "success" do
      assert get_app() == :diacritical
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

    setup [:c_init, :c_err]
    setup do: %{start_type: %{invalid: "normal", valid: :normal}}

    test "FunctionClauseError (&1)", %{
      init: %{valid: init},
      start_type: %{invalid: start_type}
    } do
      assert_raise FunctionClauseError, fn -> start(start_type, init) end
    end

    test "FunctionClauseError (&2)", %{
      init: %{invalid: init},
      start_type: %{valid: start_type}
    } do
      assert_raise FunctionClauseError, fn -> start(start_type, init) end
    end

    test "success", %{
      err: err,
      init: %{valid: init},
      start_type: %{valid: start_type}
    } do
      assert start(start_type, init) == err
    end
  end

  describe "stop/1" do
    import DiacriticalApp, only: [stop: 1]

    test "success" do
      assert stop([]) == :ok
    end
  end
end
