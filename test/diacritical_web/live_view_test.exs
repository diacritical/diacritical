defmodule DiacriticalWeb.LiveViewTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.8.0"

  use DiacriticalCase.Conn, async: true

  alias DiacriticalCase
  alias DiacriticalWeb

  alias DiacriticalWeb.HTML
  alias DiacriticalWeb.LiveView
  alias DiacriticalWeb.Token

  alias HTML.Layout

  @typedoc "Represents the context."
  @typedoc since: "0.8.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.8.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_name_default(context()) :: context_merge()
  defp c_name_default(c) when is_map(c) do
    %{name: %{invalid: "default", valid: :default}}
  end

  @spec c_socket_nonce(context()) :: context_merge()
  defp c_socket_nonce(c) when is_map(c) do
    nonce =
      18
      |> :crypto.strong_rand_bytes()
      |> Base.url_encode64()

    unsigned = %Phoenix.LiveView.Socket{
      private: %{connect_params: %{"_csp_token" => nonce}},
      transport_pid: self()
    }

    signed = %Phoenix.LiveView.Socket{
      private: %{connect_params: %{"_csp_token" => Token.sign(nonce)}},
      transport_pid: self()
    }

    %{
      socket: %{
        assigned: %Phoenix.LiveView.Socket{assigns: %{nonce: nonce}},
        halted: %Phoenix.LiveView.Socket{
          unsigned
          | redirected: {:redirect, %{to: "/hello", status: 302}}
        },
        invalid: %{},
        mounted: %Phoenix.LiveView.Socket{
          signed
          | assigns: %{__changed__: %{nonce: true}, nonce: nonce}
        },
        signed: signed,
        unsigned: unsigned
      }
    }
  end

  doctest LiveView, import: true

  describe "__phoenix_verify_routes__/1" do
    import LiveView, only: [__phoenix_verify_routes__: 1]

    test "success" do
      assert __phoenix_verify_routes__(LiveView) == :ok
    end
  end

  describe "on_mount/4" do
    import LiveView, only: [on_mount: 4]

    setup ~W[c_name_default c_param c_session c_socket_nonce]a

    test "FunctionClauseError (&1)", %{
      name: %{invalid: name},
      param: %{valid: param},
      session: %{valid: session},
      socket: %{assigned: socket}
    } do
      assert_raise FunctionClauseError, fn ->
        on_mount(name, param, session, socket)
      end
    end

    test "FunctionClauseError (&2)", %{
      name: %{valid: name},
      param: %{invalid: param},
      session: %{valid: session},
      socket: %{assigned: socket}
    } do
      assert_raise FunctionClauseError, fn ->
        on_mount(name, param, session, socket)
      end
    end

    test "FunctionClauseError (&3)", %{
      name: %{valid: name},
      param: %{valid: param},
      session: %{invalid: session},
      socket: %{assigned: socket}
    } do
      assert_raise FunctionClauseError, fn ->
        on_mount(name, param, session, socket)
      end
    end

    test "FunctionClauseError (&4)", %{
      name: %{valid: name},
      param: %{valid: param},
      session: %{valid: session},
      socket: %{invalid: socket}
    } do
      assert_raise FunctionClauseError, fn ->
        on_mount(name, param, session, socket)
      end
    end

    test "unsigned", %{
      name: %{valid: name},
      param: %{valid: param},
      session: %{valid: session},
      socket: %{halted: socket!, unsigned: socket}
    } do
      assert on_mount(name, param, session, socket) == {:halt, socket!}
    end

    test "signed", %{
      name: %{valid: name},
      param: %{valid: param},
      session: %{valid: session},
      socket: %{mounted: socket!, signed: socket}
    } do
      assert on_mount(name, param, session, socket) == {:cont, socket!}
    end

    test "assigned", %{
      name: %{valid: name},
      param: %{valid: param},
      session: %{valid: session},
      socket: %{assigned: socket}
    } do
      assert on_mount(name, param, session, socket) == {:cont, socket}
    end
  end
end
