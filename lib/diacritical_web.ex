defmodule DiacriticalWeb do
  @moduledoc "Defines commonalities for `Phoenix` modules."
  @moduledoc since: "0.4.0"

  use Boundary,
    deps: [
      Diacritical,
      EEx.Engine,
      Logger,
      Phoenix,
      Phoenix.Component,
      Phoenix.Ecto,
      Phoenix.HTML,
      Phoenix.LiveReloader,
      Phoenix.LiveView,
      Phoenix.PubSub,
      Phoenix.Template,
      Plug
    ],
    exports: [Endpoint]

  @typedoc "Represents the static path."
  @typedoc since: "0.6.0"
  @type static_path() :: [Path.t()]

  @typedoc "Represents the host."
  @typedoc since: "0.11.0"
  @type host() :: String.t()

  @typedoc "Represents the tenant."
  @typedoc since: "0.11.0"
  @type tenant() :: String.t()

  @typedoc "Represents the assigns."
  @typedoc since: "0.8.0"
  @type assigns() :: Phoenix.LiveView.Socket.assigns()

  @typedoc "Represents the connection."
  @typedoc since: "0.5.0"
  @type conn() :: Plug.Conn.t()

  @typedoc "Represents the nonce."
  @typedoc since: "0.8.0"
  @type nonce() :: binary()

  @typedoc "Represents the connection option."
  @typedoc since: "0.5.0"
  @type opt() :: Plug.opts()

  @typedoc "Represents the render."
  @typedoc since: "0.8.0"
  @type render() :: Phoenix.LiveView.Rendered.t()

  @doc """
  Returns the path for static assets.

  ## Example

      iex> static_path()
      ~W[asset bimi.svg favicon.ico robots.txt]

  """
  @doc since: "0.6.0"
  @spec static_path() :: static_path()
  def static_path(), do: ~W[asset bimi.svg favicon.ico robots.txt]

  @doc """
  Returns the tenant for the given `host`.

  ## Example

      iex> to_tenant("example.com")
      "com_example"

  """
  @doc since: "0.11.0"
  @spec to_tenant(host()) :: tenant()
  def to_tenant(host) when is_binary(host) do
    delimiter = "."

    host
    |> String.trim(delimiter)
    |> String.split(delimiter)
    |> Enum.reverse()
    |> Enum.join("_")
  end
end
