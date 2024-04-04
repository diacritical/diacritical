defmodule Diacritical do
  @moduledoc "Demonstrates `Kernel` syntax."
  @moduledoc since: "0.1.0"

  use Boundary,
    deps: [
      DiacriticalSchema,
      Ecto,
      Ecto.Adapters.Postgres,
      Ecto.Adapters.SQL,
      Ecto.Migrator,
      Gettext,
      Logger,
      Swoosh
    ],
    exports: [{Context, []}, I18n, Repo, Supervisor]

  import Diacritical.I18n

  @typedoc "Represents the greeting."
  @typedoc since: "0.1.0"
  @type greeting() :: String.t()

  @doc """
  Greets the world!

  ## Example

      iex> greet()
      "Hello, world!"

  """
  @doc since: "0.1.0"
  @spec greet() :: greeting()
  def greet(), do: gettext("Hello, world!")
end
