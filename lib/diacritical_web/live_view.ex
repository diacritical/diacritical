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

  alias DiacriticalWeb

  alias DiacriticalWeb.HTML

  alias HTML.Layout

  @typedoc "Represents the socket."
  @typedoc since: "0.8.0"
  @type socket() :: Phoenix.LiveView.Socket.t()

  @typedoc "Represents the potential nonce."
  @typedoc since: "0.8.0"
  @type maybe_nonce() :: nil | binary()

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

  @doc """
  Attaches a hook to apply common assignments onto the given `socket`.

  ## Examples

      iex> %{name: %{valid: name}} = c_name_default(%{})
      iex> %{param: %{valid: param}} = c_param(%{})
      iex> %{session: %{valid: session}} = c_session(%{})
      iex> %{socket: %{halted: socket!, unsigned: socket}} = c_socket_nonce(%{})
      iex>
      iex> on_mount(name, param, session, socket)
      {:halt, socket!}

      iex> %{name: %{valid: name}} = c_name_default(%{})
      iex> %{param: %{valid: param}} = c_param(%{})
      iex> %{session: %{valid: session}} = c_session(%{})
      iex> %{socket: %{mounted: socket!, signed: socket}} = c_socket_nonce(%{})
      iex>
      iex> on_mount(name, param, session, socket)
      {:cont, socket!}

      iex> %{name: %{valid: name}} = c_name_default(%{})
      iex> %{param: %{valid: param}} = c_param(%{})
      iex> %{session: %{valid: session}} = c_session(%{})
      iex> %{socket: %{assigned: socket}} = c_socket_nonce(%{})
      iex>
      iex> on_mount(name, param, session, socket)
      {:cont, socket}

  """
  @doc since: "0.8.0"
  @spec on_mount(name(), param(), session(), socket()) :: hook()
  def on_mount(name, param, session, %Phoenix.LiveView.Socket{} = socket)
      when is_atom(name) and is_map(param) and is_map(session) do
    maybe_nonce = maybe_get_nonce(socket)

    if connected?(socket) && !maybe_nonce do
      {:halt, redirect(socket, to: ~p"/hello")}
    else
      {:cont, assign_new(socket, :nonce, fn -> maybe_nonce end)}
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
