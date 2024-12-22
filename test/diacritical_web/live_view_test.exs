defmodule DiacriticalWeb.LiveViewTest do
  @moduledoc "Defines an `ExUnit.Case` case."
  @moduledoc since: "0.8.0"

  use DiacriticalCase.Conn, async: true

  alias Diacritical
  alias DiacriticalCase
  alias DiacriticalWeb

  alias Diacritical.Context
  alias DiacriticalWeb.HTML
  alias DiacriticalWeb.LiveView

  alias Context.Account
  alias HTML.Layout

  @typedoc "Represents the context."
  @typedoc since: "0.8.0"
  @type context() :: DiacriticalCase.context()

  @typedoc "Represents the context merge value."
  @typedoc since: "0.8.0"
  @type context_merge() :: DiacriticalCase.context_merge()

  @spec c_name() :: context_merge()
  @spec c_name(context()) :: context_merge()
  defp c_name(c \\ %{}) when is_map(c) do
    %{name: %{invalid: "default", valid: :default}}
  end

  @spec c_name_account(context()) :: context_merge()
  defp c_name_account(c) when is_map(c) do
    name = c[:name] || c_name()[:name]
    %{name: Map.put(name, :account, :account)}
  end

  @spec c_session_token(context()) :: context_merge()
  defp c_session_token(c) when is_map(c) do
    session = c[:session] || c_session()[:session]

    data =
      case c[:token][:loaded] do
        nil -> get_in(c_token_loaded(), [:token, :loaded, Access.key(:data)])
        %{data: data} -> data
      end

    %{session: Map.put(session, :token, %{"token" => data})}
  end

  @spec c_socket_account(context()) :: context_merge()
  defp c_socket_account(c) when is_map(c) do
    socket = c[:socket] || c_socket()[:socket]

    data =
      with nil <- c[:session][:token],
           nil <- c[:token][:loaded] do
        get_in(c_token_loaded(), [:token, :loaded, Access.key(:data)])
      else
        %{"token" => data} -> data
        %{data: data} -> data
      end

    account = Account.get_by_token_data_and_type(data, "session")

    %{
      socket:
        socket
        |> Map.put(:account, assign(socket.valid, :account, account))
        |> Map.put(:missing, assign(socket.valid, :account, nil))
    }
  end

  @spec c_name_nonce(context()) :: context_merge()
  defp c_name_nonce(c) when is_map(c) do
    name = c[:name] || c_name()[:name]
    %{name: Map.put(name, :nonce, :nonce)}
  end

  @spec c_nonce() :: context_merge()
  @spec c_nonce(context()) :: context_merge()
  defp c_nonce(c \\ %{}) when is_map(c) do
    %{
      nonce:
        18
        |> :crypto.strong_rand_bytes()
        |> Base.url_encode64()
    }
  end

  @spec c_session_nonce(context()) :: context_merge()
  defp c_session_nonce(c) when is_map(c) do
    session = c[:session] || c_session()[:session]
    nonce = c[:nonce] || c_nonce()[:nonce]
    %{session: Map.put(session, :nonce, %{"nonce" => nonce})}
  end

  @spec c_socket_redirected() :: context_merge()
  @spec c_socket_redirected(context()) :: context_merge()
  defp c_socket_redirected(c \\ %{}) when is_map(c) do
    socket = c[:socket] || c_socket()[:socket]

    redirected =
      %{socket.valid | redirected: {:redirect, %{to: "/hello", status: 302}}}

    %{socket: Map.put(socket, :redirected, redirected)}
  end

  @spec c_socket_nonce(context()) :: context_merge()
  defp c_socket_nonce(c) when is_map(c) do
    socket =
      case c[:socket][:redirected] do
        nil -> c_socket_redirected()[:socket]
        _socket -> c[:socket]
      end

    nonce =
      with nil <- c[:session][:nonce],
           nil <- c[:nonce] do
        c_nonce()[:nonce]
      else
        %{"nonce" => nonce} -> nonce
        nonce -> nonce
      end

    %{socket: Map.put(socket, :nonce, assign(socket.valid, :nonce, nonce))}
  end

  @spec c_tenant() :: context_merge()
  @spec c_tenant(context()) :: context_merge()
  defp c_tenant(c \\ %{}) when is_map(c) do
    %{tenant: "com_example"}
  end

  @spec c_name_tenant(context()) :: context_merge()
  defp c_name_tenant(c) when is_map(c) do
    name = c[:name] || c_name()[:name]
    %{name: Map.put(name, :tenant, :tenant)}
  end

  @spec c_session_tenant(context()) :: context_merge()
  defp c_session_tenant(c) when is_map(c) do
    session = c[:session] || c_session()[:session]
    tenant = c[:tenant] || c_tenant()[:tenant]
    %{session: Map.put(session, :tenant, %{"tenant" => tenant})}
  end

  @spec c_socket_tenant(context()) :: context_merge()
  defp c_socket_tenant(c) when is_map(c) do
    socket =
      case c[:socket][:redirected] do
        nil -> c_socket_redirected()[:socket]
        _socket -> c[:socket]
      end

    tenant =
      with nil <- c[:session][:tenant],
           nil <- c[:tenant] do
        c_tenant()[:tenant]
      else
        %{"tenant" => tenant} -> tenant
        tenant -> tenant
      end

    %{socket: Map.put(socket, :tenant, assign(socket.valid, :tenant, tenant))}
  end

  @spec c_session_default(context()) :: context_merge()
  defp c_session_default(c) when is_map(c) do
    session =
      c_session()
      |> c_session_nonce()
      |> c_session_tenant()
      |> c_session_token()
      |> Map.get(:session)

    default = %{
      "nonce" => get_in(session, [:nonce, "nonce"]),
      "tenant" => get_in(session, [:tenant, "tenant"]),
      "token" => get_in(session, [:token, "token"])
    }

    %{session: Map.put(session, :default, default)}
  end

  doctest LiveView, import: true

  describe "__phoenix_verify_routes__/1" do
    import LiveView, only: [__phoenix_verify_routes__: 1]

    test "success" do
      assert __phoenix_verify_routes__(LiveView) == :ok
    end
  end

  describe "on_mount/4 when :account = name" do
    import LiveView, only: [on_mount: 4]

    setup [
      :checkout_repo,
      :c_name_account,
      :c_param,
      :c_session_token,
      :c_socket_account
    ]

    test "missing", %{
      name: %{account: name},
      param: %{valid: param},
      session: %{valid: session},
      socket: %{missing: socket!, valid: socket}
    } do
      assert on_mount(name, param, session, socket) == {:cont, socket!}
    end

    test "present", %{
      name: %{account: name},
      param: %{valid: param},
      session: %{token: session},
      socket: %{account: socket!, valid: socket}
    } do
      assert on_mount(name, param, session, socket) == {:cont, socket!}
    end
  end

  describe "on_mount/4 when :nonce = name" do
    import LiveView, only: [on_mount: 4]

    setup ~W[c_name_nonce c_param c_session_nonce c_socket_nonce]a

    test "failure", %{
      name: %{nonce: name},
      param: %{valid: param},
      session: %{valid: session},
      socket: %{redirected: socket!, valid: socket}
    } do
      assert on_mount(name, param, session, socket) == {:halt, socket!}
    end

    test "success", %{
      name: %{nonce: name},
      param: %{valid: param},
      session: %{nonce: session},
      socket: %{nonce: socket!, valid: socket}
    } do
      assert on_mount(name, param, session, socket) == {:cont, socket!}
    end
  end

  describe "on_mount/4 when :tenant = name" do
    import LiveView, only: [on_mount: 4]

    setup ~W[c_name_tenant c_param c_session_tenant c_socket_tenant]a

    test "failure", %{
      name: %{tenant: name},
      param: %{valid: param},
      session: %{valid: session},
      socket: %{redirected: socket!, valid: socket}
    } do
      assert on_mount(name, param, session, socket) == {:halt, socket!}
    end

    test "success", %{
      name: %{tenant: name},
      param: %{valid: param},
      session: %{tenant: session},
      socket: %{tenant: socket!, valid: socket}
    } do
      assert on_mount(name, param, session, socket) == {:cont, socket!}
    end
  end

  describe "on_mount/4 when is_atom(name)" do
    import LiveView, only: [on_mount: 4]

    setup ~W[checkout_repo c_name c_param c_session_default c_socket]a

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
      socket: %{valid: socket}
    } do
      assert {:halt, _socket} = on_mount(name, param, session, socket)
    end

    test "success", %{
      name: %{valid: name},
      param: %{valid: param},
      session: %{default: session},
      socket: %{valid: socket}
    } do
      assert {:cont, _socket} = on_mount(name, param, session, socket)
    end
  end
end
