defmodule Diacritical.Repo.Migration do
  @moduledoc "Defines commonalities for `Ecto.Migration` migrations."
  @moduledoc since: "0.10.0"

  alias Diacritical

  alias Diacritical.Repo

  @typedoc "Represents the source."
  @typedoc since: "0.10.0"
  @type source() :: [Path.t()]

  @typedoc "Represents the repository."
  @typedoc since: "0.10.0"
  @type repo() :: module()

  @typedoc "Represents the direction."
  @typedoc since: "0.10.0"
  @type dir() :: :down | :up

  @typedoc "Represents the option used by the migrator."
  @typedoc since: "0.10.0"
  @type opt() :: Keyword.t()

  @typedoc "Represents the version."
  @typedoc since: "0.10.0"
  @type version() :: integer()

  @typedoc "Represents the application."
  @typedoc since: "0.10.0"
  @type app() :: Repo.app()

  @typedoc "Represents the run confirmation."
  @typedoc since: "0.10.0"
  @type on_run() :: {:error, term()} | {:ok, [version()], [app()]}

  @typedoc "Represents the migration."
  @typedoc since: "0.10.0"
  @type migrate() :: [on_run()]

  @typedoc "Represents the rollback."
  @typedoc since: "0.10.0"
  @type rollback() :: on_run()

  @app :diacritical

  @spec source() :: source()
  defp source() do
    @app
    |> Application.fetch_env!(:env)
    |> Keyword.keys()
    |> Enum.map(&Ecto.Migrator.migrations_path(Repo, "migration/#{&1}"))
  end

  @spec run(repo(), dir(), opt()) :: on_run()
  defp run(repo, dir, opt)
       when is_atom(repo) and dir in [:down, :up] and is_list(opt) do
    Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, source(), dir, opt))
  end

  @doc """
  Runs all of the pending migrations for the configured repositories.

  Ensures the application is loaded first.

  ## Example

      iex> checkout_repo()
      iex>
      iex> migrate()
      [{:ok, [], []}]

  """
  @doc since: "0.10.0"
  @spec migrate() :: migrate()
  def migrate() do
    @app
    |> tap(&Application.ensure_loaded/1)
    |> Application.fetch_env!(:ecto_repos)
    |> Enum.map(&run(&1, :up, all: true))
  end

  @doc """
  Reverts the applied migrations for the given `repo` to the given `version`.

  Ensures the application is loaded first.

  ## Example

      iex> checkout_repo()
      iex>
      iex> rollback(Repo, 9_223_372_036_854_775_807)
      {:ok, [], []}

  """
  @doc since: "0.10.0"
  @spec rollback(repo(), version()) :: rollback()
  def rollback(repo, version) when is_atom(repo) and is_integer(version) do
    Application.ensure_loaded(@app)
    run(repo, :down, to: version)
  end

  @doc """
  In `use`, calls `use Ecto.Migration`.

  ## Example

      iex> defmodule TestMigration do
      ...>   use Diacritical.Repo.Migration
      ...> end
      iex>
      iex> TestMigration.__migration__()
      [disable_ddl_transaction: false, disable_migration_lock: false]

  """
  @doc since: "0.10.0"
  defmacro __using__(opt) when is_list(opt) do
    quote do
      use Ecto.Migration, unquote(opt)
    end
  end
end
