defmodule DiacriticalWeb do
  @moduledoc "Defines commonalities for `Phoenix` modules."
  @moduledoc since: "0.4.0"

  use Boundary,
    deps: [Diacritical, Phoenix, Phoenix.PubSub, Plug],
    exports: [Endpoint]
end
