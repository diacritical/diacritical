defmodule DiacriticalWeb.LiveView.Page do
  @moduledoc "Defines a `Phoenix.LiveView` view."
  @moduledoc since: "0.8.0"

  use DiacriticalWeb.LiveView

  alias Diacritical
  alias DiacriticalWeb

  alias DiacriticalWeb.LiveView

  @typedoc "Represents the parameter."
  @typedoc since: "0.8.0"
  @type param() :: LiveView.param()

  @typedoc "Represents the session."
  @typedoc since: "0.8.0"
  @type session() :: LiveView.session()

  @typedoc "Represents the socket."
  @typedoc since: "0.8.0"
  @type socket() :: LiveView.socket()

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

  @typedoc "Represents the assigns."
  @typedoc since: "0.8.0"
  @type assigns() :: Phoenix.LiveView.Socket.assigns()

  @typedoc "Represents the render."
  @typedoc since: "0.8.0"
  @type render() :: Phoenix.LiveView.Rendered.t()

  @impl Phoenix.LiveView
  @doc """
  Defines an entrypoint with the given `param`, `session`, and `socket`.

  ## Example

      iex> %{param: %{valid: param}} = c_param()
      iex> %{session: %{valid: session}} = c_session()
      iex> %{socket: %{valid: socket}} = c_socket()
      iex>  
      iex> {
      ...>   :ok,
      ...>   %Phoenix.LiveView.Socket{
      ...>     assigns: %{__changed__: %{greeting: true}}
      ...>   }
      ...> } = mount(param, session, socket)

  """
  @doc since: "0.8.0"
  @spec mount(param(), session(), socket()) :: mount()
  def mount(param, session, socket)
      when (is_atom(param) or is_map(param)) and is_map(session) and
             is_struct(socket, Phoenix.LiveView.Socket) do
    {:ok, assign(socket, :greeting, Diacritical.greet())}
  end

  @impl Phoenix.LiveView
  @doc """
  Renders a template for the given `assigns`.

  ## Example

      iex> %{assigns: %{valid: assigns}} = c_assigns_greeting()
      iex> c = c_resp_body_greeting()
      iex> %{resp_body: resp_body} = c_resp_body_to_html(c)
      iex>  
      iex> render_component(Page, assigns) =~ resp_body
      true

  """
  @doc since: "0.8.0"
  @spec render(assigns()) :: render()
  def render(assigns) when is_map(assigns) do
    ~H"""
    <span>{@greeting}</span>
    """
  end
end
