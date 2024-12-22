defmodule DiacriticalWeb.LiveView do
  @moduledoc "Defines commonalities for `Phoenix.LiveView` views."
  @moduledoc since: "0.8.0"

  use Phoenix.VerifiedRoutes,
    endpoint: :"Elixir.DiacriticalWeb.Endpoint",
    router: :"Elixir.DiacriticalWeb.Router",
    statics: DiacriticalWeb.static_path()

  import Phoenix.Component, only: [assign_new: 3]
  import Phoenix.LiveView

  alias Diacritical
  alias DiacriticalWeb

  alias Diacritical.Context
  alias DiacriticalWeb.Component
  alias DiacriticalWeb.HTML

  alias Context.Account
  alias HTML.Layout

  @typedoc "Represents the session."
  @typedoc since: "0.8.0"
  @type session() :: map()

  @typedoc "Represents the potential account."
  @typedoc since: "0.17.0"
  @type maybe_account() :: Account.maybe_account()

  @typedoc "Represents the potential nonce."
  @typedoc since: "0.8.0"
  @type maybe_nonce() :: nil | DiacriticalWeb.nonce()

  @typedoc "Represents the potential tenant."
  @typedoc since: "0.23.0"
  @type maybe_tenant() :: nil | DiacriticalWeb.tenant()

  @typedoc "Represents the session name."
  @typedoc since: "0.8.0"
  @type name() :: atom()

  @typedoc "Represents the parameter."
  @typedoc since: "0.8.0"
  @type param() :: Phoenix.LiveView.unsigned_params()

  @typedoc "Represents the socket."
  @typedoc since: "0.8.0"
  @type socket() :: Phoenix.LiveView.Socket.t()

  @typedoc "Represents the status."
  @typedoc since: "0.8.0"
  @type status() :: :cont | :halt

  @typedoc "Represents the hook."
  @typedoc since: "0.8.0"
  @type hook() :: {status(), socket()}

  @typedoc "Represents the assigns."
  @typedoc since: "0.8.0"
  @type assigns() :: DiacriticalWeb.assigns()

  @typedoc "Represents the opt keyword."
  @typedoc since: "0.8.0"
  @type opt_keyword() ::
          {:layout, {module(), String.t()}}
          | {:temporary_assigns, Keyword.t()}

  @typedoc "Represents the opt."
  @typedoc since: "0.8.0"
  @type opt() :: [opt_keyword()]

  @typedoc "Represents the mount."
  @typedoc since: "0.8.0"
  @type mount() :: {:ok, socket()} | {:ok, socket(), opt()}

  @typedoc "Represents the render."
  @typedoc since: "0.8.0"
  @type render() :: DiacriticalWeb.render()

  @spec maybe_get_account(session()) :: maybe_account()
  defp maybe_get_account(session) when is_map(session) do
    if token = session["token"] do
      Account.get_by_token_data_and_type(token, "session")
    end
  end

  @spec maybe_get_nonce(session()) :: maybe_nonce()
  defp maybe_get_nonce(session) when is_map(session) do
    session["nonce"]
  end

  @spec maybe_get_tenant(session()) :: maybe_tenant()
  defp maybe_get_tenant(session) when is_map(session) do
    session["tenant"]
  end

  @doc """
  Attaches a hook to apply common assignments onto the given `socket`.

  ## Examples

      iex> checkout_repo()
      iex> %{name: %{account: name}} = c_name_account(%{})
      iex> %{param: %{valid: param}} = c_param()
      iex> %{session: %{token: session}} = c = c_session_token(%{})
      iex> %{socket: %{account: socket!, valid: socket}} = c_socket_account(c)
      iex>
      iex> on_mount(name, param, session, socket)
      {:cont, socket!}

      iex> %{name: %{nonce: name}} = c_name_nonce(%{})
      iex> %{param: %{valid: param}} = c_param()
      iex> %{session: %{nonce: session}} = c = c_session_nonce(%{})
      iex> %{socket: %{nonce: socket!, valid: socket}} = c_socket_nonce(c)
      iex>
      iex> on_mount(name, param, session, socket)
      {:cont, socket!}

      iex> checkout_repo()
      iex> %{name: %{require_account: name}} = c_name_require_account(%{})
      iex> %{param: %{valid: param}} = c_param()
      iex> %{session: %{valid: session}} = c_session(%{})
      iex> %{socket: %{account: socket}} = c_socket_account(%{})
      iex>
      iex> on_mount(name, param, session, socket)
      {:cont, socket}

      iex> %{name: %{tenant: name}} = c_name_tenant(%{})
      iex> %{param: %{valid: param}} = c_param()
      iex> %{session: %{tenant: session}} = c = c_session_tenant(%{})
      iex> %{socket: %{tenant: socket!, valid: socket}} = c_socket_tenant(c)
      iex>
      iex> on_mount(name, param, session, socket)
      {:cont, socket!}

  """
  @doc since: "0.8.0"
  @spec on_mount(name(), param(), session(), socket()) :: hook()
  def on_mount(:account, param, session, socket)
      when is_map(param) and is_map(session) and
             is_struct(socket, Phoenix.LiveView.Socket) do
    {:cont, assign_new(socket, :account, fn -> maybe_get_account(session) end)}
  end

  def on_mount(:nonce, param, session, socket)
      when is_map(param) and is_map(session) and
             is_struct(socket, Phoenix.LiveView.Socket) do
    case maybe_get_nonce(session) do
      nil -> {:halt, redirect(socket, to: ~p"/hello")}
      nonce -> {:cont, assign_new(socket, :nonce, fn -> nonce end)}
    end
  end

  def on_mount(:require_account, param, session, socket)
      when is_map(param) and is_map(session) and
             is_struct(socket, Phoenix.LiveView.Socket) do
    case socket.assigns[:account] do
      nil -> {:halt, redirect(socket, to: ~p"/hello")}
      _account -> {:cont, socket}
    end
  end

  def on_mount(:tenant, param, session, socket)
      when is_map(param) and is_map(session) and
             is_struct(socket, Phoenix.LiveView.Socket) do
    case maybe_get_tenant(session) do
      nil -> {:halt, redirect(socket, to: ~p"/hello")}
      tenant -> {:cont, assign_new(socket, :tenant, fn -> tenant end)}
    end
  end

  def on_mount(name, param, session, socket)
      when is_atom(name) and is_map(param) and is_map(session) and
             is_struct(socket, Phoenix.LiveView.Socket) do
    with {:cont, socket} <- on_mount(:nonce, param, session, socket),
         {:cont, socket} <- on_mount(:tenant, param, session, socket) do
      on_mount(:account, param, session, socket)
    end
  end

  @doc """
  In `use`, calls `use Phoenix.LiveView` with a defined `:layout` and hooks.

  ## Example

      iex> defmodule TestLiveView do
      ...>   use DiacriticalWeb.LiveView
      ...>
      ...>   alias Diacritical
      ...>
      ...>   @impl Phoenix.LiveView
      ...>   def mount(param, session, socket)
      ...>       when (is_atom(param) or is_map(param)) and is_map(session) and
      ...>              is_struct(socket, Phoenix.LiveView.Socket) do
      ...>     {:ok, assign(socket, :greeting, Diacritical.greet())}
      ...>   end
      ...>
      ...>   @impl Phoenix.LiveView
      ...>   def render(assigns) when is_map(assigns) do
      ...>     ~H"<span>{@greeting}</span>"
      ...>   end
      ...> end
      iex>
      iex> %{assigns: %{valid: assigns}} = c_assigns_greeting()
      iex> render = render_component(TestLiveView, assigns)
      iex> %{selector: selector} = c_selector_span()
      iex>
      iex> TestLiveView.__live__()
      %{
        container: {:div, []},
        kind: :view,
        layout: {Layout, "app"},
        lifecycle: %Phoenix.LiveView.Lifecycle{
          mount: [
            %{
              function: &LiveView.on_mount/4,
              id: {LiveView, :default},
              stage: :mount
            }
          ]
        },
        log: :debug
      }
      iex> assert_element render, selector
      true

  """
  @doc since: "0.8.0"
  defmacro __using__(opt) when is_list(opt) do
    quote do
      use Gettext, backend: Diacritical.Gettext

      use Phoenix.LiveView,
          Keyword.merge([layout: {Layout, :app}], unquote(opt))

      use Phoenix.VerifiedRoutes,
        endpoint: :"Elixir.DiacriticalWeb.Endpoint",
        router: :"Elixir.DiacriticalWeb.Router",
        statics: DiacriticalWeb.static_path()

      import Component

      on_mount(unquote(__MODULE__))
    end
  end
end
