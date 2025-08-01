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
  @type moduledoc_group() :: nil | Keyword.t([module()])

  @typedoc "Represents the compilation path."
  @typedoc since: "0.2.0"
  @type elixirc_path() :: [Path.t()]

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
  @static_path "priv/diacritical_web/static/"

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
        "asset.build": "esbuild diacritical_web",
        "asset.deploy": ["esbuild diacritical_web --minify", "phx.digest"],
        "asset.setup": ["npm.install", "esbuild.install --if-missing"],
        "boundary.ex_doc_groups": [
          "boundary.ex_doc_groups",
          "cmd sed 1d boundary.exs > .boundary.exs",
          "cmd rm boundary.exs"
        ],
        credo: "credo --config-name default",
        "npm.install": "cmd --cd #{@asset_path} npm install",
        "npm.update": "cmd --cd #{@asset_path} npm update",
        "phx.digest": "phx.digest #{@static_path}",
        "phx.digest.clean": "phx.digest.clean --output #{@static_path}"
      ],
      app: :diacritical,
      boundary: [default: [type: :strict]],
      compilers: [:boundary, :phoenix_live_view | Mix.compilers()],
      deps: [
        {:bandit, "~> 1.7"},
        {:boundary, "~> 0.10", runtime: false},
        {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
        {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
        {:dns_cluster, "~> 0.2"},
        {:ecto, "~> 3.13"},
        {:ecto_sql, "~> 3.13"},
        {:esbuild, "~> 0.10", runtime: env == :dev},
        {:ex_doc, "~> 0.38", only: :dev, runtime: false},
        {:phoenix, "~> 1.8-rc"},
        {:phoenix_html, "~> 4.2"},
        {:phoenix_live_reload, "~> 1.6", runtime: env == :dev},
        {:phoenix_live_view, "~> 1.1"},
        {:postgrex, "~> 0.21"}
      ],
      deps_path: "dep",
      dialyzer: [ignore_warnings: ".dialyzer.exs", plt_add_apps: [:ex_unit]],
      docs: [groups_for_modules: load_moduledoc_group(env)],
      elixir: "~> 1.18",
      elixirc_options: [warnings_as_errors: true],
      elixirc_paths: get_elixirc_path(env),
      homepage_url: "https://diacritical.net",
      listeners: [Phoenix.CodeReloader],
      name: "Diacritical",
      releases: [diacritical: [overlays: ["rel/overlay"]]],
      source_url: "https://github.com/diacritical/diacritical",
      start_permanent: env == :prod,
      version: "0.9.0"
    ]
  end
end
