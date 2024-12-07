defmodule DiacriticalWeb do
  @moduledoc "Defines commonalities for `Phoenix` modules."
  @moduledoc since: "0.4.0"

  use Boundary,
    deps: [
      Diacritical,
      EEx.Engine,
      Logger,
      Phoenix,
      Phoenix.HTML,
      Phoenix.LiveReloader,
      Phoenix.PubSub,
      Phoenix.Template,
      Plug
    ],
    exports: [Endpoint]

  @typedoc "Represents the static path."
  @typedoc since: "0.6.0"
  @type static_path() :: [Path.t()]

  @typedoc "Represents the connection."
  @typedoc since: "0.5.0"
  @type conn() :: Plug.Conn.t()

  @typedoc "Represents the connection option."
  @typedoc since: "0.5.0"
  @type opt() :: Plug.opts()

  @doc """
  Returns the path for static assets.

  ## Example

      iex> static_path()
      ~W[asset bimi.svg favicon.ico robots.txt]

  """
  @doc since: "0.6.0"
  @spec static_path() :: static_path()
  def static_path(), do: ~W[asset bimi.svg favicon.ico robots.txt]
end
