defmodule Diacritical.TelemetryTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.12.0"

  use DiacriticalCase.Supervisor, async: true

  alias Diacritical

  alias Diacritical.Telemetry

  doctest Telemetry, import: true

  describe "init/1" do
    import Telemetry, only: [init: 1]

    setup :c_init_arg

    test "FunctionClauseError", %{init_arg: %{invalid: init_arg}} do
      assert_raise FunctionClauseError, fn -> init(init_arg) end
    end

    test "success", %{init_arg: %{valid: init_arg}} do
      assert {:ok, {_sup_flag, _child_spec}} = init(init_arg)
    end
  end

  describe "start_link/1" do
    import Telemetry, only: [start_link: 1]

    setup :c_init_arg
    setup do: %{err: {:error, {:already_started, Process.whereis(Telemetry)}}}

    test "FunctionClauseError", %{init_arg: %{invalid: init_arg}} do
      assert_raise FunctionClauseError, fn -> start_link(init_arg) end
    end

    test "success", %{err: err, init_arg: %{valid: init_arg}} do
      assert start_link(init_arg) == err
    end
  end

  describe "metrics/0" do
    import Telemetry, only: [metrics: 0]

    test "success" do
      assert [%{measurement: _measurement} | _metric] = metrics()
    end
  end
end
