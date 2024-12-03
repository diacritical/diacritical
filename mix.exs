defmodule DiacriticalApp.MixProject do
  @moduledoc "Defines a `Mix.Project` project and an OTP application."
  @moduledoc since: "0.1.0"

  use Mix.Project

  alias DiacriticalApp

  @typedoc "Represents the application configuration keyword."
  @typedoc since: "0.3.0"
  @type application_keyword() ::
          {:mod, {module(), DiacriticalApp.init_arg()}}
          | {Keyword.key(), Keyword.value()}

  @typedoc "Represents the application configuration."
  @typedoc since: "0.3.0"
  @type application() :: [application_keyword()]

  @typedoc "Represents the environment."
  @typedoc since: "0.2.0"
  @type env() :: :dev | :prod | :test | atom()

  @typedoc "Represents the migration flag."
  @typedoc since: "0.10.0"
  @type migration_flag() :: String.t()

  @typedoc "Represents the module documentation group."
  @typedoc since: "0.2.0"
  @type groups_for_modules() :: nil | Keyword.t([module()])

  @typedoc "Represents the compilation path."
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

  @asset_path "asset/diacritical_web/"
  @repo_path "priv/diacritical/repo/"
  @migration_path "#{@repo_path}migration/"
  @static_path "priv/diacritical_web/static/"

  @doc """
  Returns the application configuration.

  ## Example

      iex> {DiacriticalApp, _init_arg} = application()[:mod]

  """
  @doc since: "0.3.0"
  @spec application() :: application()
  def application() do
    [
      extra_applications: [:logger, :os_mon, :runtime_tools],
      mod: {DiacriticalApp, []}
    ]
  end

  @spec migration_flag(env()) :: migration_flag()
  defp migration_flag(:dev = env) do
    "--migrations-path=#{@migration_path}#{env} #{migration_flag(:test)}"
  end

  defp migration_flag(:test = env) do
    "--migrations-path=#{@migration_path}#{env} #{migration_flag(:prod)}"
  end

  defp migration_flag(env) when is_atom(env) do
    "--migrations-path=#{@migration_path}#{env}"
  end

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
        "asset.build": "esbuild diacritical_web",
        "asset.deploy": ["esbuild diacritical_web --minify", "phx.digest"],
        "asset.setup": ["npm.install", "esbuild.install --if-missing"],
        "boundary.ex_doc_groups": [
          "boundary.ex_doc_groups",
          "cmd tail -n +2 boundary.exs > .boundary.exs",
          "cmd rm boundary.exs"
        ],
        credo: "credo --config-name default",
        "ecto.gen.migration":
          "ecto.gen.migration --migrations-path=#{@migration_path}#{env}",
        "ecto.load": "ecto.load --dump-path=#{@repo_path}structure.sql",
        "ecto.migrate": "ecto.migrate #{migration_flag(env)}",
        "ecto.migration": "ecto.migrations",
        "ecto.migrations": "ecto.migrations #{migration_flag(env)}",
        "ecto.reset": ["ecto.drop", "ecto.setup"],
        "ecto.rollback": "ecto.rollback #{migration_flag(env)}",
        "ecto.seed": "run #{@repo_path}seed.exs",
        "ecto.setup": [
          "ecto.create",
          "ecto.load --skip-if-loaded",
          "ecto.migrate",
          "ecto.seed"
        ],
        "npm.install": "cmd --cd #{@asset_path} npm install",
        "npm.update": "cmd --cd #{@asset_path} npm update",
        "phx.digest": "phx.digest #{@static_path}",
        "phx.digest.clean": "phx.digest.clean --output #{@static_path}"
      ],
      app: :diacritical,
      boundary: [default: [type: :strict]],
      compilers: [:boundary | Mix.compilers()],
      deps: [
        {:argon2_elixir, "~> 4.1"},
        {:bandit, "~> 1.6"},
        {:boundary, "~> 0.10", runtime: false},
        {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
        {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
        {:dns_cluster, "~> 0.1"},
        {:ecto_sql, "~> 3.12"},
        {:esbuild, "~> 0.8", runtime: env == :dev},
        {:ex_doc, "~> 0.35", only: :dev, runtime: false},
        {:jason, "~> 1.4"},
        {:phoenix, "~> 1.7"},
        {:phoenix_ecto, "~> 4.6"},
        {:phoenix_html, "~> 4.1"},
        {:phoenix_live_reload, "~> 1.5", runtime: env == :dev},
        {:phoenix_live_view, "1.0.0-rc.7", override: true},
        {:postgrex, "~> 0.19"},
        {:req, "~> 0.5"},
        {:swoosh, "~> 1.17"},
        {:telemetry_metrics, "~> 1.0"},
        {:telemetry_poller, "~> 1.0"}
      ],
      deps_path: "dep",
      dialyzer: [ignore_warnings: ".dialyzer.exs", plt_add_apps: [:ex_unit]],
      docs: [groups_for_modules: groups_for_modules(env)],
      elixir: "~> 1.17",
      elixirc_options: [warnings_as_errors: true],
      elixirc_paths: elixirc_paths(env),
      homepage_url: "https://diacritical.net",
      name: "Diacritical",
      releases: [diacritical: [overlays: ["rel/overlay"]]],
      source_url: "https://github.com/diacritical/diacritical",
      start_permanent: env == :prod,
      version: "0.14.0"
    ]
  end
end
