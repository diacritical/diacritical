defmodule DiacriticalWeb.Controller do
  @moduledoc "Defines commonalities for `Phoenix.Controller` controllers."
  @moduledoc since: "0.5.0"

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
      iex> %{conn: %{valid: c!}} = c_conn_format(c)
      iex> %{action: %{valid: action}} = c_action(%{})
      iex> conn = TestController.call(c!, action)
      iex>
      iex> Phoenix.Controller.layout(conn)
      false
      iex> Phoenix.Controller.view_module(conn)
      DiacriticalWeb.TXT.Page

  """
  @doc since: "0.5.0"
  defmacro __using__(opt) when is_list(opt) do
    quote do
      use Phoenix.Controller,
          Keyword.merge([put_default_views: false], unquote(opt))

      plug :put_new_view, unquote(opt)[:view]
    end
  end
end
