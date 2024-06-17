defmodule DiacriticalWeb.Controller.Page do
  @moduledoc "Defines a `Phoenix.Controller` controller."
  @moduledoc since: "0.5.0"

  use DiacriticalWeb.Controller,
    view: [html: DiacriticalWeb.HTML.Page, txt: DiacriticalWeb.TXT.Page]

  alias Diacritical
  alias DiacriticalWeb

  alias DiacriticalWeb.Controller

  @typedoc "Represents the connection."
  @typedoc since: "0.5.0"
  @type conn() :: Controller.conn()

  @typedoc "Represents the connection option."
  @typedoc since: "0.5.0"
  @type opt() :: Controller.opt()

  @doc """
  Handles a controller action, `:greet`, for the given `conn` and `opt`.

  ## Example

      iex> c = c_request_path_hello()
      iex> c! = c_conn(c)
      iex> %{conn: %{valid: conn}} = c_conn_format_txt(c!)
      iex> %{action: %{valid: action}} = c_action_greet()
      iex> %{status: status} = c_status_ok()
      iex> %{resp_body: resp_body} = c_resp_body_greet()
      iex>
      iex> text_response(call(conn, action), status)
      resp_body

  """
  @doc since: "0.5.0"
  @spec greet(conn(), opt()) :: conn()
  def greet(conn, _opt) when is_struct(conn, Plug.Conn) do
    render(conn, :greet, greeting: Diacritical.greet())
  end
end
