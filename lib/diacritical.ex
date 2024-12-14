defmodule Diacritical do
  @moduledoc "Demonstrates `Kernel` syntax."
  @moduledoc since: "0.1.0"

  use Boundary,
    deps: [Ecto, Ecto.Adapters.Postgres, Ecto.Adapters.SQL, Ecto.Migrator],
    exports: [Supervisor]

  @typedoc "Represents the greeting."
  @typedoc since: "0.1.0"
  @type greeting() :: String.t()

  @typedoc "Represents the application."
  @typedoc since: "0.10.0"
  @type app() :: Application.app()

  @doc """
  Greets the world!

  ## Example

      iex> greet()
      "Hello, world!"

  """
  @doc since: "0.1.0"
  @spec greet() :: greeting()
  def greet(), do: "Hello, world!"
end
