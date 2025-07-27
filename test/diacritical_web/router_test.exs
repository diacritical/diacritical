defmodule DiacriticalWeb.RouterTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.5.0"

  use DiacriticalCase.Conn, async: true

  alias DiacriticalWeb

  alias DiacriticalWeb.Controller
  alias DiacriticalWeb.Router

  alias Controller.Page

  describe "__routes__/0" do
    import Router, only: [__routes__: 0]

    test "success" do
      assert [%{path: _path, plug: _plug} | _route] = __routes__()
    end
  end

  describe "__checks__/0" do
    import Router, only: [__checks__: 0]

    test "success" do
      assert __checks__() == (&Page.init/1)
    end
  end

  describe "__helpers__/0" do
    import Router, only: [__helpers__: 0]

    test "success" do
      assert __helpers__() == nil
    end
  end

  describe "__match_route__/3" do
    import Router, only: [__match_route__: 3]

    test "success" do
      assert {_metadata, _prepare, _pipeline, {_plug, _opts}} =
               __match_route__(["hello"], "GET", [])
    end
  end

  describe "__forward__/1" do
    import Router, only: [__forward__: 1]

    test "success" do
      assert __forward__(Page) == nil
    end
  end

  describe "__verify_route__/1" do
    import Router, only: [__verify_route__: 1]

    test "success" do
      assert __verify_route__(["hello"]) == {nil, false}
    end
  end

  describe "plaintext/2" do
    import Router, only: [plaintext: 2]

    setup ~W[c_request_path c_conn c_conn_format c_opt]a

    test "Plug.Conn.WrapperError", %{conn: %{invalid: conn}, opt: opt} do
      assert_raise Plug.Conn.WrapperError, fn -> plaintext(conn, opt) end
    end

    test "success", %{conn: %{valid: conn}, opt: opt} do
      assert plaintext(conn, opt) == conn
    end
  end

  describe "init/1" do
    import Router, only: [init: 1]

    setup :c_opt

    test "success", %{opt: opt} do
      assert init(opt) == opt
    end
  end

  describe "call/2" do
    import Router, only: [call: 2]

    setup [
      :c_request_path,
      :c_conn,
      :c_conn_script_name,
      :c_opt,
      :c_status,
      :c_resp_body_greeting
    ]

    test "FunctionClauseError", %{conn: %{invalid: conn}, opt: opt} do
      assert_raise FunctionClauseError, fn -> call(conn, opt) end
    end

    test "success", %{
      conn: %{valid: conn},
      opt: opt,
      resp_body: resp_body,
      status: status
    } do
      assert text_response(call(conn, opt), status) == resp_body
    end
  end
end
