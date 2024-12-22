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

  describe "c_action_greet/0" do
    import Conn, only: [c_action_greet: 0]

    test "success" do
      assert %{action: _action} = c_action_greet()
    end
  end

  describe "c_action_greet/1" do
    import Conn, only: [c_action_greet: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_action_greet(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{action: _action} = c_action_greet(context)
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

  describe "c_conn_format_txt/1" do
    import Conn, only: [c_conn_format_txt: 1]

    setup do
      %{
        context: %{
          invalid: %{conn: %{valid: %{}}},
          valid: %{conn: %{valid: %Plug.Conn{}}}
        }
      }
    end

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_conn_format_txt(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{conn: _conn} = c_conn_format_txt(context)
    end
  end

  describe "c_conn_script_name/1" do
    import Conn, only: [c_conn_script_name: 1]

    setup do
      %{context: %{invalid: %{conn: %{}}, valid: %{conn: %{invalid: %{}}}}}
    end

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_conn_script_name(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{conn: _conn} = c_conn_script_name(context)
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

  describe "c_param/0" do
    import Conn, only: [c_param: 0]

    test "success" do
      assert %{param: _param} = c_param()
    end
  end

  describe "c_param/1" do
    import Conn, only: [c_param: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_param(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{param: _param} = c_param(context)
    end
  end

  describe "c_request_path_hello/0" do
    import Conn, only: [c_request_path_hello: 0]

    test "success" do
      assert %{request_path: _request_path} = c_request_path_hello()
    end
  end

  describe "c_request_path_hello/1" do
    import Conn, only: [c_request_path_hello: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_request_path_hello(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{request_path: _request_path} = c_request_path_hello(context)
    end
  end

  describe "c_session/0" do
    import Conn, only: [c_session: 0]

    test "success" do
      assert %{session: _session} = c_session()
    end
  end

  describe "c_session/1" do
    import Conn, only: [c_session: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_session(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{session: _session} = c_session(context)
    end
  end

  describe "c_socket/0" do
    import Conn, only: [c_socket: 0]

    test "success" do
      assert %{socket: _socket} = c_socket()
    end
  end

  describe "c_socket/1" do
    import Conn, only: [c_socket: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_socket(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{socket: _socket} = c_socket(context)
    end
  end

  describe "c_status_ok/0" do
    import Conn, only: [c_status_ok: 0]

    test "success" do
      assert %{status: _status} = c_status_ok()
    end
  end

  describe "c_status_ok/1" do
    import Conn, only: [c_status_ok: 1]

    setup :c_context

    test "FunctionClauseError", %{context: %{invalid: context}} do
      assert_raise FunctionClauseError, fn -> c_status_ok(context) end
    end

    test "success", %{context: %{valid: context}} do
      assert %{status: _status} = c_status_ok(context)
    end
  end
end
