defmodule DiacriticalApp do
  @moduledoc "Defines an `Application` application."
  @moduledoc since: "0.3.0"

  use Application
  use Boundary, deps: [Bandit, Diacritical]

  alias Diacritical

  alias Diacritical.Supervisor

  @typedoc "Represents the application."
  @typedoc since: "0.3.0"
  @type app() :: Application.app()

  @typedoc "Represents the configuration."
  @typedoc since: "0.3.0"
  @type config() :: keyword()

  @typedoc "Represents the removed configuration."
  @typedoc since: "0.3.0"
  @type config_removed() :: [atom()]

  @typedoc "Represents the configuration confirmation."
  @typedoc since: "0.3.0"
  @type on_change() :: :ok

  @typedoc "Represents the start type."
  @typedoc since: "0.3.0"
  @type start_type() :: Application.start_type()

  @typedoc "Represents the argument used by the start process."
  @typedoc since: "0.3.0"
  @type init_arg() :: Supervisor.init_arg()

  @typedoc "Represents the error given by the start process."
  @typedoc since: "0.3.0"
  @type start_err() :: {:already_started, pid()} | {:shutdown, term()} | term()

  @typedoc "Represents the start process confirmation."
  @typedoc since: "0.3.0"
  @type on_start() :: {:error, start_err()} | {:ok, pid()}

  @typedoc "Represents the state."
  @typedoc since: "0.3.0"
  @type state() :: Application.state()

  @typedoc "Represents the stop confirmation."
  @typedoc since: "0.3.0"
  @type on_stop() :: :ok

  @doc """
  Gets the application for `DiacriticalApp`.

  ## Example

      iex> app()
      :diacritical

  """
  @doc since: "0.3.0"
  @spec app() :: app()
  def app(), do: Application.get_application(__MODULE__)

  @impl Application
  @doc """
  Reloads the configuration with the given `changed`, `new`, and `removed`.

  ## Example

      iex> config_change([], [], [])
      :ok

  """
  @doc since: "0.3.0"
  @spec config_change(config(), config(), config_removed()) :: on_change()
  def config_change(changed, new, removed)
      when is_list(changed) and is_list(new) and is_list(removed) do
    :ok
  end

  @impl Application
  @doc """
  Starts the top-level supervisor with the given `start_type` and `init_arg`.

  ## Example

      iex> %{init_arg: %{valid: init_arg}} = c_init_arg()
      iex> %{err: err} = c_err()
      iex>
      iex> start(:normal, init_arg)
      err

  """
  @doc since: "0.3.0"
  @spec start(start_type(), init_arg()) :: on_start()
  def start(start_type, init_arg)
      when is_atom(start_type) and is_list(init_arg) do
    init_arg = [
      {:children, [{Bandit, plug: :"Elixir.DiacriticalWeb.Endpoint"}]}
      | init_arg
    ]

    Supervisor.start_link(init_arg)
  end

  @impl Application
  @doc """
  Performs cleanup with the given `state` when the application is stopped.

  ## Example

      iex> stop([])
      :ok

  """
  @doc since: "0.3.0"
  @spec stop(state()) :: on_stop()
  def stop(_state), do: :ok
end
