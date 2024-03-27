defmodule Diacritical.Telemetry do
  @moduledoc "Defines a `Telemetry` supervisor."
  @moduledoc since: "0.13.0"

  use Supervisor

  alias Diacritical

  @typedoc "Represents the argument used by the start process."
  @typedoc since: "0.13.0"
  @type init_arg() :: Diacritical.Supervisor.init_arg()

  @typedoc "Represents the initialization confirmation."
  @typedoc since: "0.13.0"
  @type on_init() :: Diacritical.Supervisor.on_init()

  @typedoc "Represents the start process confirmation."
  @typedoc since: "0.13.0"
  @type on_start() :: Diacritical.Supervisor.on_start()

  @impl Supervisor
  @doc """
  Initializes a supervisor process with the given `init_arg`.

  ## Example

      iex> %{init_arg: %{valid: init_arg}} = c_init_arg()
      iex>
      iex> {:ok, {_sup_flag, _child_spec}} = init(init_arg)

  """
  @doc since: "0.13.0"
  @spec init(init_arg()) :: on_init()
  def init(init_arg) when is_list(init_arg) do
    Supervisor.init(
      [{:telemetry_poller, [measurements: [], period: 10_000]}],
      strategy: :one_for_one
    )
  end

  @doc """
  Starts a supervisor process with the given `init_arg`.

  ## Example

      iex> %{init_arg: %{valid: init_arg}} = c_init_arg()
      iex> err = {:error, {:already_started, Process.whereis(Telemetry)}}
      iex>
      iex> start_link(init_arg)
      err

  """
  @doc since: "0.13.0"
  @spec start_link(init_arg()) :: on_start()
  def start_link(init_arg) when is_list(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end
end
