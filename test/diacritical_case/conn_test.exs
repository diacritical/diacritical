defmodule DiacriticalCase.ConnTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.5.0"

  use DiacriticalCase.Template, async: true

  alias DiacriticalCase

  alias DiacriticalCase.Conn

  doctest Conn, import: true

  describe "__ex_unit__/2" do
    setup :c_context

    test ":setup", %{context: %{valid: context}} do
      assert Conn.__ex_unit__(:setup, context) == context
    end

    test ":setup_all", %{context: %{valid: context}} do
      assert Conn.__ex_unit__(:setup_all, context) == context
    end
  end

  describe "c_conn/0" do
    import Conn, only: [c_conn: 0]

    test "success" do
      assert %{conn: _conn} = c_conn()
    end
  end

  describe "c_conn/1" do
    import Conn, only: [c_conn: 1]

    setup do
      %{
        context: %{invalid: %{request_path: ~C"/"}, valid: %{request_path: "/"}}
      }
    end

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_conn(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{conn: _conn} = c_conn(context)
    end
  end
end
