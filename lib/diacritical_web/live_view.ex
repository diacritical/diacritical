defmodule DiacriticalWeb.LiveView do
  @moduledoc "Defines commonalities for `Phoenix.LiveView` views."
  @moduledoc since: "0.8.0"

  use Phoenix.VerifiedRoutes,
    endpoint: :"Elixir.DiacriticalWeb.Endpoint",
    router: :"Elixir.DiacriticalWeb.Router",
    statics: DiacriticalWeb.static_path()

  import DiacriticalWeb.Token, only: [verify: 1]
  import Phoenix.Component, only: [assign_new: 3]
  import Phoenix.LiveView

  alias Diacritical
  alias DiacriticalWeb

  alias Diacritical.Context
  alias DiacriticalWeb.HTML

  alias Context.Account
  alias HTML.Layout

  @typedoc "Represents the socket."
  @typedoc since: "0.8.0"
  @type socket() :: Phoenix.LiveView.Socket.t()

  @typedoc "Represents the potential nonce."
  @typedoc since: "0.8.0"
  @type maybe_nonce() :: nil | binary()

  @typedoc "Represents the potential host."
  @typedoc since: "0.12.0"
  @type maybe_host() :: nil | DiacriticalWeb.host()

  @typedoc "Represents the potential account."
  @typedoc since: "0.18.0"
  @type maybe_account() :: Account.maybe_account()

  @typedoc "Represents the session name."
  @typedoc since: "0.8.0"
  @type name() :: atom()

  @typedoc "Represents the parameter."
  @typedoc since: "0.8.0"
  @type param() :: Phoenix.LiveView.unsigned_params()

  @typedoc "Represents the session."
  @typedoc since: "0.8.0"
  @type session() :: map()

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

  @spec maybe_get_nonce(socket()) :: maybe_nonce()
  defp maybe_get_nonce(%Phoenix.LiveView.Socket{} = socket) do
    if connected?(socket) do
      maybe_token = get_connect_params(socket)["_csp_token"]

      case verify(maybe_token) do
        {:error, _error} -> nil
        {:ok, nonce} -> nonce
      end
    end
  end

  @spec maybe_get_host(socket()) :: maybe_host()
  defp maybe_get_host(%Phoenix.LiveView.Socket{} = socket) do
    if connected?(socket) do
      get_connect_params(socket)["host"]
    end
  end

  @spec maybe_get_account(session()) :: maybe_account()
  defp maybe_get_account(session) when is_map(session) do
    if token = session["token"] do
      Account.get_by_token_data_and_type(token, "session")
    end
  end

  @doc """
  Attaches a hook to apply common assignments onto the given `socket`.

  ## Examples

      iex> checkout_repo()
      iex> %{name: %{valid: name}} = c_name_default(%{})
      iex> %{param: %{valid: param}} = c_param()
      iex> %{session: %{valid: session}} = c_session()
      iex> %{socket: %{halted: socket!, unsigned: socket}} = c_socket_nonce(%{})
      iex>
      iex> on_mount(name, param, session, socket)
      {:halt, socket!}

      iex> checkout_repo()
      iex> %{token: %{loaded: %{data: data}}} = c = c_token_loaded()
      iex> %{name: %{valid: name}} = c_name_default(%{})
      iex> %{param: %{valid: param}} = c_param()
      iex> session = %{"token" => data}
      iex> %{socket: %{mounted: socket!, signed: socket}} = c_socket_nonce(c)
      iex>
      iex> on_mount(name, param, session, socket)
      {:cont, socket!}

      iex> checkout_repo()
      iex> %{token: %{loaded: %{data: data}}} = c = c_token_loaded()
      iex> %{name: %{valid: name}} = c_name_default(%{})
      iex> %{param: %{valid: param}} = c_param()
      iex> session = %{"token" => data}
      iex> %{socket: %{assigned: socket}} = c_socket_nonce(c)
      iex>
      iex> on_mount(name, param, session, socket)
      {:cont, socket}

  """
  @doc since: "0.8.0"
  @spec on_mount(name(), param(), session(), socket()) :: hook()
  def on_mount(name, param, session, %Phoenix.LiveView.Socket{} = socket)
      when is_atom(name) and is_map(param) and is_map(session) do
    maybe_nonce = maybe_get_nonce(socket)
    maybe_host = maybe_get_host(socket)

    if connected?(socket) && !(maybe_nonce || maybe_host) do
      {:halt, redirect(socket, to: ~p"/hello")}
    else
      {
        :cont,
        socket
        |> assign_new(:nonce, fn -> maybe_nonce end)
        |> assign_new(:tenant, fn -> DiacriticalWeb.to_tenant(maybe_host) end)
        |> assign_new(:account, fn -> maybe_get_account(session) end)
      }
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
      ...>   def mount(param, session, %Phoenix.LiveView.Socket{} = socket)
      ...>       when (is_map(param) or is_atom(param)) and is_map(session) do
      ...>     {:ok, assign(socket, greeting: Diacritical.greet())}
      ...>   end
      ...>
      ...>   @impl Phoenix.LiveView
      ...>   def render(assigns) when is_map(assigns) do
      ...>     ~H"<span><%= @greeting %></span>"
      ...>   end
      ...> end
      iex>
      iex> %{assigns: %{valid: assigns}} = c_assigns_greeting()
      iex> c = c_resp_body_greet()
      iex> %{resp_body: resp_body} = c_resp_body_to_html(c)
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
      iex> render_component(TestLiveView, assigns) =~ resp_body
      true

  """
  @doc since: "0.8.0"
  defmacro __using__(opt) when is_list(opt) do
    quote do
      use Phoenix.LiveView,
          Keyword.merge([layout: {Layout, :app}], unquote(opt))

      use Phoenix.VerifiedRoutes,
        endpoint: :"Elixir.DiacriticalWeb.Endpoint",
        router: :"Elixir.DiacriticalWeb.Router",
        statics: DiacriticalWeb.static_path()

      on_mount(unquote(__MODULE__))
    end
  end
end
