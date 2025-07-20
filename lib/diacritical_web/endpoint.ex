defmodule DiacriticalWeb.Endpoint do
  @moduledoc "Defines a `Phoenix.Endpoint` endpoint."
  @moduledoc since: "0.4.0"

  use Phoenix.Endpoint, otp_app: :diacritical

  alias Diacritical
  alias DiacriticalWeb

  @typedoc "Represents the connection."
  @typedoc since: "0.4.0"
  @type conn() :: Plug.Conn.t()

  @typedoc "Represents the connection option."
  @typedoc since: "0.4.0"
  @type opt() :: Plug.opts()

  @doc """
  Greets the world (for the given `conn` and `opt`)!

  ## Example

      iex> c = c_request_path(%{})
      iex> %{conn: %{valid: conn}} = c_conn(c)
      iex> %{opt: opt} = c_opt(%{})
      iex> %{status: status} = c_status(%{})
      iex> %{resp_body: resp_body} = c_resp_body(%{})
      iex>
      iex> text_response(greet(conn, opt), status)
      resp_body

  """
  @doc since: "0.4.0"
  @spec greet(conn(), opt()) :: conn()
  def greet(conn, _opt) when is_struct(conn, Plug.Conn) do
    Phoenix.Controller.text(conn, "#{Diacritical.greet()}\n")
  end

  plug :greet
end
