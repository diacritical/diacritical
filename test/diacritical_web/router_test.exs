defmodule DiacriticalWeb.RouterTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.5.0"

  use DiacriticalCase.Conn, async: true

  alias DiacriticalCase
  alias DiacriticalSchema
  alias DiacriticalWeb

  alias DiacriticalSchema.Account
  alias DiacriticalWeb.Controller
  alias DiacriticalWeb.Endpoint
  alias DiacriticalWeb.Router

  alias Controller.Page

  @typedoc "Represents the context."
  @typedoc since: "0.6.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.6.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_conn_format_html(context()) :: context_merge()
  defp c_conn_format_html(%{conn: %{valid: conn} = c})
       when is_struct(conn, Plug.Conn) do
    %{conn: %{c | valid: Phoenix.Controller.put_format(conn, "html")}}
  end

  @spec c_conn_session(context()) :: context_merge()
  defp c_conn_session(%{conn: %{valid: conn} = c})
       when is_struct(conn, Plug.Conn) do
    secret_key_base = Endpoint.config(:secret_key_base)

    %{
      conn: %{
        c
        | valid:
            conn
            |> Map.replace!(:secret_key_base, secret_key_base)
            |> init_test_session(%{})
      }
    }
  end

  describe "__routes__/0" do
    import Router, only: [__routes__: 0]

    test "success" do
      assert [%{path: _path, plug: _plug} | _route] = __routes__()
    end
  end

  describe "__checks__/0" do
    import Router, only: [__checks__: 0]

    test "success" do
      assert __checks__() == (&Phoenix.LiveView.Plug.init/1)
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

    setup ~W[c_request_path_hello c_conn c_conn_format_txt c_opt]a

    test "Plug.Conn.WrapperError", %{conn: %{invalid: conn}, opt: opt} do
      assert_raise Plug.Conn.WrapperError, fn -> plaintext(conn, opt) end
    end

    test "success", %{conn: %{valid: conn}, opt: opt} do
      assert plaintext(conn, opt) == conn
    end
  end

  describe "browser/2" do
    import Router, only: [browser: 2]

    setup [
      :checkout_repo,
      :c_token_loaded,
      :c_request_path_hello,
      :c_conn,
      :c_conn_format_html,
      :c_conn_session,
      :c_opt
    ]

    setup %{conn: conn = %{valid: valid}, token: %{loaded: token}} do
      key = "__Host-token"

      %{
        conn:
          Map.merge(
            conn,
            %{
              cookie:
                valid
                |> put_resp_cookie(key, token.data, sign: true)
                |> then(&put_req_cookie(&1, key, &1.resp_cookies[key].value)),
              token: put_session(valid, "token", token.data)
            }
          )
      }
    end

    test "Plug.Conn.WrapperError", %{conn: %{invalid: conn}, opt: opt} do
      assert_raise Plug.Conn.WrapperError, fn -> browser(conn, opt) end
    end

    test "token", %{
      conn: %{token: conn},
      opt: opt,
      token: %{loaded: token}
    } do
      conn! = browser(conn, opt)
      assert conn!.private.phoenix_format == "html"
      assert get_session(conn!, "token") == token.data
      assert %Account{} = conn!.assigns.account
    end

    test "cookie", %{
      conn: %{cookie: conn},
      opt: opt,
      token: %{loaded: token}
    } do
      conn! = browser(conn, opt)
      assert conn!.private.phoenix_format == "html"
      assert get_session(conn!, "token") == token.data
      assert %Account{} = conn!.assigns.account
    end

    test "empty", %{conn: %{valid: conn}, opt: opt} do
      conn! = browser(conn, opt)
      assert conn!.private.phoenix_format == "html"
      refute get_session(conn!, "token")
      refute conn!.assigns.account
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
      :c_request_path_hello,
      :c_conn,
      :c_conn_script_name,
      :c_opt,
      :c_status_ok,
      :c_resp_body_greet
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
