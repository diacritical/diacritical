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
  @typedoc since: "0.11.0"
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
      mod: {DiacriticalApp, []},
      extra_applications: [:logger, :os_mon, :runtime_tools]
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

  ## Examples

      iex> project()[:app]
      :diacritical

      iex> project()[:version]
      "0.45.0"

  """
  @doc since: "0.1.0"
  @spec project() :: project()
  def project() do
    env = Mix.env()

    [
      aliases: [
        "asset.build": [
          "cmd --cd #{@asset_path} npm run build",
          "esbuild diacritical_web"
        ],
        "asset.deploy": [
          "cmd --cd #{@asset_path} npm run deploy",
          "esbuild diacritical_web --minify",
          "phx.digest"
        ],
        "asset.format": ["cmd --cd #{@asset_path} npm run format"],
        "asset.format.check": ["cmd --cd #{@asset_path} npm run format:check"],
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
        "gettext.merge": "gettext.merge priv/diacritical/gettext",
        "npm.install": "cmd --cd #{@asset_path} npm install",
        "npm.update": "cmd --cd #{@asset_path} npm update",
        "phx.digest": "phx.digest #{@static_path}",
        "phx.digest.clean": "phx.digest.clean --output #{@static_path}"
      ],
      app: :diacritical,
      boundary: [default: [type: :strict]],
      compilers: [:boundary | Mix.compilers()],
      deps: [
        {:argon2_elixir, "~> 4.0"},
        {:bandit, "~> 1.5"},
        {:boundary, "~> 0.10", runtime: false},
        {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
        {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
        {:ecto_psql_extras, "~> 0.8"},
        {:ecto_sql, "~> 3.11"},
        {:esbuild, "~> 0.8", runtime: env == :dev},
        {:ex_doc, "~> 0.34", only: :dev, runtime: false},
        {:floki, "~> 0.36", only: :test},
        {:gettext, "~> 0.24"},
        {
          :heroicons,
          app: false,
          compile: false,
          depth: 1,
          github: "tailwindlabs/heroicons",
          sparse: "optimized",
          tag: "v2.1.5"
        },
        {:jason, "~> 1.4"},
        {:libcluster, "~> 3.3"},
        {:phoenix, "~> 1.7"},
        {:phoenix_ecto, "~> 4.6"},
        {:phoenix_html, "~> 4.1"},
        {:phoenix_live_dashboard, "~> 0.8"},
        {:phoenix_live_reload, "~> 1.5", runtime: env == :dev},
        {:phoenix_live_view, "1.0.0-rc.6", override: true},
        {:postgrex, "~> 0.18"},
        {:req, "~> 0.5"},
        {:swoosh, "~> 1.16"},
        {:tailwind_formatter, "~> 0.4", only: [:dev, :test], runtime: false},
        {:telemetry_metrics, "~> 1.0"},
        {:telemetry_poller, "~> 1.1"}
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
      version: "0.45.0"
    ]
  end
end
