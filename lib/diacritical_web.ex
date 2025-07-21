defmodule DiacriticalWeb do
  @moduledoc "Defines commonalities for `Phoenix` modules."
  @moduledoc since: "0.4.0"

  use Boundary,
    deps: [
      Diacritical,
      EEx.Engine,
      Phoenix,
      Phoenix.PubSub,
      Phoenix.Template,
      Plug
    ],
    exports: [Endpoint]
end
