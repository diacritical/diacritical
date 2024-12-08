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
      Phoenix.PubSub,
      Phoenix.Template,
      Plug
    ],
    exports: [Endpoint]

  @typedoc "Represents the connection."
  @typedoc since: "0.5.0"
  @type conn() :: Plug.Conn.t()

  @typedoc "Represents the connection option."
  @typedoc since: "0.5.0"
  @type opt() :: Plug.opts()
end
