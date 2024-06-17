defmodule DiacriticalWeb.Controller do
  @moduledoc "Defines commonalities for `Phoenix.Controller` controllers."
  @moduledoc since: "0.5.0"

  alias Diacritical
  alias DiacriticalWeb

  alias Diacritical.I18n
  alias DiacriticalWeb.HTML

  alias HTML.Layout

  @typedoc "Represents the connection."
  @typedoc since: "0.5.0"
  @type conn() :: DiacriticalWeb.conn()

  @typedoc "Represents the connection option."
  @typedoc since: "0.5.0"
  @type opt() :: DiacriticalWeb.opt()

  @doc """
  In `use`, calls `use Phoenix.Controller`, then stores the associated view.

  ## Example

      iex> defmodule TestController do
      ...>   use DiacriticalWeb.Controller, view: [txt: DiacriticalWeb.TXT.Page]
      ...>
      ...>   alias Diacritical
      ...>
      ...>   def greet(conn, _param) when is_struct(conn, Plug.Conn) do
      ...>     render(conn, :greet, greeting: Diacritical.greet())
      ...>   end
      ...> end
      iex>
      iex> c = c_conn()
      iex> %{conn: %{valid: c!}} = c_conn_format_txt(c)
      iex> %{action: %{valid: action}} = c_action_greet(%{})
      iex> conn = TestController.call(c!, action)
      iex>
      iex> Phoenix.Controller.layout(conn)
      false
      iex> Phoenix.Controller.view_module(conn)
      DiacriticalWeb.TXT.Page

  """
  @doc since: "0.5.0"
  defmacro __using__(opt) when is_list(opt) do
    quote bind_quoted: [opt: opt] do
      use Phoenix.Controller, Keyword.merge([put_default_views: false], opt)

      use Phoenix.VerifiedRoutes,
        endpoint: :"Elixir.DiacriticalWeb.Endpoint",
        router: :"Elixir.DiacriticalWeb.Router",
        statics: DiacriticalWeb.static_path()

      import I18n

      plug :put_layout, html: {Layout, :app}
      plug :put_new_view, opt[:view]
    end
  end
end
