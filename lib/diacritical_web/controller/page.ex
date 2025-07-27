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

      iex> c = c_request_path()
      iex> c! = c_conn(c)
      iex> c! = c_conn_format(c!)
      iex> %{conn: %{valid: conn}} = c_conn_view(c!)
      iex> %{opt: opt} = c_opt()
      iex> %{status: status} = c_status()
      iex> %{resp_body: resp_body} = c_resp_body_greeting()
      iex>
      iex> text_response(greet(conn, opt), status)
      resp_body

  """
  @doc since: "0.5.0"
  @spec greet(conn(), opt()) :: conn()
  def greet(conn, _opt) when is_struct(conn, Plug.Conn) do
    render(conn, :greet, greeting: Diacritical.greet())
  end
end
