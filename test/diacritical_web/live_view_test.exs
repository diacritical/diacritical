defmodule DiacriticalWeb.LiveViewTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.8.0"

  use DiacriticalCase.Conn, async: true

  alias DiacriticalCase
  alias DiacriticalWeb

  alias DiacriticalWeb.HTML
  alias DiacriticalWeb.LiveView

  alias HTML.Layout

  @typedoc "Represents the context."
  @typedoc since: "0.8.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.8.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_name(context()) :: context_merge()
  defp c_name(c) when is_map(c) do
    %{name: %{invalid: "default", valid: :default}}
  end

  @spec c_socket_nonce(context()) :: context_merge()
  defp c_socket_nonce(c) when is_map(c) do
    socket = c[:socket] || c_socket()[:socket]

    %{"nonce" => nonce} =
      c[:session][:nonce] || c_session()[:session][:nonce]

    redirected =
      %{socket.valid | redirected: {:redirect, %{to: "/hello", status: 302}}}

    %{
      socket:
        socket
        |> Map.put(:nonce, assign(socket.valid, :nonce, nonce))
        |> Map.put(:redirected, redirected)
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

    setup ~W[c_name c_param c_session c_socket_nonce]a

    test "FunctionClauseError (&1)", %{
      name: %{invalid: name},
      param: %{valid: param},
      session: %{valid: session},
      socket: %{valid: socket}
    } do
      assert_raise FunctionClauseError, fn ->
        on_mount(name, param, session, socket)
      end
    end

    test "FunctionClauseError (&2)", %{
      name: %{valid: name},
      param: %{invalid: param},
      session: %{valid: session},
      socket: %{valid: socket}
    } do
      assert_raise FunctionClauseError, fn ->
        on_mount(name, param, session, socket)
      end
    end

    test "FunctionClauseError (&3)", %{
      name: %{valid: name},
      param: %{valid: param},
      session: %{invalid: session},
      socket: %{valid: socket}
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

    test "failure", %{
      name: %{valid: name},
      param: %{valid: param},
      session: %{valid: session},
      socket: %{redirected: socket!, valid: socket}
    } do
      assert on_mount(name, param, session, socket) == {:halt, socket!}
    end

    test "success", %{
      name: %{valid: name},
      param: %{valid: param},
      session: %{nonce: session},
      socket: %{nonce: socket!, valid: socket}
    } do
      assert on_mount(name, param, session, socket) == {:cont, socket!}
    end
  end
end
