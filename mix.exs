defmodule DiacriticalApp.MixProject do
  @moduledoc "Defines a `Mix.Project` project and an OTP application."
  @moduledoc since: "0.1.0"

  use Mix.Project

  alias DiacriticalApp

  @typedoc "Represents the application configuration keyword."
  @typedoc since: "0.3.0"
  @type application_keyword() ::
          {:mod, {module(), DiacriticalApp.init()}}
          | {Keyword.key(), Keyword.value()}

  @typedoc "Represents the application configuration."
  @typedoc since: "0.3.0"
  @type application() :: [application_keyword()]

  @typedoc "Represents the environment."
  @typedoc since: "0.2.0"
  @type env() :: :dev | :prod | :test | atom()

  @typedoc "Represents the module documentation group."
  @typedoc since: "0.2.0"
  @type groups_for_modules() :: nil | Keyword.t([module()])

  @typedoc "Represents the compilation paths."
  @typedoc since: "0.3.0"
  @type elixirc_paths() :: [Path.t()]

  @typedoc "Represents the project configuration keyword."
  @typedoc since: "0.1.0"
  @type project_keyword() ::
          {:app, DiacriticalApp.app()}
          | {:version, String.t()}
          | {Keyword.key(), Keyword.value()}

  @typedoc "Represents the project configuration."
  @typedoc since: "0.1.0"
  @type project() :: [project_keyword()]

  @spec groups_for_modules(env()) :: groups_for_modules()
  defp groups_for_modules(:dev) do
    ".boundary.exs"
    |> Code.eval_file()
    |> elem(0)
  end

  defp groups_for_modules(env) when is_atom(env), do: nil

  @spec elixirc_paths(env()) :: elixirc_paths()
  defp elixirc_paths(:dev), do: elixirc_paths(:test)
  defp elixirc_paths(:test), do: ["support" | elixirc_paths(:prod)]
  defp elixirc_paths(env) when is_atom(env), do: ["lib"]

  @doc """
  Returns the application configuration.

  ## Example

      iex> {DiacriticalApp, _init} = application()[:mod]

  """
  @doc since: "0.3.0"
  @spec application() :: application()
  def application() do
    [
      extra_applications: [:logger, :os_mon, :runtime_tools],
      mod: {DiacriticalApp, []}
    ]
  end

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
        {:dns_cluster, "~> 0.1"},
        {:ex_doc, "~> 0.36", only: :dev, runtime: false}
      ],
      deps_path: "dep",
      dialyzer: [ignore_warnings: ".dialyzer.exs", plt_add_apps: [:ex_unit]],
      docs: [groups_for_modules: groups_for_modules(env)],
      elixir: "~> 1.18",
      elixirc_options: [warnings_as_errors: true],
      elixirc_paths: elixirc_paths(env),
      homepage_url: "https://diacritical.net",
      name: "Diacritical",
      source_url: "https://github.com/diacritical/diacritical",
      start_permanent: env == :prod,
      version: "0.2.0"
    ]
  end
end
