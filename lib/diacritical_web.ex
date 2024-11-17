defmodule DiacriticalWeb do
  @moduledoc "Defines commonalities for `Plug` plugs."
  @moduledoc since: "0.4.0"

  use Boundary, deps: [Diacritical, Plug]
end
