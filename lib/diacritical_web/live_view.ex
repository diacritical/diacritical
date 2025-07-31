defmodule DiacriticalWeb.LiveView do
  @moduledoc "Defines commonalities for `Phoenix.LiveView` views."
  @moduledoc since: "0.8.0"

  use Phoenix.VerifiedRoutes,
    endpoint: :"Elixir.DiacriticalWeb.Endpoint",
    router: :"Elixir.DiacriticalWeb.Router",
    statics: DiacriticalWeb.get_static_path()

  import Phoenix.Component, only: [assign_new: 3]
  import Phoenix.LiveView

  alias DiacriticalWeb

  alias DiacriticalWeb.HTML

  alias HTML.Layout

  @typedoc "Represents the session."
  @typedoc since: "0.8.0"
  @type session() :: map()

  @typedoc "Represents the potential nonce."
  @typedoc since: "0.8.0"
  @type maybe_nonce() :: nil | DiacriticalWeb.nonce()

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

  @spec maybe_get_nonce(session()) :: maybe_nonce()
  defp maybe_get_nonce(session) when is_map(session) do
    session["nonce"]
  end

  @doc """
  Attaches a hook to apply common assignments onto the given `socket`.

  ## Example

      iex> %{name: %{valid: name}} = c_name(%{})
      iex> %{param: %{valid: param}} = c_param()
      iex> %{session: %{nonce: session}} = c = c_session()
      iex> %{socket: %{nonce: socket!, valid: socket}} = c_socket_nonce(c)
      iex>
      iex> on_mount(name, param, session, socket)
      {:cont, socket!}

  """
  @doc since: "0.8.0"
  @spec on_mount(name(), param(), session(), socket()) :: hook()
  def on_mount(name, param, session, socket)
      when is_atom(name) and is_map(param) and is_map(session) and
             is_struct(socket, Phoenix.LiveView.Socket) do
    case maybe_get_nonce(session) do
      nil -> {:halt, redirect(socket, to: ~p"/hello")}
      nonce -> {:cont, assign_new(socket, :nonce, fn -> nonce end)}
    end
  end

  @doc """
  In `use`, calls `use Phoenix.LiveView` with a default `:layout` and hooks.

  ## Example

      iex> defmodule TestLiveView do
      ...>   use DiacriticalWeb.LiveView
      ...>
      ...>   @impl Phoenix.LiveView
      ...>   def mount(param, session, socket)
      ...>       when (is_atom(param) or is_map(param)) and is_map(session) and
      ...>              is_struct(socket, Phoenix.LiveView.Socket) do
      ...>     {:ok, socket}
      ...>   end
      ...>
      ...>   @impl Phoenix.LiveView
      ...>   def render(assigns) when is_map(assigns) do
      ...>     ~H\"""
      ...>     <span>{assigns[:dismissal] || "Goodbye, world!"}</span>
      ...>     \"""
      ...>   end
      ...> end
      iex>
      iex> %{assigns: %{valid: assigns}} = c_assigns()
      iex> c = c_resp_body_dismissal()
      iex> %{resp_body: resp_body} = c_resp_body_to_html(c)
      iex>
      iex> TestLiveView.__live__()
      %{
        container: {:div, []},
        kind: :view,
        layout: {Layout, "main"},
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
          Keyword.merge([layout: {Layout, :main}], unquote(opt))

      use Phoenix.VerifiedRoutes,
        endpoint: :"Elixir.DiacriticalWeb.Endpoint",
        router: :"Elixir.DiacriticalWeb.Router",
        statics: DiacriticalWeb.get_static_path()

      on_mount(unquote(__MODULE__))
    end
  end
end
