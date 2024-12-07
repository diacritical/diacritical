defmodule Diacritical.Supervisor do
  @moduledoc "Defines a `Supervisor` supervisor."
  @moduledoc since: "0.3.0"

  use Supervisor

  @typedoc "Represents the argument used by the start process."
  @typedoc since: "0.3.0"
  @type init_arg() :: Keyword.t()

  @typedoc "Represents the child specification."
  @typedoc since: "0.3.0"
  @type child_spec() :: Supervisor.child_spec()

  @typedoc "Represents the supervisor flags and child specifications."
  @typedoc since: "0.3.0"
  @type init() :: {Supervisor.sup_flags(), [child_spec()]}

  @typedoc "Represents the initialization confirmation."
  @typedoc since: "0.3.0"
  @type on_init() :: :ignore | {:ok, init()}

  @typedoc "Represents the locally registered name of the supervisor."
  @typedoc since: "0.3.0"
  @type name() :: Supervisor.name()

  @typedoc "Represents the option keyword."
  @typedoc since: "0.3.0"
  @type opt_keyword() :: {:name, name()} | {Keyword.key(), Keyword.value()}

  @typedoc "Represents the option used by the start process."
  @typedoc since: "0.3.0"
  @type opt() :: [opt_keyword()]

  @typedoc "Represents the start process confirmation."
  @typedoc since: "0.3.0"
  @type on_start() :: Supervisor.on_start()

  @doc """
  Defines the child specification for the given `init_arg`.

  ## Example

      iex> %{init_arg: %{valid: init_arg}} = c_init_arg(%{})
      iex>
      iex> child_spec(init_arg)
      %{
        id: Supervisor,
        start: {Supervisor, :start_link, [init_arg]},
        type: :supervisor
      }

  """
  @doc since: "0.3.0"
  @spec child_spec(init_arg()) :: child_spec()
  def child_spec(init_arg) when is_list(init_arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [init_arg]},
      type: :supervisor
    }
  end

  @impl Supervisor
  @doc """
  Initializes a supervisor process with the given `init_arg`.

  ## Example

      iex> %{init_arg: %{valid: init_arg}} = c_init_arg(%{})
      iex>
      iex> init(init_arg)
      {
        :ok,
        {
          %{
            auto_shutdown: :never,
            intensity: 3,
            period: 5,
            strategy: :one_for_one
          },
          init_arg
        }
      }

  """
  @doc since: "0.3.0"
  @spec init(init_arg()) :: on_init()
  def init(init_arg) when is_list(init_arg) do
    Supervisor.init(init_arg[:children] || [], strategy: :one_for_one)
  end

  @doc """
  Starts a supervisor process with the given `init_arg` and `opt`.

  If an `opt` list is not given, the function will give the process this module
  to use as its locally registered name.

  ## Example

      iex> start_supervisor!(%{})
      iex> %{init_arg: %{valid: init_arg}} = c_init_arg(%{})
      iex> %{err: err} = c_err(%{})
      iex>
      iex> start_link(init_arg)
      err

  """
  @doc since: "0.3.0"
  @spec start_link(init_arg()) :: on_start()
  @spec start_link(init_arg(), opt()) :: on_start()
  def start_link(init_arg, opt \\ [name: __MODULE__])
      when is_list(init_arg) and is_list(opt) do
    Supervisor.start_link(__MODULE__, init_arg, opt)
  end
end
