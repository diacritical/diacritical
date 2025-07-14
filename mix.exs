defmodule Diacritical.MixProject do
  @moduledoc "Defines a `Mix.Project` project."
  @moduledoc since: "0.1.0"

  use Mix.Project

  @typedoc "Represents the environment."
  @typedoc since: "0.2.0"
  @type env() :: :dev | :prod | :test | atom()

  @typedoc "Represents the module documentation group."
  @typedoc since: "0.2.0"
  @type moduledoc_group() :: nil | Keyword.t([module()])

  @typedoc "Represents the compilation path."
  @typedoc since: "0.2.0"
  @type elixirc_path() :: [Path.t()]

  @typedoc "Represents the project configuration keyword."
  @typedoc since: "0.1.0"
  @type project_keyword() ::
          {:app, Application.app()}
          | {:version, String.t()}
          | {Keyword.key(), Keyword.value()}

  @typedoc "Represents the project configuration."
  @typedoc since: "0.1.0"
  @type project() :: [project_keyword()]

  @spec load_moduledoc_group(env()) :: moduledoc_group()
  defp load_moduledoc_group(:dev) do
    ".boundary.exs"
    |> Code.eval_file()
    |> elem(0)
  end

  defp load_moduledoc_group(env) when is_atom(env), do: nil

  @spec get_elixirc_path(env()) :: elixirc_path()
  defp get_elixirc_path(:dev), do: get_elixirc_path(:test)
  defp get_elixirc_path(:test), do: ["support" | get_elixirc_path(:prod)]
  defp get_elixirc_path(env) when is_atom(env), do: ["lib"]

  @doc """
  Returns the project configuration.

  ## Example

      iex> project()[:app]
      :diacritical

  """
  @doc since: "0.1.0"
  @spec project() :: project()
  def project() do
    env = Mix.env()

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
        {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
        {:ex_doc, "~> 0.38", only: :dev, runtime: false}
      ],
      deps_path: "dep",
      dialyzer: [ignore_warnings: ".dialyzer.exs"],
      docs: [groups_for_modules: load_moduledoc_group(env)],
      elixir: "~> 1.18",
      elixirc_options: [warnings_as_errors: true],
      elixirc_paths: get_elixirc_path(env),
      homepage_url: "https://diacritical.net",
      name: "Diacritical",
      source_url: "https://github.com/diacritical/diacritical",
      start_permanent: env == :prod,
      version: "0.2.0"
    ]
  end
end
