defmodule Diacritical.Telemetry do
  @moduledoc "Defines a `Telemetry` supervisor."
  @moduledoc since: "0.12.0"

  use Supervisor

  import Telemetry.Metrics

  alias Diacritical

  @typedoc "Represents the argument used by the start process."
  @typedoc since: "0.12.0"
  @type init_arg() :: Diacritical.Supervisor.init_arg()

  @typedoc "Represents the initialization confirmation."
  @typedoc since: "0.12.0"
  @type on_init() :: Diacritical.Supervisor.on_init()

  @typedoc "Represents the start process confirmation."
  @typedoc since: "0.12.0"
  @type on_start() :: Diacritical.Supervisor.on_start()

  @typedoc "Represents the metrics."
  @typedoc since: "0.18.0"
  @type metrics() :: [Telemetry.Metrics.t()]

  @impl Supervisor
  @doc """
  Initializes a supervisor process with the given `init_arg`.

  ## Example

      iex> %{init_arg: %{valid: init_arg}} = c_init_arg()
      iex>
      iex> {:ok, {_sup_flag, _child_spec}} = init(init_arg)

  """
  @doc since: "0.12.0"
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
  @doc since: "0.12.0"
  @spec start_link(init_arg()) :: on_start()
  def start_link(init_arg) when is_list(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @doc """
  Returns the `Telemetry` metrics.

  ## Example

      iex> [%{measurement: _measurement} | _metric] = metrics()

  """
  @doc since: "0.18.0"
  @spec metrics() :: metrics()
  def metrics() do
    [
      summary(
        "diacritical.repo.query.total_time",
        unit: {:native, :millisecond}
      ),
      summary(
        "diacritical.repo.query.decode_time",
        unit: {:native, :millisecond}
      ),
      summary(
        "diacritical.repo.query.query_time",
        unit: {:native, :millisecond}
      ),
      summary(
        "diacritical.repo.query.queue_time",
        unit: {:native, :millisecond}
      ),
      summary(
        "diacritical.repo.query.idle_time",
        unit: {:native, :millisecond}
      ),
      summary(
        "phoenix.endpoint.start.system_time",
        unit: {:native, :millisecond}
      ),
      summary(
        "phoenix.endpoint.stop.duration",
        unit: {:native, :millisecond}
      ),
      summary(
        "phoenix.router_dispatch.start.system_time",
        tags: [:route],
        unit: {:native, :millisecond}
      ),
      summary(
        "phoenix.router_dispatch.exception.duration",
        tags: [:route],
        unit: {:native, :millisecond}
      ),
      summary(
        "phoenix.router_dispatch.stop.duration",
        tags: [:route],
        unit: {:native, :millisecond}
      ),
      summary(
        "phoenix.socket_connected.duration",
        unit: {:native, :millisecond}
      ),
      summary(
        "phoenix.channel_joined.duration",
        unit: {:native, :millisecond}
      ),
      summary(
        "phoenix.channel_handled_in.duration",
        tags: [:event],
        unit: {:native, :millisecond}
      ),
      summary(
        "swoosh.deliver.start",
        unit: {:native, :millisecond}
      ),
      summary(
        "swoosh.deliver.exception",
        unit: {:native, :millisecond}
      ),
      summary(
        "swoosh.deliver.stop",
        unit: {:native, :millisecond}
      ),
      summary(
        "swoosh.deliver_many.start",
        unit: {:native, :millisecond}
      ),
      summary(
        "swoosh.deliver_many.exception",
        unit: {:native, :millisecond}
      ),
      summary(
        "swoosh.deliver_many.stop",
        unit: {:native, :millisecond}
      ),
      summary(
        "vm.memory.total",
        unit: {:byte, :kilobyte}
      ),
      summary(
        "vm.total_run_queue_lengths.total",
        []
      ),
      summary(
        "vm.total_run_queue_lengths.cpu",
        []
      ),
      summary(
        "vm.total_run_queue_lengths.io",
        []
      )
    ]
  end
end
