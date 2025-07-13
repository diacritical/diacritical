defmodule Diacritical do
  @moduledoc "Demonstrates `Kernel` syntax."
  @moduledoc since: "0.1.0"

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
  def greet(), do: "Hello, world!"
end
