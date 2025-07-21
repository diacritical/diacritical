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

  describe "c_action/0" do
    import Conn, only: [c_action: 0]

    test "success" do
      assert %{action: _action} = c_action()
    end
  end

  describe "c_action/1" do
    import Conn, only: [c_action: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_action(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{action: _action} = c_action(context)
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

  describe "c_conn_format/1" do
    import Conn, only: [c_conn_format: 1]

    setup do
      %{
        context: %{
          invalid: %{conn: %{valid: %{}}},
          valid: %{conn: %{valid: %Plug.Conn{}}}
        }
      }
    end

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_conn_format(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{conn: _conn} = c_conn_format(context)
    end
  end

  describe "c_opt/0" do
    import Conn, only: [c_opt: 0]

    test "success" do
      assert %{opt: _opt} = c_opt()
    end
  end

  describe "c_opt/1" do
    import Conn, only: [c_opt: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_opt(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{opt: _opt} = c_opt(context)
    end
  end

  describe "c_request_path/0" do
    import Conn, only: [c_request_path: 0]

    test "success" do
      assert %{request_path: _request_path} = c_request_path()
    end
  end

  describe "c_request_path/1" do
    import Conn, only: [c_request_path: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_request_path(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{request_path: _request_path} = c_request_path(context)
    end
  end

  describe "c_status/0" do
    import Conn, only: [c_status: 0]

    test "success" do
      assert %{status: _status} = c_status()
    end
  end

  describe "c_status/1" do
    import Conn, only: [c_status: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_status(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{status: _status} = c_status(context)
    end
  end
end
