defmodule DiacriticalWeb.Endpoint do
  @moduledoc "Defines a `Phoenix.Endpoint` endpoint."
  @moduledoc since: "0.4.0"

  use Phoenix.Endpoint, otp_app: :diacritical

  alias DiacriticalWeb

  alias DiacriticalWeb.Controller
  alias DiacriticalWeb.Router

  alias Controller.Page

  @typedoc "Represents the connection."
  @typedoc since: "0.4.0"
  @type conn() :: DiacriticalWeb.conn()

  @typedoc "Represents the connection option."
  @typedoc since: "0.4.0"
  @type opt() :: DiacriticalWeb.opt()

  @doc """
  Greets the world (for the given `conn` and `opt`)!

  ## Example

      iex> c = c_request_path_hello()
      iex> %{conn: %{valid: conn}} = c_conn(c)
      iex> %{opt: opt} = c_opt()
      iex> %{status: status} = c_status_ok()
      iex> %{resp_body: resp_body} = c_resp_body_greet()
      iex>
      iex> text_response(greet(conn, opt), status)
      resp_body

  """
  @doc since: "0.4.0"
  @spec greet(conn(), opt()) :: conn()
  def greet(conn, _opt) when is_struct(conn, Plug.Conn) do
    conn
    |> Phoenix.Controller.accepts(["txt", "text"])
    |> Page.call(:greet)
  end

  socket "/live",
         Phoenix.LiveView.Socket,
         longpoll: [connect_info: [session: config[:session]]],
         websocket: [connect_info: [session: config[:session]]]

  plug Plug.Static,
    at: "/",
    from: {:diacritical, "priv/diacritical_web/static"},
    only: DiacriticalWeb.static_path()

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.CodeReloader
    plug Phoenix.LiveReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :diacritical
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    cookie_key: "request_logger",
    param_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    json_decoder: Phoenix.json_library(),
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"]

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, config[:session]
  plug Router
end
