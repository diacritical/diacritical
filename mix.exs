defmodule Diacritical.MixProject do
  @moduledoc "Defines a `Mix.Project` project."
  @moduledoc since: "0.1.0"

  use Mix.Project

  @typedoc "Represents the project configuration keyword."
  @typedoc since: "0.1.0"
  @type project_keyword() ::
          {:app, Application.app()}
          | {:version, String.t()}
          | {Keyword.key(), Keyword.value()}

  @typedoc "Represents the project configuration."
  @typedoc since: "0.1.0"
  @type project() :: [project_keyword()]

  @doc """
  Returns the project configuration.

  ## Example

      iex> project()[:app]
      :diacritical

  """
  @doc since: "0.1.0"
  @spec project() :: project()
  def project() do
    [
      app: :diacritical,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      version: "0.1.0"
    ]
  end
end
