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

  ## Examples

      iex> project()[:app]
      :diacritical

      iex> project()[:version]
      "0.1.0"

  """
  @doc since: "0.1.0"
  @spec project() :: project()
  def project() do
    [
      app: :diacritical,
      deps: [],
      deps_path: "dep",
      elixir: "~> 1.16",
      elixirc_options: [warnings_as_errors: true],
      start_permanent: Mix.env() == :prod,
      version: "0.1.0"
    ]
  end
end
