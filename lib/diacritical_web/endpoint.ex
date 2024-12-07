defmodule DiacriticalWeb.Endpoint do
  @moduledoc "Defines a `Plug` plug."
  @moduledoc since: "0.4.0"

  @behaviour Plug

  import Plug.Conn

  alias Diacritical
  alias DiacriticalWeb

  @typedoc "Represents the connection option."
  @typedoc since: "0.4.0"
  @type opt() :: Plug.opts()

  @typedoc "Represents the connection."
  @typedoc since: "0.4.0"
  @type conn() :: Plug.Conn.t()

  @impl Plug
  @doc """
  Initializes the plug with the given `opt`.

  ## Example

      iex> %{opt: opt} = c_opt(%{})
      iex>
      iex> init(opt)
      opt

  """
  @doc since: "0.4.0"
  @spec init(opt()) :: opt()
  def init(opt), do: opt

  @impl Plug
  @doc """
  Greets the world (for the given `conn` and `opt`)!

  ## Example

      iex> c = c_request_path_hello(%{})
      iex> %{conn: %{valid: conn}} = c_conn(c)
      iex> %{opt: opt} = c_opt(%{})
      iex> %{status: status} = c_status_ok(%{})
      iex> c! = c_resp_headers_cache_default(%{})
      iex> %{resp_headers: resp_headers} = c_resp_headers_content_plaintext(c!)
      iex> %{resp_body: resp_body} = c_resp_body_greet(%{})
      iex>
      iex> sent_resp(call(conn, opt))
      {status, resp_headers, resp_body}

  """
  @doc since: "0.4.0"
  @spec call(conn(), opt()) :: conn()
  def call(conn, _opt) when is_struct(conn, Plug.Conn) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "#{Diacritical.greet()}\n")
  end
end
