defmodule DiacriticalWeb.Controller.PageTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.5.0"

  use DiacriticalCase.Conn, async: true

  alias DiacriticalCase
  alias DiacriticalWeb

  alias DiacriticalWeb.Controller
  alias DiacriticalWeb.TXT

  alias Controller.Page

  @typedoc "Represents the context."
  @typedoc since: "0.5.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.5.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_conn_view(context()) :: context_merge()
  defp c_conn_view(%{conn: %{valid: conn} = c})
       when is_struct(conn, Plug.Conn) do
    %{conn: %{c | valid: Phoenix.Controller.put_view(conn, txt: TXT.Page)}}
  end

  doctest Page, import: true

  describe "init/1" do
    import Page, only: [init: 1]

    setup :c_opt

    test "success", %{opt: opt} do
      assert init(opt) == opt
    end
  end

  describe "call/2" do
    import Page, only: [call: 2]

    setup ~W[c_request_path c_conn c_conn_format c_action c_status c_resp_body]a

    test "FunctionClauseError (&1)", %{
      action: %{valid: action},
      conn: %{invalid: conn}
    } do
      assert_raise FunctionClauseError, fn -> call(conn, action) end
    end

    test "FunctionClauseError (&2)", %{
      action: %{invalid: action},
      conn: %{valid: conn}
    } do
      assert_raise FunctionClauseError, fn -> call(conn, action) end
    end

    test "success", %{
      action: %{valid: action},
      conn: %{valid: conn},
      resp_body: resp_body,
      status: status
    } do
      assert text_response(call(conn, action), status) == resp_body
    end
  end

  describe "action/2" do
    import Page, only: [action: 2]

    setup [
      :c_action,
      :c_request_path,
      :c_conn,
      :c_conn_format,
      :c_conn_view,
      :c_opt,
      :c_status,
      :c_resp_body
    ]

    setup %{action: %{valid: action}, conn: %{valid: conn} = c} do
      %{
        conn: %{
          c
          | invalid: %{private: %{phoenix_action: action}},
            valid: Plug.Conn.put_private(conn, :phoenix_action, action)
        }
      }
    end

    test "FunctionClauseError", %{conn: %{invalid: conn}, opt: opt} do
      assert_raise FunctionClauseError, fn -> action(conn, opt) end
    end

    test "success", %{
      conn: %{valid: conn},
      opt: opt,
      resp_body: resp_body,
      status: status
    } do
      assert text_response(action(conn, opt), status) == resp_body
    end
  end

  describe "greet/2" do
    import Page, only: [greet: 2]

    setup [
      :c_request_path,
      :c_conn,
      :c_conn_format,
      :c_conn_view,
      :c_opt,
      :c_status,
      :c_resp_body
    ]

    test "FunctionClauseError", %{conn: %{invalid: conn}, opt: opt} do
      assert_raise FunctionClauseError, fn -> greet(conn, opt) end
    end

    test "success", %{
      conn: %{valid: conn},
      opt: opt,
      resp_body: resp_body,
      status: status
    } do
      assert text_response(greet(conn, opt), status) == resp_body
    end
  end
end
