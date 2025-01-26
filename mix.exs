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
      aliases: [
        "boundary.ex_doc_groups": [
          "boundary.ex_doc_groups",
          "cmd sed 1d boundary.exs > .boundary.exs",
          "cmd rm boundary.exs"
        ],
        credo: "credo --config-name default"
      ],
      app: :diacritical,
      boundary: [default: [type: :strict]],
      compilers: [:boundary | Mix.compilers()],
      deps: [
        {:boundary, "~> 0.10", runtime: false},
        {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
        {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
      ],
      deps_path: "dep",
      elixir: "~> 1.18",
      elixirc_options: [warnings_as_errors: true],
      start_permanent: Mix.env() == :prod,
      version: "0.1.0"
    ]
  end
end
